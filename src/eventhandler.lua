rlog("Global Event Handler Events Version 1.00")

adminspawned = {}
hevent = {
    ClassName = "Handle_Events",
    TANKERTIME = 0,
    TANKER_COOLDOWN = 0,
    _handlelqm = false,
    _handlemarkers = false,
    spawnedunits = {},
    spawnedgroup = {},
    blueprefix = "cjtf_blue_",
    redprefix = "cjtf_red_",
    neutralprefix = "untf_",
}

function hevent:New(_markers,_lqm,_death,_tankertime,_tankercooldown)
    local self = BASE:Inherit(self,BASE:New())
    self:E("Initalising Handle Events")
    self._handlemarkers = _markers or false
    self._handlelqm = _lqm or false
    self.TANKERTIMER= _tankertime or TANKERTIMER
    self.TANKER_COOLDOWN = _tankercooldown or TANKER_COOLDOWN
    return self
end
--- Sets the Blue Spawn Prefix
function hevent:setblueprefix(bp)
  if bp ~= nil then
    self.blueprefix = bp
  end
end
--- Sets the Red Spawn Prefix
function hevent:setredprefix(rp)
  if rp ~= nil then
    self.redprefix = rp
  end
end
--- Sets the Neutral Spawn Prefix
function hevent:setunprefix(up)
  if up ~= nil then
    self.neutralprefix = up
  end
end

function hevent:Start()
  self:E({"Starting Handle_Events"})  
  if self._handlemarkers ~= false then
    self:HandleEvent(EVENTS.MarkRemoved)
  end
  if self._handlelqm ~= false then
      self:HandleEvent(EVENTS.LandingQualityMark)
  end
end

function hevent:Stop()
  self:E({"Stopping Handle_Events"})  
  self:UnhandleEvent(EVENTS.MarkRemoved)
  self:UnhandleEvent(EVENTS.LandingQualityMark)

end
-- handles the Landing Quality Mark Event
function hevent:OnEventLandingQualityMark(EventData)
    self:E({"Landing Quality Mark",EventData})
    local comment = EventData.comment
    local who = EventData.IniPlayerName
    if who == nil then
        who = EventData.IniUnitName
        self:E({"NPC Landed",who})
        return
    end
    if who == nil then
          who = "Unknown"
    end
    local t = EventData.IniTypeName
    if t == nil then
        t = "Unknown"
    end
    local where = EventData.PlaceName
    self:E({comment,who,where,t})
    hm("**Super Carrier LSO** \n> ** " .. where .. "** \n> **Landing Grade for  " .. who .. " **Aircraft Type:** " .. t .. " \n> **Grade:** " .. comment .. "." )
    hmlso( "**Super Carrier LSO** \n> ** " .. where .. "** \n> **Landing Grade for  " .. who .. " **Aircraft Type:** " .. t .. " \n> **Grade:** " .. comment .. "."  )
