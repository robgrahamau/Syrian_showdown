local template = {
    type = "",
    spawnchance = 100,
    spawntable = {},
  }
  
  aomanager = {
    classname = "Area of Operations Manager",
    name = nil,
    aozone = nil,
    active = false,
    players = {},
    grouptemplates = {},
    statictemplate = {},
    striketargets = {},
    -- These are our strike targets (Map objects)
    minstrike = 0,
    maxstrike = 0,
    spawnedstrike = 0,
    alivestrike = 0,
    
    -- Spawnable sam sites
    minsams = 0,
    maxsams = 0,
    spawnedsams = 0,
    alivesams = 0,
    samgroups = {},
    -- Spawnable Armor  
    minarmor = 0,
    maxarmor = 0,
    spawnedarmor = 0,
    alivearmor = 0,
    armourgroups = {},
    -- Spawnable Infantry
    mininf = 0,
    maxinf = 0,
    spawnedinf = 0,
    aliveinf = 0,
    infantrygroups = {},
    -- Other groups (HVT)
    minhvt = 0,
    maxhvt = 0,
    spawnedhvt = 0,
    alivehvt = 0,
    hvtgroups = {},
    -- static items
    minstatics = 0,
    maxstatics = 0,
    spawnedstatics = 0,
    alivestatics = 0,
    staticsgroups = {},
  }
  
  --- Create a new instance of the manger.
  -- @param name #string - The name of the manager
  -- @param zone #zone - a Moose Zone that contains the AO.
  function aomanager:New(_name,_zone)
    local self = BASE:Inherit(self,BASE:New())
    self.name = _name
    self.aozone = _zone
    
    return self
  end
  --- adds a template table to the group template.
  -- templates need to be in the following format
  --  template = {
  --  --  type = "",
  --  spawnchance = 100,
  --  spawntable = {},
  --}
  -- Where type can be 
  -- • Sam
  -- • Armor
  -- • hvt
  -- • Infantry
  -- Spawn Chance is the chance of it spawning as part of the random groups.
  -- spawntable is the table for the groups.
  -- returns self.  
  function aomanager:AddGroupTemplate(_table)
    table.insert(self.grouptemplates,_table)
    return self
  end
  --- Adds a static template table to the statics table.
  -- To DO: Format
  function aomanager:AddStaticTempalte(_table)
    table.insert(self.statictemplate,_table)
    return self
  end
  
  --- Adds the Unique ID of a strike target to the table.
  -- This needs to be the ID of the map item.
  -- the table format for this is 
  -- striketarget = { name = "Target Name", type = "Target Type", ID = SceneryID }
  function aomanger:AddStrikeTargets(_table)
    table.insert(self.striketargets,_table)
    return self
  end
  
  function aomanager:SetStrike(_min,_max)
    self.minstrike = _min
    self.maxstrike = _max
    return self
  end
  
  function aomanager:SetSam(_min,_max)
    self.minsams = _min
    self.maxsams = _max
  end
  
  function aomanager:SetArmor(_min,_max)
    self.minarmor = _min
    self.maxarmor = _max
  end
  
  function aomanager:SetInf(_min,_max)
    self.mininf = _min
    self.maxinf = _max
  end
  
  function aomanager:SetHVT(_min,_max)
    self.minhvt = _min
    self.maxhvt = _max
  end
  
  function aomanager:Activate()
    if self.active == false then
      -- we want to activate the AO so we need to work out how many of each unit type we need to activate.
      local strike = math.random(self.minstrike,self.maxstrike)
      local sam = math.random(self.minsams,self.maxsams)
      local armor = math.random(self.minarmor,selfmaxarmor)
      local inf = math.random(self.mininf,self.maxinf)
      local hvt = math.random(self.hvt,self.maxhvt)
      
      -- now we want to start spawning each of these in
      for i=1, strike do 
        
      end
    else
    
    
    end
  
  end
  function multitablespawn(tbl, _country)
      for i = 1, #tbl do
          if tbl[i].helicopter ~= nil then
              if tbl[i].helicopter.group ~= nil then
                  DEBUGMESSAGE(
                      "Tablespawn Group[" .. i .. "].helicopter is not nil and is size:" .. #tbl[i].helicopter.group
                  )
                  tablespawn(tbl[i].helicopter.group, _country, Group.Category.HELICOPTER)
              end
          end
          if tbl[i].vehicle ~= nil then
              if tbl[i].vehicle.group ~= nil then
                  DEBUGMESSAGE("Tablespawn Group[" .. i .. "].vehicle is not nil and is size:" .. #tbl[i].vehicle.group)
  
                  local istrain = false
  
                  if tbl[i].vehicle.group[1].units ~= nil then
                      if #tbl[i].vehicle.group[1].units > 0 then
                          if tbl[i].vehicle.group[1].units[1].type == "Train" then
                              DEBUGMESSAGE("OK!!! " .. tbl[i].vehicle.group[1].units[1].type)
                              istrain = true
                          end
                      end
                  end
  
                  if istrain then
                      tablespawn(tbl[i].vehicle.group, _country, Group.Category.TRAIN)
                  else
                      tablespawn(tbl[i].vehicle.group, _country, Group.Category.GROUND)
                  end
              end
          end
          if tbl[i].plane ~= nil then
              if tbl[i].vehicle.plane ~= nil then
                  DEBUGMESSAGE:New("Tablespawn Group[" .. i .. "].plane is not nil and is size:" .. #tbl[i].plane.group)
                  tablespawn(tbl[i].plane.group, _country, Group.Category.AIRPLANE)
              end
          end
          if tbl[i].ship ~= nil then
              if tbl[i].ship.group ~= nil then
                  DEBUGMESSAGE("Tablespawn Group[" .. i .. "].ship is not nil and is size:" .. #tbl[i].ship.group)
                  tablespawn(tbl[i].ship.group, _country, Group.Category.SHIP)
              end
          end
      end
  end
  