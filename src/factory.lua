--- Rob's factory class.
-- this simulates the 'production' of items based on an existing group of buildings in the game
-- every x amount of time the factory will produce an object, and then attempt to send those objects
-- to warehouses.
-- To use you set up a new factory using
-- RGFactory:New(_factoryname,_production,_productionamount,_productiontime,_send_time,_useostime,_coalition)
-- example
-- Ezzorfactory = RGFactory:New("Ez-Zor Land Cruiser Conversions","lc dshk",2,(60*60*24*4),(60*60*24*4.5),true,1)
-- in the above example we created a factory with the name Ez-Zor Land Cruiser Conversions, 
-- it will produce the template lc dshk
-- it will produce 2 of these templates every production period
-- a production period is 60*60*24*4 seconds or 345600 seconds
-- it will attempt to send to a warehouse every 60*60*24*4.5 seconds or 388800 seconds
-- it will use the OS time to try and do this (so real time not 'heart beat time')
-- and it will send to red coalition (1)
--
-- At this point we are ready to add the actual warehouse items on the map, remember that every warehouse item
-- is equal to part of the factories overall production, so 10 id's on the map = 100/10 health etc.
-- as health is decreased overall production is by the % of the health, so at 100% in the above example 2 groups would be produced.
-- at 50% only 1 group would be produced.
-- at 25% only 1/2 a group.
--
-- to add the warehouses we use: RGFactory:AddParts(_objectid,_description)
-- example:
-- Ezzorfactory:AddParts(197492779,"Hanger")
-- EzzorFactory:AddParts(197492772,"Industrial")
-- EzzorFactory:AddParts(118065130,"Hanger")
-- 
-- Remember you can get your id's by  right clicking in ME and using the assign as option.
--
-- Now we want to add the Moose warehouses that this is linked to using RGFactory:AddWarehouse(_warehouse)
-- example
-- EzzorFactory:AddWarehouse(whouse.ezor)
--
-- now finally we want to start the factory up using
-- RGFactory:Start()
-- example
-- EzzorFactory:Start()
-- 
-- If you need to stop the factory use :Stop() 
-- Saving Data out from a factory for persistance is as easy as using :RequestSaveData() 
-- This will produce a table with the values for the current warehouse.
-- loading the data back in is as easy as creating the warehouse object then using
-- :LoadSaveData(Datatable)
-- Do this BEFORE you start the factory.

--- Core Factory object
RGFactory = {
    ClassName = "Factory",
    FactoryName = "",
    production_time = (60*60*24*4), -- should be 345,600 seconds
    nextproduction_time = 0,
    noosnextproduction_time = 0,
    production_amount = 1,
    send_time =(60*60*24*4), -- should be 345,600 seconds
    nextsendtime = 0,
    noosnextsendtime = 0,
    _handler = nil,
    factoryparts = {},
    production = nil,
    warehouses = {},
    coalition = 1,
    marker = nil,
    _timer = nil,
    markeractive = true,
    currenthealth = 0,
    storedproduction = 0,
    useostime = true,
    heartbeattime = 1,
    coreobject = nil,
    markerupdate_time = (60*60),
    nextmarkertime = 0,
    noosmarkertime = 0,
    initalized = false,
}

---RGFactory New creates a new object.
---@param _factoryname string - the name of this factory
---@param _production string - the template of the group being produced.
---@param _productionamount int - how many get produced each production time.
---@param _productiontime int - the number of seconds it takes to produce the amount above.
---@param _sendtime int -- how often to try and send production to warehouses
---@param _useostime boolean - do we use os time (Real time) or a heartbeatcounter (pauses if game pauses)
---@param _coalition int - dcs coalition 1 = red, 2 = blue, 0 = neutral.
---@return table
function RGFactory:New(_factoryname,_production,_productionamount,_productiontime,_sendtime,_useostime,_coalition)
    local self = BASE:Inherit(self,BASE:New())
    self:E("Initalising Factory Class")
    if _factoryname == nil then
        self:E({"Error in RGFactory, no valid name, factories must have a name!"})
        return false
    end
    self.Factoryname = _factoryname
    self.production = _production
    self.production_amount = _productionamount or 0
    self.production_time = _productiontime or (60*60*24*4)
    self.useostime = _useostime or true
    self.send_time = _sendtime or (60*60*24*4)
    self.coalition = _coalition or 1
    self._timer = TIMER:New(function() self:HeartBeat() end)
    self:E({string.format("New factory made with a name of %s production will be %s base production amount is %d and a base production time of %d minutes",self.Factoryname,self.production,self.production_amount,self.production_time)})
    
    return self