end
--- Handles our OnEventMarkRemove
function hevent:OnEventMarkRemoved(EventData)
  if EventData.text~=nil and EventData.text:lower():find("-") then
    local dcsgroupname = EventData.IniDCSGroupName
    local _playername = EventData.IniPlayerName
    local _group = GROUP:FindByName(dcsgroupname)
    local text = EventData.text:lower()
    local text2 = EventData.text
    local vec3={y=EventData.pos.y, x=EventData.pos.x, z=EventData.pos.z}
    local coord = COORDINATE:NewFromVec3(vec3)
    local _coalition = EventData.coalition
    local red = false
    if _coalition == 1 then
      red = true
    end
    coord.y = coord:GetLandHeight()
    if EventData.text:lower():find("-weather") then
      self:handleWeatherRequest(text,coord,_group)
    elseif EventData.text:lower():find("-tanker") then
      self:handleTankerRequest(text,coord,_coalition,_playername,_group)
    elseif EventData.text:lower():find("-help") then
      self:handlehelp(_group)
    elseif EventData.text:lower():find("-smoke") then
      self:handleSmoke(text,coord,_coalition,_group,_playername)
    elseif EventData.text:lower():find("-groupcheck") then
      self:groupchecker()
    elseif EventData.text:lower():find("-flare") then
      coord:FlareRed(math.random(0,360))
      SCHEDULER:New(nil,function() 
        coord:FlareRed(math.random(0,360))
      end,{},30)
    elseif EventData.text:lower():find("-light") then
      coord.y = coord.y + 1000
      coord:IlluminationBomb(1000)
    elseif EventData.text:lower():find("-lightbright") then
      coord.y = coord.y + 1500
      coord:IlluminationBomb(10000)
    elseif EventData.text:lower():find("-ctldfob") then
      -- ctld drop.
      if ADMIN == true then
        if ctld ~= nil then
          self:E({"attempting to spawn a fob"})
          MESSAGE:New("Attempting to spawn a fob lets see if it breaks",30):ToGroup(_group)
          local _unitId = ctld.getNextUnitId()
          local _name = "ctld Deployed FOB #" .. _unitId
          local _fob = nil
          self:E({"ctld",text})
          local keywords=UTILS.Split(text,"|")
          local s = keywords[2]
          if (s == "blue") then
            _fob = ctld.spawnFOB(2, 211, vec3, _name)
          elseif (s == "red") then
            _fob = ctld.spawnFOB(34, 211, vec3, _name)
          else
            _fob = ctld.spawnFOB(2, 211, vec3, _name)
          end
          table.insert(ctld.logisticUnits, _fob:getName())
          if ctld.troopPickupAtFOB == true then
            table.insert(ctld.builtFOBS, _fob:getName())
          end
        else
          MESSAGE:New("No CTLD was found are you certain it's installed?",60):ToGroup(_group)
        end
      end
    elseif EventData.text:lower():find("-routeside") then
      if ADMIN == true then
        self:routemassgroup(text,coord,_playername,_group)
      else
        MESSAGE:New("Unable, Admin Commands need to be active to use that command",15):ToGroup(_group)
      end
    elseif EventData.text:lower():find("-massdel") then
      if ADMIN == true then
        self:deletemassgroup(text,coord,_playername)
      else
        MESSAGE:New("Unable, Admin Commands need to be active to use that command",15):ToGroup(_group)
      end
    elseif EventData.text:lower():find("-explode") then
      if ADMIN == true then
        self:handleExplosion(text,coord,_playername,_group)
      else
        MESSAGE:New("Unable, Admin Commands need to be active to use that command",15):ToGroup(_group)
      end
    elseif EventData.text:lower():find("-admin") then
        self:handleeadmin(text,_playername)
    elseif EventData.text:lower():find("-radmin") then
        self:rhandleeadmin(text,_group,_playername)
    elseif EventData.text:lower():find("-spawn") or EventData.text:lower():find("-rs") then
      if ADMIN == true then
        self:newhandlespawn(text2,coord,_group,_playername)
      else
        MESSAGE:New("Admin Commands need to be active to spawn new units",15):ToGroup(_group)
      end
    elseif EventData.text:lower():find("-load") then
      if ADMIN == true then
        dofile(lfs.writedir() .."pg\\input.lua")
      else
        MESSAGE:New("Admin Commands need to be active to input a file",15):ToGroup(_group)
      end
    elseif EventData.text:lower():find("-despawn") or EventData.text:lower():find("-ds") then
      if ADMIN == true then
        self:handledespawn(text2,_playername,_group)
      else
        MESSAGE:New("Admin Commands need to be active to despawn units",15):ToGroup(_group)
      end
    elseif EventData.text:lower():find("-runscript") then
      hm("Wow ok " .. playername .. "is attempting to run a script.. hope they know the magic words")
      self:handleScript(text2,_playername,_group)
    elseif EventData.text:lower():find("-msgall") or EventData.text:lower():find("-ma") then
      if ADMIN == true then
        self:msgtoall(text2)
      else
        MESSAGE:New("Admin Commands need to be active to message all",15):ToGroup(_group)
      end
    end
  end
end
--- handles our help requests.
function hevent:handlehelp(_group)
  local msgtext = "Map Command Help Requested. The Following are valid commands for markers any with a - at the start require you to delete the marker. \n -help (this command) \n -smoke,red or -smoke,green or -smoke,blue or -smoke,white (Spawn a random smoke near the location) \n -flare (fire flares from the location of the nearest friendly forces) \n -weather (request a GRIBS weather report from the location of the marker) \n%d"
  local _msg = MESSAGE:New(msgtext,15):ToGroup(_group)
