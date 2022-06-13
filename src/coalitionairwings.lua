
--- Airwings 
--#region Airwing

US.AirWings.USAW380  = AIRWING:New("akrotiri","380th Air Expeditonary Wing")
US.AirWings.USAW380:SetMarker(false)
US.AirWings.USAW380:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Akrotiri))
US.AirWings.USAW380:SetRespawnAfterDestroyed(900)
US.AirWings.USAW380:SetTakeoffCold()
US.AirWings.USAW380:__Start(1)

US.AirWings.USCAW9 = AIRWING:New("abew","Carrier Air Wing Nine")
US.AirWings.USCAW9:SetMarker(false)
US.AirWings.USCAW9:SetAirbase(AIRBASE:FindByName("AbeLinc"))
US.AirWings.USCAW9:SetRespawnAfterDestroyed(900)
US.AirWings.USCAW9:SetTakeoffAir()
US.AirWings.USCAW9:__Start(3)

--#endregion

--#region Squadrons


US.Squadrons.USVAW117 = SQUADRON:New("OVERLORD1",4,"Wallbangers") -- E2D
US.Squadrons.USVAW117:AddMissionCapability({AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
US.Squadrons.USVAW117:SetFuelLowRefuel(0.2)
US.Squadrons.USVAW117:SetFuelLowRefuel(true)
US.Squadrons.USVAW117:SetTurnoverTime(30,60) -- 30 minutes turn around time after landing to be able to be combat ready again, 60 minutes to repair 1LP

US.Squadrons.USVFA14 = SQUADRON:New("TopHatters",6,"Tophatters") -- F14A135GR
US.Squadrons.USVFA14:AddMissionCapability({AUFTRAG.Type.ALERT5,AUFTRAG.Type.ESCORT,AUFTRAG.Type.Cap,AUFTRAG.Type.GCICAP,AUFTRAG.Type.INTERCEPT},80)
US.Squadrons.USVFA14:SetFuelLowRefuel(true)
US.Squadrons.USVFA14:SetFuelLowThreshold(0.3)
US.Squadrons.USVFA14:SetTurnoverTime(40,80) -- 40 minutes to turn around, this is proper rearm, refuel and checks.. 80 minutes to repair 1lp as the cats especially the A's were getting old.
US.Squadrons.USVFA14:SetRadio(256,radio.modulation.AM)

US.Squadrons.USVFA192 = SQUADRON:New("Dragons",6,"Dragons") -- F18C
US.Squadrons.USVFA192:AddMissionCapability({AUFTRAG.Type.ALERT5,AUFTRAG.Type.ESCORT,AUFTRAG.Type.Cap,AUFTRAG.Type.GCICAP,AUFTRAG.Type.INTERCEPT},80)
US.Squadrons.USVFA192:SetFuelLowRefuel(true)
US.Squadrons.USVFA192:SetFuelLowThreshold(0.3)
US.Squadrons.USVFA192:SetTurnoverTime(40,60) -- 40 minutes turn around, the 'Hornets' never did really exceed the cats in their turn around times, but less to maintain (repair) as they were easier in this regards.
US.Squadrons.USVFA192:SetRadio(256,radio.modulation.AM)

US.Squadrons.USVMFA314 = SQUADRON:New("BlackKnights",6,"Black Knights")
US.Squadrons.USVMFA314:AddMissionCapability({AUFTRAG.Type.CAS,AUFTRAG.Type.CASENHANCED,AUFTRAG.Type.STRIKE,AUFTRAG.Type.BAI,80})
US.Squadrons.USVMFA314:AddMissionCapability({AUFTRAG.Type.SEAD,60})
US.Squadrons.USVMFA314:AddMissionCapability({AUFTRAG.Type.ANTISHIP,80})
US.Squadrons.USVMFA314:AddMissionCapability({AUFTRAG.Type.ESCORT,AUFTRAG.Type.ALERT5,AUFTRAG.Type.Cap,AUFTRAG.Type.INTERCEPT,70})
US.Squadrons.USVMFA314:SetFuelLowRefuel(true)
US.Squadrons.USVMFA314:SetFuelLowThreshold(0.3)
US.Squadrons.USVMFA314:SetTurnoverTime(40,60) -- 40 minutes turn around, the 'Hornets' never did really exceed the cats in their turn around times, but less to maintain (repair) as they were easier in this regards.
US.Squadrons.USVMFA314:SetRadio(256,radio.modulation.AM)

US.Squadrons.USVFA151 = SQUADRON:New("Vigilantes", 6,"Vigilantes")
US.Squadrons.USVFA151:AddMissionCapability({AUFTRAG.Type.CAS,AUFTRAG.Type.CASENHANCED,AUFTRAG.Type.STRIKE,AUFTRAG.Type.BAI,80})
US.Squadrons.USVFA151:AddMissionCapability({AUFTRAG.Type.SEAD,60})
US.Squadrons.USVFA151:AddMissionCapability({AUFTRAG.Type.ANTISHIP,80})
US.Squadrons.USVFA151:AddMissionCapability({AUFTRAG.Type.ESCORT,AUFTRAG.Type.ALERT5,AUFTRAG.Type.Cap,AUFTRAG.Type.INTERCEPT,70})
US.Squadrons.USVFA151:SetFuelLowRefuel(true)
US.Squadrons.USVFA151:SetFuelLowThreshold(0.3)
US.Squadrons.USVFA151:SetTakeoffCold()
US.Squadrons.USVFA151:SetTurnoverTime(40,60) -- 40 minutes turn around, the 'Hornets' never did really exceed the cats in their turn around times, but less to maintain (repair) as they were easier in this regards.
US.Squadrons.USVFA151:SetRadio(256,radio.modulation.AM)


US.Squadrons.US968SQNAW = SQUADRON:New("MAGIC",3,"968th Expeditionary Airborne Air Control Squadron")
US.Squadrons.US968SQNAW:AddMissionCapability({AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
US.Squadrons.US968SQNAW:SetFuelLowRefuel(true)
US.Squadrons.US968SQNAW:SetFuelLowThreshold(0.25) 
US.Squadrons.US968SQNAW:SetTurnoverTime(30,60)

US.Squadrons.US310SQNTNK = SQUADRON:New("TEXACO",2,"310th Air Refueling Squadron")
US.Squadrons.US310SQNTNK:AddMissionCapability({AUFTRAG.Type.ORBIT,AUFTRAG.Type.TANKER},100)
US.Squadrons.US310SQNTNK:SetFuelLowRefuel(true)
US.Squadrons.US310SQNTNK:SetFuelLowThreshold(0.25)
US.Squadrons.US310SQNTNK:SetTurnoverTime(30,60)
US.Squadrons.US310SQNTNK:SetRadio(251,radio.modulation.AM)

US.Squadrons.US310SQNTNKP = SQUADRON:New("ARC",2,"310th Air Refueling Squadron - Probe")
US.Squadrons.US310SQNTNKP:AddMissionCapability({AUFTRAG.Type.ORBIT,AUFTRAG.Type.TANKER},100)
US.Squadrons.US310SQNTNKP:SetFuelLowRefuel(true)
US.Squadrons.US310SQNTNKP:SetFuelLowThreshold(0.25)
US.Squadrons.US310SQNTNKP:SetTurnoverTime(30,60)
US.Squadrons.US310SQNTNKP:SetRadio(251.5,radio.modulation.AM)



US.Squadrons.US12SQNESC = SQUADRON:New("F15Escort",6,"525th Fighter Squadron - Escort")
US.Squadrons.US12SQNESC:AddMissionCapability({AUFTRAG.Type.ESCORT},100)
US.Squadrons.US12SQNESC:SetFuelLowRefuel(true)
US.Squadrons.US12SQNESC:SetFuelLowThreshold(0.3)
US.Squadrons.US12SQNESC:SetTurnoverTime(30,60)
US.Squadrons.US12SQNESC:SetTakeoffCold()
US.Squadrons.US12SQNESC:SetRadio(255,radio.modulation.AM)


US.Squadrons.US12THAID = SQUADRON:New("F15Cap",6,"525th Fighter Squadron - Air Interdiction")
US.Squadrons.US12THAID:AddMissionCapability({AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},80)
US.Squadrons.US12THAID:SetFuelLowThreshold(0.3)
US.Squadrons.US12THAID:SetFuelLowRefuel(true) 
US.Squadrons.US12THAID:SetTurnoverTime(30,60)
US.Squadrons.US12THAID:SetTakeoffCold()
US.Squadrons.US12THAID:SetRadio(255,radio.modulation.AM)

--#endregion

--#region add squadrons to airwings

US.AirWings.USAW380:AddSquadron(US.Squadrons.US968SQNAW)
US.AirWings.USAW380:NewPayload("MAGIC",3,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
US.AirWings.USAW380:AddSquadron(US.Squadrons.US12SQNESC)
US.AirWings.USAW380:NewPayload("F15Escort",40,{AUFTRAG.Type.ESCORT},100)
US.AirWings.USAW380:AddSquadron(US.Squadrons.US12THAID)
US.AirWings.USAW380:NewPayload("F15Cap",40,{AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},100)
US.AirWings.USAW380:AddSquadron(US.Squadrons.US310SQNTNK)
US.AirWings.USAW380:NewPayload("TEXACO",2,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.TANKER},100)
US.Airwings.USAW380:AddSquadron(US.Squadrons.US310SQNTNKP)
US.AirWings.USAW380:NewPayload("ARC",2,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.TANKER},100)

US.AirWings.USCAW9:AddSquadron(US.Squadrons.USVAW117)
US.AirWings.USCAW9:NewPayload("OVERLORD1",4,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
US.AirWings.USCAW9:AddSquadron(US.Squadrons.USVFA14)
US.AirWings.USCAW9:NewPayload("TopHatters",52,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.ESCORT,AUFTRAG.Type.CAP},100)
US.AirWings.USCAW9:AddSquadron(US.Squadrons.USVFA192)
US.AirWings.USCAW9:NewPayload("Dragons",256,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.ESCORT,AUFTRAG.Type.CAP},90)
US.AirWings.USCAW9:NewPayload("Dragons-1",256,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.INTERCEPT},100)
US.AirWings.USCAW9:NewPayload("TopHatters-1",256,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.ESCORT,AUFTRAG.Type.CAP},90)
US.AirWings.USCAW9:AddSquadron(US.Squadrons.USVMFA314)
US.AirWings.USCAW9:NewPayload("BlackKnights",256,{AUFTRAG.Type.CAS,AUFTRAG.Type.STRIKE,AUFTRAG.Type.BAI},100)
--USCAW9:AddSquadron(USVFA151)
--USCAW9:NewPayload("Vigilantes",24,{AUFTRAG.Type.ANTISHIP},100)
--USCAW9:NewPayload("Vigilantes-1",64,{AUFTRAG.Type.SEAD},100)
--USCAW9:NewPayload("Vigilantes-2",128,{AUFTRAG.Type.CAS,AUFTRAG.Type.CASENHANCED},100)


--#endregion 

--#region navigation points etc for Airwings
US.AirWings.USAW380:AddPatrolPointTANKER(Z_IDAKU:GetCoordinate(),30000,315,180,40,0)
US.AirWings.USAW380:AddPatrolPointTANKER(Z_ELVIS:GetCoordinate(),30000,315,180,40,0)



--#endregion