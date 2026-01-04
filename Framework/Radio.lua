require("SimRailCore")
require("Framework/Common")
require("Sounds")

local radioActions = {}

local function makeRadioAction(scenarioState, radioButtons, chats)
    radioButtons = radioButtons or { 0, 1, 2, 3 }
    return function(buttonUsed, trainsetInfo)
        Debug("Radio button used: " .. buttonUsed)
        local correctButton = Contains(radioButtons, buttonUsed)

        if (correctButton == false) then
            Debug("Wrong button used.")
            return false
        end

        CreateCoroutine(function()
            if (chats ~= nil) then
                for _, chat in ipairs(chats)
                do
                    RadioChat(chat.source, chat.text)
                end
            end

            ChangeState(TriggerType.Radio, scenarioState, trainsetInfo)
        end)

        return true
    end
end

function RadioChat( radioCaller, textKey )
    if (radioCaller == RadioCallers.Driver) then
        DriverText(textKey)
    else
        DispatcherText(textKey)
    end
end

function ExecuteRadioCall(radioButton, trainsetInfo)
    local scenarioState = GetScenarioState()
    if (radioActions[scenarioState] ~= nil) then
        if (radioActions[scenarioState](radioButton, trainsetInfo)) then
            return true
        end
    else
        Debug("RadioAction NOT found for scenario state " .. scenarioState)
    end

    return false
end

function SetRadioAction(scenarioState, radioButtons, chats)
    radioActions[scenarioState] = makeRadioAction(scenarioState, radioButtons, chats)
end