end
--- checks current group and unit count for all coalitions.
function hevent:groupchecker()
  local tempset = SET_UNIT:New():FilterActive():FilterOnce()
  local ucounter = 0
  local ub = 0
  local ur = 0
  local un = 0
  tempset:ForEach(function(g) 
    ucounter = ucounter + 1
    local uc = g:GetCoalition()
    if uc == 1 then
      ur = ur + 1
    elseif uc == 2 then
      ub = ub + 1
    else
      un = un + 1
    end
  end)
  tempset = SET_GROUP:New():FilterActive():FilterOnce()
  local gcounter = 0
  local gb = 0
  local gr = 0
  local gn = 0
  tempset:ForEach(function(g) 
    gcounter = gcounter + 1
    local gc = g:GetCoalition()
    if gc == 1 then
      gr = gr + 1
    elseif gc == 2 then
      gb = gb + 1
    else
      gn = gn + 1
    end
  end)
  MESSAGE:New(String.format("Current Group Count is: %d Active Groups, \n • Blue Groups: %d , Red Groups: %d , Neutral Groups: %d \n Unit Count is: %d Units \n • Blue Units: %d , Red Units: %d , Neutral Units: %d ",gcounter,gb,gr,gn,ucounter,ub,ur,un),30):ToAll()
end
--- Handles our smoke marker rounds..
function hevent:handleSmoke(text,_coord,col,_group,_playername)
  local keywords=UTILS.Split(text, ",")
  self:E({keywords})
  local keyphrase= "white"
  if keywords[2] ~= nil then
    keyphrase = keywords[2]
  end
  local _col = 2
  local _side = "blue"
  if col == 1 then
    _col = 1
    _side = "red"
  end
  local _dist = 10000
  local _inrange = false
  local _time = 30
  local _unitdistance = 10000
  local gunits = SET_GROUP:New():FilterCategoryGround():FilterCoalitions(_side):FilterActive(true):FilterOnce()
  local nc = _coord:GetRandomCoordinateInRadius(500,100)
  -- if admin is true we bypass a chunk of stuff and just automatically dump ourselves in range.
  if ADMIN ~= true then 
    gunits:ForEach(function(g)
      if g:IsAlive() == true then
        local groupname = g:GetName()
        local _group = GROUP:FindByName(groupname)
        local gc = _group:GetCoordinate()
        if gc == nil then
          BASE:E({"Could not get Coord for group:",g:GetName(),g:GetCoordinate(),gc})
        else
          local d = gc:Get2DDistance(_coord)
          if d < _dist then
            _inrange = true
            if d < _unitdistance then
              _unitdistance = d
            end
          end
        end
      end
    end)
  else
    _inrange = true
    nc = _coord
  end
  local _mgrs = _coord:ToStringMGRS()
  BASE:E({"SMOKE MGRS SHOULD BE HERE",_mgrs})
  local msg = MESSAGE:New(string.format("Firehawk, this is %s requesting smoke at %s.",_playername,_mgrs),30)
  if _col == 1 then
    msg:ToRed()
  else
    msg:ToBlue()
  end
  hm(string.format("Firehawk, this is %s requesting smoke at %s",_playername,_coord:ToStringMGRS()))
  if _inrange then
    -- calculate time to get smoke on target this will be (d/1000) * 5 + 30
    _time = (_unitdistance/1000) * 5 + 30
    local _or = (_unitdistance/100)
    local _ir = (_unitdistance/1000) * 2
    nc = _coord:GetRandomCoordinateInRadius(_or,_ir)
    if ADMIN == true then
      _time = 1
      nc = _coord
    end
    msg = MESSAGE:New(string.format("%s, firehawk smoke mark request recieved estimate impact in %d seconds",_playername,_time),30)
    if _col == 1 then
      msg:ToRed()
    else
      msg:ToBlue()
    end
    if keyphrase:lower():find("red") then
      SCHEDULER:New(nil,function() 
        nc:SmokeRed() 
        msg = MESSAGE:New(string.format("%s, firehawk red mark should be on the deck",_playername),30)
        if _col == 1 then
          msg:ToRed()
        else
          msg:ToBlue()
        end
      end,{},_time)
      return           
    elseif keyphrase:lower():find("blue") then
      SCHEDULER:New(nil,function() 
        nc:SmokeRed() 
        msg = MESSAGE:New(string.format("%s, firehawk blue mark should be on the deck",_playername),30)
        if _col == 1 then
          msg:ToRed()
        else
          msg:ToBlue()
        end
      end,{},_time)
      return
    elseif keyphrase:lower():find("green") then
      SCHEDULER:New(nil,function() 
        nc:SmokeGreen() 
        msg = MESSAGE:New(string.format("%s, firehawk greenn mark should be on the deck",_playername),30)
        if _col == 1 then
          msg:ToRed()
        else
          msg:ToBlue()
        end
      end,{},_time)
      return
    elseif keyphrase:lower():find("orange") then
      SCHEDULER:New(nil,function() 
        nc:SmokeOrange()
        msg = MESSAGE:New(string.format("%s, firehawk orange mark should be on the deck",_playername),30)
        if _col == 1 then
          msg:ToRed()
        else
          msg:ToBlue()
        end
      end,{},_time)
      return
    else
      SCHEDULER:New(nil,function() 
        nc:SmokeWhite() 
        msg = MESSAGE:New(string.format("%s, firehawk White mark should be on the deck",_playername),30)
        if _col == 1 then
          msg:ToRed()
        else
          msg:ToBlue()
        end
      end,{},_time)
    end
  else
    local msg = MESSAGE:New(string.format("%s , Firehawk Unable to launch smoke, no friendly units arte within 10km of the target area.",_playername),60)
    if _col == 1 then
      msg:ToRed()
    else
      msg:ToBlue()
    end
  end
