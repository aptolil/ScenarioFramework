require("SimRailCore")

function ReleaseSignalDZ_E2(scenarioState, triggerName, trainsetInfo)
    VDReleaseRoute("DZ_E2", VDOrderType.TrainRoute)
end

function ReleaseSignalDZ_B(scenarioState, triggerName, trainsetInfo)
    VDReleaseRoute("DZ_B", VDOrderType.TrainRoute)
end

function SetSwitchesAtDZ(scenarioState, triggerName, trainsetInfo)
    VDSetSwitchPosition("z_DZ_1", false)
    VDSetSwitchPosition("z_DZ_3a", true)
    VDSetSwitchPosition("z_DZ_5b", true)
    VDSetSwitchPosition("z_DZ_17", false)
end