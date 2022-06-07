-- Important Globals go here
env.info("TGW Syria By Robert Graham Initialising.")
_VERSION = 0.27
_LASTUPDATE = "07/06/2022"
_DEBUG = true
_PASSWORD = "test"
ADMINPASSWORD2 = "testing"
trigger.action.setUserFlag("SSB",100)
_SRCPATH = "syria\\src\\"
_PERSISTANCEPATH = "syria\\"
dofile(lfs.writedir() .. _SRCPATH .. "utils.lua")
_HMLOADED = false
_USEHYPEMAN = false
ADMIN = false
initalstart = true
TANKERTIMER = 0
TANKER_COOLDOWN = (1)*60
BLUEUNITLIMIT = 500
REDUNITLIMIT = 500
NOWTABLE = {}
NOWYEAR = nil
NOWMONTH = nil
NOWDAY = nil
NOWHOUR = nil
NOWMINUTE = nil
NOWSEC = nil


function rlog(_val)
    RGUTILS.log(_val)
end

RGUTILS:updatetime()

---Hypeman Msg Handler
---@param msg string
function hm(msg)
    if __HMLOADED then
        HypeMan.sendBotMessage(msg)
    else
        env.info(string.format("Hypeman not loaded: %s",msg))
    end
end

---Hypeman LSO Msg Handler
---@param msg string
function hmlso(msg)
	if _HMLOADED then
        HypeMan.sendLSOBotMessage(msg)
    else
        env.info(string.format("Hypemand not loaded - LSOMSG: %s",msg))
    end
end

---File Loader with error handling.
---@param filename string
---@param path string
function _loadfile(filename,path)
    rlog({"Attempting to load file",filename,path})    
    local ran, errorMSG = pcall(function() dofile(lfs.writedir() ..path .. filename) end)
		if not ran then
			rlog({"_loadfile errored ",errorMSG})
		end
end

_loadfile("moose.lua",_SRCPATH)
_loadfile("mist.lua",_SRCPATH)
timeupdate = TIMER:New(function() RGUTILS:updatetime() end)
timeupdate:Start(nil,1)
if _USEHYPEMAN then
    _loadfile("HypeMan.lua","c:\\HypeMan\\")
    _HMLOADED = true
end
_loadfile("eventhandler.lua",_SRCPATH)
_loadfile("unitspawner.lua",_SRCPATH)
_loadfile("farpcreator.lua",_SRCPATH)
_loadfile("warehouse.lua",_SRCPATH)
_loadfile("moosectld.lua",_SRCPATH)
_loadfile("hound.lua",_SRCPATH)
_loadfile("dcslink.lua",_SRCPATH)
_loadfile("factory.lua",_SRCPATH)
_loadfile("transporters.lua",_SRCPATH)
_loadfile("groundintel.lua",_SRCPATH)
_loadfile("carrier.lua",_SRCPATH)
-- _loadfile("randommpads.lua",_SRCPATH)
-- Temp stuff for testing on the Syria Misson -- 


myhandler = hevent:New(true,true,false,60,60)
myhandler:Start()



myfarpcontrol = FARPCREATOR:New("Tanf Control","Super","Convoytemplate","servicevehicletemplate",country.id.USA)
-- start it.
atzone = ZONE:New("attanf")
atco = atzone:GetCoordinate()

myfarpcontrol:UseStartPoints(true)
myfarpcontrol:AddStartPoint(atco)
myfarpcontrol:UseClosestPoint(true)
myfarpcontrol:AddFarpsToPoints(true)
myfarpcontrol:Start()


ACTIVEBLUEGROUPS = SET_GROUP:New():FilterActive():FilterCoalitions("blue"):FilterStart()
ACTIVEREDGROUPS =  SET_GROUP:New():FilterActive():FilterCoalitions("red"):FilterStart()



if initalstart == true then
    -- ISIS Items
    ADDTOWAREHOUSE("syrian platoon",30,whouse.ezor)
    ADDTOWAREHOUSE("syrian manpad",10,whouse.ezor)
    ADDTOWAREHOUSE("Mi8 transport",6,whouse.ezor,WAREHOUSE.Attribute.AIR_TRANSPORTHELO)
    ADDTOWAREHOUSE("t55",9,whouse.ezor)
    ADDTOWAREHOUSE("t72b",3,whouse.ezor)
    ADDTOWAREHOUSE("zsu57",12,whouse.ezor)
    ADDTOWAREHOUSE("hl zu23",12,whouse.ezor)
    ADDTOWAREHOUSE("lc kord",24,whouse.ezor)
    ADDTOWAREHOUSE("lc dshk",24,whouse.ezor)
    ADDTOWAREHOUSE("btr80",12,whouse.ezor)
    ADDTOWAREHOUSE("btr-rd",12,whouse.ezor)
    ADDTOWAREHOUSE("plz-05",3,whouse.ezor)
    ADDTOWAREHOUSE("hq7",6,whouse.ezor)
    ADDTOWAREHOUSE("sa6",6,whouse.ezor)
    ADDTOWAREHOUSE("sa19",4,whouse.ezor)
    ADDTOWAREHOUSE("sa9",10,whouse.ezor)
    ADDTOWAREHOUSE("shilka",10,whouse.ezor)
    ADDTOWAREHOUSE("zsu57",14,whouse.ezor)
    ADDTOWAREHOUSE("ural",30,whouse.ezor)


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
Elint_blue:systemOn()

local prespawnsa10 = CTLD_CARGO:New(nil,"SA10",{"sa10"},CTLD_CARGO.Enum.FOB,true,true,24,nil,false,750,3,"SAM SYSTEMS")
redctld:InjectVehicles(ZONE:New("sa10"),prespawnsa10)
redctld:InjectVehicles(ZONE:New("palmyrasa10"),prespawnsa10)
bluectld:InjectVehicles(ZONE:New("h3north_patriot"),CTLD_CARGO:New(nil,"Patriot",{"patriot"},CTLD_CARGO.Enum.FOB,true,true,24,nil,false,750,3,"SAM SYSTEMS"))

EZORFACTORY = RGFactory:New("Ez-Zor Factory","hl zu23",1,(60*60*24*3.5),(60*60*24*4),true,1)
EZORFACTORY:AddParts(197492779,"hanger")
EZORFACTORY:AddParts(118065130,"hanger")
EZORFACTORY:AddParts(197492772,"industrial")
EZORFACTORY:AddParts(197492805,"industrial")
EZORFACTORY:AddParts(118065223,"hanger")

EZORFACTORY:AddWarehouse(whouse.ezor)
EZORFACTORY:enableMarkers(true)
EZORFACTORY:Start()

EZORFACTORY1 = RGFactory:New("Ez-zor Factory 1","syrian platoon",1,(60*60*24*2),(60*60*24*4),true,1)
EZORFACTORY1:AddParts("118065666","hanger")
EZORFACTORY1:AddParts("197492801","Building")
EZORFACTORY1:AddParts("197492802","Building")
EZORFACTORY1:AddParts("197492755","Building")
EZORFACTORY1:AddWarehouse(whouse.ezor)
EZORFACTORY1:enableMarkers(true)
EZORFACTORY1:Start()




env.info("loader.lua end")