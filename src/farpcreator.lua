  -- TO DO (Rob)
  -- see about moving some of the hard coded stuff out allowing for templates for the farp etc.
    
  --- Farp Creator original code base by [62VAC] Targs, O-O'd and expanded by Rob Graham.
  -- This class aims to allow you to request a convoy to make a farp.
  -- It works by looking for a helicopter group and where that group is landed 
  -- it then will spawn and route a 'convoy' to that location and if the convoy group arrives it will deploy a farp structure.
  -- All values are required to be entered.
  -- Use is rather simple to do you use to instantate the class you need to use the following
  -- 
  -- -- First we need 2 templates a Convoy Template and an actual Farp service template
  -- myservicetemplate = "servicetemplate" -- this is the vehciles that will spawn at the farp
  -- myconvoytemplate = "ConvoyTemplate"   -- this is the actual convoy that will drive to the farp.
  -- 
  -- -- Now we are going to make the actual farp controller we need a few things here, a Name that will show up in the menu,
  -- -- The prefix of the groups that will be able to use the menu/controller
  -- -- the two templates we made above
  -- -- and finally the country that we want the farp to be made from.
  --
  --  myfarpcontrol = FARPCREATOR:New("My Farp Controller","Scouts",myconvoytemplate,myservicetemplate,country.id.USA)
  --  
  -- -- We can now if we want to start the class with mynewfarpchecker:Start()
  -- -- However if we wish we can also set a few 'options' to customise how our farp controller works
  -- -- such as if all the conoys will come from a given coordinate (the easiest means is to use a zone and grab the coord but you could use any MOOSE COORDINATE)
  -- -- if we are using those zones if the class will use the closest zone
  -- -- and finally if we want to add the farps to the zone.
  -- -- To add a zone we create a zone in the ME and then add it's to the farp controller
  -- -- 
  -- -- newzone = ZONE:New("farpconvoystart") -- Our zone
  -- -- newzonecoordinate = newzone:GetCoordinate() -- Our Zone Coord
  -- --
  -- -- Now we tell the controller we want to use start zones
  -- myfarpcontrol:UseStartPoints(true)
  -- -- And then we add the start point to it. 
  -- myfarpcontrol:AddStartPoint(newzonecoordinate)
  -- -- Now we are going to tell it that we want it to comes from the closest point to were we request the farp.
  -- myfarpcontrol:UseClosestPoint(true)
  -- -- and that when the FARP is made to make it a valid new starting point for convoys
  -- myfarpcontrol:AddFarpsToPoints(true)
  -- finally we are going to start our farp
  -- myfarpcontrol:Start()
  --
  -- Some things to note however about the class are that it currently has some values HARD CODED.
  -- These are the 3 convoy limit.
  -- the radio codes for the farp
  -- and some radius checks. 
  -- the actual 'farp' itself is currently all hardcoded in layout in the spawn code
   
  -- creates our base class
  FARPCREATOR = {
    Classname = "Targs FARP Creator",
    name = nil,
    client = {},
    clientmenus = {},
    scheduler = nil,
    schedulerid = nil,
    debug = false,
    OuterRadius = 10000,
    InnerRadius = 500,
    maxconvoys = 3,
    TargetRadius = 50,
    countryid = nil,
    convoytemplate = nil,
    servicetemplate = nil,
    convoyspeed = 50,
    convoys = {},
    farpcounter = 0,
    beattime = 10,
    menuadded = {},
    MenuF10 = {},
    MenuF10Root = nil,
    topmenu = nil,
    startpoints = {},
    usestartpoints = false,
    userandompoint = false,
    useclosestpoint = false,
    addfarps = false,
    radios ={127.5,125.25,129.25}
  }
  
