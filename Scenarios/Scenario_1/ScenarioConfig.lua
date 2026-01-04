require("SimRailCore")
require("ScenarioTriggers")
require("Framework/TriggerFunctions")
require("Framework/Common")
require("Framework/Route")
require("Framework/Environment")

ShowDebugText = false

StartPosition = { 15580.27, 337.76, 20650.96 }

---------------
-- [EN] User configuration starts here
-- [PL] Konfiguracja użytkownika zaczyna się tutaj
---------------

EnvironmentConfig = { 
    SelectMonth = false, -- Month = 6,
    SelectTime = false, Hour = 8,
    SelectWeather = true, -- Weather = "Snow"
}

PlayerLocomotives = { "Traxx", "ET22", "EU07", "EP07", "ET25" }

Scenario = {
    { scenarioId = 1, langText = "Scenario1" },
    { scenarioId = 2, langText = "Scenario2" },
    { scenarioId = 3, langText = "Scenario3" },
    { scenarioId = 4, langText = "Scenario4" },
    { scenarioId = 5, langText = "Scenario5" }
}

StartAlternatives = {
   ["LALocoReady"] = {
      scenarioId = 1,
      signal = "LB_Tm415",
      distance = 69,
      scenarioState = "LALocoReady",
      radioChannel = 2,
      trainState = TrainsetState.tsShunting,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "WelcomeLALocoReady",
      playerPosition = { 15578.27, 337.76, 20606.96 }, 
      playerInsideTrain = true,
      timeTable = "PlayerLBshunt.xml", -- add time table for all and handle in setup
      botSetup = { { BotId = "BotAtLA", create = true, commands = { BotCommandType.bcDrive } } }
   },
   ["LALocoReady2"] = {
      scenarioId = 1,
      signal = "LB_R3",
      distance = 50,
      scenarioState = "LALocoReady2",
      radioChannel = 2,
      trainState = TrainsetState.tsShunting,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "WelcomeLALocoReady",
      playerPosition = { 15578.27, 337.76, 20606.96 }, 
      playerInsideTrain = true,
      timeTable = "PlayerLBshunt.xml", -- add time table for all and handle in setup
      botSetup = { { BotId = "BotAtLA", create = true, commands = { BotCommandType.bcDrive } } }
   },
   ["LALocoReady5"] = {
      scenarioId = 1,
      signal = "LB_Tm411",
      distance = 348,
      scenarioState = "LALocoReady5",
      radioChannel = 2,
      trainState = TrainsetState.tsShunting,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "WelcomeLALocoReady",
      playerPosition = { 15278.29, 337.81, 20385.64 }, 
      playerInsideTrain = true,
      timeTable = "PlayerLBshunt.xml", -- add time table for all and handle in setup
      botSetup = { { BotId = "BotAtLA", create = true, commands = { BotCommandType.bcDrive } } }
   },
   ["LALocoReady3"] = {
      scenarioId = 1,
      signal = "LB_O",
      distance = 50,
      scenarioState = "LALocoReady3",
      radioChannel = 2,
      trainState = TrainsetState.tsShunting,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "WelcomeLALocoReady",
      playerPosition = { 15578.27, 337.76, 20606.96 }, 
      playerInsideTrain = true,
      timeTable = "PlayerLBshunt.xml", -- add time table for all and handle in setup
      botSetup = { { BotId = "BotAtLA", create = true, commands = { BotCommandType.bcDrive } } }
   },
   ["LALocoReady4"] = {
      scenarioId = 1,
      signal = "LB_Tm411",
      distance = 348,
      scenarioState = "LALocoReady4",
      radioChannel = 2,
      trainState = TrainsetState.tsShunting,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "WelcomeLALocoReady",
      playerPosition = { 15278.29, 337.81, 20385.64 }, 
      playerInsideTrain = true,
      timeTable = "PlayerLBshunt.xml", -- add time table for all and handle in setup
      botSetup = { { BotId = "BotAtLA", create = true, commands = { BotCommandType.bcDrive } } }
   },
   ["LATrainReady"] = {
      scenarioId = 2,
      signal = "LB_Tm305",
      distance = 30,
      scenarioState = "LATrainReady",
      radioChannel = 2,
      trainState = TrainsetState.tsShunting,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "",
      playerPosition = { 15578.27, 337.76, 20606.96 }, 
      playerInsideTrain = true,
      timeTable = "PlayerLBshunt.xml", -- add time table for all and handle in setup
      carriages = {
         minLength = 250,
         maxLength = 300,
         maxWeight = -160,
         cargoTypes = { CargoTypes.Containers, CargoTypes.Petroleum, CargoTypes.Wood }
      },
      botSetup = { { BotId = "BotAtLA", create = true, orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } },
                   { BotId = "BotAtLAshunt", create = true, orderType = OrderType.Shunting, routes = {"LB_Tm308", "LB_M4kps" }, commands = { BotCommandType.bcDrive } },
                 }
   },
   ["AtDZ_Tm12_deco"] = {
      scenarioId = 3,
      signal = "DZ_Tm12",
      distance = 100,
      scenarioState = "AtDZ_Tm12_deco",
      radioChannel = 2,
      trainState = TrainsetState.tsShunting,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "",
      playerPosition = { 15578.27, 337.76, 20606.96 }, 
      playerInsideTrain = true,
      timeTable = "PlayerDZshunt.xml", -- add time table for all and handle in setup
      carriages = {
         minLength = 50,
         maxLength = 100,
         maxWeight = 160,
         cargoTypes = { CargoTypes.Containers, CargoTypes.Petroleum, CargoTypes.Wood }
      }
   },
   ["AtDZ_Tm12_again"] = {
      scenarioId = 4,
      signal = "DZ_Tm12",
      distance = 30,
      scenarioState = "AtDZ_Tm12_again",
      radioChannel = 2,
      trainState = TrainsetState.tsShunting,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "",
      playerPosition = { 15578.27, 337.76, 20606.96 }, 
      playerInsideTrain = true,
      timeTable = "PlayerDZDeparture.xml", -- add time table for all and handle in setup
      carriages = {
         minLength = 200,
         maxLength = 300,
         cargoTypes = { CargoTypes.Containers, CargoTypes.Petroleum, CargoTypes.Wood }
      }
   },
   ["B_Decoupled"] = {
      scenarioId = 5,
      signal = "B_K6",
      distance = 30,
      scenarioState = "B_Decoupled",
      radioChannel = 2,
      trainState = TrainsetState.tsTrain,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "",
      playerPosition = { 15578.27, 337.76, 20606.96 }, 
      playerInsideTrain = true
   },
   ["AtFinalDestination"] = {
      scenarioId = 7,
      signal = "SG_N7",
      distance = 100,
      scenarioState = "AtFinalDestination",
      radioChannel = 2,
      trainState = TrainsetState.tsTrain,
      dynamicState = DynamicState.dsStop,
      trainType = TrainTypes.Cargo,
      welcomeText = "",
      playerPosition = { 15578.27, 337.76, 20606.96 }, 
      playerInsideTrain = true
   }
}