end
--- Handles a script input requires Admin to be true + an extra password.
-- enters by 
-- '-runscript;somerandompassword;if JEFFSSUCK == true then socksjeff:Destroy();'
-- really shoulnd't be used.
function hevent:handleScript(text,_playername,_group)
  local keywords = UTILS.Split(text,";")
  local doublecheck = keywords[2]
  local script = keywords[3]
  if (ADMIN == true) and (doublecheck == ADMINPASSWORD2) then
    self:E({"attempting to run script"})
    hm(string.format("%s knew both the magic words Now do they know how to code?",_playername))
    local ran, errorMSG = pcall(function() loadstring(script)  end)
		if not ran then
      MESSAGE:New(string.format("Script Run was not successful errored with %s",errorMSG),30):ToGroup(_group)
      hm(string.format("%s apparently did not know how to code! check the logs for the error msg please"))
      self:E({"handlescript error:",_playername,errorMSG})
    else
      MESSAGE:New("Script Run was successful",30):ToGroup(_group)
      hm(string.format("%s knew both the magic words and how to code it's amazing.",_playername))
    end
  else
      MESSAGE:New(string.format("Uh, uh, uh.. %s didn't say the magic word! Are you being naughty? This is a reserved Server Admin command only",_playername,30)):ToGroup(_group)
      hm(string.format("***Ohhh, some ones being Naughty aren't they %s***, \n `Uh, uh, uh.. you didn't say the magic word` \n https://tenor.com/view/jurassic-park-nedry-dennis-no-no-nah-you-didnt-say-the-magic-word-gif-16617306 \n Hey @Rob Graham#3967 investigate!",_playername))
  end
end

--- Handles our call to do an explosion.
function hevent:handleExplosion(text,coord,_playername,_playergroup)
  local keywords=UTILS.Split(text, ",")
  local yeild = keywords[2]
  yeild = tonumber(yeild)
  if ADMIN == true then
    if yeild == nil then
      yeild = 250
      local msg = string.format("Ok, who let sock near the armory?, %s initated a 250lbs explosive",_playername)
      hm(msg)
      MESSAGE:New(msg,30):toGroup(_playergroup)
    end
    coord:Explosion(yeild)
    hm("Oh shit... I swore there was " .. yeild .. " more of this shit arou.... Ohhh there it is")
  end
end

