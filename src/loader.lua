-- Important Globals go here
env.info("TGW Syria By Robert Graham Initialising.")
_VERSION = 0.30
_LASTUPDATE = "14/06/2022"
_DEBUG = true
_PASSWORD = "test"
ADMINPASSWORD2 = "testing"
trigger.action.setUserFlag("SSB",000)
_SRCPATH = lfs.writedir() .."syria\\src\\"
_PERSISTANCEPATH= lfs.writedir() .. "syria\\"
_SRSPATH = "D:\\DCS-SimpleRadio-Standalone\\"
--_SRSPATH = "E:\\DCS-SimpleRadio-Standalone\\"
_SRSPORT = 5002
dofile( _SRCPATH .. "utils.lua")
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
US = {} -- holds our forces
US.AirWings = {}
US.Squadrons = {}
US.Brigades = {}
US.Platoons = {}
US.Flotilla = {}
US.Fleet = {}

SYRIA = {} -- holds our forces
SYRIA.AirWings = {}
SYRIA.Squadrons = {}
SYRIA.Brigades = {}
SYRIA.Platoons = {}
SYRIA.Flotilla = {}
SYRIA.Fleet = {}
SYRIA.Factories = {}

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
    local ran, errorMSG = pcall(function() dofile(path .. filename) end)
		if not ran then
			rlog({"_loadfile errored ",errorMSG})
		end
end

_loadfile("moose.lua",_SRCPATH)
_loadfile("mist.lua",_SRCPATH)
_loadfile("constants.lua",_SRCPATH)
_loadfile("stts.lua",_SRCPATH)
timeupdate = TIMER:New(function() RGUTILS:updatetime() end)
timeupdate:Start(nil,1)
if _USEHYPEMAN then
    _loadfile("HypeMan.lua","c:\\HypeMan\\")
    _HMLOADED = true
end
_loadfile("zones.lua",_SRCPATH)
_loadfile("missioncommands.lua",_SRCPATH)
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
_loadfile("client.lua",_SRCPATH)


_loadfile("syrianairwings.lua",_SRCPATH)
_loadfile("coalitionairwings.lua",_SRCPATH)
_loadfile("coalitionawacs.lua",_SRCPATH)


_loadfile("syrianforces.lua",_SRCPATH)
_loadfile("coalitionforces.lua",_SRCPATH)
-- _loadfile("randommpads.lua",_SRCPATH)
-- Temp stuff for testing on the Syria Misson -- 

-- These are "Global" items. So the handler is Global to every one as is Active Groups
-- Hence why they are in the loader and not out in their own area.

MAINHANDLER = hevent:New(true,true,false,60,60)
MAINHANDLER:Start()
ACTIVEBLUEGROUPS = SET_GROUP:New():FilterActive():FilterCoalitions("blue"):FilterStart()
ACTIVEREDGROUPS =  SET_GROUP:New():FilterActive():FilterCoalitions("red"):FilterStart()


env.info("loader.lua end")