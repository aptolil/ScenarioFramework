require("SimRailCore")
require("Framework/Common")

local playerLocoName = ""
local playerTrainMaxWeight = 0
local playerStartTrainWeight = 0
local playerStartTrainLength = 0
local welcomeText = ""
local playerLocomotives = {}

-- Available locomtives
local locos = {
    ["Traxx"] = { name = "E186 - EU43 - TRAXX F140 MS2e", types = { LocomotiveNames.E186_929, LocomotiveNames.E186_134 }, weight = { service = 84, train = 2500 }, trainTypes = { TrainTypes.Cargo, TrainTypes.Passenger }, brakeRegime = BrakeRegime.P },
    ["ET22"] = { name = "ET22 - 201E", 
        types = { LocomotiveNames.ET22_243, LocomotiveNames.ET22_256, LocomotiveNames.ET22_644, LocomotiveNames.ET22_836, LocomotiveNames.ET22_911, LocomotiveNames.ET22_1163 }, 
        weight = { service = 120, train = 3125 }, trainTypes = { TrainTypes.Cargo, TrainTypes.Passenger }, brakeRegime = BrakeRegime.P },
    ["EU07"] = { name = "EU07", 
        types = { LocomotiveNames.EU07_005, LocomotiveNames.EU07_068, LocomotiveNames.EU07_070, LocomotiveNames.EU07_085, LocomotiveNames.EU07_092, LocomotiveNames.EU07_096 }, 
        weight = { service = 80, train = 1800 }, trainTypes = { TrainTypes.Cargo, TrainTypes.Passenger }, brakeRegime = BrakeRegime.P },
    ["ED250"] = { name = "ED250 - Pendolino", types = { LocomotiveNames.ED250_018, LocomotiveNames.ED250_001, LocomotiveNames.ED250_009, LocomotiveNames.ED250_015 }, weight = { service = 410, train = 410 }, trainTypes = { TrainTypes.Passenger }, brakeRegime = BrakeRegime.R },
    ["EP08"] = { name = "EP08 - 102E", types = { LocomotiveNames.EP08_00, LocomotiveNames.EP08_008, LocomotiveNames.EP08_013 }, weight = { service = 80, train = 1800 }, trainTypes = { TrainTypes.Passenger }, brakeRegime = BrakeRegime.P },
    ["EP07"] = { name = "EP07 - 4E", types = { LocomotiveNames.EP07_135, LocomotiveNames.EP07_174, LocomotiveNames.EU07_241 }, weight = { service = 80, train = 1800 }, trainTypes = { TrainTypes.Cargo, TrainTypes.Passenger }, brakeRegime = BrakeRegime.P },
    ["ET25"] = { name = "ET25 - Dragon 2", types = { LocomotiveNames.ET25_002, LocomotiveNames.E6ACTa_014, LocomotiveNames.E6ACTa_016, LocomotiveNames.E6ACTadb_027 }, weight = { service = 120, train = 3500 }, trainTypes = { TrainTypes.Cargo }, brakeRegime = BrakeRegime.P },
    ["EN57"] = { name = "EN57 - Kibel", 
        types = { LocomotiveNames.EN57_009, LocomotiveNames.EN57_038, LocomotiveNames.EN57_047, 
                  LocomotiveNames.EN57_206, LocomotiveNames.EN57_612, LocomotiveNames.EN57_614, 
                  LocomotiveNames.EN57_650, LocomotiveNames.EN57_919, LocomotiveNames.EN57_1000, 
                  LocomotiveNames.EN57_1003, LocomotiveNames.EN57_1051, LocomotiveNames.EN57_1181, 
                  LocomotiveNames.EN57_1219, LocomotiveNames.EN57_1316, LocomotiveNames.EN57_1331, 
                  LocomotiveNames.EN57_1458, LocomotiveNames.EN57_1567, LocomotiveNames.EN57_1571, 
                  LocomotiveNames.EN57_1752, LocomotiveNames.EN57_1755, LocomotiveNames.EN57_1796, 
                  LocomotiveNames.EN57_1821}, 
                  weight = { service = 127, train = 127 }, trainTypes = { TrainTypes.Passenger }, brakeRegime = BrakeRegime.P },
    ["EN71"] = { name = "EN71 - Kibel", 
        types = { LocomotiveNames.EN71_002, LocomotiveNames.EN71_004, LocomotiveNames.EN71_005,
                  LocomotiveNames.EN71_011, LocomotiveNames.EN71_015},
                  weight = { service = 182, train = 182 }, trainTypes = { TrainTypes.Passenger }, brakeRegime = BrakeRegime.P },
    ["EN76"] = { name = "EN76 - Elf", 
        types = { LocomotiveNames.EN76_006, LocomotiveNames.EN76_022 },
                  weight = { service = 135, train = 135 }, trainTypes = { TrainTypes.Passenger }, brakeRegime = BrakeRegime.P },
    ["EN96"] = { name = "EN96 - Elf", 
        types = { LocomotiveNames.EN96_001 }, weight = { service = 83, train = 83 }, trainTypes = { TrainTypes.Passenger }, brakeRegime = BrakeRegime.P },
}