--- handles tanker cooldown help requests
function hevent:tankerCooldownHelp(tankername,_col)
    local msg = MESSAGE:New(string.format("Tanker routing is now available again for %s. Use the following marker commands:\n-tanker route %s \n-tanker route %s ,h <0-360>,d <5-100>,a <10-30,000>,s <250-400> \nFor more control",tankername,tankername,tankername), 30, MESSAGE.Type.Information)
    if _col == 1 then
      msg:ToRed()
    else 
      msg:ToBlue()
    end
end

--- Handles tanker requests for both red and blue.
-- requires that you enter the group name, works as follows:
-- -tanker route,n=My Tanker Group Name,a=15000,h=120,d=20,s=330 
-- where n = group name
-- a = altitude in ft
-- h = heading in degress
-- d = distance in nm
-- s = speed in TAS.
function hevent:handleTankerRequest(text,coord,_col,_playername,_group)
  local currentTime = os.time()
  if text:find("route") then
    local keywords=UTILS.Split(text, ",")
    local heading = nil
    local distance = nil
    local endcoord = nil
    local endpoint = false
    local altitude = nil
    local altft = nil
    local spknt = nil
    local speed = nil
    local tankergroupname = nil
    local tankergroup
    local tankername = ""
    BASE:E({keywords=keywords})
    for _,keyphrase in pairs(keywords) do
      local str=UTILS.Split(keyphrase, "=")
      local key=str[1]
      local val=str[2]
      if key:lower():find("n") then
        tankergroupname = val
      end
      if key:lower():find("h") then
        heading = tonumber(val)
      end
      if key:lower():find("d") then
        distance = tonumber(val)
      end
      if key:lower():find("a") then
        altitude = tonumber(val)
      end
      if key:lower():find("s") then
        speed = tonumber(val)
      end
    end
    -- if we have no tanker name we break out with a msg.
    if tankergroupname == nil or "" then
      MESSAGE:New("No tanker group was entered, please enter a tanker group to control and try again",30):ToGroup(_group)
      return false
    else
      tankergroup = GROUP:FindByName(tankergroupname)
      if tankergroup == nil then
        MESSAGE:New(string.format("No Group with the name %s was found please check and try again",tankergroupname),30):ToGroup(_group)
        return
      end
    end
    -- check that the unit is actually a tanker.
    local tanker = tankergroup:GetUnit(0)
    if tanker:IsTanker() ~= true then
      MESSAGE:New(string.format("%s is not a valid tanker group and is unable to be redirected",tankergroupname),30):ToGroup(_group)
      return
    end
    -- if the tankers not well ours we don't command it.
    if tankergroup:GetCoalition() ~= _col then
      MESSAGE:New(string.format("Unable to command tanker group %s as they are not of your coalition %s",tankergroupname,_playername),30):ToGroup(_group)
      return
    end
    -- lets work out our cooldowns.
    local cooldown = currentTime - self.TANKERTIMER
    if cooldown < self.TANKER_COOLDOWN then 
      MESSAGE:New(string.format("%s Requests are not available at this time.\nRequests will be available again in %d minutes", (TANKER_COOLDOWN - cooldown) / 60),30, MESSAGE.Type.Information):ToGroup(_group)
      return
    end
    -- is the tanker alive?
    if tankergroup:IsAlive() ~= true then
      MESSAGE:New(string.format("%s is currently not avalible for tasking, it's M.I.A",tankergroupname),30,MESSAGE.Type.Information):ToGroup(_group)
      return
    end
    -- update our tanker time.
    self.TANKERTIMER = currentTime
    -- check our values make them sane or default them to sane values.
    if altitude == nil then
      altft = 19000
      altitude = UTILS.FeetToMeters(19000)
    else
      if altitude > 24000 then
        altitude = 24000
      elseif altitude < 6000 then
        altitude = 6000
      end
      altft = altitude
      altitude = UTILS.FeetToMeters(altft)
    end
    if speed == nil then
      spknt = 370
      speed = UTILS.KnotsToMps(370)
    else
      if speed > 450 then
        speed = 450
      elseif speed < 250 then
        speed = 250
      end
      spknt = speed
      speed = UTILS.KnotsToMps(speed)
    end
    if heading ~= nil then
      if heading < 0 then
        heading = 0
      elseif heading > 360 then
        heading = 360
      end
      if distance ~= nil then
        if distance > 100 then
          distance = 100
        end
        if distance < 5 then
          distance = 5
        end
        endcoord = coord:Translate(UTILS.NMToMeters(distance),heading)
      else
        endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
        distance = 25
      end
    else
      heading = math.random(0,360)
      endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
      distance = 25
    end
    -- actually build our task and push it to the tanker.
    tanker:ClearTasks()
    local routeTask = tanker:TaskOrbit( coord, altitude,  speed, endcoord )
    tanker:SetTask(routeTask, 2)
    local tankerTask = tanker:EnRouteTaskTanker()
    tanker:PushTask(tankerTask, 4)
    -- message to all of blue goes out.
    local msg = MESSAGE:New( string.format("%s Tanker is re-routed to the location requested by %s.\nIt will orbit on a heading of %d for %d nm, Alt: %d Gnd Speed %d.\n%d minutes cooldown starting now", tanker:GetName(),_playername,heading,distance,altft,spknt, TANKER_COOLDOWN / 60),30, MESSAGE.Type.Information )
    if _col == 1 then
      msg:ToRed()
    else
      msg:ToBlue()
    end
    SCHEDULER:New(nil, function() self:tankerCooldownHelp(tankergroupname,_col) end, {}, TANKER_COOLDOWN)
  end
