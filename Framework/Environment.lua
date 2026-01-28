-- SimRail - The Railway Simulator
-- LUA Scripting scenario
-- Version: 1.0
--
require("SimRailCore")
require("Framework/Common")
require("Framework/RolingStock")

local weatherTypes = { 
                { name = "LightSnow", type = WeatherConditionCode.LightSnow, 
                    temp = { -15, -2 }, visibility = { 800, 1000 }, windSpeed = 5, snowFallTime = 20, months = { 11, 12, 1, 2, 3 } },
                { name = "Snow", type = WeatherConditionCode.Snow, 
                    temp = { -15, -2 }, visibility = { 500, 800 }, windSpeed = 30, snowFallTime = 50, months = { 11, 12, 1, 2, 3 } },
                { name = "FreezingRain", type = WeatherConditionCode.FreezingRain, 
                    temp = { -2, 2 }, visibility = { 200, 500 }, windSpeed = 18, snowFallTime = 25, months = { 10, 11, 12, 1, 2, 3, 4 } },
                { name = "Sleet", type = WeatherConditionCode.Sleet, 
                    temp = { -2, 2 }, visibility = { 200, 500 }, windSpeed = 18, snowFallTime = 25, months = { 10, 11, 12, 1, 2, 3, 4 } },
                { name = "LightThunderStorm", type = WeatherConditionCode.LightThunderstorm, 
                    temp = { 10, 18 }, visibility = { 1000, 1200 }, windSpeed = 5, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "ThunderstormWithLightRain", type = WeatherConditionCode.ThunderstormWithLightRain, 
                    temp = { 10, 18 }, visibility = { 1000, 1200 }, windSpeed = 5, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "ThunderstormWithRain", type = WeatherConditionCode.ThunderstormWithRain, 
                    temp = { 10, 18 }, visibility = { 1000, 1200 }, windSpeed = 5, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "ModerateRain", type = WeatherConditionCode.ModerateRain, 
                    temp = { 5, 15 }, visibility = { 1000, 1200 } , windSpeed = 36, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "LightRain", type = WeatherConditionCode.LightRain, 
                    temp = { 5, 15 }, visibility = { 1000, 1200 } , windSpeed = 36, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "Mist", type = WeatherConditionCode.Mist, 
                    temp = { 10, 18 }, visibility = { 75, 150 }, windSpeed = 5, months = { 4, 5, 6, 8, 9, 10, 11 } },
                { name = "Haze", type = WeatherConditionCode.Haze, 
                    temp = { 10, 18 }, visibility = { 75, 200 }, windSpeed = 5, months = { 4, 5, 6, 7, 8, 9, 10, 11 } },
                { name = "Fog", type = WeatherConditionCode.Fog, 
                    temp = { 10, 18 }, visibility = { 25, 75 }, windSpeed = 5, months = { 6, 7, 8, 9, 10, 11 } },
                { name = "ClearSky", type = WeatherConditionCode.ClearSky, 
                    temp = { 20, 28 }, visibility = { 1800, 2200 }, windSpeed = 10, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "FewClouds", type = WeatherConditionCode.FewClouds, 
                    temp = { 18, 27 }, visibility = { 1800, 2200 }, windSpeed = 10, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "BrokenClouds", type = WeatherConditionCode.BrokenClouds, 
                    temp = { 18, 27 }, visibility = { 1800, 2200 }, windSpeed = 12, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "ScatteredClouds", type = WeatherConditionCode.ScatteredClouds, 
                    temp = { 18, 27 }, visibility = { 1800, 2200 }, windSpeed = 12, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "OvercastClouds", type = WeatherConditionCode.OvercastClouds,
                    temp = { 15, 24 }, visibility = { 1200, 2200 }, windSpeed = 18, months = { 4, 5, 6, 7, 8, 9, 10 } },
                { name = "ClearSky", type = WeatherConditionCode.ClearSky, 
                    temp = { -15, 5 }, visibility = { 1800, 2200 }, windSpeed = 10, months = { 11, 12, 1, 2, 3 } },
                { name = "FewClouds", type = WeatherConditionCode.FewClouds, 
                    temp = { -15, 5 }, visibility = { 1800, 2200 }, windSpeed = 10, months = { 11, 12, 1, 2, 3 } },
                { name = "BrokenClouds", type = WeatherConditionCode.BrokenClouds, 
                    temp = { -15, 5 }, visibility = { 1800, 2200 }, windSpeed = 12, months = { 11, 12, 1, 2, 3 } },
                { name = "ScatteredClouds", type = WeatherConditionCode.ScatteredClouds, 
                    temp = { -15, 5 }, visibility = { 1800, 2200 }, windSpeed = 12, months = { 11, 12, 1, 2, 3 } },
                { name = "OvercastClouds", type = WeatherConditionCode.OvercastClouds,
                    temp = { -15, 5 }, visibility = { 1200, 2200 }, windSpeed = 18, months = { 11, 12, 1, 2, 3 } }
}