-- Defines available wagons/carriages and their meta data like length, weights and possible loads.
-- This information will be used to put together random train sets.
local cargoWagons = { 
    { wagon = { FreightWagonNames._441V_31516635283_3, FreightWagonNames._441V_31516635512_5 },
            length = 13.5,
            cargo = { FreightLoads_412W_v4.Coal, FreightLoads_412W_v4.Ballast, FreightLoads_412W_v4.Sand , FreightLoads_412W_v4.WoodLogs }, 
            weight = { empty = 24, minWithLoad = 40, maxWithLoad = 64 } 
    },
    { wagon = { FreightWagonNames.EAOS_3356_5300_118_0, FreightWagonNames.EAOS_3351_5356_394_5, FreightWagonNames.EAOS_3356_5300_177_6, 
                FreightWagonNames.EAOS_3151_5349_475_9, FreightWagonNames.EAOS_3151_5351_989_9 },
            length = 14,
            cargo = { FreightLoads_412W_v4.Ballast, FreightLoads_412W_v4.Coal, FreightLoads_412W_v4.Sand, FreightLoads_412W_v4.WoodLogs }, 
            weight = { empty = 20, minWithLoad = 30, maxWithLoad = 60 } 
    },
    { wagon = { FreightWagonNames.SGS_3151_3944_773_6, FreightWagonNames.SGS_3151_3947_512_5 },
            length = 14,
            cargo = { FreightLoads_412W.Sheet_metal, FreightLoads_412W.Concrete_slab, FreightLoads_412W.Gas_pipeline, FreightLoads_412W.Pipeline,
                    FreightLoads_412W.Steel_circle, FreightLoads_412W.T_beam, FreightLoads_412W.Tie, FreightLoads_412W.Tree_trunk, 
                    FreightLoads_412W.Wooden_beam, FreightLoads_412W.RandomContainerAll, FreightLoads_412W.RandomContainer3x20, 
                    FreightLoads_412W.RandomContainer1x40, FreightLoads_412W.RandomContainer2040, FreightLoads_412W.RandomContainer1x20,
                    FreightLoads_412W.RandomContainer2x20 }, 
            weight = { empty = 20, minWithLoad = 40, maxWithLoad = 60 } 
    },
    { wagon = { FreightWagonNames.Zaes_3351_0079_375_1, FreightWagonNames.Zaes_3351_7881_520_5, FreightWagonNames.Zaes_3351_7980_031_3, 
                    FreightWagonNames.Zaes_3351_7982_861_1, FreightWagonNames.Zaes_3451_7981_215_0, FreightWagonNames.Zas_8451_7862_699_8 },
        length = 12,
        cargo = { FreightLoads_406Ra.Ethanol, FreightLoads_406Ra.Heating_Oil, FreightLoads_406Ra.Petrol, FreightLoads_406Ra.Crude_Oil }, 
        weight = { empty = 23, minWithLoad = 20, maxWithLoad = 57 } 
    },
    { wagon = { FreightWagonNames._230_01_31514508558_7 },
        length = 14,
        cargo = { FreightLoads_629Z.RandomContainer1x20, FreightLoads_629Z.RandomContainer2x20, FreightLoads_629Z.RandomContainer1x40 }, 
        weight = { empty = 16.5, minWithLoad = 40, maxWithLoad = 73.5 } 
    },
    { wagon = { FreightWagonNames._434Z_31514553133_5 },
        length = 20,
        cargo = { FreightLoads_629Z.RandomContainer1x20, FreightLoads_629Z.RandomContainer2x20, FreightLoads_629Z.RandomContainer3x20, 	
                    FreightLoads_629Z.RandomContainer1x40, FreightLoads_629Z.RandomContainer2040, FreightLoads_629Z.GasContainer2x20, 	
                    FreightLoads_629Z.GasContainer3x20 }, 
        weight = { empty = 18.87, minWithLoad = 60, maxWithLoad = 70 } 
    },
    { wagon = { FreightWagonNames._629Z_21514960133_0 },
        length = 27,
        cargo = { FreightLoads_629Z.RandomContainer2x20, FreightLoads_629Z.RandomContainer3x20, FreightLoads_629Z.RandomContainer4x20, 
                    FreightLoads_629Z.RandomContainer2x40, FreightLoads_629Z.RandomContainer202040, FreightLoads_629Z.RandomContainer402020, 
                    FreightLoads_629Z.GasContainer2x20, FreightLoads_629Z.GasContainer3x20, FreightLoads_629Z.GasContainer4x20 }, 
        weight = { empty = 27, minWithLoad = 60, maxWithLoad = 106.5 } 
    },
    { wagon = { FreightWagonNames.UACS_3351_9307_587_6 },
        length = 14,
        cargo = { DummyLoadObject }, 
        weight = { empty = 24.5, minWithLoad = 20, maxWithLoad = 55.7 } 
    }
}

