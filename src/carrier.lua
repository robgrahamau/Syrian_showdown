env.info("carrier.lua")

SHELL11=RECOVERYTANKER:New(UNIT:FindByName("AbeLinc"), "Shell11")
SHELL11:SetRadio(251)
SHELL11:SetCallsign(CALLSIGN.Tanker.Shell,1)
SHELL11:SetAltitude(6000)
SHELL11:SetTACAN(69,"SH1")
SHELL11:SetLowFuelThreshold(20)
SHELL11:SetTakeoffHot()
SHELL11:Start()


env.info("hound.lua end")