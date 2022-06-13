WESTAWACS = AWACS:New("West Awacs",US.AirWings.USAW380,"blue",AIRBASE.Syria.Akrotiri,"LCD03",Z_FEZWEST,"ELVIS",255,radio.modulation.AM)
WESTAWACS:SetEscort(1)
WESTAWACS:SetAwacsDetails(CALLSIGN.AWACS.Magic,1,32,RGUTILS.CalculateTAS(32000,240,0),090,25)
WESTAWACS:SetSRS(_SRSPATH,"Female","US-EN",5002)
WESTAWACS:SetRejectionZone(Z_SYRIANAS)
WESTAWACS:SetAICAPDetails(CALLSIGN.Aircraft.Ford,3,4,350)
WESTAWACS:SetModernEra()
WESTAWACS.PlayerGuidance = false
WESTAWACS:DrawFEZ()
WESTAWACS.AllowMarkers = true
WESTAWACS:__Start(7)


CARRIERAWACS = AWACS:New("CAW9 AWACS",US.AirWings.USCAW9,"blue","AbeLinc","GOOSE",Z_FEZSOUTH,"RENO",256,radio.modulation.AM)
CARRIERAWACS:SetEscort(1)
CARRIERAWACS:SetAwacsDetails(CALLSIGN.AWACS.Overlord,1,26,RGUTILS.CalculateTAS(26000,250,0),040,25)
CARRIERAWACS:SetRejectionZone(Z_SYRIANAS)
CARRIERAWACS:SetAICAPDetails("Hornet",2,2,350)
CARRIERAWACS:SetModernEra()
CARRIERAWACS:DrawFEZ()
CARRIERAWACS:SetSRS(_SRSPATH,"Female","US-EN",5002)
CARRIERAWACS.AllowMarkers = true
CARRIERAWACS.PlayerGuidance = false
CARRIERAWACS:__Start(11)