--- Farp Creator original code base by Targs, O-O'd by Robert Graham.
--- This class aims to allow you to request a convoy to make a farp.
--- It works by looking for a helicopter group and where that group is landed 
--- it then will spawn and route a 'convoy' to that location and if the convoy group arrives it will deploy a farp structure.
--- All values are required to be entered.
---@param name string name - The name of this FARPCREATOR instance also used in the Menu name to identify.
---@param prefix string prefix - Client groups containing this will be able to access this functions menu
---@param convoytemplate string convoytemplate - The mission editor template for the FARP convoy
---@param servicetemplate string servicetemplate - The mission editor template for the Service vehicles for the Farp, remember this needs all your service units!
---@param countryid country countryid - the country id that any units or farps spawned by this will be on ie country.id.USA
---@return table|nil
function FARPCREATOR:New(name,prefix,convoytemplate,servicetemplate,countryid)
    local self = BASE:Inherit(self,BASE:New()) -- use moose to do the hard work here.
    -- all this should be fairly self explainitory
    self.name = name
    self.clients = SET_CLIENT:New():FilterPrefixes(prefix):FilterActive(true):FilterStart()
    self.OuterRadius = 10000
    self.InnerRadius = 500
    self.maxconvoys = 3
    self.TargetRadius = 50
    self.countryid = countryid
    self.convoytemplate = convoytemplate
    self.servicetemplate = servicetemplate
    self.FarpHDG = 3.1764992386297
    self.convoys = {}
    self.farpcounter = 0
    self.beattime = 10
    self.menuadded = {}
    self.MenuF10 = {}
    self.MenuF10Root = nil
    self.topmenu = nil
    self.startpoints = {}
    self.usestartpoints = false
    BASE:E({self.name,"Created FARP"})
    return self
end

  --- Allows for the changing of the radius's for this Farp convoy checks
  --- @param inner int - The inner radius of the spawn ie the closest point to the client that a convoy may spawn in meters
  --- @param outer int - The outer radius of the spawn ie the furtherest point to the client that a convoy may spawn in meters
  --- @param targetradius int - How close the convoy has to get the point the player requested it create the farp before it spawns.
  --- @return self
function FARPCREATOR:SetConvoyRadius(inner,outer,targetradius)
    self.InnerRadius = inner
    self.OuterRadius = outer
    self.TargetRadius = targetradius
    return self
end
--- Adds a start point to the table list.
--- @param coord COORDINATE
--- @return self
function FARPCREATOR:AddStartPoint(_coord)
    table.insert(self.startpoints,_coord)
    return self
end
--- Set the convoy speed in km/h
--- @param _speed integer speed in km.
--- @return self
function FARPCREATOR:SetConvoySpeed(_speed)
  self.convoyspeed = _speed 
  return self
end

--- Removes a start point from the table list.
--- @param _cord COORDINATE - the coordinate to remove from the list.
--- @return self.
function FARPCREATOR:RemoveStartPoint(_coord)
    local _Temp = {}
    for k,v in pairs(self.startpoints) do
        if v ~= _coord then
            table.insert(_Temp,v)
        end
    end
    self.startpoints = _Temp
    return self
end
--- do we use the a start point or not. Defaults to true if nothing given.
--- @param _val boolean - True or False on the use.
--- @return self
function FARPCREATOR:UseStartPoints(_val)
    self.usestartpoints = _val or true
    if self.debug == true then
        self:E({"Setusestartpoints to:",self.usestartpoints,_val})
    end
    return self
end

---Use Closest Point True/false
---@param _val boolean true/false
function FARPCREATOR:UseClosestPoint(_val)
    self.useclosestpoint = _val or true
    if self.debug == true then
        self:E({"UseClosestPoint to:",self.useclosestpoint,_val})
    end
end

---Add Farps to Closest Points
---@param _val boolean true/false
function FARPCREATOR:AddFarpsToPoints(_val)
    self.addfarps = _val or true
    if self.debug == true then
        self:E({"Addfarps to:",self.addfarps,_val})
    end
