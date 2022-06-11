WESTAWACS = AWACS:New("West Awacs",USAW380,"blue",AIRBASE.Syria.Akrotiri,"LCD03",Z_FEZWEST,"RENO",255,radio.modulation.AM)
WESTAWACS:SetEscort(2)
WESTAWACS:SetAwacsDetails(CALLSIGN.AWACS.Magic,1,32,320,090,25)
--WESTAWACS:SetSRS(_SRSPATH,"Female","US-EN",5015)
WESTAWACS:SetRejectionZone(Z_SYRIANAS)
WESTAWACS:SetAICAPDetails(CALLSIGN.Aircraft.Ford,4,3,350)
WESTAWACS:SetModernEra()
WESTAWACS.PlayerGuidance = false
WESTAWACS:DrawFEZ()
WESTAWACS.AllowMarkers = true
WESTAWACS:__Start(7)