end
-- Handle red tanker requests (we need to merge this with the above at some point.)
function hevent:handleRedTankerRequest(text,coord,_playername,_group)
  MESSAGE:New("Red Coalition Tanker Routing Commands are Currently Not Supported",30,"Info"):ToGroup(_group)
end
 -- runs a mass delete command.
function hevent:massdel(_coord,dist,_coalition,_playername)
  local delcount = 0
  MESSAGE:New(string.format("Mass Delete requested by admin %s at coord %s, all units within %d meters of %s coalition will be deleted",_playername,_coord.ToStringMGRS(),dist,_coalition),30,"Info"):ToAll()
  local gunits = SET_GROUP:New():FilterCategoryGround():FilterActive(true):FilterOnce()
  if _coalition == "blue" or _coalition == "Blue" or _coalition == "BLUE" then
    gunits:FilterCoalitions("blue"):FilterCategoryGround():FilterActive(true):FilterOnce()
  elseif _coalition == "red" then
    gunits:FilterCoalitions("red"):FilterCategoryGround():FilterActive(true):FilterOnce()
  end
  gunits:ForEach(function(g)  
    if g:IsAlive() == true then
      local _group = GROUP:FindByName(g:GetName())
      gc = _group:GetCoordinate()
      if gc == nil then
        BASE:E({"Could not get Coord for group:",g:GetName(),g:GetCoordinate(),gc})
      else
        local d = gc:Get2DDistance(_coord)
        if d < dist then
          g:Destroy()
          delcount = delcount + 1
        end
      end
    else
      BASE:E({"Group is dead",g:GetName()})
    end
  end)
  MESSAGE:New(string.format("Mass Delete requested Completed, we deleted %d Groups",delcount),30,"Info"):ToAll()
end
--- works out the massdel command
-- command entry is '-massdel,d=1000,s=red'
-- if s is blank then it defaults to removing both.
function hevent:deletemassgroup(text,coord,_playername)
  local keywords=UTILS.Split(text,",")
  local dist = 25000
  local col = "both"
  for _,keyphrase in pairs(keywords) do
    local str=UTILS.Split(keyphrase, "=")
    local key=str[1]
    local val=str[2]
    if key:lower():find("d") then
      dist = tonumber(val)
    end
    if key:lower():find("s") then
      col = val
    end
  end
  self:massdel(coord,dist,col,_playername)
