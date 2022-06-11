--- Airwings 
--#region Airwing

USAW380  = AIRWING:New("akrotiri","380th Air Expeditonary Wing")
USAW380:SetMarker(false)
USAW380:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Akrotiri))
USAW380:SetRespawnAfterDestroyed(900)
USAW380:SetTakeoffCold()
USAW380:__Start(2)




--#endregion

--#region Squadribs

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

USAW380:AddSquadron(US968SQNAW)
USAW380:NewPayload("MAGIC",3,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.AWACS},100)
USAW380:AddSquadron(US12SQNESC)
USAW380:NewPayload("F15Escort",12,{AUFTRAG.Type.ESCORT},100)
USAW380:AddSquadron(US12THAID)
USAW380:NewPayload("F15Cap",12,{AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},100)
USAW380:AddSquadron(US310SQNTNK)
USAW380:NewPayload("TEXACO",2,{AUFTRAG.Type.ORBIT,AUFTRAG.Type.TANKER},100)
