require("SimRailCore");
-- https://www.naturalreaders.com/online/

-- English UK
-- --------------
-- Drv = Ryan
-- Dsp at LA = Libby
-- Dsp at Dz = Ollie
-- Dsp at B = Isidora
-- Narrator = Isabella
-- BrakeTester = Alessio

-- Polish
-- ------------
-- Drv = Florian
-- Dsp at LA = Nova
-- Dsp at Dz = Remy
-- Dsp at B = Isabella
-- Narrator = Ada
-- BrakeTester = Alessio

Sounds = {
    ["DispatcherIsReady"]    = { 
        [Languages.English] = "../../../Sounds/EN_DispatcherIsReady.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_DispatcherIsReady.mp3" 
    },
    ["DispatcherIsNotReady"] = { 
        [Languages.English] = "../../../Sounds/EN_DispatcherIsNotReady.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_DispatcherIsNotReady.mp3"
    },
    ["GameOver"] = { 
        [Languages.English] = "../../../Sounds/EN_gameover.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_gameover.mp3" 
    },
    ["NoAnswer"] = { 
        [Languages.English] = "../../../Sounds/EN_NoAnswer.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_NoAnswer.mp3" 
    },

    ["ChangeDirection"] = { 
        [Languages.English] = "../../../Sounds/EN_ChangeDirection.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_ChangeDirection.mp3" 
    },
    ["ChangeDirectionToCarriages"] = { 
        [Languages.English] = "../../../Sounds/EN_ChangeDirectionToCarriages.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_ChangeDirectionToCarriages.mp3" 
    },

    ["IsShunting"] = { 
        [Languages.English] = "../../../Sounds/EN_IsShunting.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_IsShunting.mp3" 
    },
    ["IsDriving"] = { 
        [Languages.English] = "../../../Sounds/EN_IsDriving.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_IsDriving.mp3" 
    },

    ["LeakCheckStart"] = { 
        [Languages.English] = "../../../Sounds/EN_LeakCheckStart.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_LeakCheckStart.mp3" 
    },
    ["LeakCheckApplyBrake"] = { 
        [Languages.English] = "../../../Sounds/EN_LeakCheckApplyBrake.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_LeakCheckApplyBrake.mp3" 
    },
    ["LeakCheckReleaseBrake"] = { 
        [Languages.English] = "../../../Sounds/EN_LeakCheckReleaseBrake.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_LeakCheckReleaseBrake.mp3" 
    },
    ["LeakCheckPressureLeak"] = { 
        [Languages.English] = "../../../Sounds/EN_LeakCheckPressureLeak.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_LeakCheckPressureLeak.mp3" 
    },
    ["LeakCheckPressureNoLeak"] = { 
        [Languages.English] = "../../../Sounds/EN_LeakCheckPressureNoLeak.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_LeakCheckPressureNoLeak.mp3" 
    },

    ["BrakeCheckStart"] = { 
        [Languages.English] = "../../../Sounds/EN_BrakeCheckStart.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_BrakeCheckStart.mp3" 
    },
    ["BrakeCheckApplyBrake"] = { 
        [Languages.English] = "../../../Sounds/EN_BrakeCheckApplyBrake.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_BrakeCheckApplyBrake.mp3" 
    },
    ["BrakeCheckBrakesApplied"] = { 
        [Languages.English] = "../../../Sounds/EN_BrakeCheckBrakesApplied.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_BrakeCheckBrakesApplied.mp3" 
    },
    ["BrakeCheckReleaseBrakes"] = { 
        [Languages.English] = "../../../Sounds/EN_BrakeCheckReleaseBrakes.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_BrakeCheckReleaseBrakes.mp3" 
    },
    ["BrakeCheckBrakesReleased"] = { 
        [Languages.English] = "../../../Sounds/EN_BrakeCheckBrakesReleased.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_BrakeCheckBrakesReleased.mp3" 
    },
    ["BrakeCheckBrakesNotOK"] = { 
        [Languages.English] = "../../../Sounds/EN_BrakeCheckBrakesNotOK.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_BrakeCheckBrakesNotOK.mp3" 
    },
    ["BrakeCheckBrakesOK"] = { 
        [Languages.English] = "../../../Sounds/EN_BrakeCheckBrakesOK.mp3", 
        [Languages.Polish]  = "../../../Sounds/PL_BrakeCheckBrakesOK.mp3" 
    },

-- --------------------------------
-- [EN] User configuration starts here
-- [PL] Konfiguracja użytkownika zaczyna się tutaj
-- --------------------------------


    ["WelcomeLALocoReady"] = { 
        [Languages.English] = "EN_WelcomeLALocoReady.mp3", 
        [Languages.Polish]  = "PL_WelcomeLALocoReady.mp3" 
    },

    ["DrvTrainReady"] = { 
        [Languages.English] = "EN_DrvTrainReady.mp3", 
        [Languages.Polish]  = "PL_DrvTrainReady.mp3" 
    },
    ["DrvTrainReady2"] = { 
        [Languages.English] = "EN_DrvTrainReady2.mp3", 
        [Languages.Polish]  = "PL_DrvTrainReady2.mp3" 
    },
    ["DrvTrainReady3"] = { 
        [Languages.English] = "EN_DrvTrainReady3.mp3", 
        [Languages.Polish]  = "PL_DrvTrainReady3.mp3" 
    },
    ["DrvTrainReady4"] = { 
        [Languages.English] = "EN_DrvTrainReady4.mp3", 
        [Languages.Polish]  = "PL_DrvTrainReady4.mp3" 
    },
    ["DrvTrainReady5"] = { 
        [Languages.English] = "EN_DrvTrainReady4.mp3", 
        [Languages.Polish]  = "PL_DrvTrainReady4.mp3" 
    },
    ["DrvShuntToCarriages"] = { 
        [Languages.English] = "EN_DrvShuntToCarriages.mp3", 
        [Languages.Polish]  = "PL_DrvShuntToCarriages.mp3" 
    },
    ["DrvLaTrainDepart"] = { 
        [Languages.English] = "EN_DrvTrainDepart.mp3", 
        [Languages.Polish]  = "PL_DrvTrainDepart.mp3" 
    },
    ["DspShuntToCarriages"] = { 
        [Languages.English] = "EN_DspShuntToCarriages.mp3", 
        [Languages.Polish]  = "PL_DspShuntToCarriages.mp3" 
    },
    ["DspLaTrainDepart"] = { 
        [Languages.English] = "EN_DspLaTrainDepart.mp3", 
        [Languages.Polish]  = "PL_DspLaTrainDepart.mp3" 
    },

    ["DrvDzArrived"] = { 
        [Languages.English] = "EN_DrvDzArrived.mp3", 
        [Languages.Polish]  = "PL_DrvDzArrived.mp3" 
    },
    ["DrvDzArrived2"] = { 
        [Languages.English] = "EN_DrvDzArrived2.mp3", 
        [Languages.Polish]  = "PL_DrvDzArrived2.mp3" 
    },
    ["DrvDzShuntToNewWagons"] = { 
        [Languages.English] = "EN_DrvDzShuntToNewWagons.mp3", 
        [Languages.Polish]  = "PL_DrvDzShuntToNewWagons.mp3" 
    },
    ["DrvDzTrainDepart"] = { 
        [Languages.English] = "EN_DrvTrainDepart.mp3", 
        [Languages.Polish]  = "PL_DrvTrainDepart.mp3" 
    },
    ["DspDzBeginShunting"] = { 
        [Languages.English] = "EN_DspDzBeginShunting.mp3", 
        [Languages.Polish]  = "PL_DspDzBeginShunting.mp3" 
    },
    ["DspDzBeginShunting2"] = { 
        [Languages.English] = "EN_DspDzBeginShunting2.mp3", 
        [Languages.Polish]  = "PL_DspDzBeginShunting2.mp3" 
    },
    ["DspDzShuntToNewWagons"] = { 
        [Languages.English] = "EN_DspDzShuntToNewWagons.mp3", 
        [Languages.Polish]  = "PL_DspDzShuntToNewWagons.mp3" 
    },
    ["DspDzTrainDepart"] = { 
        [Languages.English] = "EN_DspDzTrainDepart.mp3", 
        [Languages.Polish]  = "PL_DspDzTrainDepart.mp3" 
    },

    ["DrvBReady"] = { 
        [Languages.English] = "EN_DrvBReady.mp3", 
        [Languages.Polish]  = "PL_DrvBReady.mp3" 
    },
    ["DspBRodger"] = { 
        [Languages.English] = "EN_DspBRodger.mp3", 
        [Languages.Polish]  = "PL_DspBRodger.mp3" 
    }
};