local weatherTransitions = {
   { fromType = WeatherConditionCode.OvercastClouds, -- 15-24    4,5,6,7,8,9,10
     toTypes = {
         WeatherConditionCode.BrokenClouds, -- 18-27 4,5,6,7,8,9,10
         WeatherConditionCode.ModerateRain, -- 5-15 4,5,6,7,8,9,10
         WeatherConditionCode.LightThunderstorm -- 10-18  4,5,6,7,8,9,10
     }
   },
   { fromType = WeatherConditionCode.ModerateRain,-- 5-15 4,5,6,7,8,9,10
     toTypes = {
         WeatherConditionCode.Haze, -- 10-18    4,5,6,7,8,9,10,11
         WeatherConditionCode.OvercastClouds, -- 15-24    4,5,6,7,8,9,10
         WeatherConditionCode.LightThunderstorm-- 10-18  4,5,6,7,8,9,10
     }
   },
   { fromType = WeatherConditionCode.ScatteredClouds,-- 18-27    4,5,6,7,8,9,10
     toTypes = {
         WeatherConditionCode.OvercastClouds, -- 15-24    4,5,6,7,8,9,10
         WeatherConditionCode.BrokenClouds, -- 18-27 4,5,6,7,8,9,10
         WeatherConditionCode.FewClouds -- 18-27 4,5,6,7,8,9,10
     }
   },
   { fromType = WeatherConditionCode.BrokenClouds,-- 18-27    4,5,6,7,8,9,10
     toTypes = {
         WeatherConditionCode.OvercastClouds, -- 15-24    4,5,6,7,8,9,10
         WeatherConditionCode.ScatteredClouds, -- 18-27 4,5,6,7,8,9,10
         WeatherConditionCode.FewClouds -- 18-27 4,5,6,7,8,9,10
     }
   },
   { fromType = WeatherConditionCode.FewClouds,-- 18-27    4,5,6,7,8,9,10
     toTypes = {
         WeatherConditionCode.BrokenClouds, -- 18-27    4,5,6,7,8,9,10
         WeatherConditionCode.ScatteredClouds, -- 18-27 4,5,6,7,8,9,10
         WeatherConditionCode.ClearSky -- 20-28 4,5,6,7,8,9,10
     }
   },
   { fromType = WeatherConditionCode.ClearSky,-- 20-28    4,5,6,7,8,9,10
     toTypes = {
         WeatherConditionCode.BrokenClouds, -- 18-27    4,5,6,7,8,9,10
         WeatherConditionCode.ScatteredClouds, -- 18-27 4,5,6,7,8,9,10
         WeatherConditionCode.FewClouds -- 18-27 4,5,6,7,8,9,10
     }
   },
   { fromType = WeatherConditionCode.Fog,-- 10-18   6,7,8,9,10,11
     toTypes = {
         WeatherConditionCode.Mist, -- 
         WeatherConditionCode.Haze, -- 
         WeatherConditionCode.LightRain, -- 
         WeatherConditionCode.ModerateRain -- 
     }
   },
   { fromType = WeatherConditionCode.Haze,-- 
     toTypes = {
         WeatherConditionCode.Mist, -- 
         WeatherConditionCode.Fog, -- 
         WeatherConditionCode.LightRain, -- 
         WeatherConditionCode.ModerateRain -- 
     }
   },
   { fromType = WeatherConditionCode.Mist,-- 
     toTypes = {
         WeatherConditionCode.Fog, -- 
         WeatherConditionCode.Haze, -- 
         WeatherConditionCode.LightRain, -- 
         WeatherConditionCode.ModerateRain -- 
     }
   },
   { fromType = WeatherConditionCode.LightRain,-- 
     toTypes = {
         WeatherConditionCode.Fog, -- 
         WeatherConditionCode.Haze, -- 
         WeatherConditionCode.ModerateRain -- 
     }
   },
   { fromType = WeatherConditionCode.ModerateRain,-- 
     toTypes = {
         WeatherConditionCode.Fog, -- 
         WeatherConditionCode.Haze, -- 
         WeatherConditionCode.LightRain -- 
     }
   },
   { fromType = WeatherConditionCode.ThunderstormWithRain,-- 
     toTypes = {
         WeatherConditionCode.Haze, -- 
         WeatherConditionCode.LightRain, -- 
         WeatherConditionCode.ThunderstormWithLightRain, -- 
         WeatherConditionCode.OvercastClouds, -- 
     }
   },
   { fromType = WeatherConditionCode.ThunderstormWithLightRain,-- 
     toTypes = {
         WeatherConditionCode.Haze, -- 
         WeatherConditionCode.LightRain, -- 
         WeatherConditionCode.ThunderstormWithRain, -- 
         WeatherConditionCode.OvercastClouds, -- 
     }
   },
   { fromType = WeatherConditionCode.LightThunderstorm,-- 
     toTypes = {
         WeatherConditionCode.Haze, -- 
         WeatherConditionCode.LightRain, -- 
         WeatherConditionCode.ThunderstormWithRain, -- 
         WeatherConditionCode.ThunderstormWithLightRain, -- 
         WeatherConditionCode.OvercastClouds, -- 
     }
   },
   { fromType = WeatherConditionCode.Sleet,-- 
     toTypes = {
         WeatherConditionCode.ModerateRain, -- 
         WeatherConditionCode.LightRain, -- 
         WeatherConditionCode.FreezingRain, -- 
         WeatherConditionCode.LightSnow, -- 
         WeatherConditionCode.Snow, -- 
         WeatherConditionCode.OvercastClouds, -- 
     }
   },
   { fromType = WeatherConditionCode.FreezingRain,-- 
     toTypes = {
         WeatherConditionCode.ModerateRain, -- 
         WeatherConditionCode.LightRain, -- 
         WeatherConditionCode.LightSnow, -- 
         WeatherConditionCode.OvercastClouds, -- 
         WeatherConditionCode.Snow, -- 
     }
   },
   { fromType = WeatherConditionCode.LightSnow,-- 
     toTypes = {
         WeatherConditionCode.Sleet, -- 
         WeatherConditionCode.FreezingRain, -- 
         WeatherConditionCode.Snow, -- 
         WeatherConditionCode.OvercastClouds, -- 
         WeatherConditionCode.BrokenClouds, -- 
         WeatherConditionCode.ClearSky, -- 
         WeatherConditionCode.FewClouds, -- 
     }
   },
   { fromType = WeatherConditionCode.Snow,-- 
     toTypes = {
         WeatherConditionCode.Sleet, -- 
         WeatherConditionCode.FreezingRain, -- 
         WeatherConditionCode.LightSnow, -- 
         WeatherConditionCode.OvercastClouds, -- 
         WeatherConditionCode.BrokenClouds, -- 
         WeatherConditionCode.ClearSky, -- 
         WeatherConditionCode.FewClouds, -- 
     }
   },
}

