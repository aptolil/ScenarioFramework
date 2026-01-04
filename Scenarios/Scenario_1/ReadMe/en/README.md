# Welcome

In software development you normally don't want to mix software code with business logic. 
That should normally apply to simrail scenarios as well. 
That's the reason I have developed a small framework which makes it possible to
develop scenarios separated from lua code. 
Scenarios are defined in a configuration file and, if the built in trigger functions are not enough, with separate user defined trigger functions. 

In this ReadMe file you will find a short description of the example scenario as well as a description of how to use the framework when developing your own scenarios.


## Mission

This is a short example scenario where you will be shunting in odd places and bot trains will come and go in a perhaps unrealistic way. 
The purpose of this scenario is not to be realistic. It is more an example of how one can use the Framework to create a scenario in a simplified way.

This scenario starts in Lazy where you will be shunting to your carriages. 
As a first action, call the dispatcher who will create a route for you to the carriages. Call the dispatcher once more when you have coupled the locomotive to the carriages and you are ready to departure.

From Lazy you will be driving to Dąbrowa Górnicza Ząbkowice where you will add a couple of more carriages to the once you already have. Call the dispatcher again when arriving at the red light at Dąbrowa Górnicza Ząbkowice.
When at the station, make sure to stop at an appropriate distance from the shunting signals so that you new carriages and locomotive can fit and not extend past the signal. 
The new carriages can be seen to the right and there are usually three och four carriages. Call the dispatcher when you have decoupled from your old carriages and the again when you have coupled the new carriages to the old once and you are ready to departure.

At Będzin you will park your carriages at a side track. Decouple the carriages from your locomotive and call the dispatcher, telling him/her that you are ready to drive to your final destination, Sosnowiec Glówny, where you will park the locomotive.

To finish the scenario you have to park the locomotive 50 meters or less from the signal. Turn off the locomotive and exit through the door.

In a couple of places you might not get a go signal and no response from the dispatcher. If this happens to you, try to drive slowly closer to the signal. It should the give you a go signal.

# Making your own scenarios

## File structure

To make your own scenario, copy the Framework file map, the mission.lua file and the ScenarioConfig.lua file.
Make changes to the ScenarioConfig.lua file and create your own Locales and Sound files.

## Scenario files

### mission.lua

You don't have to change anything in the mission.lua file. Just copy it from this example scenario to your own scenario.

### ScenarioConfig.lua

It is in this file where you configure the whole scenario. There is a couple of global variables used for defining the scenario. Where and how it starts and what will happen along the way to the final destination.
Below is a description of all variables you have to change to make your own scenario:

#### Environment

With this variable you can decide how to set the month, time of day and the weather. If `Month`, `Hour` and/or `Weather` are specified those specific values are used. If not, the `SelectMonth`, `SelectTime` and/or `SelectWeather` is set to `true` the player will be prompted with a drop down menu where he/she can select what is appropriate. If they are set to false a random value vill be selected.

In this example the scenario will start at 8 a clock (A fixed value). The month will be randomly selected and the weather will be selected by the user.

    Environment = { 
        SelectMonth = false, -- Month = 3,
        SelectTime = false, Hour = 8,
        SelectWeather = true, -- Weather = "Snow"
    }


#### PlayerLocomotives

This section defines what locomotives you can drive in the scenario. If you defines more than one, you will be presented with a drop down menu where you can choose what train to drive.
Locomotives you can choose from are:

- Traxx
- ET22
- EU07
- ED250
- EP08
- EP07
- ET25
- EN57
- EN71
- EN76
- EN96

    PlayerLocomotives = { "Traxx", "ET22", "EU07", "EP07", "ET25" }

#### Scenario

This variable defines possible start positions within the scenario. For instance if the scenario starts with some shunting which will continue with train driving, it is possible to skip the shunting part and select that you want to start with the train driving part.
For each scenario start you have to define a structure like the one below:

    Scenario = {
        { scenarioId = 1, langText = "Scenario1" }
    }