end
--- Creates out menu for client groups
--- @param targetgroup GROUP - Our client target group
--- @param _client CLIENT - Moose CLIENT for the player
function FARPCREATOR:CreateMenu(targetgroup,_client)
  local group = _client:GetGroup()
  local gid = group:GetID()
  if group and gid then
    if not self.menuadded[gid] then
      self.menuadded[gid] = true
      local _rootPath = missionCommands.addSubMenuForGroup(gid,"" .. self.name .. " Farp Control")
      local _spawn = missionCommands.addCommandForGroup(gid,"Farp Convoy Request",_rootPath,self.SpawnConvoy,self,_client)
    end
  end
  --   local menuname = "" .. self.name .. " FARP Convoy Request"
  --  self.client[_client.ObjectName] = MENU_GROUP_COMMAND:New(targetgroup,menuname,topmenu,self.FARPCREATOR,{self,_client}) -- add our menu, to targetgroup, name it spawn farp, add to top menu, call farpcreation, pass _client as the variable.
end

--- F10 Menu Creation
--- Ideally I want to do this so it only runs through this shit once for a client when it first becomes alive.
--- also have it run quicker then the 10 second heart beat
--- we will look into it later for now we just want it to work.
function FARPCREATOR:MenuCreator()
  BASE:E({"self.name","Menu Creator"})
  self.clients:ForEachClient(function(MooseClient)
    if MooseClient:GetGroup() ~= nil then
      local _group = MooseClient:GetGroup()
      self:CreateMenu(_group,MooseClient,self.topmenu)
    end
  end)
end

--- Starts our Heart Beat for the Creator.
--- @return self
function FARPCREATOR:Start()
  BASE:E(self.name,"Farp Heartbeat should be starting with a beat time of ",self.beattime)
  if self.scheduler == nil then
    self.scheduler , self.schedulerid = SCHEDULER:New(nil,function() self:heartbeat() end,{},0,self.beattime)
  else
    self.scheduler:Start()
  end
  return self
end

--- Stops our Heart Beat for the creator
--- @return self
function FARPCREATOR:Stop()
  BASE:E(self.name,"Farp Heartbeat should be stopping")
  if self.scheduler ~= nil then
    self.scheduler:Stop()
  else
    BASE:E({self.name,"Unable to stop as we don't have a scheduler to stop! Are we started?"})  
  end
  return self
end

--- Heart Beat function
--- This function contains our primary 'heart beat' which will run at a default rate of once every 10 seconds unless otherwise set.
function FARPCREATOR:heartbeat()
  -- Logging information
  if self.debug == true then
    self:E({self.name,"Heart Beat"})
  end
  -- Run our menu commands.
  self:MenuCreator()
  -- run our convoy checker
  self:CheckConvoys()
  if self.debug == true then
    self:E({self.name,"Heart Beat Complete"})
  end
end

--- this spawns our convoy based on the client that requests it.
--- @param CLIENT - moose client that is requesting the spawn.
function FARPCREATOR:SpawnConvoy(_client)
  if self.debug == true then
    self:E({self.name,"Spawn Convoy",self.farpcounter,self.maxconvoys,_client})
  end
  -- check if the farp limit has been reached.
  if self.farpcounter < self.maxconvoys then
    local cid = _client.ObjectName -- get our client id
    self:E({self.name,"CID",cid})
    if self.convoys[cid] == nil then
      self:E({self.name,"self.convoy[cid] was nil"})
      self:spawn(_client)
    else
      -- we have a convoy for this client id so we need to check if it's still alive
      local temptable = self.convoys[cid]
      if temptable.FarpServiceConvoy:IsAlive() ~= true then
        self:spawn(_client)
      else
        MESSAGE:New("Unable to request new Convoy, last one is still alive",60):ToClient(_client)
      end
    end
  else
    MESSAGE:New("Unable to request new convoy as maximum FARP count has been reached",60):ToClient(_client)
    BASE:E({self.name,"Spawn Convoy Unable FARP Count Reached",self.farpcounter,self.maxconvoys})
  end
end

