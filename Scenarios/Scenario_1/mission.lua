-- SimRail - The Railway Simulator
-- LUA Scripting scenario
-- Version: 1.0
--
require("SimRailCore")
require("Sounds")
require("ScenarioConfig")
require("Framework/Radio")
require("Framework/Trigger")
require("Framework/State")
require("Framework/RolingStock")
require("Framework/Common")
require("Framework/BotTrain")
require("Framework/Route")
require("Framework/Environment")

DeveloperMode = function()
    return false -- true
end

StartPosition = { 15580.27, 337.76, 20650.96 }

local isVDReady = false
local startScenarioDefinition

-- --------------------------------------------------------------------------------------------------------------------------------
function EarlyScenarioStart()
    math.randomseed(os.time())
    InitRoutes(Routes)
    InitBotTrains(BotTrains)
    InitRolingStock(PlayerLocomotives)
    InitStateMachine(StateMachine, BotScenarios)
    InitTriggers(TrackTriggers, SignalTriggers, RadioTriggers)

    CreateCoroutine(function ()
        startScenarioDefinition = GetStartScenario()
        if (startScenarioDefinition == nil) then
            return
        end

        SetPlayerStartPosition(startScenarioDefinition.StartPosition)
        ConfigureEnvironment()

        local playerLocomotiveKey = GetPlayerLocomotive()

        -- Create Scenario
        CreateStartScenario(startScenarioDefinition, playerLocomotiveKey)
        CreateBotStartScenario(startScenarioDefinition)
    end)

    CreateCoroutine(function ()
    	while true do
            local success, errorMsg = pcall(ResubmitFailedVDorder)
            if (not success) then
                Error("Can not resubmit failed VD orders '" .. errorMsg .. "'")
            end
    		coroutine.yield(CoroutineYields.WaitForSeconds, 30)
    	end
    end)

    CreateCoroutine(function ()
    	while true do
            local success, errorMsg = pcall(ExecuteQueuedVDorder)
            if (not success) then
                Error("Can not execute VD orders '" .. errorMsg .. "'")
            end
    		coroutine.yield(CoroutineYields.WaitForSeconds, 5)
    	end
    end)
end

-- Called to prepare the scenario. Add constants here. In not called if scenario is restarted.
function PrepareScenario()
end

--- Function called by SimRail when the loading finishes - you should set scenario time in here, spawn trains etc. After calling this mission recorder is started and stuff gets registered
function StartScenario()
    StartRecorder()

	local success, errorMsg = pcall(MakeTriggers, GetScenarioState())
    if (not success) then
        Error("Can not make triggers '" .. errorMsg .. "'")
    end

    CreateCoroutine(function()
        Debug("Display scenario data")

        local success, errorMsg = pcall(ShowScenarioData, 30)
        if (not success) then
            Error("Can not show scenario data '" .. errorMsg .. "'")
        end

        NarrativeText(GetWelcomeText())
    end)
end

-- --------------------------------------------------------------------------------------------------------------------------------
function OnTrainsetsJoined(builtTrainset, destroyedTrainset)
    CreateCoroutine(function()
        ChangeState(TriggerType.Coupling, GetScenarioState(), builtTrainset)
    end)
end


function OnTrainsetsSplit(oldTrainset, newTrainset)
    CreateCoroutine(function()
        ChangeState(TriggerType.Decoupling, GetScenarioState(), newTrainset)
    end)
end

--- Function below is called by SimRail when VD is ready to start receiving orders
function OnVirtualDispatcherReady()
    CreateCoroutine(function()
        isVDReady = true
        NarrativeText("DispatcherIsReady")

        local success, errorMsg = pcall(SetBotRouting, startScenarioDefinition) -- Called when CDdispatcher is ready
        if (not success) then
            Error("Can not set bot routing '" .. errorMsg .. "'")
        end
    end)
end

function OnPlayerRadioCall(trainsetInfo, radioButton, currentlyUsedChannel)
    local expectedChannel = trainsetInfo.GetIntendedRadioChannel()

    -- Check that correct radio channel is used.
    if (currentlyUsedChannel ~= expectedChannel) then
        return
    end

    -- Dispatcher is not ready
    if (isVDReady == false) then
        DisplayChatText("DispatcherIsNotReady")
        return
    end

    if (ExecuteRadioCall(radioButton, trainsetInfo)) then
        return
    end

    DisplayChatText("NoAnswer")
end

function OnVirtualDispatcherResponseReceived(orderId, status)
    if (status == VDReponseCode.Accepted) then
        HandleVDorderAccepted(orderId)
        return
    end

    if (status == VDReponseCode.Error) then
        HandleVDorderFailure(orderId)
        return
    end
end