`scenarioId` is just a number used in the variable `StartAlternatives` below. It can be anything but must be found in `StartAlternatives`. 
`langText` is a text key defined in a `locales/*.lang` file, describing the scenario. This text will be shown in a drop down menu if there are more than one alternative to choose from. 

#### BotTrains

This variable defines all bot trains that will participate in the scenario. 
Each train is defined with a key, e.g. "BotAtLA" below, and has a structure with the following parameters:

- `locoName` - What locomotive to spawn. Se `PlayerLocomotives` for a list of locomotives to select from.
- `minLength` - The train minimum length including carriages.
- `maxLength` - The train maximum length including carriages. The actual train length will be a random number between min and max length. But the maximum total weight will effect the length as well.
- `atSignalName` - The name of the signal where this train will be spawned.
- `distance` - The distance from signal at which the train will be spawned.
- `trainState` - The used trainset state (tsTrain or tsShunting)
- `trainType` - Can be `Cargo` or `Passenger`.
- `cargoTypes` - The kind of cargo this train should have. Se subject "Cargo types" below.

```
    BotTrains = {
        ["BotAtLA"] = { locoName = "ET22", minLength = 100, maxLength = 230, atSignalName = "LB_R1", distance = 130, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Cargo },
        ["BotAtLAshunt"] = { locoName = "EU07", minLength = 20, maxLength = 60, atSignalName = "LB_Tm308", distance = 225, trainState = TrainsetState.tsShunting, trainType = TrainTypes.Cargo },
        ["BotArrivingAtLA"] = { locoName = "ED250", minLength = 187, maxLength = 187, atSignalName = "LB_P2", distance = 183, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger },
        ["BotDepartureFromLA"] = { locoName = "EN57", minLength = 187, maxLength = 187, atSignalName = "LB_H2", distance = 170, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger },
        ["BotPassengerAtDZ"] = { locoName = "EN76", minLength = 187, maxLength = 187, atSignalName = "DZ_X", distance = 190, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger },
        ["BotCargoAtLCZ"] = { locoName = "ET25", minLength = 187, maxLength = 450, atSignalName = "LC_Z", distance = 2000, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Cargo, cargoTypes = { CargoTypes.Containers } },
        ["BotAtB"] = { locoName = "EU07", minLength = 200, maxLength = 300, atSignalName = "B_S", distance = 100, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger }
    }
```

This list of trains is just a template of possible trains to spawn. 
They will not be spawned just because they are defined here. 
Se section BotScenarios below for a description of how these definitions are used. 

##### Cargo types

When creating a train set, you can influence the type of load it has by specifying the types of load desired. This is done by adding parameter "cargoTypes" to the trainset specification in `BotTrains`, `StartAlternatives` and/or `StartCarriages`. The following cargo types can be used:

- Coal
- Ballast
- Sand
- Wood
- Metal
- Pipelines
- Concrete
- Petroleum
- Gas
- Containers


#### StartAlternative

This is where the scenario start state will be configured. Where the player train will be spawned and in what state. What time table to use. 
If the player train should have carriages and how they should be configured and what bot trains to spawn at the beginning.

The configuration key (e.g. "LATrainReady") is the scenario state name.

- `scenarioId` - Is an ID used in `Scenarios` (Se section above). Multiple start alternatives can have the same scenarioId. If so, one of them will be randomly selected.
- `signal` - The signal at which the player locomotive will be spawned.
- `distance` - The player locomotive will be spawned att this distance from the signal.
- `scenarioState` - Is the name of the scenario state. (Se `StateMachine` below)
- `trainState` - The player trainset state (`tsShunting` or `tsTrain`)
- `radioChannel` - The radio channel to be used at start.
- `dynamicState` - The player trainset dynamic state (e.g. `dsStop`)
- `trainType` - Specifies the type of carriages to spawn (`Cargo` or `Passenger`)
- `welcomeText` - A text and sound key for the narrator welcome text. 
- `playerPosition` - Se "known bugs" below
- `playerInsideTrain` - If the player should be spawned inside the train (true) or not (false). Also, se "known bugs" below
- `timeTable` - The name of the time table file to use.
- `carriages` - Defines if the player locomotive should have carriages or not. Omit this part if no carriages should be used.
- `carriages.minLength` - Minimum length of the trainset.
- `carriages.maxLength` - Maximum length of the trainset. The actual length of the trainset will be a combination of a randomly selected length between min and max and the maximum weight the selected locomotive can pull.
- `carriages.maxWeight` - If omitted, the locomotive train weight will be used. If > 0 the actual value will be used. If < 0 the locomotive train weight - maxWeight will be used.
- `carriages.cargoTypes` - The kind of cargo this train should have. Se subject "Cargo types" above.
- `botSetup` - Bot trains that will be spawned at start up. For a description of its parameters, se `BotScenarios` below. Omit this part if no bot trains should be created at the scenario start.