end
---RGFactory:AddParts(_objectid,_description) is how you add parts to the factory, this uses DCS MAP objects ID's.
---@param _objectid int - The DCS MAP object ID
---@param _description any - Can be anything you want.
---@return table
function RGFactory:AddParts(_objectid,_description)
    local temptable = {}
    temptable.objectid = _objectid
    temptable.desc = _description
    temptable.alive = true
    table.insert(self.factoryparts,temptable)
    if self.coreobject == nil then
        local temp = {id_ = _objectid}
        self.coreobject = temp
    end
    return self
end

---comment
---@param _production string DCS Group name
---@param _productionamount int The amount to produce
---@param _productiontime int how many seconds to produce.
---@return table
function RGFactory:SetProduction(_production,_productionamount,_productiontime)
    self.production = _production or self.production
    self.production_amount = _productionamount or self.production_amount
    if self.useostime == true then
        self.production_time = _productiontime or self.production_time
    else
        self.noosnextproduction_time = _productiontime or self.noosnextproduction_time
    end
    return self
end
---comment
---@param _warehouse MooseWarehouseObject
---@return table
function RGFactory:AddWarehouse(_warehouse)
    if _warehouse ~= nil then
        table.insert(self.warehouses,_warehouse)
        return self
    else
        self:E({"Unable to add warehouse link as warehouse was nill."})
        return self
    end
end
---comment
---@param EventData EventData
function RGFactory:OnEventDead(EventData)
    if EventData.IniUnit and EventData.IniObjectCategory==Object.Category.SCENERY then
        -- check the table and see if the objectid matches one in our parts list
        for _key,_value in pairs(self.factoryparts) do
            if _value.objectid == EventData.IniUnitName then
                _value.alive = false
                self:E({string.format("We just lot %s in factory %s",_value.desc,self.FactoryName)})
            end    
        end
    end
end
--- Toggle markers on / off
---@param self table
---@param _val boolean
function RGFactory.enableMarkers(self,_val)
    self.markeractive = _val
end
---Creates Marker
function RGFactory:CreateMarker()
    local mp = Object.getPoint(self.coreobject)
    local tcoord = COORDINATE:NewFromVec3(mp)
    self.marker = MARKER:New(tcoord,"Factory Initalising"):ToCoalition(self.coalition)
    self.marker:ReadOnly()
end
---Updates Marker
---@param _txt string
function RGFactory:UpdateMarkerText(_txt)
    rlog("Marker Update")
    self.marker:Remove()
    local mp = Object.getPoint(self.coreobject)
    local tcoord = COORDINATE:NewFromVec3(mp)
    MARKER:New(tcoord,_txt):ToCoalition(self.coalition)
    rlog({"marked should be updated with ",_txt})
end

---Updates Marker Coordinate.
---@param _coord COORDINATE
function RGFactory:UpdateMarkerPosition(_coord)
    self.marker:UpdateCoordinate(_coord)
end

