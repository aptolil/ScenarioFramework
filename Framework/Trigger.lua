require("SimRailCore")
require("Framework/Common")
require("Framework/Radio")
require("Framework/State") -- ChangeState

local trackTriggers = {}
local trackTriggerConfig = {}
local signalTriggerConfig = {}
local radioTriggerConfig = {}

local makeTriggerResultFunction = function (triggerName, triggerType, waitFunctions, lifetime)
    return function(trainsetInfo)
        CreateCoroutine(function()
            Debug("Trigger executed: name '" .. triggerName .. "'")
            if ( waitFunctions ~= nil) then
                for i, func in ipairs(waitFunctions)
                do
                    func(trainsetInfo)
                end
            end

            ChangeState(triggerType, triggerName, trainsetInfo)

            if (lifetime ~= nil) then
                lifetime = lifetime - 1
                if (lifetime <= 0 and triggerType == TriggerType.Track) then
                    local trigger = trackTriggers[triggerName]
                    if (trigger ~= nil) then
                        RemoveTrackTrigger(trigger)
                    end
                end
            end
        end)
    end
end

function MakeTriggers(startState)
    -- Create Signal triggers
    for _, v in ipairs(signalTriggerConfig)
    do
        Debug("Making trigger for signal " .. v.signal)
        if (v.withStartState == nil or Contains(v.withStartState, startState)) then
            CreateSignalTrigger(FindSignal(v.signal), v.distance, {
                check = UnconditionalCheck,
                result = makeTriggerResultFunction(v.signal, TriggerType.Signal, v.waitFunction)
            })
        end
    end


    -- Create Track triggers

    for _, v in ipairs(trackTriggerConfig)
    do
        local isPermanent = v.isPermanent or false
        local triggerType = v.type or TrackTriggerType.Front

        if (v.withStartState == nil or Contains(v.withStartState, startState)) then
            if (triggerType == TrackTriggerType.Front) then
                Debug("Making front trigger for track " .. v.track)
                trackTriggers[v.track] = CreateTrackTriggerFront(FindTrack(v.track), v.distance, v.direction , {
                    check = UnconditionalCheck,
                    result = makeTriggerResultFunction(v.track, TriggerType.Track, v.waitFunction, v.lifetime)
                },
                not isPermanent)
            else
                Debug("Making back trigger for track " .. v.track)
                trackTriggers[v.track] = CreateTrackTriggerBack(FindTrack(v.track), v.distance, v.direction , {
                    check = UnconditionalCheck,
                    result = makeTriggerResultFunction(v.track, TriggerType.Track, v.waitFunction, v.lifetime)
                },
                not isPermanent)
            end
        end
    end

    -- Make Radio Triggers

    for _, v in ipairs(radioTriggerConfig)
    do
        Debug("Making radio trigger for scenario state " .. v[1])
        SetRadioAction(v[1], v[2].radioButtons, v[2].chats)
    end
end

function InitTriggers(track, signal, radio)
    trackTriggerConfig = track
    signalTriggerConfig = signal
    radioTriggerConfig = radio
end