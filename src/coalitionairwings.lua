--- Airwings 
--#region Airwing

USAW380  = AIRWING:New("akrotiri","380th Air Expeditonary Wing")
USAW380:SetMarker(false)
USAW380:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Akrotiri))
USAW380:SetRespawnAfterDestroyed(60*60*24*5)
USAW380:SetTakeoffCold()
USAW380:__Start(2)

USCAW9 = AIRWING:New("abew","Carrier Air Wing Nine")
USCAW9:SetMarker(false)
USCAW9:SetAirbase(AIRBASE:FindByName("AbeLinc"))
USCAW9:SetRespawnAfterDestroyed(60*60*24*5)
USCAW9:SetTakeoffCold()
USCAW9:__Start(3)

--#endregion

--#region Squadrons


USVAW117 = SQUADRON:New("OVERLORD1",4,"Wallbangers") -- E2D
USVAW117:AddMissionCapability({AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
USVAW117:SetFuelLowRefuel(0.2)
USVAW117:SetFuelLowRefuel(true)
USVAW117:SetTurnoverTime(30,60) -- 30 minutes turn around time after landing to be able to be combat ready again, 60 minutes to repair 1LP

USVFA14 = SQUADRON:New("TopHatters",12,"Tophatters") -- F14A135GR
USVFA14:AddMissionCapability({AUFTRAG.Type.ALERT5,AUFTRAG.Type.ESCORT,AUFTRAG.Type.Cap,AUFTRAG.Type.GCICAP,AUFTRAG.Type.INTERCEPT},80)
USVFA14:SetFuelLowRefuel(true)
USVFA14:SetFuelLowThreshold(0.3)
USVFA14:SetTakeoffCold()
USVFA14:SetTurnoverTime(40,80) -- 40 minutes to turn around, this is proper rearm, refuel and checks.. 80 minutes to repair 1lp as the cats especially the A's were getting old.
USVFA14:SetRadio(256,radio.modulation.AM)

USVFA192 = SQUADRON:New("Dragons",12,"Dragons") -- F18C
USVFA192:AddMissionCapability({AUFTRAG.Type.ALERT5,AUFTRAG.Type.ESCORT,AUFTRAG.Type.Cap,AUFTRAG.Type.GCICAP,AUFTRAG.Type.INTERCEPT},80)
USVFA192:SetFuelLowRefuel(true)
USVFA192:SetFuelLowThreshold(0.3)
USVFA192:SetTakeoffCold()
USVFA192:SetTurnoverTime(40,60) -- 40 minutes turn around, the 'Hornets' never did really exceed the cats in their turn around times, but less to maintain (repair) as they were easier in this regards.
USVFA192:SetRadio(256,radio.modulation.AM)

USVMFA314 = SQUADRON:New("BlackKnights",12,"Black Knights")
USVMFA314:AddMissionCapability({AUFTRAG.Type.CAS,AUFTRAG.Type.CASENHANCED,AUFTRAG.Type.STRIKE,AUFTRAG.Type.BAI,80})
USVMFA314:AddMissionCapability({AUFTRAG.Type.SEAD,60})
USVMFA314:AddMissionCapability({AUFTRAG.Type.ANTISHIP,80})
USVMFA314:AddMissionCapability({AUFTRAG.Type.ESCORT,AUFTRAG.Type.ALERT5,AUFTRAG.Type.Cap,AUFTRAG.Type.INTERCEPT,70})
USVMFA314:SetFuelLowRefuel(true)
USVMFA314:SetFuelLowThreshold(0.3)
USVMFA314:SetTakeoffCold()
USVMFA314:SetTurnoverTime(40,60) -- 40 minutes turn around, the 'Hornets' never did really exceed the cats in their turn around times, but less to maintain (repair) as they were easier in this regards.
USVMFA314:SetRadio(256,radio.modulation.AM)

USVFA151 = SQUADRON:New("Vigilantes", 12,"Vigilantes")
USVFA151:AddMissionCapability({AUFTRAG.Type.CAS,AUFTRAG.Type.CASENHANCED,AUFTRAG.Type.STRIKE,AUFTRAG.Type.BAI,80})
USVFA151:AddMissionCapability({AUFTRAG.Type.SEAD,60})
USVFA151:AddMissionCapability({AUFTRAG.Type.ANTISHIP,80})
USVFA151:AddMissionCapability({AUFTRAG.Type.ESCORT,AUFTRAG.Type.ALERT5,AUFTRAG.Type.Cap,AUFTRAG.Type.INTERCEPT,70})
USVFA151:SetFuelLowRefuel(true)
USVFA151:SetFuelLowThreshold(0.3)
USVFA151:SetTakeoffCold()
USVFA151:SetTurnoverTime(40,60) -- 40 minutes turn around, the 'Hornets' never did really exceed the cats in their turn around times, but less to maintain (repair) as they were easier in this regards.
USVFA151:SetRadio(256,radio.modulation.AM)


US968SQNAW = SQUADRON:New("MAGIC",3,"968th Expeditionary Airborne Air Control Squadron")
US968SQNAW:AddMissionCapability({AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
US968SQNAW:SetFuelLowRefuel(true)
US968SQNAW:SetFuelLowThreshold(0.25) 
US968SQNAW:SetTurnoverTime(30,60)

US310SQNTNK = SQUADRON:New("TEXACO",2,"310th Air Refueling Squadron")
US310SQNTNK:AddMissionCapability({AUFTRAG.Type.ORBIT,AUFTRAG.Type.TANKER},100)
US310SQNTNK:SetFuelLowRefuel(true)
US310SQNTNK:SetFuelLowThreshold(0.25)
US310SQNTNK:SetTurnoverTime(30,60)
US310SQNTNK:SetRadio(251,radio.modulation.AM)

US12SQNESC = SQUADRON:New("F15Escort",12,"525th Fighter Squadron - Escort")
US12SQNESC:AddMissionCapability({AUFTRAG.Type.ESCORT},100)
US12SQNESC:SetFuelLowRefuel(true)
US12SQNESC:SetFuelLowThreshold(0.3)
US12SQNESC:SetTurnoverTime(30,60)
US12SQNESC:SetTakeoffCold()
US12SQNESC:SetRadio(255,radio.modulation.AM)


US12THAID = SQUADRON:New("F15Cap",12,"525th Fighter Squadron - Air Interdiction")
US12THAID:AddMissionCapability({AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},80)
US12THAID:SetFuelLowThreshold(0.3)
US12THAID:SetFuelLowRefuel(true) 
US12THAID:SetTurnoverTime(30,60)
US12THAID:SetTakeoffCold()
US12THAID:SetRadio(255,radio.modulation.AM)

--#endregion

--#region add squadrons to airwings

USAW380:AddSquadron(US968SQNAW)
USAW380:NewPayload("MAGIC",3,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
USAW380:AddSquadron(US12SQNESC)
USAW380:NewPayload("F15Escort",40,{AUFTRAG.Type.ESCORT},100)
USAW380:AddSquadron(US12THAID)
USAW380:NewPayload("F15Cap",40,{AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},100)
USAW380:AddSquadron(US310SQNTNK)
USAW380:NewPayload("TEXACO",2,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.TANKER},100)


USCAW9:AddSquadron(USVAW117)
USCAW9:NewPayload("OVERLORD1",4,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
USCAW9:AddSquadron(USVFA14)
USCAW9:NewPayload("TopHatters",52,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.ESCORT,AUFTRAG.Type.CAP},100)
USCAW9:AddSquadron(USVFA192)
USCAW9:NewPayload("Dragons",256,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.ESCORT,AUFTRAG.Type.CAP},90)
USCAW9:NewPayload("Dragons-1",256,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.INTERCEPT},100)
USCAW9:NewPayload("TopHatters-1",256,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.ESCORT,AUFTRAG.Type.CAP},90)
USCAW9:AddSquadron(USVMFA314)
USCAW9:NewPayload("BlackKnights",256,{AUFTRAG.Type.CAS,AUFTRAG.Type.STRIKE,AUFTRAG.Type.BAI},100)
--USCAW9:AddSquadron(USVFA151)
--USCAW9:NewPayload("Vigilantes",24,{AUFTRAG.Type.ANTISHIP},100)
--USCAW9:NewPayload("Vigilantes-1",64,{AUFTRAG.Type.SEAD},100)
--USCAW9:NewPayload("Vigilantes-2",128,{AUFTRAG.Type.CAS,AUFTRAG.Type.CASENHANCED},100)


--#endregion 

--#region navigation points etc for Airwings
USAW380:AddPatrolPointTANKER(Z_IDAKU:GetCoordinate(),30000,315,180,40,0)
USAW380:AddPatrolPointTANKER(Z_ELVIS:GetCoordinate(),30000,315,180,40,0)



--#endregion