```
    StartAlternatives = {
        ["LATrainReady"] = {
            scenarioId = 2,
            signal = "LB_Tm305",
            distance = 30,
            scenarioState = "LATrainReady",
            radioChannel = 2,
            trainState = TrainsetState.tsShunting,
            dynamicState = DynamicState.dsStop,
            trainType = TrainTypes.Cargo,
            welcomeText = "welcomeText",
            playerPosition = { 15578.27, 337.76, 20606.96 }, 
            playerInsideTrain = true,
            timeTable = "PlayerLBshunt.xml", -- add time table for all and handle in setup
            carriages = {
                minLength = 250,
                maxLength = 300,
                maxWeight = -160,
                cargoTypes = { CargoTypes.Containers, CargoTypes.Petroleum, Cargotypes.Wood }
            },
            botSetup = { { BotId = "BotAtLA", create = true, orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } },
                        { BotId = "BotAtLAshunt", create = true, orderType = OrderType.Shunting, routes = {"LB_Tm308", "LB_M4kps" }, commands = { BotCommandType.bcDrive } },
                    }
        }
    }
```

#### StateMachine

Each state is defined with a key, called the current state name.  Each scenario state can have multiple triggers but only one can be executed, based on trigger type and condition. 
The first match will be used. 
When changing state to a target state a list of functions can be executed. Each trigger has parameters defined below:

- `type` - is the kind of trigger that can initiate a state transition. There are six types of triggers that can be used (Radio, Signal, Coupling, Decoupling or Track)
- `condition` - defines a function that has to return true for the transition to take effect
- `transition` - defines a list och functions to execute when transition to a new state
- `targetState` - defines the state that will be the current state after the transition is done. If targetState is a list of names, one of the names will be randomly selected.
- `alwaysBotCmd` - If true, bot commands will always be performed if there are any, regardless of whether the the condition is true or not.

```
    StateMachine = {
        ["LALocoReady"] =         { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                     targetState = "LALocoStartShunting" } },
        ["LALocoStartShunting"] = { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                     targetState = "LALocoShunting" } },
        ["LALocoAtWagons"] =      { { type = TriggerType.Coupling, alwaysBotCmd = true, condition = { LeakCheck, BrakeCheck }, transition = nil, targetState = "LATrainReady" } },
        ["LATrainReady"] =        { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute, ChangeWeather },      targetState = "LATrainShunting" } },
        ["LATrainShunting"] =     { { type = TriggerType.Track,    condition = nil, transition = { ChangeTrainStatusToDriving },   targetState = { "AtLC_S6a", "AtLC_S6b" } } },  
        ["AtDZ_Tm12_deco"] =      { { type = TriggerType.Decoupling, condition = nil, transition = nil,                            targetState = "AtDZ_Tm12" } }
    }
```

#### Routes

Routes are used by state transition function "SetRoute". 
Each scenarioState which uses transition function "SetRoute" has to have an entry in Routes. Se StateMachine above.

The Key value used muse be the same as the one used in StateMachine where function "SetRoute" is used.

- `orderType` - Defines the order type used when calling VDSetOrder (Shunting or Train)
- `route` - Is a list of signal names between which a route shall be set.

