require("SimRailCore")
require("Framework/Common")

local scenarioState = ""
local playerStateMachine = {}
local botStateMachine = {}

local function doBotAction(shouldBeDone, stateName)
    if (shouldBeDone and botStateMachine[stateName] ~= nil) then
        local success, result = pcall(DoBotScenarioAction, botStateMachine[stateName])
        if (success) then
            botStateMachine[stateName] = nil
        else
            Debug("ERROR doing bot action: " .. result)
        end
    end
end

local function getTargetState(stateInfo)
    local targetStates = stateInfo.targetState
    if (type(targetStates) == "table") then
        return targetStates[math.random(1, #targetStates)]
    else
        return targetStates
    end
end

local function doTransitionFunctions(stateInfo, triggerName, trainsetInfo)
    if (stateInfo.transition ~= nil) then
        for x, func in ipairs(stateInfo.transition)
        do
            CreateCoroutine(function()
                local success, result = pcall(func, scenarioState, triggerName, trainsetInfo)
                if (not success) then
                    Debug("Can not execure transition function " .. x .. " for trigger " .. triggerName)
                    Debug("Error message: " .. result)
                end
            end)
        end
    end
end

local function execStateFunction(func, triggerName, trainsetInfo)
    local success, result = pcall(func, triggerName, trainsetInfo)
    if (not success) then
        Debug("Can not execute function in trigger " .. triggerName)
        Debug("Error msg:" .. result)
        return false
    end
    return result
end

local function conditionIsFulfilled(stateInfo, triggerName, trainsetInfo)
    if (stateInfo.condition == nil) then
        return true
    end

    if (type(stateInfo.condition) ~= "table") then
        return execStateFunction(stateInfo.condition, triggerName, trainsetInfo)
    end

    for _, func in ipairs(stateInfo.condition)
    do
        if (not execStateFunction(func, triggerName, trainsetInfo)) then
            return false
        end
    end
    return true
end

local function doStateChange(stateInfo, triggerName, trainsetInfo)
    local doBotActionsBefore = math.random(1,100) <= 50
    doBotAction(doBotActionsBefore, scenarioState)

    -- Do scenario transition functions
    doTransitionFunctions(stateInfo, triggerName, trainsetInfo)

    -- Do bot actions after scnario transition functions?
    doBotAction(not doBotActionsBefore, scenarioState)

    -- Set target state as current state
    scenarioState = getTargetState(stateInfo)

    Debug("ScenarioState is now '" .. scenarioState .. "'")
end

function ChangeState(triggerType, triggerName, trainsetInfo)
    if (playerStateMachine[scenarioState] == nil) then
        Debug("ERROR: There is no definition for state '" .. scenarioState .. "'")
        return
    end

    local oldScenarioState = scenarioState
    for _, stateInfo in ipairs(playerStateMachine[scenarioState])
    do
        if (stateInfo.type == triggerType) then
            if (stateInfo.alwaysBotCmd) then
                doBotAction(true, scenarioState)
            end
            if (conditionIsFulfilled(stateInfo, triggerName, trainsetInfo)) then
                doStateChange(stateInfo, triggerName, trainsetInfo)
                break
            end
        end
    end

    if (oldScenarioState == scenarioState) then
        Debug("SENARIO STAT NOT CHANGED")
    end
end

function GetScenarioState()
    return scenarioState
end

function SetScenarioState(state)
    if (state == nil) then
        Debug("No scenario state to set")
        return
    end
    if (playerStateMachine[state] == nil) then
        Debug("There is no scenario state called '" .. state .. "'")
        return
    end

    scenarioState = state
end

function InitStateMachine(playerStateMachineConfig, botStateMachineConfig)
    playerStateMachine = playerStateMachineConfig
    botStateMachine = botStateMachineConfig
end