function FARPCREATOR:spawn(_client)
  local temptable = {}
  temptable.client = _client -- store our client object for easier use.
  local cid = _client.ObjectName -- get our client id
  local FARPLocationVect = _client:GetPointVec2()
  local FARPCoordinate = _client:GetCoordinate()
  temptable.FARPCoordinate = FARPCoordinate
  temptable.FARPLocationVect = FARPLocationVect
  if self.debug == true then
    BASE:E({"got Vec2",temptable.FARPLocationVect})
  end
  temptable.ConvoyAX = temptable.FARPLocationVect:GetX()
  temptable.ConvoyAY = temptable.FARPLocationVect:GetY()
  if self.debug == true then
    BASE:E({"got x and y",temptable.ConvoyAX,temptable.ConvoyAY})
  end
  temptable.FarpAX = temptable.ConvoyAX
  temptable.FarpAY = temptable.ConvoyAY
  if self.debug == true then
    BASE:E({"attempting to get Farp location"})
  end
  if self.usestartpoints == false then
    if self.debug == true then
      self:E({"Attempting to get based on vector rather then existing point",self.usestartpoints})
    end
    temptable.ConvoySpawn = FARPCoordinate:GetRandomCoordinateInRadius(self.OuterRadius,self.InnerRaidus)
    local breakout = 0
    local validcoord = true
    while temptable.ConvoySpawn:GetSurfaceType() == 3 and breakout < 20 do
      BASE:E({self.name,"Got Coordinate terrain type was",temptable.ConvoySpawn:GetSurfaceType()})
      validcoord = false
      breakout = breakout + 1
      temptable.ConvoySpawn = FARPCoordinate:GetRandomCoordinateInRadius(self.OuterRadius,self.InnerRaidus)
    end
    if validcoord == false then
      MESSAGE:New("We were unable to find a valid spawn coordinate in 50 attempts, Please try your request again",60):ToClient(_client)
      BASE:E({self.name,"No Valid Coordinate terrain type was",temptable.ConvoySpawn:GetSurfaceType()})
      return false
    end
  else
    -- we want to use one of the possible stored convoy start points.
    if self.debug == true then
      self:E({"Attempting to get based on an existing point rather then existing point",self.usestartpoints})
    end
    local ttable = self.startpoints
    if #ttable == 0 then
      self:E({"startpoint 1"})
      MESSAGE:New("We are unable to locate a valid start coordinate for your convoy",60):ToClient(_client)
      self:E({"startpoint 2"})
      return false
    end
    if self.debug == true then
      self:E({"Past line 285"})
    end
    if self.userandompoint then
      if self.debug then
        self:E({"in use random point"})
      end
      local _tc = self.startpoints[ math.random( #ttable ) ]    
      temptable.ConvoySpawn = _tc
      self:E({"end use random point"})
    end
    if self.useclosestpoint then
      if self.debug == true then
        self:E({"Past line 300"})
      end
      local _tc = nil
      local _md = 99999999999999999
      for k,v in pairs(self.startpoints) do
        if self.debug == true then
          self:E({"Past line 308",k,v})
        end
        local _d = FARPCoordinate:Get2DDistance(v)
        self:E({"Past line 312",k,v})
        if _d < _md then
          _tc = v
          _md = _d
        end
      end
      temptable.ConvoySpawn = _tc
    end
  end
  if self.debug == true then
    temptable.ConvoySpawn:SmokeBlue()
    BASE:E({"Got Coordinate terrain type was",temptable.ConvoySpawn:GetSurfaceType()})
    BASE:E({"attempting to spawn"})
  end
  if self.debug == true then
    BASE:E({"Template is:",self.convoytemplate})
  end
  temptable.FarpServiceConvoy = SPAWN:NewWithAlias(self.convoytemplate,"" ..self.name .. "_convoy_" .. cid ..""):SpawnFromCoordinate(temptable.ConvoySpawn)
  if self.debug == true then
    BASE:E({"Spawned."})
  end
  temptable.FarpServiceConvoy:SetAIOn()
  temptable.FarpServiceConvoy:RouteGroundOnRoad(temptable.FARPCoordinate,self.convoyspeed,1,"OnRoad")
  self.convoys[cid] = temptable -- put temp table into convoys under the client ID for references.
  MESSAGE:New("New FARP Convoy is enroute to your location",60):ToClient(_client)
end

--- this checks our convoys to see if they are there or not.
function FARPCREATOR:CheckConvoys()
  if self.debug == true then
    BASE:E({self.name,"Check Convoys"})
  end
  for k,v in pairs(self.convoys) do
    if v ~= nil then
      BASE:E({self.name,"Check Convoy",k,v})
      local temptable = v
      if  temptable.FarpServiceConvoy:IsAlive() then
        -- do our check for the convoy position here.
        local ServiceConvoyVec2 = temptable.FarpServiceConvoy:GetPointVec2();
        local Convoyhasarrived = ServiceConvoyVec2:IsInRadius(temptable.FARPLocationVect, self.TargetRadius)
        if Convoyhasarrived == true then
          -- we need to spawn the FARP and then delete THIS convoy.
          MESSAGE:New("Your FARP Convoy has arrived at it's destination and is now setting up",30):ToClient(temptable.client)
          self:SpawnFarp(temptable,k)
          temptable.FarpServiceConvoy:Destroy()
          self.convoys[k] = nil
        else
          return true -- it's not arrived so we don't care right now.
        end
      else
        temptable.FarpServiceConvoy:Destroy()  -- make certain we remove the items just incase.
        MESSAGE:New("Your FARP Convoy was destroyed prior to reaching its destination, Protect it better next time",60):ToClient(temptable.client)
        self.convoys[k] = nil
      end
    else
      BASE:E({self.name,"Check Convoy Warning, V was Nil! this shouldn't happen"})
    end
  end
end
  
--- this spawns in the actual farp items.
---@param temptable table our temporary table
---@param cid country.id
function FARPCREATOR:SpawnFarp(temptable,cid)
  -- increase our counter we also
  if self.debug == true then
    self:E({self.name,"Spawning Farp",self.farpcounter,temptable,cid})
  end
  self.farpcounter = self.farpcounter + 1
  MESSAGE:New("A FARP Convoy has arrived at it's destination and is setting up a new FARP",30):ToBlue()
  local vehiclevect = temptable.FARPCoordinate:Translate(40,0)
  local SpawnServiceVehicles = SPAWN:NewWithAlias(self.servicetemplate,"FarpServiceVechiles" .. self.farpcounter):SpawnFromCoordinate(vehiclevect)    
  self:SpawnStatic("Farp1_ComandPost_" .. self.farpcounter .. "","kp_ug","Fortifications","FARP CP Blindage",100,(temptable.FarpAX - -46.022111867),(temptable.FarpAY - -9.20689690),(self.FarpHDG - 1.6057029118348))
  self:SpawnStatic("Farp1_Generator1_" .. self.farpcounter .. "","GeneratorF","Fortifications","GeneratorF",100,(temptable.FarpAX - -7.522753786),(temptable.FarpAY - -37.85968299),(self.FarpHDG -1.5358897417550))
  self:SpawnStatic("Farp1_Tent1_" .. self.farpcounter .. "","PalatkaB","Fortifications","FARP Tent",50,(temptable.FarpAX - -42.785309231),(temptable.FarpAY - -9.12264485),(self.FarpHDG - 1.6057029118348))  
  self:SpawnStatic("Farp1_CoveredAmmo1_" .. self.farpcounter .. "","SetkaKP","Fortifications","FARP Ammo Dump Coating",50,(temptable.FarpAX - 35.293756408),(temptable.FarpAY - 57.35770154),(self.FarpHDG - 3.1590459461098))
  self:SpawnStatic("Farp1_Tent2_" .. self.farpcounter .. "","PalatkaB","Fortifications","FARP Tent",50,(temptable.FarpAX - -49.432834216),(temptable.FarpAY - -9.14503574),(self.FarpHDG - 1.6057029118348))
  self:SpawnStatic("Farp1_Wsock1_" .. self.farpcounter .. "","H-Windsock_RW","Fortifications","Windsock",3,(temptable.FarpAX - 43.70051151),(temptable.FarpAY -  2.35458818),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre1_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - -9.52339492),(temptable.FarpAY - 41.91442888),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre2_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 26.51502196),(temptable.FarpAY - 13.74232991),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre3_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 26.27681096),(temptable.FarpAY - -22.30693542),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre4_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 44.69212731),(temptable.FarpAY - 27.50978001),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre5_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - -9.37543603),(temptable.FarpAY - -7.37904581),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre6_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 26.19740729),(temptable.FarpAY - 27.55856816),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre7_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 8.41098563),(temptable.FarpAY - -7.37904581),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre8_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 8.07919727),(temptable.FarpAY - 41.59167618),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre9_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - -9.37543603),(temptable.FarpAY - 27.71737550),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre10_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - -9.21662870),(temptable.FarpAY - 7.15182545),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre11_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 44.77786563),(temptable.FarpAY - -8.33188983),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre12_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 9.87567332),(temptable.FarpAY - 17.86661589),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre13_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 26.19740729),(temptable.FarpAY - -8.17308250),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre14_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 8.31389554),(temptable.FarpAY - 7.09103057),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre15_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 8.41098563),(temptable.FarpAY - 27.63797183),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre16_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 44.61905829),(temptable.FarpAY - 13.74232991),(self.FarpHDG ))
  self:SpawnStatic("Farp1_Tyre17_" .. self.farpcounter .. "","H-tyre_B_WF","Fortifications","Black_Tyre_WF",3,(temptable.FarpAX - 43.93118389),(temptable.FarpAY - -22.67033198),(self.FarpHDG )) 
  self:SpawnFarpBuilding("Farp_Heliport_" ..self.farpcounter .. "","invisiblefarp","Heliports","Invisible FARP",self.radios[self.farpcounter],0,self.farpcounter,(temptable.FarpAX - 0.00000000),(temptable.FarpAY - 0.00000000),(self.FarpHDG))
  if self.addfarps == true then
    self:AddStartPoint(temptable.FARPCoordinate)
  end
  self:E({self.name,"Spawned Farp",self.farpcounter})