```
    Routes = {
        ["LALocoReady"] =         { orderType = OrderType.Shunting, route = { "LB_Tm415", "LB_Tm355", "LB_Tm346", "LB_H308", "LB_Tm205" } },
        ["AtDZ_E2"] =             { orderType = OrderType.Train,    route = { "DZ_E2", "DZ_G9" } }
    }
```

#### SignalTriggers

This structure defines what signal triggers should be created.
There should be one trigger defined for each defined trigger type "Signal" in the StateMachine. 

- `signal`, `distance` - where to place the trigger
- `withStartState` - Trigger will only be created with these start scenario states, If withStartState is nil the trigger will always be used.
- `waitFunction` - functions to execute before the trigger is finished

```
    SignalTriggers = {
        { signal = "LB_Tm210", distance = 60, withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4"} },
        { signal = "SG_N7", distance = 50, waitFunction = { TrainTurnedOff, PlayerWalkingOutside } } 
    }
```

#### TrackTriggers

This structure defines what track triggers should be created.
There should be one trigger defined for each defined trigger type "Track" in the StateMachine.

- `track`, `distance`, `direction` - where to place the trigger
- `waitFunction` - functions to execute before the trigger is finished
- `type` - The kind och track trigger. Can be Back or Front. (Se TrackTriggerType)
- `isPermanent` - If not true the trigger will be deleted after it has fired.
- `lifetime` - Is used with a permanent trigger. The trigger will be deleted after it has fired this many times.
- `withStartState` - Trigger will only be created with these start scenario states, If withStartState is nil the trigger will always be used.

```
    TrackTriggers = {
        { track = "t13543", distance = 22, direction = 0 }, 
        { track = "t12890", distance = 68, direction = -1, waitFunction = { ChangeDirectionAndShuntToCarriages}, withStartState = { "LALocoReady", "LALocoReady2" , "LALocoReady4", "LALocoReady5"} }, 
        { track = "t26820", distance = 34, direction = -1, waitFunction = { ChangeDirectionAndShuntToCarriages}, type = TrackTriggerType.Back, isPermanent = true, lifetime = 2  } 
    }
```

#### RadioTriggers

Define radio call trigger.

Based on the scenario state, define what will happen when pressing a radio button.
Each scenarioState in the StateMachine where TriggerType is Radio has to have a definition in table RadioTriggers.

- `radioButtons` - List of radio buttons that can be used.
- `chats.source` - Who is talking (Driver or Dispatcher)
- `chats.text` - A text and sound key to be used. 

```
    RadioTriggers = {
        { "LALocoReady",
            { radioButtons = { 1, 3 },
            chats = { { source = RadioCallers.Driver, text = "DrvTrainReady" },
                        { source = RadioCallers.Dispatcher, text = "DspShuntToCarriages"},
                        { source = RadioCallers.Driver, text = "DrvShuntToCarriages"}
                    }
            }
        }
    }
```

#### StartCarriages

Carriages that will be created when starting the scenario. They can be "bot" carriages not used by the player or they can be carriages used by the player during the scenario.

- `trainType` - The type of carriages to create (Cargo or Passenger)
- `minLength`, `maxLenght` - Min and max length of the carriages set to create. The actual length will be a combination of these values and the maximum weight.
- `maxWeight` - If omitted, only the length will be used. If > 0 the actual value will be used. If < 0 the player locomotive train weight - maxWeight will be used.
- `atSignalName`, `distance` - Where the place the carriages.
- `trainPhysics` - Can be Bot or Player and decides what simulation physics will be used.
- `withStartState` - If specified, these carriages will only be spawned for these scenario start states. If omitted, they will be spawned for all scenarios.
- `belongsToPlayerTrain` - At scenario start a pop up text will show player train length och weight for the scenario. This parameter defines if carriages length and weight should be included in the player train. It can be used in scenarios where the player starts by shunting to the carriages.
- `cargoTypes` - The kind of cargo this train should have. Se subject "Cargo types" above.