local passengerWagons = {
    { wagon = { PassengerWagonNames.Bc9ou_5051_5978_003_8, PassengerWagonNames.Bcdu_5051_5978_003_8_The80s, 
                 PassengerWagonNames.Bcdu_5051_5970_048_0_The80s, PassengerWagonNames.Bcwxz_5151_5980_271_6_The80s },
        length = 25, weight = 38, brakeRegime = BrakeRegime.R
    },
    { wagon = { PassengerWagonNames.B10ou_5051_2000_608_3, PassengerWagonNames.B10nou_5051_2008_607_7,
                    PassengerWagonNames.B10ou_5151_2070_829_9, PassengerWagonNames.B10nouz_5151_2071_102_0,
                    PassengerWagonNames.Bdnu_5051_2000_608_3_The80s, PassengerWagonNames.Bdnu_5051_2008_607_7_The80s },
        length = 25, weight = 38, brakeRegime = BrakeRegime.R
    },
    { wagon = { PassengerWagonNames.B10ou_5051_2000_608_3 },
        length = 26.4, weight = 46, brakeRegime = BrakeRegime.R
    },
    { wagon = { PassengerWagonNames.WRmnouz_6151_8870_191_1 },
        length = 26, weight = 48, brakeRegime = BrakeRegime.R
    },
    { wagon = { PassengerWagonNames.A9mnouz_6151_1970_214_5, PassengerWagonNames.A9mnouz_6151_1970_234_3,
                   PassengerWagonNames.B11gmnouz_6151_2170_107_7 },
        length = 26, weight = 38, brakeRegime = BrakeRegime.R
    },
    { wagon = { PassengerWagonNames.B10bmnouz_6151_2071_105_1, PassengerWagonNames.B11bmnouz_6151_2170_064_0,
                  PassengerWagonNames.B11bmnouz_6151_2170_098_8 },
        length = 26, weight = 50, brakeRegime = BrakeRegime.R
    }
}

local cargoTypes = {
    [CargoTypes.Coal] = { FreightLoads_412W_v4.Coal },
    [CargoTypes.Ballast] = { FreightLoads_412W_v4.Ballast },
    [CargoTypes.Sand] = { FreightLoads_412W_v4.Sand },
    [CargoTypes.Wood] = { FreightLoads_412W_v4.WoodLogs, FreightLoads_412W.Tree_trunk,
                FreightLoads_412W.Wooden_beam },
    [CargoTypes.Metal] = { FreightLoads_412W.Sheet_metal, FreightLoads_412W.T_beam, 
                FreightLoads_412W.Steel_circle },
    [CargoTypes.Pipelines] = { FreightLoads_412W.Gas_pipeline, FreightLoads_412W.Pipeline },
    [CargoTypes.Concrete] = { FreightLoads_412W.Concrete_slab, FreightLoads_412W.Tie },
    [CargoTypes.Petroleum] = { FreightLoads_406Ra.Ethanol, FreightLoads_406Ra.Heating_Oil,
                    FreightLoads_406Ra.Petrol, FreightLoads_406Ra.Crude_Oil },
    [CargoTypes.Gas] = { FreightLoads_629Z.GasContainer2x20, FreightLoads_629Z.GasContainer3x20,
                FreightLoads_629Z.GasContainer4x20 },
    [CargoTypes.Containers] = { FreightLoads_412W.RandomContainerAll, FreightLoads_412W.RandomContainer3x20,
                FreightLoads_412W.RandomContainer1x40, FreightLoads_412W.RandomContainer2040,
                FreightLoads_412W.RandomContainer1x20, FreightLoads_412W.RandomContainer2x20,
                FreightLoads_629Z.RandomContainer1x20, FreightLoads_629Z.RandomContainer2x20,
                FreightLoads_629Z.RandomContainer3x20, FreightLoads_629Z.RandomContainer4x20, 
                FreightLoads_629Z.RandomContainer1x40, FreightLoads_629Z.RandomContainer2x40,
                FreightLoads_629Z.RandomContainer2040, FreightLoads_629Z.RandomContainer202040,
                FreightLoads_629Z.RandomContainer402020 }
}