---Runs factory Check
function RGFactory:CheckFactoryItems()
    self:E("Checking Factory Items")
    local _totalobjects = 0
    local _aliveobjects = 0
    
    for _key,_value in pairs(self.factoryparts) do 
        _totalobjects = _totalobjects + 1
        if _value.alive == true then
            _aliveobjects = _aliveobjects + 1            
        end
    end
    local _ch = _aliveobjects / _totalobjects
    self.currenthealth = _ch
    self:E({"Marker Active is",self.markeractive})
    if self.markeractive == true then
        -- self:E({"Marker is",self.marker})
        local _nextmarker = 0
        local _nextprod = 0
        local _nextsend = 0
        local _currenthealth = (self.currenthealth *100)
        local _nextstock = self.storedproduction + (self.production_amount/self.currenthealth)
        BASE:E({"use os time",self.useostime})
        if self.useostime == true then
            _nextmarker = self.nextmarkertime - NOWTIME
            _nextprod = self.nextproduction_time - NOWTIME
            _nextsend = self.nextsendtime - NOWTIME
            BASE:E({"ostime",self.nextmarkertime,self.nextproduction_time,self.sendtime,_nextmarker,_nextprod,_nextsend})
        else
            _nextmarker = self.nextmarkertime - self.noosmarkertime
            _nextprod = self.nextproduction_time - self.noosnextproduction_time
            _nextsend = self.nextsendtime - self.noosnextsendtime
            BASE:E({"DCStime",self.nextmarkertime,self.nextproduction_time,self.sendtime,_nextmarker,_nextprod,_nextsend})
        end
        local mtxt = string.format(" %s Health is: %d | Producing: %s | Stock Now: %d | Next: %d \n Next Production in: %s | Next Warehouse send in : %s",self.Factoryname,_currenthealth,self.production,self.storedproduction,_nextstock,RGUTILS.getTimefromseconds(_nextprod),RGUTILS.getTimefromseconds(_nextsend))
        self:UpdateMarkerText(mtxt)
    end
end

---Runs Item Production
function RGFactory:ProduceItems()
    self:CheckFactoryItems()
    local _currentproduction = self.production_amount * self.currenthealth
    self.storedproduction = self.storedproduction + _currentproduction
end

---Sends Items to warehouses
function RGFactory:SendProduction()
    local _itemstosend = self.storedproduction
    local whtable = self.warehouses
    local whcount = #whtable
    local possiblesendtoeach = _itemstosend / whcount
    local sent = 0
    if _itemstosend == 0 then
        -- no items to send so return out
        return false
    end
    if possiblesendtoeach < 1 and _itemstosend > 0 then 
        -- we can't send at least 1 to each location so we'll have to step through.
        local _items = _itemstosend
        rlog({"We are sending to each individually"})
        for _,v in pairs(whtable) do
            if _items > 0 then
                if v:GetCoalition() == self.coalition then
                    ADDTOWAREHOUSE(self.production,1,v)
                    sent = sent + 1
                    _items = _items - 1
                end
            end
        end
        rlog({"We sent a total of:",sent,_items})
        self.storedproduction = _items
    else
        -- we can send at least one to reach location we arer going to round down possible and send that to each location
        -- and then work out what we have left and store.
        local _send = math.floor(possiblesendtoeach)
        rlog({"We are sending",_send})
        for _,v in pairs(whtable) do
            if v:GetCoalition() == self.coalition then
                ADDTOWAREHOUSE(self.production,_send,v)
                sent = sent + 1
            end
        end
        local leftproduction  = _itemstosend - sent
        self.storedproduction = leftproduction
    end
end