-- Key: is current scenario state. Each scenario state can have multiple triggers
-- type: is the kind of trigger that can initiate a state transition
-- condition: defines a function that has to return true for the transition to take effect
-- transition: defines a list och functions to execute when transition to a new state
-- targetState: defines a the state that will be the current state after the transition is done. If targetState is a list of names, one of the names will be randomly selected.
StateMachine = {
    ["LALocoReady"] =         { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                                                  targetState = "LALocoStartShunting" } },
    ["LALocoReady2"] =        { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                                                  targetState = "LALocoStartShunting" } },
    ["LALocoReady3"] =        { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                                                  targetState = "LALocoAtWagons" } },
    ["LALocoReady4"] =        { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                                                  targetState = "LALocoStartShunting" } },
    ["LALocoReady5"] =        { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                                                  targetState = "LALocoStartShunting2" } },
    ["LALocoStartShunting"] = { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                                                  targetState = "LALocoShunting" } },
    ["LALocoStartShunting2"] = { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                                                 targetState = "LALocoShunting" } },
    ["LALocoShunting"] =      { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                                                  targetState = "LALocoAtWagons" } },
    ["LALocoAtWagons"] =      { { type = TriggerType.Coupling, alwaysBotCmd = true, condition = { LeakCheck, BrakeCheck }, transition = nil,                targetState = "LATrainReady" } },
    ["LATrainReady"] =        { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute, ChangeWeather },                                   targetState = "LATrainShunting" } },
    ["LATrainShunting"] =     { { type = TriggerType.Track,    condition = nil, transition = { ChangeTrainStatusToDriving },                                targetState = { "AtLC_S6a", "AtLC_S6b" } } }, 
    ["AtLC_S6a"] =            { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                                                  targetState = "AtDZ_E2" } },
    ["AtLC_S6b"] =            { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                                                  targetState = "AtDZ_B" } },
    ["AtDZ_E2"] =             { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                                                  targetState = "At_t10862" } },
    ["AtDZ_B"] =              { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                                                  targetState = "At_t10707" } }, 
    ["At_t10707"] =           { { type = TriggerType.Track,    condition = nil, transition = { ReleaseSignalDZ_B },                                         targetState = "At_t10705" } }, 
    ["At_t10862"] =           { { type = TriggerType.Track,    condition = nil, transition = { ReleaseSignalDZ_E2 },                                        targetState = "At_t10860" } }, 
    ["At_t10860"] =           { { type = TriggerType.Track,    condition = nil, transition = { ChangeTrainStatusToShunting, SetRoute },                     targetState = "AtDZ_Tm12_deco" } },
    ["At_t10705"] =           { { type = TriggerType.Track,    condition = nil, transition = { ChangeTrainStatusToShunting, SetSwitchesAtDZ },              targetState = "AtDZ_Tm12_deco" } },
    ["AtDZ_Tm12_deco"] =      { { type = TriggerType.Decoupling, condition = nil, transition = nil,                                                         targetState = "AtDZ_Tm12" } },
    ["AtDZ_Tm12"] =           { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                                                  targetState = "At_t26820" } },
    ["At_t26820"] =           { { type = TriggerType.Track,    condition = nil, transition = { SetRoute },                                                  targetState = "DZLocoAtWagons" } },
    ["DZLocoAtWagons"] =      { { type = TriggerType.Coupling, condition = nil, transition = nil,                                                           targetState = "AtDZ_G13" } },
    ["AtDZ_G13"] =            { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                                                  targetState = "At_t26820_again" } },
    ["At_t26820_again"] =     { { type = TriggerType.Track,    condition = nil, transition = { SetRoute },                                                  targetState = "DZ_Connect_wagons" } },
    ["DZ_Connect_wagons"] =   { { type = TriggerType.Coupling, condition = nil, transition = nil,                                                           targetState = "AtDZ_Tm12_again" } },
    ["AtDZ_Tm12_again"] =     { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute, ChangeWeather },                                   targetState = "At_t10616" } },
    ["At_t10616"] =           { { type = TriggerType.Track,    condition = nil, transition = { ChangeTrainStatusToDriving, SetRoute },                      targetState = "AtDG_A" } },
    ["AtDG_A"] =              { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                                                  targetState = "AtB_B" } }, 
    ["AtB_B"] =               { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                                                  targetState = "AtB_K6" } }, 
    ["AtB_K6"] =              { { type = TriggerType.Decoupling, condition = nil, transition = nil,                                                         targetState = "B_Decoupled" } },
    ["B_Decoupled"] =         { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                                                  targetState = "ToEndStation" } },
    ["ToEndStation"] =        { { type = TriggerType.Track,    condition = nil, transition = { SetRoute },                                                  targetState = "AtFinalDestination" } }, 
    ["AtFinalDestination"] =  { { type = TriggerType.Signal,    condition = nil, transition = { EndOfGame },                                                targetState = "EndOfGame" } }
}