local environment = {
    currentTime = { h = 2, m = 10 },
    fixedDate = false,
    currentDate = { m = 2, d = 1 },
    currentTemp = 0,
    currentWeatherType = nil
}
-- --------------------------------------------------------------------------------------------------------------------------------

local function setWeather(weather, instantChange)
    instantChange = instantChange or false
    if (weather == nil) then
        return
    end

    Debug("NEW WEATHER :" .. weather.name)

    local snowFallTime = weather.snowFallTime or 0
    local maxTemp = weather.temp[2]
    if (environment.currentTemp < 0) then
        maxTemp = environment.currentTemp
    end
    environment.currentTemp = math.random(weather.temp[1], math.min(weather.temp[2], maxTemp))

    local visibility = math.random(weather.visibility[1], weather.visibility[2])

    SetWeather(weather.type, environment.currentTemp, 1000, 100, visibility, 
                0, weather.windSpeed, snowFallTime, instantChange)
    environment.currentWeatherType = weather.type
end

local function findSutableWeatherData(selectedWeather, currentMonth)
    for _, weather in ipairs(weatherTypes)
    do
        if (weather.type == selectedWeather and Contains(weather.months, currentMonth)) then
            return weather
        end
    end

    return nil
end

local function selectMonth()
    local selectedMonth = GetDropdownMenuIndex("SelectMonth", "ConfirmMonth", { "M01", "M02", "M03", "M04", "M05", "M06", "M07", "M08", "M09", "M10", "M11", "M12" })

    if (selectedMonth == nil) then
        Error("No month selected")
    end

    return selectedMonth