end

---Spawn a Static FARP
---@param _name string the name
---@param _shape string_dcsshape the static type as per the object
---@param _cat string_Category
---@param _type string_DCS_TYPE
---@param _radio float
---@param _modulation int
---@param _callsign enum
---@param _x float
---@param _y float
---@param _heading float
function FARPCREATOR:SpawnFarpBuilding(_name,_shape,_cat,_type,_radio,_modulation,_callsign,_x,_y,_heading)
  local staticObj = {
    ["name"] = _name , --unit name (Name this something identifying some you can find it later)
    ["category"] = _cat,
    ["shape_name"] = _shape,
    ["type"] = _type,
    ["heliport_frequency"] = _radio,
    ["x"] = _x,
    ["y"] = _y,
    ["heliport_modulation"] = _modulation,
    ["heliport_callsign_id"] = _callsign,
    ["heading"] = _heading,
    -- These can be left as is, but is required
    ["groupId"] = 1,          --id's of the group/unit we're spawning  (will auto increment if id is taken?)
    ["unitId"] = 1,
    ["dead"] = false,
  }
  coalition.addStaticObject(self.countryid, staticObj)
end

---spawns all our statics.
---@param _name string
---@param _shape string_dcs_shape
---@param _cat string_category
---@param _type string_type
---@param _rate int
---@param _x float
---@param _y float
---@param _heading float
function FARPCREATOR:SpawnStatic(_name,_shape,_cat,_type,_rate,_x,_y,_heading)
  local staticObj = {
    ["name"] = _name , --unit name (Name this something identifying some you can find it later)
    ["category"] = _cat,
    ["shape_name"] = _shape,
    ["type"] = _type,
    ["rate"] = _rate,
    ["x"] = _x,
    ["y"] = _y,
    ["heading"] = _heading,
    ["groupId"] = 1,          --id's of the group/unit we're spawning  (will auto increment if id is taken?)
    ["unitId"] = 1,
    ["dead"] = false,
  }
  coalition.addStaticObject(self.countryid, staticObj)
end