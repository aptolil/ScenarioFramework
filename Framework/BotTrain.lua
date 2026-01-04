require("SimRailCore")
require("Framework/Common")
require("Framework/Route")
require("Framework/RolingStock") -- CreateEngine, CreateWagons

local botTrains = {}

local function setBotCommands(trainsetInfo, commands)
    Debug("Setting commands for trainset " .. trainsetInfo.name)
    for i, v in ipairs(commands)
    do
        local command = CreateShortBotCommand(v, "command" .. i)
        command.overrideCurrentNow = true
        AddBotCommand(trainsetInfo, command)
    end
end

local function makeBotTrain(locoKey, minLength, maxLength, trainType, cargoTypes)
    Debug("Create bot loco key " .. locoKey)
    local locoDefinition = GetLocoDefinition(locoKey)
    local _, maxWeight, loco = CreateLocomotive(locoDefinition, trainType)
    local train = { loco }
    if (maxWeight ~= 0) then
        local _, _, bot1Wagons = CreateRandomWagonSet(maxWeight, minLength, maxLength, trainType, cargoTypes)

        train = ConcatTables(train, bot1Wagons)
    end

    return train
end

local function placeBotTrain(name, train, signalName, distance, trainState)
    Debug("PlaceBotTrain")
    name = name or "Unknown"
    distance = distance or 50
    signalName = signalName or ""

    if (signalName == "") then
        Debug("No signal given")
        return
    end

    Debug("Placing bot train '" .. name .. "' at signal " .. signalName)
    local trainSet = nil
    SpawnTrainsetOnSignalAsync(name, FindSignal(signalName), distance, false, false, true, train, 
        function(createdTrainSet) 
            trainSet = createdTrainSet 
            trainSet.SetState(DynamicState.dsStop, trainState, false)
        end)

    return trainSet
end

local function validateBotScenario(scenario)
    if (scenario.botSetup == nil) then
        Debug("No bot actions to setup at scenario start")
        return false
    end

    return true
end
        
local function doBotRouting(action)
    if (action.routes ~= nil) then
        QueueVDorder(action.routes, action.orderType)
    end
end

local function getBotTrain(botId)
    Debug("Do Bot actions for key " .. botId)
    local botInfo = botTrains[botId]
    if (botInfo == nil) then
        Debug("DoBotScenarioAction: BotId " .. botId .. " not found..")
    end
    return botInfo
end

local function spawnBotTrain(botId)
    Debug("Spawning bot train with key " .. botId)
    local botData = botTrains[botId]
    if (botData == nil) then
        Debug("Bot data not found for botId " .. botId)
        return
    end
    Debug("Creating bot train " .. botData.locoName)
    local bot = makeBotTrain(botData.locoName, botData.minLength, botData.maxLength, botData.trainType, botData.cargoTypes)
    botData.trainsetInfo = placeBotTrain("Bot " .. botData.locoName .. " at " .. botId, bot, botData.atSignalName, botData.distance, botData.trainState)

    return botData.trainsetInfo
end

local function createBotTrain(botId)
    Debug("Creating bot train " .. botId)
    return spawnBotTrain(botId)
end

local function deleteBotTrain(botId, trainsetInfo)
    if (trainsetInfo ~= nil) then
        Debug("Deleting bot train " .. botId)
        DespawnTrainset(trainsetInfo)
        trainsetInfo = nil
    end

    return trainsetInfo
end

function DoBotScenarioAction(actions, doRouting)
    doRouting = doRouting or true

    if (actions == nil) then
        return 
    end

    for _, action in ipairs(actions)
    do
        local botInfo = getBotTrain(action.BotId)
        if (botInfo == nil) then
            return
        end

        if (action.create) then
            botInfo.trainsetInfo = createBotTrain(action.BotId)
        end

        if (action.delete) then
            botInfo.trainsetInfo = deleteBotTrain(action.BotId, botInfo.trainsetInfo)
        end

        if (doRouting) then
            doBotRouting(action)
        end

        if (action.commands ~= nil and botInfo.trainsetInfo ~= nil) then
            CreateCoroutine(function()
                setBotCommands(botInfo.trainsetInfo, action.commands)
            end)
        end
    end
end

function CreateBotStartScenario(scenario)
    if (not validateBotScenario(scenario)) then
        return
    end

    DoBotScenarioAction(scenario.botSetup, false) -- Don't set routs before VDdispatcher is ready.
end

function SetBotRouting(scenario) -- Called when CDdispatcher is ready
    local actions = scenario.botSetup

    if (actions == nil) then
        return
    end

    for _, action in ipairs(actions)
    do
        doBotRouting(action)
    end
end

function InitBotTrains(trains)
    botTrains = trains
end