end
--- Handle a weather request.
function hevent:handleWeatherRequest(text, coord, _group)
  local currentPressure = coord:GetPressure(0)
  local currentTemperature = coord:GetTemperature()
  local currentWindDirection, currentWindStrengh = coord:GetWind()
  local currentWindDirection1a, currentWindStrength1a = coord:GetWind(UTILS.FeetToMeters(500))
  local currentWindDirection1, currentWindStrength1 = coord:GetWind(UTILS.FeetToMeters(1000))
  local currentWindDirection2, currentWindStrength2 = coord:GetWind(UTILS.FeetToMeters(2000))
  local currentWindDirection5, currentWindStrength5 = coord:GetWind(UTILS.FeetToMeters(5000))
  local currentWindDirection10, currentWindStrength10 = coord:GetWind(UTILS.FeetToMeters(10000))
  local weatherString = string.format("Requested weather: Wind from %d@%.1fkts, QNH %.2f, Temperature %d", currentWindDirection, UTILS.MpsToKnots(currentWindStrengh), currentPressure * 0.0295299830714, currentTemperature)
  local weatherString1 = string.format("Wind 500ft MSL: Wind from%d@%.1fkts",currentWindDirection1, UTILS.MpsToKnots(currentWindStrength1a))
  local weatherString2a = string.format("Wind 1,000ft MSL: Wind from%d@%.1fkts",currentWindDirection2, UTILS.MpsToKnots(currentWindStrength1))
  local weatherString2 = string.format("Wind 2,000ft MSL: Wind from%d@%.1fkts",currentWindDirection2, UTILS.MpsToKnots(currentWindStrength2))
  local weatherString5 = string.format("Wind 5,000ft MSL: Wind from%d@%.1fkts",currentWindDirection5, UTILS.MpsToKnots(currentWindStrength5))
  local weatherString10 = string.format("Wind 10,000ft MSL: Wind from%d@%.1fkts",currentWindDirection10, UTILS.MpsToKnots(currentWindStrength10))
  MESSAGE:New(weatherString, 30, MESSAGE.Type.Information):ToGroup(_group)
  MESSAGE:New(weatherString2a, 30, MESSAGE.Type.Information):ToGroup(_group)
  MESSAGE:New(weatherString1, 30, MESSAGE.Type.Information):ToGroup(_group)
  MESSAGE:New(weatherString2, 30, MESSAGE.Type.Information):ToGroup(_group)
  MESSAGE:New(weatherString5, 30, MESSAGE.Type.Information):ToGroup(_group)
  MESSAGE:New(weatherString10, 30, MESSAGE.Type.Information):ToGroup(_group)
  hm('Weather Requested \n ' .. weatherString .. '\n' .. weatherString1 .. '\n' .. weatherString2 .. '\n' .. weatherString5 .. '\n' .. weatherString10 .. '\n')
end
--- handle an admin attempt.
function hevent:handleeadmin(text,_playername)
  local keywords=UTILS.Split(text, ",")
  local wrongpassword = false
  BASE:E({keywords=keywords})
  for _,keyphrase in pairs(keywords) do
    if keyphrase == _PASSWORD then
      if ADMIN == false then
        ADMIN = true
      else
        ADMIN = false
      end
    else
      ADMIN = false
      wrongpassword = true
    end
  end
  if ADMIN == true then
    MESSAGE:New(string.format("Admin Commands have been enabled by %s",_playername),30):ToAll()
    hm(string.format("Admin Commands have been enabled by %s",_playername))
  else
    if wrongpassword == false then
      MESSAGE:New(string.format("Admin Commands are now disabled by %s",_playername),30):ToAll()
      hm(string.format("Admin Commands have been enabled by %s",_playername))
    else
      MESSAGE:New(string.format("Wrong Password was entered by by %s",_playername),30):ToAll()
      hm(string.format("@Admin Group Wrong Password was entered by by %s",_playername))
    end
  end
end
--- Silent version of the above.
function hevent:rhandleeadmin(text,_group,_playername)
  local keywords=UTILS.Split(text, ",")
  BASE:E({keywords=keywords})
  for _,keyphrase in pairs(keywords) do
    if keyphrase == _PASSWORD then
      if ADMIN == false then
        ADMIN = true
      else
        ADMIN = false
      end
    end
  end
  if ADMIN == true then
    BASE:E({"ADMIN ENABLED"})
     MESSAGE:New(string.format("%s, Admin Commands are Now Enabled",_playername),15):ToGroup(_group)
  else
    BASE:E({"ADMIN DISABLED"})
    MESSAGE:New(string.format("%s, Admin Commands are Now Disabled",_playername),15):ToGroup(_group)
  end
