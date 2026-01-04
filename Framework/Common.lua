require("SimRailCore")
require("Sounds")

TriggerType = { Signal = 1, Track = 2, Radio = 3, Coupling = 4, Decoupling = 5 }
RadioCallers = { Driver = 1, Dispatcher = 2 }
OrderType = { Shunting = 1, Train = 2 }
TrackTriggerType = { Front = 1, Back = 2 }
TrainTypes = { Cargo = 1, Passenger = 2 }
TrainPhysics = { Bot = 1, Player = 2 }
CargoTypes = { Coal = 1, Ballast = 2, Sand = 3, Wood = 4, Metal = 5, Pipelines = 6,
                Concrete = 7, Petroleum = 8, Gas = 9, Containers = 10 }


local function playAudioAndDisplayText(color, who, textKey, volume, radioFilter)
    textKey = textKey or ""
    volume = volume or 1
    who = who or "?"

    if (textKey == "") then
        return
    end

    DisplayCommunicationChatText(who, true, color, textKey)
    if (Sounds[textKey] ~= nil) then
        Debug("Playing sound with key " .. textKey)
        PlayNarrationAudioClip(textKey, volume, radioFilter)
        coroutine.yield(CoroutineYields.WaitForAudioFinishedPlaying, textKey);
    end
end

function Contains(tbl, str)
    for _,v in ipairs(tbl)
    do
       if (v == str) then
            return true
       end 
    end

    return false
end

function ConcatTables(destinationTbl, sourceTbl)
    for  _,v in pairs(sourceTbl)
    do
        table.insert(destinationTbl, v)
    end

    return destinationTbl
end

function Debug(text)
    if (ShowDebugText == true) then
        Log(text)
    end
end


function NarrativeText( textKey )
    playAudioAndDisplayText(ColorCreateHex("#a0a0ff"), "Narrator", textKey)
end

function DriverText( textKey )
    playAudioAndDisplayText(ColorCreateHex("#00ff00"), "Driver", textKey)
end

function DispatcherText( textKey )
    playAudioAndDisplayText(ColorCreateHex("#9000ff"), "Dispatcher", textKey, 0.2, 0)
end

function BrakeTesterText( textKey )
    playAudioAndDisplayText(ColorCreateHex("#ffa00f"), "BrakeTester", textKey, 0.2, 0)
end

function MonthName(month)
    if (month <1 or month > 12) then
        Error("Month out of bounds. (" .. month .. ")")
        return
    end

    local monthNames = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }

    return monthNames[month] or "?"
end

function GetDropdownMenuIndex(description, confirmation, options)
    local selectedIndex = nil;

    ShowDropdownMessageBox(description, options,
        { ConfirmationText = confirmation,
            OnConfirm = function(_, index)
                selectedIndex = index
                return false
            end,
            OnSelect = function() return false end
        })

    coroutine.yield(CoroutineYields.WaitUntil, function () return selectedIndex ~= nil end);

    return selectedIndex
end