-- Routes are used by State transition function "SetRoute". 
-- Each scenarioState which uses transition function "SetRoute" has to have en entry in Routes.
Routes = {
    ["LALocoReady"] =         { orderType = OrderType.Shunting, route = { "LB_Tm415", "LB_Tm355", "LB_Tm346", "LB_H308", "LB_Tm205" } },
    ["LALocoReady2"] =        { orderType = OrderType.Shunting, route = { "LB_R3", "LB_H308", "LB_Tm205" } },
    ["LALocoReady3"] =        { orderType = OrderType.Shunting, route = { "LB_O", "LB_H318" } },
    ["LALocoReady4"] =        { orderType = OrderType.Shunting, route = { "LB_Tm411", "LB_L", "LB_Tm346", "LB_H308", "LB_Tm205" } },
    ["LALocoReady5"] =        { orderType = OrderType.Shunting, route = { "LB_Tm411", "LB_L", "LB_Tm331", "LB_Tm206", "LA_Tm153" } },
    ["LALocoStartShunting2"] = { orderType = OrderType.Shunting, route = { "LB_Tm200", "LB_Tm210", "LB_Tm306", "LB_M4kps" } },
    ["LALocoStartShunting"] = { orderType = OrderType.Shunting, route = { "LB_Tm210", "LB_Tm306", "LB_M4kps" } },
    ["LALocoShunting"] =      { orderType = OrderType.Shunting, route = { "LB_O", "LB_H318" } },
    ["LATrainReady"] =        { orderType = OrderType.Shunting, route = { "LB_Tm305", "LB_M6kps" } },
    ["AtLC_S6a"] =            { orderType = OrderType.Train,    route = { "LC_S6", "LC_W2kps" } },
    ["AtLC_S6b"] =            { orderType = OrderType.Train,    route = { "LC_S6", "LC_W1kps" } },
    ["AtDZ_E2"] =             { orderType = OrderType.Train,    route = { "DZ_E2", "DZ_G9" } },
    ["AtDZ_B"] =              { orderType = OrderType.Train,    route = { "DZ_B", "DZ_G11" } },
    ["At_t10860"] =           { orderType = OrderType.Shunting, route = { "DZ_Tm1", "DZ_Tm12" } },
    ["AtDZ_Tm12"] =           { orderType = OrderType.Shunting, route = { "DZ_Tm12", "DZ_P" } },
    ["At_t26820"] =           { orderType = OrderType.Shunting, route = { "DZ_J", "DZ_C13" } },
    ["AtDZ_G13"] =            { orderType = OrderType.Shunting, route = { "DZ_G13", "DZ_P" } },
    ["At_t26820_again"] =     { orderType = OrderType.Shunting, route = { "DZ_J", "DZ_C10" } },
    ["AtDZ_Tm12_again"] =     { orderType = OrderType.Shunting, route = { "DZ_Tm12", "DZ_O" } },
    ["At_t10616"] =           { orderType = OrderType.Train,    route = { "DZ_O", "DZ_Wkps" } },
    ["AtDG_A"] =              { orderType = OrderType.Train,    route = { "DG_A", "DG_N1", "DG_O_12kps" } },
    ["AtB_B"] =               { orderType = OrderType.Train,    route = { "B_B", "B_K6" } },
    ["B_Decoupled"] =         { orderType = OrderType.Train,    route = { "B_K6", "B_Rkps" } },
    ["ToEndStation"] =        { orderType = OrderType.Train,    route = { "SG_B", "SG_N7" } }
}
-- ---------------------------------------------------------------------------------------------------------------
-- Define signal trigger
--
-- signal, distance: where to place the trigger
-- withStartState: Trigger will only be created with these start scenario states, If withStartState is nil the trigger will always be used.
-- waitFunction: functions to execute before the trigger is finished

