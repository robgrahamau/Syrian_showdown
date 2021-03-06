if initalstart == true then
 


    -- US Army Items
    ADDTOWAREHOUSE("us platoon",10,whouse.tanf)
    ADDTOWAREHOUSE("us manpad",10,whouse.tanf)
    ADDTOWAREHOUSE("uh60a",1,whouse.tanf)
    ADDTOWAREHOUSE("cobra",2,whouse.tanf)
    ADDTOWAREHOUSE("warrior",2,whouse.tanf)
    ADDTOWAREHOUSE("m2a2",4,whouse.tanf)
    ADDTOWAREHOUSE("m1a2",2,whouse.tanf)
    ADDTOWAREHOUSE("paladin",2,whouse.tanf)
    ADDTOWAREHOUSE("paladin",3,whouse.h3)
    ADDTOWAREHOUSE("us platoon",10,whouse.h3)
    ADDTOWAREHOUSE("us manpad",10,whouse.h3)
    ADDTOWAREHOUSE("uh60a",3,whouse.h3)
    ADDTOWAREHOUSE("cobra",3,whouse.h3)
    ADDTOWAREHOUSE("warrior",3,whouse.h3)
    ADDTOWAREHOUSE("m2a2",8,whouse.h3)
    ADDTOWAREHOUSE("m1a2",8,whouse.h3)
    ADDTOWAREHOUSE("paladin",2,whouse.h3)
    ADDTOWAREHOUSE("oh58d",2,whouse.h3)
    ADDTOWAREHOUSE("m939",20,whouse.tanf)
    ADDTOWAREHOUSE("m939",20,whouse.h3)
end

Elint_blue = HoundElint:create(coalition.side.BLUE)
Elint_blue:addPlatform("commtower1")
Elint_blue:addPlatform("commtower2")
Elint_blue:addPlatform("commtower3")
Elint_blue:addPlatform("commtower4")
Elint_blue:addPlatform("f16seed1")
Elint_blue:addPlatform("f16seed2")
Elint_blue:addPlatform("OVERLORD1")
Elint_blue:addPlatform("TEXACO11")
Elint_blue:setMarkerType(HOUND.MARKER.POLYGON)
Elint_blue:enableMarkers()
Elint_blue:enableBDA()
-- Elint_blue:enableController()
-- Elint_blue:systemOn()

bluectld:InjectVehicles(Z_H3PAT,CTLD_CARGO:New(nil,"Patriot",{"patriot"},CTLD_CARGO.Enum.FOB,true,true,24,nil,false,750,3,"SAM SYSTEMS"))
COALITIONFARPCONTROL = FARPCREATOR:New("Tanf Control","Super","Convoytemplate","servicevehicletemplate",country.id.USA)
COALITIONFARPCONTROL:UseStartPoints(true)
COALITIONFARPCONTROL:AddStartPoint(atco)
COALITIONFARPCONTROL:UseClosestPoint(true)
COALITIONFARPCONTROL:AddFarpsToPoints(true)
COALITIONFARPCONTROL:Start()


TANKERMISSION(Z_IDAKU:GetCoordinate(),30000,RGUTILS.CalculateTAS(30000,315,0),180,35,0,US.AirWings.USAW380,300,(60*60*3),250,radio.modulation.AM,62,"SHL")
TANKERMISSION(Z_IDAKU:GetCoordinate(),20000,RGUTILS.CalculateTAS(20000,240,0),090,35,0,US.AirWings.USAW380,300,(60*60*3),250,radio.modulation.AM,62,"SH3")
TANKERMISSION(Z_GOOSE:GetCoordinate(),27000,RGUTILS.CalculateTAS(27000,275,0),090,35,1,US.AirWings.USAW380,300,(60*60*3),250,radio.modulation.AM,62,"AR2")