require("SimRailCore")
require("Framework/Common")

--[[
    Signal Trigger functions
    These functions has to be declared before the Trigger tables below
    ]]--
local function getLocoController(trainsetInfo)
    for _, vehicle in ipairs(trainsetInfo.Vehicles)
    do
        if (vehicle.controller ~= nil) then
            return vehicle.controller
        end
    end
    Error("Can not get player train controll info.")
end

local function brakesAreApplied(locoControll)
    locoControll = locoControll or getLocoController(RailstockGetPlayerTrainset())

    if (locoControll.brakePipePressure <= 4.6) then
        Debug("Main brake applied")
        return true
    else
        return false
    end
end

local function brakesAreReleased(locoControll)
    locoControll = locoControll or getLocoController(RailstockGetPlayerTrainset())

    if (locoControll.brakePipePressure >= 5.0) then
        Debug("Main brake is released")
        return true
    else
        return false
    end
end

local function cabinsAreInactive(locoControll)
    locoControll = locoControll or getLocoController(RailstockGetPlayerTrainset())

    local isInactive = locoControll.activeCabin == 0
    if (isInactive) then
        Debug("   Cabin is inactivated.")
    end

    return isInactive
end

local function springBrakeApplied(locoControll)
    locoControll = locoControll or getLocoController(RailstockGetPlayerTrainset())

    if (locoControll.springBrakeEnabled) then
        Debug("  Spring brake is applied.")
        return true
    end

    return false
end

local function isLocoOff()
    local locoControll = getLocoController(RailstockGetPlayerTrainset())
     
    if (cabinsAreInactive(locoControll) and brakesAreApplied(locoControll) and springBrakeApplied(locoControll)) then
        return true
    end

    return false
end

local function checkIfPlayerIsWalkingOutside()
    return GetCameraView() == CameraView.FirstPersonWalkingOutside
end

local function checkIfPlayerIsSittingInCabin()
    return GetCameraView() == CameraView.Sitting
end

local function getStableBrakePipePressure(locoControll)
    locoControll = locoControll or getLocoController(RailstockGetPlayerTrainset())
    local startPressure, endPressure

    repeat
        startPressure = locoControll.brakePipePressure
        coroutine.yield(CoroutineYields.WaitForSeconds, 5)
        endPressure = locoControll.brakePipePressure
    until ((startPressure - endPressure) < 0.1)
    return endPressure
end

function WaitForTrainToStop(_)
    Debug("Wait for train to stop.")
    coroutine.yield(CoroutineYields.WaitForTrainsetStop, RailstockGetPlayerTrainset())
end

function ChangeDirectionAndShunt(_)
    WaitForTrainToStop()
    NarrativeText("ChangeDirection")
end

function ChangeDirectionAndShuntToCarriages(_)
    WaitForTrainToStop()
    NarrativeText("ChangeDirectionToCarriages")
end

function UnconditionalCheck(_)
    return true
end

function TrainTurnedOff(_)
    Debug("Wait for the train to be turned off")
    coroutine.yield(CoroutineYields.WaitUntil, isLocoOff)
end

function PlayerWalkingOutside(_)
    Debug("Waitin for the player to get out of the locomotive")
    coroutine.yield(CoroutineYields.WaitUntil, checkIfPlayerIsWalkingOutside)
end

function EndOfGame(_)
    Debug("The Game is over !!!!!!!!!!")
    NarrativeText("GameOver")
    FinishMission(MissionResultEnum.Success)
end

function LeakCheck()
    local locoControll = getLocoController(RailstockGetPlayerTrainset())

    -- Start leak check when player is in cabin
    coroutine.yield(CoroutineYields.WaitUntil, checkIfPlayerIsSittingInCabin)

    -- Doing leak check. 
    -- First check that brakes are released (the pressure is correct)
    NarrativeText("LeakCheckStart")
    coroutine.yield(CoroutineYields.WaitUntil, brakesAreReleased)

    -- Apply brakes. Save stable value
    NarrativeText("LeakCheckApplyBrake")
    coroutine.yield(CoroutineYields.WaitUntil, brakesAreApplied)

    -- wait for pressure to be stable
    local startPressure = getStableBrakePipePressure(locoControll) or 4.6

    -- wait for one minute and check pressure drop
    coroutine.yield(CoroutineYields.WaitForSeconds, 60)
    local endPressure = locoControll.brakePipePressure or 0
    NarrativeText("LeakCheckReleaseBrake")
    Debug("Start pressure: " .. startPressure .. ", end pressure: " .. endPressure .. ", difference: " .. (startPressure - endPressure))

    -- Check that the pressure hasn't droped with more than 0.5 bar.
    if ((startPressure - endPressure) > 0.5) then
        NarrativeText("LeakCheckPressureLeak")
        return false
    else
        NarrativeText("LeakCheckPressureNoLeak")
        return true
    end
end

function BrakeCheck()
    -- Doing brake check. 
    -- First check that brakes are released (the pressure is correct)
    local brakesAreOK = false
    local retryCount = 0
    local maxRetryCount = 1

    repeat
        -- Start brake check when player is in cabin
        coroutine.yield(CoroutineYields.WaitUntil, checkIfPlayerIsSittingInCabin)

        NarrativeText("BrakeCheckStart")
        coroutine.yield(CoroutineYields.WaitUntil, brakesAreReleased)

        -- Apply brakes. 
        NarrativeText("BrakeCheckApplyBrake")
        coroutine.yield(CoroutineYields.WaitUntil, brakesAreApplied)
        DriverText("BrakeCheckBrakesApplied")
        
        -- Check that they are applied
        coroutine.yield(CoroutineYields.WaitForSeconds, 30)
        BrakeTesterText("BrakeCheckReleaseBrakes")
        
        -- Check that they are released again
        coroutine.yield(CoroutineYields.WaitUntil, brakesAreReleased)
        DriverText("BrakeCheckBrakesReleased")
        coroutine.yield(CoroutineYields.WaitForSeconds, 30)

        if (retryCount < maxRetryCount and math.random(1, 100) < 5) then
            retryCount = retryCount + 1
            BrakeTesterText("BrakeCheckBrakesNotOK")
        else
            BrakeTesterText("BrakeCheckBrakesOK")
            brakesAreOK = true
        end
    until(brakesAreOK)

    return true
end

--[[
    Trigger Result functions
    ]]--

function ChangeTrainStatusToDriving(scenarioState, triggerName, trainsetInfo)
    Debug("Change train status to driving")
    trainsetInfo.SetState(DynamicState.dsCoast, TrainsetState.tsTrain, false)
    --NarrativeText("IsDriving")
end

function ChangeTrainStatusToShunting(scenarioState, triggerName, trainsetInfo)
    Debug("Change train status to shunting")
    trainsetInfo.SetState(DynamicState.dsCoast, TrainsetState.tsShunting, false)
    --NarrativeText("IsShunting")
end