```
    StartCarriages = {
        { trainType = TrainTypes.Cargo, minLength = 70, maxLength = 100, atSignalName = "LB_Tm304", distance = 60, trainPhysics = TrainPhysics.Bot,
                withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4", "LALocoReady5", "LATrainReady" } },
        { trainType = TrainTypes.Cargo, maxWeight = -160, minLength = 300, maxLength = 450, atSignalName = "LB_Tm305", distance = 90, trainPhysics = TrainPhysics.Player, belongsToPlayerTrain = true, 
                cargoTypes = { CargoTypes.Containers, CargoTypes.Petroleum, CargoTypes.Wood },
                withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4", "LALocoReady5"} },
        { trainType = TrainTypes.Cargo, maxWeight = 160, minLength = 50, maxLength = 100, atSignalName = "DZ_G13", distance = 74, trainPhysics = TrainPhysics.Player,
                withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4", "LALocoReady5", "LATrainReady", "AtDZ_Tm12_deco" } }
    }
```

#### BotScenarios

This variable defines what to do with bot trains during the scenario. It contains a list of scenario name keys. The same names used in the StateMachine above. 
Each key contains a list of "bot actions" defined by the following parameters:

- `BotId` - Defines what bot train these actions are fore. Se `BotTrains` above.
- `orderType` - The VDSetRoute order type to use (Train or Shunting)
- `routes` - A list of signal names between which a route should be set using VDSetRoute.
- `commands` - A list of bot commands to use, e.g. bcDrive.
- `create` - Is set to true if the bot train should be spawned.
- `delete` - Is set to true if the bot trains should be de-spawned.

```
    BotScenarios = {
        ["LALocoReady"] = {
            { BotId = "BotAtLA", orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } }
        },
        ["LALocoAtWagons"] = {
            { BotId = "BotAtLAshunt", create = true, commands = { BotCommandType.bcDrive } },
            { BotId = "BotAtLA", delete = true }
        },
        ["LATrainShunting"] = {
            { BotId = "BotArrivingAtLA", create = true, orderType = OrderType.Train, routes = {"LB_P2", "LB_R3" }, commands = { BotCommandType.bcDrive } },
            { BotId = "BotDepartureFromLA", create = true, orderType = OrderType.Train, routes = {"LB_H2", "LB_P2kps" }, commands = { BotCommandType.bcDrive } }
        },
        ["AtDZ_E2"] = {
            { BotId = "BotArrivingAtLA", delete = true },
            { BotId = "BotCargoAtLCZ", delete = true }
        }
    }
```

### ScenarioTriggers.lua

In the `ScenarioConfig.lua` file, trigger functions can be called in different situations. They can be called from the `StateMachine`, `SignalTriggers` or `TrackTriggers` structures.

There are a couple of pre defined trigger functions that can be used and they can be found below. 
If you need to define your own trigger functions they should be defined in this file. Functions are called with parameter `trainsetInfo`.

Pre defined functions are:

- `SetRoute` - Set a new route found in `ScenatioConfig.lua`, variable `Routes`.
- `WaitForTrainToStop` - Wait for the train to stop.
- `ChangeDirectionAndShunt` - Waits for the train to stop after which the narrator tells the player to change direction and continue to shunt.
- `ChangeDirectionAndShuntToCarriages` - Waits for the train to stop after which the narrator tells the player to change direction and continue to shunt to the carriages.
- `TrainTurnedOff` - Waits until the locomotive is parked and turned off.
- `PlayerWalkingOutside` - Waits for the player to be walking outside the locomotive.
- `EndOfGame` - Finished the scenario.
- `ChangeTrainStatusToDriving` -  Change train status to driving
- `ChangeTrainStatusToShunting` - Change train status to shunting
- `ChangeWeather` - Change current weather type
- `LeakCheck` - Perform a break system leak check
- `BrakeCheck` - Perform a brake system check


### Known bugs

Player can not be spawned outside the locomotive at a specified place. Parameter `playerPosition` in `StartAlternatives` has no effect or can make de game to freez. 