-- Important Globals go here
env.info("TGW Syria By Robert Graham Initialising.")
_VERSION = 0.1
_LASTUPDATE = "24/02/1011"
_DEBUG = true
_PASSWORD = "test"

trigger.action.setUserFlag("SSB",100)
_SRCPATH = "syria\\src\\"
dofile(lfs.writedir() .. _SRCPATH .. "utils.lua")
_HMLOADED = false
_USEHYPEMAN = false
ADMIN = false
TANKERTIMER = 0
TANKER_COOLDOWN = (1)*60
function rlog( Arguments )
    if _DEBUG then
        local DebugInfoCurrent = debug.getinfo( 2, "nl" )
        local DebugInfoFrom = debug.getinfo( 3, "l" )
        local Function = "function"
        if DebugInfoCurrent.name then
            Function = DebugInfoCurrent.name
        end
        local LineCurrent = DebugInfoCurrent.currentline
          local LineFrom = -1 
        if DebugInfoFrom then
          LineFrom = DebugInfoFrom.currentline
        end
        env.info( string.format( "%6d(%6d)/%1s:%30s%05s.%s(%s)" , LineCurrent, LineFrom, "Error", "Rob Debug", ":", Function, RGUTILS.oneLineSerialize( Arguments ) ) )
        hm(string.format( "%6d(%6d)/%1s:%30s%05s.%s(%s)" , LineCurrent, LineFrom, "Error", "Rob Debug", ":", Function, RGUTILS.oneLineSerialize( Arguments ) ) )
    else
      env.info( string.format( "%1s:%30s%05s(%s)" , "Error", "Rob Debug", ":", RGUTILS.oneLineSerialize( Arguments ) ) )
      hm(string.format( "%1s:%30s%05s(%s)" , "Error", "Rob Debug", ":", RGUTILS.oneLineSerialize( Arguments ) ) )
    end
end

function hm(msg)
    if __HMLOADED then
        HypeMan.sendBotMessage(msg)
    else
        env.info(string.format("Hypeman not loaded: %s",msg))
    end
end
function hmlso(msg)
	if _HMLOADED then
        HypeMan.sendLSOBotMessage(msg)
    else
        env.info(string.format("Hypemand not loaded - LSOMSG: %s",msg))
    end
end
function _loadfile(filename,path)
    rlog({"Attempting to load file",filename,path})    
    local ran, errorMSG = pcall(function() dofile(lfs.writedir() ..path .. filename) end)
		if not ran then
			rlog({"_loadfile errored ",errorMSG})
		end
end

_loadfile("moose.lua",_SRCPATH)
_loadfile("mist.lua",_SRCPATH)
if _USEHYPEMAN then
    _loadfile("HypeMan.lua","c:\\HypeMan\\")
    _HMLOADED = true
end
_loadfile("eventhandler.lua",_SRCPATH)
_loadfile("farpcreator.lua",_SRCPATH)



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
  