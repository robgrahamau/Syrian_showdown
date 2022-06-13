SYRIA.AirWings.RUSSIA201 = AIRWING:New("damascus","Russian 201 Expeditionary")
SYRIA.AirWings.RUSSIA201:SetMarker(false)
SYRIA.AirWings.RUSSIA201:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Damascus))
SYRIA.AirWings.RUSSIA201:SetRespawnAfterDestroyed(900)
SYRIA.AirWings.RUSSIA201:SetTakeoffCold()
SYRIA.AirWings.RUSSIA201:__Start(5)

SYRIA.AirWings.S12thTransport1 = AIRWING:New("ezzor","Syrian 12th Transport")
SYRIA.AirWings.S12thTransport1:SetMarker(false)
SYRIA.AirWings.S12thTransport1:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Deir_ez_Zor))
SYRIA.AirWings.S12thTransport1:SetRespawnAfterDestroyed(900)
SYRIA.AirWings.S12thTransport1:SetTakeoffCold()
SYRIA.AirWings.S12thTransport1:__Start(17)

SYRIA.AirWings.Abu = AIRWING:New("abu","Abu Al-Duhur")
SYRIA.AirWings.Abu:SetMarker(false)
SYRIA.AirWings.Abu:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Abu_al_Duhur))
SYRIA.AirWings.Abu:SetRespawnAfterDestroyed(900)
SYRIA.AirWings.Abu:SetTakeoffCold()
SYRIA.AirWings.Abu:__Start(23)

SYRIA.Squadrons.S678Sqn = SQUADRON:New("mig23_cap",4,"678 Squadron")
SYRIA.Squadrons.S678Sqn:AddMissionCapability({AUFTRAG.Type.ALERT5,AUFTRAG.Type.ESCORT,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.GCICAP},80)
SYRIA.Squadrons.S678Sqn:SetFuelLowThreshold(0.25)
SYRIA.Squadrons.S678Sqn:SetTakeoffCold()
SYRIA.Squadrons.S678Sqn:SetTurnoverTime(40,80)
SYRIA.Squadrons.S678Sqn:SetRadio(256,radio.modulation.AM)

SYRIA.Squadrons.S2Sqn = SQUADRON:New("l39za_air",8,"2 Squadron")
SYRIA.Squadrons.S2Sqn:AddMissionCapability({AUFTRAG.Type.CAP,AUFTRAG.Type.GCICAP},50)
SYRIA.Squadrons.S2Sqn:SetFuelLowThreshold(0.25)
SYRIA.Squadrons.S2Sqn:SetTakeoffCold()
SYRIA.Squadrons.S2Sqn:SetTurnoverTime(40,80)
SYRIA.Squadrons.S2Sqn:SetRadio(256,radio.modulation.AM)



SYRIA.Squadrons.ezormi8transport = SQUADRON:New("Mi8 transport",5,"Mi8 Transport Sqn Ezezor")
SYRIA.Squadrons.ezormi8transport:AddMissionCapability({AUFTRAG.Type.OPSTRANSPORT})

SYRIA.AirWings.S12thTransport1:AddSquadron(SYRIA.Squadrons.ezormi8transport)
SYRIA.AirWings.S12thTransport1:NewPayload("Mi8 transport",6,{AUFTRAG.Type.OPSTRANSPORT},70)