end

local function setMonth(environmentConfig)
    if (environmentConfig ~= nil and environmentConfig.Month ~= nil) then
        environment.currentDate.m = environmentConfig.Month
    else
        if (environmentConfig.SelectMonth) then
            environment.currentDate.m = selectMonth()
        else
            environment.currentDate.m = math.random(1, 12)
        end
    end

    return environment.currentDate.m
end

local function setTimeOfDay(environmentConfig)
    environment.currentTime.m = math.random(1, 59)

    if (environmentConfig ~= nil and environmentConfig.Hour ~= nil) then
        environment.currentTime.h = environmentConfig.Hour
    else
        if (environmentConfig.SelectTime) then
            environment.currentTime.h = GetDropdownMenuIndex("SelectTime", "ConfirmTime", 
                { "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", 
                 "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "24:00" })
        else
            environment.currentTime.h = math.random(1, 23)
        end
    end
end

local function getAvaliableWeatherTypes(month)
    local availableWeathertypes = {}

    for i, weather in ipairs(weatherTypes)
    do
        if (Contains(weather.months, month)) then
            table.insert(availableWeathertypes, weather)
        end
    end

    if (#availableWeathertypes == 0) then
        Error("There are no available weather types for month " .. month)
    end

    return availableWeathertypes
end

local function getWeatherByName(availableWeathertypes, weatherName)
    local foundWeather = nil

    for _,weather in ipairs(availableWeathertypes)
    do 
        if (weather.name == weatherName) then
            foundWeather = weather
            break
        end
    end

    if (foundWeather == nil) then
        Error("There is no available weather called '" .. weatherName .. "'")
    end

    return foundWeather
end

local function userSelectedWeather(availableWeathertypes)
    local options = {}
    for i, weather in ipairs(availableWeathertypes)
    do
        table.insert(options, weather.name)
    end
    local selectedWeatherIndex = GetDropdownMenuIndex("SelectWeather", "ConfirmWeather", options)

    if (selectedWeatherIndex == nil) then
        Error("No weather selected")
    end

    return availableWeathertypes[selectedWeatherIndex]
end

local function configureWeather(environmentConfig, month)
    local availableWeathertypes = getAvaliableWeatherTypes(month)
    local selectedWeather = nil

    if (environmentConfig ~= nil and environmentConfig.Weather ~= nil) then
        selectedWeather = getWeatherByName(availableWeathertypes, environmentConfig.Weather)
    else
        if (environmentConfig.SelectWeather) then
            selectedWeather = userSelectedWeather(availableWeathertypes)
        else
            selectedWeather = availableWeathertypes[math.random(1, #availableWeathertypes)]
        end
    end

    if (selectedWeather == nil) then
        Error("No weather have been selected")
    end

    environment.currentWeatherType = selectedWeather.type

    return selectedWeather
end

local function getPossibleWeatherTransitions(currentWeather)
    local possibleWethertypes = nil
    for _, type in ipairs(weatherTransitions)
    do 
        if (type.fromType == currentWeather) then
            possibleWethertypes = type.toTypes
            break
        end
    end

    return possibleWethertypes
end

local function letUserSelectScenarioStart()
    Debug("Selecting Scenario")
    local options = {}
    for _,scenario in ipairs(Scenario)
    do
        table.insert(options, scenario.langText)
    end

    local scenarioIndex = GetDropdownMenuIndex("SelectScenario", "ConfirmScenario", options)

    if (scenarioIndex == nil) then
        Error("No scenario selected")
    end

    return scenarioIndex
end

local function getAllScenarioAlternativesBySelectedScenarioId(selectedScenarioId)
    Debug("Selected scenario ID " .. selectedScenarioId)
    local scenarioAlternatives = {}
    for index, alternative in pairs(StartAlternatives)
    do
        local scenarioId = alternative.scenarioId or 0
        if (scenarioId == selectedScenarioId) then
            table.insert(scenarioAlternatives, alternative)
        end
    end

    Debug(#scenarioAlternatives .. " scenario alternatives selected")

    if (#scenarioAlternatives == 0) then
        Error("No scenario found")
    end

    return scenarioAlternatives
end

local function getStartScenarioDefinition()
    Scenario = Scenario or {}
    if (#Scenario == 0) then
        Error("There is no start scenario defined")
        return
    end

    local selectedScenario = {}
    if (#Scenario == 1) then
        selectedScenario = GetScenarioAlternativeById(Scenario[1].scenarioId)
    else
        selectedScenario = SelectStartScenario() or {}
    end

    if (#selectedScenario == 0) then
        Error("No start scenario selected")
    end

    return selectedScenario
end


local function setupEnvironment(environmentConfig)
    environmentConfig = environmentConfig or EnvironmentConfig
    Debug("Setting environment")
    environment.currentDate.d = math.random(1, 28)
    setMonth(environmentConfig)
    setTimeOfDay(environmentConfig)

    SetStartDateTime(DateTimeCreate(2024, environment.currentDate.m, environment.currentDate.d, environment.currentTime.h, environment.currentTime.m, 0))
    Debug("Start time 2024-" .. environment.currentDate.m .. "-" .. environment.currentDate.d .. " " .. environment.currentTime.h .. ":" .. environment.currentTime.m .. ":00")

    setWeather(configureWeather(environmentConfig, environment.currentDate.m), true)
end

function GetCurrentMonth()
    return environment.currentDate.m
end

function GetCurrentDay()
    return environment.currentDate.d
end

function GetCurrentHour()
    return environment.currentTime.h
end

function GetCurrentMinute()
    return environment.currentTime.m
end

function GetCurrentTemp()
    return environment.currentTemp
end

function GetScenarioAlternativeById(scenarioId)
    local scenarioAlternatives = getAllScenarioAlternativesBySelectedScenarioId(scenarioId)
    local selected = math.random(1, #scenarioAlternatives)
    Debug("Selected scenario start " .. selected .. " out of " .. #scenarioAlternatives)
    local selectedScenario =  scenarioAlternatives[selected]
    if (selectedScenario == nil) then
        Error("NO SCENARIO FOUND")
        return
    end
    Debug("Selected scenario = " .. selectedScenario.scenarioState)
    return selectedScenario
end

function SelectStartScenario()
    local selectedScenario = Scenario[letUserSelectScenarioStart()]
    local scenarioToPlay = GetScenarioAlternativeById(selectedScenario.scenarioId)

    if (scenarioToPlay == nil) then
        Error("No scenario selected")
        return
    end

    Debug("Selected scenario to play " .. scenarioToPlay.scenarioState)
    return scenarioToPlay
end

function ChangeWeather()
    local possibleWethertypes = getPossibleWeatherTransitions(environment.currentWeatherType)

    if (possibleWethertypes == nil) then
        return
    end

    local selectedWeather = possibleWethertypes[math.random(1, #possibleWethertypes)]

    setWeather(findSutableWeatherData(selectedWeather, environment.currentDate.m), false)
end

function SetPlayerStartPosition(startPosition)
    local position = startPosition
    --SetBlockTeleportation(false)
    --SetPlayerPosition(position[1], position[3])
    --local vector = Vector3(position[1], position[2], position[3])
    --CameraSetLocalEulerRotation(vector, true)
    StartPosition = startPosition
end

function GetStartScenario()
    local success, startScenarioDefinition = pcall(getStartScenarioDefinition)
    if (not success) then
        Error("Can not get start scenario name '" .. startScenarioDefinition .. "'")
        return
    end
    if (startScenarioDefinition == nil) then
        Error("No scenario selected")
        return
    end

    return startScenarioDefinition
end


function ConfigureEnvironment()
    local success, errorMsg = pcall(setupEnvironment, EnvironmentConfig)
    if (not success) then
        Error("Can not setup environment '" .. errorMsg .. "'")
    end
end

function ShowScenarioData(delay)
    DisplayMessage_Formatted("ScenarioData", delay, MonthName(GetCurrentMonth()), GetCurrentDay(), GetCurrentHour(), GetCurrentMinute(), GetCurrentTemp(),
                GetPlayerLocoName(), GetPlayerStartTrainLength(), GetPlayerStartTrainWeight())
end