-- skapa en struktur som heter passengerWagons

local makeVehicle = function (wagon, cargo, brakeRegime, weight)
    return CreateNewSpawnFullVehicleDescriptor(wagon, false, cargo, weight, brakeRegime)
end

function SelectPlayerLocomotive()
    local LocoIndex = GetDropdownMenuIndex("SelectEngine", "ConfirmEngine", PlayerLocomotives)

    Debug("Selected loco " .. playerLocomotives[LocoIndex])
    return playerLocomotives[LocoIndex]
end

local function allowCoupling(trainSet)
    trainSet.SetAllowCouplerAttach(true)
    trainSet.SetAllowCouplerDetach(true)
end

local function getWagonsForCargo(cargo)
    local carriages = {}

    for _, carriage in ipairs(cargoWagons)
    do
        if (Contains(carriage.cargo, cargo)) then
            table.insert(carriages, carriage)
        end
    end

    Debug(#carriages .. " sutable carriages found for cargo " .. cargo)
    return carriages
end

local function selectWagonForCargoType(cargoType)
    local cargo = cargoTypes[cargoType]

    if (cargo == nil) then
        Error("There is no cargo type called '" .. cargoType .. "'")
        return
    end

    local selectedCargo = cargo[math.random(1, #cargo)]
    local wagons = getWagonsForCargo(selectedCargo)

    if (#wagons == 0) then
        Error("There are no sutable carriages")
        return
    end

    return wagons[math.random(1, #wagons)], selectedCargo
end

local function createRandomCargoWagon(wantedCargoTypes) -- Returns length, weight and SpawnVehicleDescription
    local loaded = math.random(0, 100) <= 70 -- If it should be loaded.
    local selectedWagon
    local cargo

    if (wantedCargoTypes ~= nil) then
        local randomCargoType = wantedCargoTypes[math.random(1, #wantedCargoTypes)]
        Debug("Selected cargo type " .. randomCargoType)
        selectedWagon, cargo = selectWagonForCargoType(randomCargoType)
    else
        selectedWagon = cargoWagons[math.random(1, #cargoWagons)]
        cargo = selectedWagon.cargo[math.random(1, #selectedWagon.cargo)]
    end

    if (selectedWagon == nil) then
        Error("Can not create a random carriage.")
        return
    end
    Debug("Selected wagon length " .. (selectedWagon.length or 0))
    Debug("Selected wagon cargo " .. (cargo or ""))
    local wagonTypes = selectedWagon.wagon
    local wagon = wagonTypes[math.random(1, #wagonTypes)]

    local weights = selectedWagon.weight
    local loadedWeight = math.random(weights.minWithLoad, weights.maxWithLoad)

    if (loaded) then
        return selectedWagon.length, loadedWeight, makeVehicle(wagon, cargo, BrakeRegime.P, loadedWeight)
    else
        return selectedWagon.length, weights.empty, makeVehicle(wagon, nil, BrakeRegime.P, weights.empty)
    end
end

local function createRandomPassengerWagon() -- Returns length, weight and SpawnVehicleDescription
    local w = math.random(1, #passengerWagons)
    local selectedWagon = passengerWagons[w]

    local wagonTypes = selectedWagon.wagon
    local selectedType = math.random(1, #wagonTypes)
    local wagon = wagonTypes[selectedType]

    return selectedWagon.length, selectedWagon.weight, makeVehicle(wagon, nil, selectedWagon.brakeRegime, selectedWagon.weight)
end

local function createStartCarriages(scenarioName, locoMaxWeight) 
    Debug("create start carriages. locoMaxWeight " .. locoMaxWeight)
    local carriagesWeight = 0
    local carriagesLength = 0

    for _, carriage in ipairs(StartCarriages)
    do
        if (Contains(carriage.withStartState, scenarioName)) then
            local maxWeight = carriage.maxWeight or locoMaxWeight
            if (maxWeight < 0) then
                maxWeight = locoMaxWeight + maxWeight
            end
            local length, weight, carriages = CreateRandomWagonSet(maxWeight, carriage.minLength, carriage.maxLength, carriage.trainType, carriage.cargoTypes)
            Debug("RandomWagonSet: length " .. length .. ", weight " .. weight .. ", # carriages " .. #carriages)

            local trainPhysics = true
            if (carriage.trainPhysics == TrainPhysics.Player) then
                trainPhysics = false
            end
            SpawnTrainsetOnSignalAsync("CarriagesAt"..carriage.atSignalName, FindSignal(carriage.atSignalName), carriage.distance, false, false, trainPhysics, carriages)
            if (carriage.belongsToPlayerTrain) then
                Debug("Values belongs to player train")
                carriagesWeight = weight
                carriagesLength = length
            end
        end
    end

    return carriagesWeight, carriagesLength
end

local function validateLocoKey(locoKey)
    locoKey = locoKey or ""
    if (locoKey == "") then
        Error("No player locomotive selected.")
        return false
    end
    if (locos[locoKey] == nil) then
        Error("There is no locomotive called '" .. locoKey .. "'")
        return false
    end

    return true
end

local function setTimeTable(trainsetInfo, timeTableFile)
    trainsetInfo.SetTimetable(LoadTimetableFromFile(timeTableFile), false)
end

local function placePlayerTrain(scenario, train)
    Debug("Place player train")
    if (train == nil) then
        Debug("There is no train to place")
        return
    end

    local trainSet = SpawnTrainsetOnSignal("Player", FindSignal(scenario.signal), scenario.distance, true, true, false, scenario.playerInsideTrain, train)
    trainSet.SetRadioChannel(scenario.radioChannel, true)
    trainSet.SetState(scenario.dynamicState, scenario.trainState, true)
    allowCoupling(trainSet)

    SetScenarioState(scenario.scenarioState)
    StartPosition = scenario.StartPosition

    if (scenario.playerInsideTrain == false) then
        Debug("PLAYER is walking outside")
        SetCameraView(CameraView.FirstPersonWalkingOutside);
    end

    if (scenario.timeTable ~= nil and #scenario.timeTable > 4 ) then
        Debug("Setting time table")
        setTimeTable(trainSet, scenario.timeTable)
    end
end
    
local function createPlayerTrain(scenario, selectedLoco)
    Debug("Create player train")
    local locoName, trainMaxWeight, loco = CreateLocomotive(selectedLoco, scenario.trainType)

    local trainLength = selectedLoco.length or 12
    local weights = selectedLoco.weight or { service = 80, train = 1800 }
    local trainWeight = weights.service or 50

    local train = { loco }
    local carriageData = scenario.carriages

    if (carriageData ~= nil) then
        local maxWeight = carriageData.maxWeight or trainMaxWeight
        if (maxWeight < 0) then
            maxWeight = trainMaxWeight + maxWeight
        end
        local carriagesLength, carriagesWeight, carriages = CreateRandomWagonSet(maxWeight, carriageData.minLength, carriageData.maxLength, scenario.trainType, carriageData.cargoTypes)
        trainWeight = trainWeight + carriagesWeight
        trainLength = trainLength + carriagesLength
        
        train = ConcatTables(train, carriages)
    end

    playerLocoName = locoName or ""
    playerTrainMaxWeight = trainMaxWeight or 0
    playerStartTrainWeight = trainWeight or 0
    playerStartTrainLength = trainLength or 0

    return train
end

local function getPlayerLocomotiveKey()
    local playerLocomotiveKey
    if (#PlayerLocomotives == 1) then
        playerLocomotiveKey = PlayerLocomotives[1]
    else
        playerLocomotiveKey = SelectPlayerLocomotive() or ""
    end
    Debug("Mission selected loco key " .. playerLocomotiveKey)

    if (playerLocomotiveKey == "") then
        Error("No locomotive selected")
    end

    return playerLocomotiveKey
end

function CreateRandomWagonSet(maxWeight, minLength, maxLength, traintype, selectedCargoTypes)
    Debug("Create random wagon set")
    Debug("   maxWeight " .. maxWeight)
    Debug("   minLength " .. minLength)
    Debug("   maxLength " .. maxLength)
    maxWeight = maxWeight or 5000
    minLength = minLength or 12
    maxLength = maxLength or 300
    traintype = traintype or TrainTypes.Cargo

    local weight = 0
    local length = 0
    local wagonSet = {}
    local finished = false
    local wagonLength
    local wagonWeight
    local wagon
    local maxSameWagonType
    local wantedLength = math.random(minLength, maxLength)
    Debug("   wantedLength " .. wantedLength)

    repeat
        if (traintype == TrainTypes.Cargo) then
            wagonLength, wagonWeight, wagon = createRandomCargoWagon(selectedCargoTypes)
            maxSameWagonType = math.random(1, 5)
        else
            wagonLength, wagonWeight, wagon = createRandomPassengerWagon()
            maxSameWagonType = 200
        end

        Debug("Created wagon")
        Debug("   wagonLength " .. wagonLength)
        Debug("   wagonWeight " .. wagonWeight)
        Debug("   maxSameWagonType " .. maxSameWagonType)

        for w = 1, maxSameWagonType, 1
        do
            if ((weight + wagonWeight > maxWeight) or (length + wagonLength > wantedLength)) then
                finished = true
                break
            end

            weight = weight + wagonWeight
            length = length + wagonLength
            table.insert(wagonSet, wagon)
        end
    until(finished)

    return length, weight, wagonSet
end

function CreateLocomotive(selectedLoco, trainType) 
    trainType = trainType or TrainTypes.Cargo

    if (Contains(selectedLoco.trainTypes, trainType) == false) then
        Debug("Loco '" .. selectedLoco.name .. "' can not be used as train type " .. trainType)
        return
    end

    local selectedVariant = math.random(1, #selectedLoco.types)
    local locoType = selectedLoco.types[selectedVariant]
    local weights = selectedLoco.weight
    local loco = makeVehicle(locoType, nil, selectedLoco.brakeRegime , weights.service)

    local trainMaxWeight = weights.train
    if (weights.train == weights.service) then
        trainMaxWeight = 0
    end

    return selectedLoco.name or "Unknown", trainMaxWeight or 300, loco
end

--[[
function PlacePlayerWagons(name, wagons, signalName, distance)
    SpawnTrainsetOnSignalAsync(name, FindSignal(signalName), distance, false, false, false, wagons, allowCoupling)
end
]]


function GetPlayerLocoName()
    return playerLocoName
end

function GetPlayerStartTrainWeight()
    return playerStartTrainWeight
end

function GetPlayerStartTrainLength()
    return playerStartTrainLength
end

function GetWelcomeText()
    return welcomeText
end

function CreateStartScenario(scenario, locoKey)
    local loco = GetLocoDefinition(locoKey)
    if (loco == nil) then
        return
    end

    Debug("CreateStartScenario.  locoKey " .. locoKey)

    local weights = loco.weight
    local locoMaxWeight = 0
    if (weights ~= nil) then
        locoMaxWeight = weights.train
    end

    local playerLoco = createPlayerTrain(scenario, loco)
    placePlayerTrain(scenario, playerLoco)

    local carriagesWeight, carriagesLength = createStartCarriages(scenario.scenarioState, locoMaxWeight)

    playerStartTrainWeight = playerStartTrainWeight + carriagesWeight
    playerStartTrainLength = playerStartTrainLength + carriagesLength
    welcomeText = scenario.welcomeText or ""
end

function GetLocoDefinition(locoKey)
    if (not validateLocoKey(locoKey)) then
        return
    end

    return locos[locoKey]
end

function InitRolingStock(locomotives)
    playerLocomotives = locomotives
end

function GetPlayerLocomotive()
    local success, playerLocomotiveKey = pcall(getPlayerLocomotiveKey)
    if (not success) then
        Error("Can not get player locomotive '" .. playerLocomotiveKey .. "'")
    end

    return playerLocomotiveKey
end