---DCS Heartbeat
---@return boolean - false means beat failed.
function RGFactory:HeartBeat()
    -- this runs our heartbeat.
    if self.useostime == true and os == nil then
        rlog({"ERROR! We need access to OS to get the time with out it we can't run!"})
        MessageToAll("Warning unable to run Heartbeat for Factories as OS is sanatized and returns nil.",30,"Admin Warning")
        return false
    end
    if self.initalized == true then
        if self.useostime == true then
            -- ok now we need to do  our checks so.. 
            if (NOWTIME > self.nextproduction_time) then
                -- Production time is here.
                self:ProduceItems()
                self.nextproduction_time = NOWTIME + self.production_time
            end
            if NOWTIME > self.nextsendtime then
                self:SendProduction()
                self.nextsendtime = NOWTIME + self.send_time
            end
            if NOWTIME > self.nextmarkertime then
                self:CheckFactoryItems()
                self.nextmarkertime = NOWTIME + self.markerupdate_time                
            end
        else
            -- update our times
            self.noosmarkertime = self.noosmarkertime + 1
            self.noosnextsendtime = self.noosnextsendtime + 1
            self.noosproduction_time = self.noosproduction_time + 1
            -- run our checks.
            if self.noosproduction_time > self.nextproduction_time then
                self:ProduceItems()
                self.noosproduction_time = 0
            end
            if self.noosnextsendtime > self.nextsendtime then
                self:SendProduction()
                self.noosnextsendtime = 0
            end
            if self.noosmarkertime > self.markerupdate_time then
                self:CheckFactoryItems()
                self.noosmarkertime = 0
            end
        end
    else
        self:E("Not init'd")
        self:CreateMarker()
        -- if we aren't init'd we want to set the times for the next set of updates
        if self.useostime == true then
            self.nextproduction_time = NOWTIME + self.production_time
            self.nextsendtime = NOWTIME + self.send_time
            self.nextmarkertime = NOWTIME + self.markerupdate_time
        else
            self.noosproduction_time = 0
            self.noosnextsendtime = 0
            self.noosmarkertime = 0
        end
        self:CheckFactoryItems()
        self.initalized = true
    end
    return true
end

---Requests Save Data for this factory
---@return table - Contains Saved data.
function RGFactory:RequestSaveData()
    local temptable = {
    Factoryname = self.FactoryName,
    production_time = self.production_time,
    nextproduction_time = self.nextproduction_time,
    noosnextproduction_time = self.noosnextproduction_time,
    production_amount = self.production_amount,
    send_time = self.send_time, -- should be 345,600 seconds
    nextsendtime = self.nextsendtime,
    noosnextsendtime = self.noosnextsendtime,
    factoryparts = self.factoryparts,
    production = self.production,
    warehouses = self.warehouses,
    coalition = self.coalition,
    currenthealth = self.currenthealth,
    storedproduction = self.storedproduction,
    useostime = self.useostime,
    heartbeattime = self.heartbeattime,
    coreobject = self.coreobject,
    markerupdate_time = self.markerupdate_time,
    nextmarkertime = self.nextmarkertime,
    noosmarkertime = self.noosmarkertime,
    }
    return temptable
end

---Loads Save Data
---@param loadtable table - Factory Table.
function RGFactory:LoadSaveData(loadtable)
    rlog({"Loading Save Data for Factory:",loadtable.FactoryName})
    self.Factoryname = loadtable.FactoryName
    self.production_time = loadtable.production_time
    self.nextproduction_time = loadtable.nextproduction_time
    self.noosnextproduction_time = loadtable.noosnextproduction_time
    self.production_amount = loadtable.production_amount
    self.send_time = loadtable.send_time
    self.nextsendtime = loadtable.nextsendtime
    self.noosnextsendtime = loadtable.noosnextsendtime
    self.factoryparts = loadtable.factoryparts
    self.production = loadtable.production
    self.warehouses = loadtable.warehouses
    self.coalition = loadtable.coalition
    self.currenthealth = loadtable.currenthealth
    self.storedproduction = loadtable.storedproduction
    self.useostime = loadtable.useostime
    self.heartbeattime = loadtable.heartbeattime
    self.coreobject = loadtable.coreobject
    self.markerupdate_time = loadtable.markerupdate_time
    self.nextmarkertime = loadtable.nextmarkertime
    self.noosmarkertime = loadtable.noosmarkertime
    self:CreateMarker()
    self:CheckFactoryItems()
    self.initalized = true
    rlog({"Factory Load is complete"})
end

---Starts the Factory Timer.
function RGFactory:Start()
    if self._timer == nil then
        self._timer = TIMER:New(function() self:Heartbeat() end)
        self._timer:Start(nil,self.heartbeattime)
    else
        self._timer:Start(nil,self.heartbeattime)
    end
end

---Stops the factory timer.
function RGFactory:Stop()
    self._timer:Stop()
end