SignalTriggers = {
     { signal = "LB_Tm210", distance = 60, withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4"} },
     { signal = "LB_Tm200", distance = 60, withStartState = { "LALocoReady5" } },
     { signal = "LB_O", distance = 60 },
     { signal = "LC_S6", distance = 1660 },
     { signal = "DZ_G13", distance = 58 },
     { signal = "DG_A", distance = 1200 },
     { signal = "B_B", distance = 1200 },
     { signal = "SG_N7", distance = 50, waitFunction = { TrainTurnedOff, PlayerWalkingOutside } } -- End of game
}

-- ---------------------------------------------------------------------------------------------------------------
-- Define track trigger
--
-- track, distance, direction: where to place the trigger
-- waitFunction: functions to execute before the trigger is finished
-- type: The kind och track trigger. Can be Back or Front. (Se TrackTriggerType)
-- isPermanent: If not true the trigger will be deleted after it has fired.
-- lifetime: Is used with a permanent trigger. The trigger will be deleted after it has fired this many times.
-- withStartState: Trigger will only be created with these start scenario states, If withStartState is nil the trigger will always be used.

TrackTriggers = {
    { track = "t13543", distance = 22, direction = 0 }, 
    { track = "t14165", distance = 2, direction = 1, waitFunction = { ChangeDirectionAndShunt} },
    { track = "t24855", distance = 17, direction = 1, waitFunction = { ChangeDirectionAndShunt} },
    { track = "t12890", distance = 68, direction = -1, waitFunction = { ChangeDirectionAndShuntToCarriages}, withStartState = { "LALocoReady", "LALocoReady2" , "LALocoReady4", "LALocoReady5"} },
    { track = "t10862", distance = 35, direction = 0 },
    { track = "t10707", distance = 2, direction = 0 },
    { track = "t10860", distance = 50, direction = 0 },
    { track = "t10705", distance = 79, direction = 0 },
    { track = "t26820", distance = 34, direction = -1, waitFunction = { ChangeDirectionAndShuntToCarriages}, type = TrackTriggerType.Back, isPermanent = true, lifetime = 2  }, -- Track at DZ station. Used to change direction when shunting
    { track = "t10616", distance = 65, direction = -1 },
    { track = "t11080", distance = 30, direction = -1 }
}

-- ---------------------------------------------------------------------------------------------------------------
-- Define radio call trigger.
--
-- Based on the scenario state, define what will happen when pressing a radio button.
-- Each scenarioState in the StateMachine where TriggerType is Radio has to have a definition in table RadioTriggers.

RadioTriggers = {
    { "LALocoReady",
        { radioButtons = { 1, 3 },
          chats = { { source = RadioCallers.Driver, text = "DrvTrainReady" },
                    { source = RadioCallers.Dispatcher, text = "DspShuntToCarriages"},
                    { source = RadioCallers.Driver, text = "DrvShuntToCarriages"}
                  }
        }
    },
    { "LALocoReady2",
        { radioButtons = { 1, 3 },
          chats = { { source = RadioCallers.Driver, text = "DrvTrainReady2" },
                    { source = RadioCallers.Dispatcher, text = "DspShuntToCarriages"},
                    { source = RadioCallers.Driver, text = "DrvShuntToCarriages"}
                  }
        }
    },
    { "LALocoReady3",
        { radioButtons = { 1, 3 },
          chats = { { source = RadioCallers.Driver, text = "DrvTrainReady3" },
                    { source = RadioCallers.Dispatcher, text = "DspShuntToCarriages"},
                    { source = RadioCallers.Driver, text = "DrvShuntToCarriages"}
                  }
        }
    },
    { "LALocoReady4",
        { radioButtons = { 1, 3 },
          chats = { { source = RadioCallers.Driver, text = "DrvTrainReady4" },
                    { source = RadioCallers.Dispatcher, text = "DspShuntToCarriages"},
                    { source = RadioCallers.Driver, text = "DrvShuntToCarriages"}
                  }
        }
    },
    { "LALocoReady5",
        { radioButtons = { 1, 3 },
          chats = { { source = RadioCallers.Driver, text = "DrvTrainReady5" },
                    { source = RadioCallers.Dispatcher, text = "DspShuntToCarriages"},
                    { source = RadioCallers.Driver, text = "DrvShuntToCarriages"}
                  }
        }
    },
    { "LATrainReady",
        { radioSelection = { 1, 3 },
            chats = { { source = RadioCallers.Driver , text = "DrvLaTrainDepart" },
                      { source = RadioCallers.Dispatcher, text = "DspLaTrainDepart" }
                    }
        }
    },
    { "AtDZ_E2",
        { radioSelection = { 0 },
            chats = { { source = RadioCallers.Driver , text = "DrvDzArrived" },
                      { source = RadioCallers.Dispatcher, text = "DspDzBeginShunting" }
                    }
        }
    },
    { "AtDZ_B",
        { radioSelection = { 0 },
            chats = { { source = RadioCallers.Driver , text = "DrvDzArrived2" },
                      { source = RadioCallers.Dispatcher, text = "DspDzBeginShunting2" }
                    }
        }
    },
    { "AtDZ_Tm12",
        { radioSelection = { 0 },
            chats = { { source = RadioCallers.Driver , text = "DrvDzShuntToNewWagons" },
                      { source = RadioCallers.Dispatcher, text = "DspDzShuntToNewWagons" }
                    }
        }
    },
    { "AtDZ_Tm12_again",
        { radioSelection = { 0 },
            chats = { { source = RadioCallers.Driver , text = "DrvDzTrainDepart" },
                      { source = RadioCallers.Dispatcher, text = "DspDzTrainDepart" }
                    }
        }
    },
    { "B_Decoupled",
        { radioSelection = { 3 },
            chats = { { source = RadioCallers.Driver , text = "DrvBReady" },
                      { source = RadioCallers.Dispatcher, text = "DspBRodger" }
                    }
        }
    }
}

StartCarriages = {
   { trainType = TrainTypes.Cargo, minLength = 70, maxLength = 100, atSignalName = "LB_Tm304", distance = 60, trainPhysics = TrainPhysics.Bot,
            withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4", "LALocoReady5", "LATrainReady" } },
    { trainType = TrainTypes.Cargo, maxWeight = -160, minLength = 300, maxLength = 450, atSignalName = "LB_Tm305", distance = 90, trainPhysics = TrainPhysics.Player, belongsToPlayerTrain = true, 
            cargoTypes = { CargoTypes.Containers, CargoTypes.Petroleum, CargoTypes.Wood },
            withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4", "LALocoReady5"} },
    { trainType = TrainTypes.Cargo, maxWeight = 160, minLength = 50, maxLength = 100, atSignalName = "DZ_G13", distance = 74, trainPhysics = TrainPhysics.Player,
            cargoTypes = { CargoTypes.Concrete },
            withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4", "LALocoReady5", "LATrainReady", "AtDZ_Tm12_deco" } }
}


BotTrains = {
    ["BotAtLA"] = { locoName = "ET22", minLength = 100, maxLength = 200, atSignalName = "LB_R1", distance = 130, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Cargo, cargoTypes = { CargoTypes.Metal } },
    ["BotAtLAshunt"] = { locoName = "EU07", minLength = 20, maxLength = 60, atSignalName = "LB_Tm308", distance = 225, trainState = TrainsetState.tsShunting, trainType = TrainTypes.Cargo },
    ["BotArrivingAtLA"] = { locoName = "ED250", minLength = 187, maxLength = 187, atSignalName = "LB_P2", distance = 183, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger },
    ["BotDepartureFromLA"] = { locoName = "EN57", minLength = 187, maxLength = 187, atSignalName = "LB_H2", distance = 170, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger },
    ["BotPassengerAtDZ"] = { locoName = "EN76", minLength = 187, maxLength = 187, atSignalName = "DZ_X", distance = 190, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger },
    ["BotCargoAtLCZ"] = { locoName = "ET25", minLength = 187, maxLength = 450, atSignalName = "LC_Z", distance = 2000, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Cargo, cargoTypes = { CargoTypes.Containers } },
    ["BotAtB"] = { locoName = "EU07", minLength = 200, maxLength = 300, atSignalName = "B_S", distance = 100, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger }
}

BotScenarios = {
    ["LALocoReady"] = {
        { BotId = "BotAtLA", orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } }
    },
    ["LALocoReady2"] = {
        { BotId = "BotAtLA", orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } }
    },
    ["LALocoReady3"] = {
        { BotId = "BotAtLA", orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } }
    },
    ["LALocoReady4"] = {
        { BotId = "BotAtLA", orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } }
    },
    ["LALocoReady5"] = {
        { BotId = "BotAtLA", orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } }
    },
    ["LALocoAtWagons"] = {
        { BotId = "BotAtLAshunt", create = true, commands = { BotCommandType.bcDrive } },
        { BotId = "BotAtLA", delete = true }
    },
    ["LATrainReady"] = { 
        { BotId = "BotAtLAshunt", orderType = OrderType.Shunting, routes = {"LB_Tm308", "LB_M4kps" }, commands = { BotCommandType.bcDrive } }
    },
    ["AtLC_S6a"] = {
        { BotId = "BotAtLAshunt", delete = true },
        { BotId = "BotCargoAtLCZ", create = true, commands = { BotCommandType.bcDrive } }
    },
    ["AtLC_S6b"] = {
        { BotId = "BotAtLAshunt", delete = true },
        { BotId = "BotCargoAtLCZ", create = true, commands = { BotCommandType.bcDrive } }
    },
    ["LATrainShunting"] = {
        { BotId = "BotArrivingAtLA", create = true, orderType = OrderType.Train, routes = {"LB_P2", "LB_R3" }, commands = { BotCommandType.bcDrive } },
        { BotId = "BotDepartureFromLA", create = true, orderType = OrderType.Train, routes = {"LB_H2", "LB_P2kps" }, commands = { BotCommandType.bcDrive } }
    },
    ["AtDZ_E2"] = {
        { BotId = "BotArrivingAtLA", delete = true },
        { BotId = "BotCargoAtLCZ", delete = true }
    },
    ["AtDZ_B"] = {
        { BotId = "BotArrivingAtLA", delete = true },
        { BotId = "BotCargoAtLCZ", delete = true }
    },
    ["At_t10616"] = {
        { BotId = "BotPassengerAtDZ", create = true, orderType = OrderType.Train, routes = {"DZ_X", "DZ_K" }, commands = { BotCommandType.bcDrive } }
    },
    ["AtDG_A"] = {
        { BotId = "BotPassengerAtDZ", delete = true }
    },
    ["B_Decoupled"] = {
        { BotId = "BotAtB", create = true, orderType = OrderType.Train, routes = {"B_S", "B_E2" }, commands = { BotCommandType.bcDrive } }
    }
}