SYRIA.Squadrons.RUSSIA_2 = SQUADRON:New("RAWAC",4,"Etiza")
SYRIA.Squadrons.RUSSIA_2:AddMissionCapability({AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
SYRIA.Squadrons.RUSSIA_2:SetFuelLowThreshold(0.2)
SYRIA.Squadrons.RUSSIA_2:SetFuelLowRefuel(true)
SYRIA.Squadrons.RUSSIA_2:SetTurnoverTime(30,60) -- 30 minutes turn around time after landing to be able to be combat ready again, 60 minutes to repair 1LP

SYRIA.Squadrons.RUSSIA_3 = SQUADRON:New("mig29",12,"301 Expeditionary")
SYRIA.Squadrons.RUSSIA_3:AddMissionCapability({AUFTRAG.Type.ALERT5,AUFTRAG.Type.ESCORT,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP},100)
SYRIA.Squadrons.RUSSIA_3:SetFuelLowRefuel(true)
SYRIA.Squadrons.RUSSIA_3:SetFuelLowThreshold(0.3)
SYRIA.Squadrons.RUSSIA_3:SetTakeoffCold()
SYRIA.Squadrons.RUSSIA_3:SetTurnoverTime(40,80)
SYRIA.Squadrons.RUSSIA_3:SetRadio(256,radio.modulation.AM)

SYRIA.AirWings.RUSSIA201:AddSquadron(SYRIA.Squadrons.RUSSIA_2)
SYRIA.AirWings.RUSSIA201:NewPayload("RAWAC",3,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
SYRIA.AirWings.RUSSIA201:AddSquadron(SYRIA.Squadrons.RUSSIA_3)
SYRIA.AirWings.RUSSIA201:NewPayload("mig29",40,{AUFTRAG.Type.ESCORT,AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},100)

SYRIA.AirWings.Abu:AddSquadron(SYRIA.Squadrons.S678Sqn)
SYRIA.AirWings.Abu:AddSquadron(SYRIA.Squadrons.S2Sqn)
SYRIA.AirWings.Abu:NewPayload("mig23_cap",200,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.ESCORT,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.GCICAP},80)
SYRIA.AirWings.Abu:NewPayload("l39za_air",200,{AUFTRAG.Type.CAP,AUFTRAG.Type.GCICAP},50)

SYRAWACS = AWACS:New("SYRIA AWACS",SYRIA.AirWings.RUSSIA201,"red",AIRBASE.Syria.Damascus,"YELTSIN",Z_SYR_FEZ_SOUTH,"BORRIS",256,radio.modulation.AM)
SYRAWACS:SetEscort(2)
SYRAWACS:SetAwacsDetails(CALLSIGN.AWACS.Magic,1,32,RGUTILS.CalculateTAS(32000,320,0),090,25)
SYRAWACS:SetSRS(_SRSPATH,"Female","US-EN",5002)
SYRAWACS:SetRejectionZone(Z_NOTSYRIAAS)
SYRAWACS:SetAdditionalZone(Z_SYR_FEZ_NORTH,false)
SYRAWACS:SetAICAPDetails(CALLSIGN.Aircraft.Ford,4,2,RGUTILS.CalculateTAS(22000,300,0))
SYRAWACS:SetModernEra()
SYRAWACS.PlayerGuidance = false
--SYRAWACS:DrawFEZ()
SYRAWACS.AllowMarkers = true
SYRAWACS:__Start(21)

SYRIA.AirWings.Abu:SetUsingOpsAwacs(SYRAWACS)
SYRIA.AirWings.Abu:AddPatrolPointCAP(Z_YELTSIN:GetCoordinate(), 26000, RGUTILS.CalculateTAS(26000,300,0), 270, 15)
SYRIA.AirWings.Abu:AddPatrolPointCAP(Z_YELTSIN:GetCoordinate(), 28000, RGUTILS.CalculateTAS(28000,300,0), 180, 25)
SYRIA.AirWings.Abu:SetNumberCAP(3)


SCHEDULER:New(nil,function() 
    SYRIA.AirWings.Abu:Save(_PERSISTANCEPATH, "Abu")
    SYRIA.AirWings.RUSSIA201:Save(_PERSISTANCEPATH, "R201")
    SYRIA.Squadrons.RUSSIA_2:Save(_PERSISTANCEPATH, "RUSSIA2")
    SYRIA.Squadrons.RUSSIA_3:Save(_PERSISTANCEPATH, "RUSSIA3")
    SYRIA.Squadrons.ezormi8transport:Save(_PERSISTANCEPATH, "ezormi8")
end,{},60,60)