end
--- Handles spawnining in a existing template group from the mission.
function newhandlespawn(text,coord,_group,_playername)
  BASE:E({"Spawn Request",text,coord,_playername})
  local keywords=UTILS.Split(text, ",")
  local unit = nil
  local name = nil
  local heading = nil
  local uheading = nil
  local side = 1
  local ran = false
  local rl = 150
  local ru = 450
  for _,keyphrase in pairs(keywords) do
     local str=UTILS.Split(keyphrase, "=")
      local key=str[1]
      local val=str[2]
    if key:lower():find("u") then
      unit = val
    elseif key:lower():find("n") then
      name = val
    elseif key:lower():find("h") then
      heading = tonumber(val)
     elseif key:lower():find("uh") then
      uheading = tonumber(val)
    elseif key:lower():find("r") then
      if val:lower() == "true" then
        ran = true 
      else
        ran = false
      end
    elseif key:lower():find("l") then
      rl = tonumber(val)
    elseif key:lower():find("m") then
      ru = tonumber(val)
    elseif key:lower():find("s") then
      if val:lower() == "blue" then
        side = 2
      elseif val:lower() == "un" then
        side = 0
      else
        side = 1
      end
    end
  end
  local sp = nil
  if (name ~= nil) and (unit ~= nil) then
    local tempgroup = GROUP:FindByName(unit)
    if tempgroup ~= nil then
      if side == 1 then
        sp = SPAWN:NewWithAlias(unit,"cjtf_red_" .. name):InitCountry(country.id.CJTF_RED)
      else
        sp = SPAWN:NewWithAlias(unit,"cjtf_blue_" .. name):InitCountry(country.id.CJTF_BLUE)
      end
      if ran == true then
        sp:InitRandomizeUnits(true,rl,ru)
      end
      if heading ~= nil then
        BASE:E({"HEADING ACTUALLY WAS NOT NIL WAS",heading})
        sp:InitGroupHeading(heading)
      else
        BASE:E({"HEADING ACTUALLY WAS NIL WAS",heading})
      end
      if uheading ~= nil then
        BASE:E({"UNIT HEADING ACTUALLY WAS NOT NIL WAS",heading})
        sp:InitHeading(heading)
      else
        BASE:E({"UNIT HEADING ACTUALLY WAS NIL WAS",heading})
      end
      BASE:E({"Spawning:",u,side,ran,heading})
      sp = sp:SpawnFromCoordinate(coord)
      table.insert(self.spawnedgroup,sp)
    else
      MESSAGE:New("Unable to spawn requested group, template group does not exist",15):ToAll()
      BASE:E({"Unable to spawn group:",unit})
    end
  else
    BASE:E({"Name was Nil! or unit was nil",unit,name})
    MESSAGE:New("unable to spawn requested group as you left out information",15):ToAll()
  end
end
--- Routes Mass Group.
function hevent:routemassgroup(text,coord,_playername,_group)
  local keywords=UTILS.Split(text,",")
  local dist = 25000
  local col = "Red"
  for _,keyphrase in pairs(keywords) do
    local str=UTILS.Split(keyphrase, "=")
    local key=str[1]
    local val=str[2]
    if key:lower():find("d") then
      dist = tonumber(val)
    end
    if key:lower():find("s") then
      col = val
    end
  end
  self:routegroups(coord,dist,col,_playername)
end
--- handle spawns.
function hevent:handledespawn(text)
  BASE:E({"DeSpawn Request",text})
  local keywords=UTILS.Split(text, ",")
  local unit = nil
  BASE:E({"DESPAWN", keywords=keywords})
  unit = keywords[2]
  local mgroup = nil
  mgroup = GROUP:FindByName(unit)
  if mgroup == nil then
    BASE:E({"Despawn error no group found"})
    MESSAGE:New("Admin Command Error, group not found.")
  else
    if mgroup:IsAlive() == true then
      mgroup:Destroy()
    end
    BASE:E({"Despawning Unit",unit})
    MESSAGE:New("And with a finger snap " .. unit .. " has become dust in the wind",10):ToAll()
  end
end
--- Message to all
function hevent:msgtoall(text)
  BASE:E({"Msg to all",text})
  local keywords=UTILS.Split(text,"|")
  local msg = keywords[2]
  if msg ~= nil then
    MESSAGE:New(msg,15):ToAll()
  end
end