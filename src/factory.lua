--- Rob's factory class.
-- this simulates the 'production' of items based on an existing group of buildings in the game
-- every x amount of time the factory will produce an object, and then attempt to send those objects
-- to warehouses.
RGFactory = {
    ClassName = "Factory",
    FactoryName = "",
    production_time = (60*24) * 4,
    nextproduction_time = 0,
    production_amount = 1,
    attempttosend_time = (60*24) * 4,
    nextsendtime = 0,
    _handler = nil,
    factoryparts = {},
    production = nil,
    warehouses = {},
    coalition = {},
    marker = nil,
    scheduler = nil,
    markeractive = false,
    currenthealth = 0,
    storedproduction = 0,
}

function RGFactory:New(_factoryname,_production,_productionamount,_productiontime)
    local self = BASE:Inherit(self,BASE:New())
    self:E("Initalising Factory Class")
    if _factoryname == nil then
        self:E({"Error in RGFactory, no valid name, factories must have a name!"})
        return false
    end
    self.Factoryname = _factoryname
    self.production = _production
    self.production_amount = _productionamount or 0
    self.production_time = _productiontime or (60*24*4)
    self:E({string.format("New factory made with a name of %s production will be %s base production amount is %n and a base production time of %n minutes",self.Factoryname,self.production,self.production_amount,self.production_time)})
    return self
end

function RGFactory:AddParts(_objectid,_description)
    local temptable = {}
    temptable.objectid = _objectid
    temptable.desc = _description
    temptable.alive = true
    table.insert(self.factoryparts,temptable)
    return self
end

function RGFactory:SetProduction(_production,_productionamount,_productiontime)
    self.production = _production or self.production
    self.production_amount = _productionamount or self.production_amount
    self.production_time = _productiontime or self.production_time
    return self
end

function RGFactory:AddWarehouse(_warehouse)
    if _warehouse ~= nil then
        table.insert(self.warehouses,_warehouse)
        return self
    else
        self:E({"Unable to add warehouse link as warehouse was null."})
        return self
    end
end

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

function RGFactory:CheckFactoryItems()
    local _totalobjects = 0
    local _aliveobjects = 0
    for _key,_value in pairs(self.factoryparts) do 
        _totalobjects = _totalobjects + 1
        if _value.alive == true then
            local _aliveobjects = _aliveobjects + 1            
        end
    end
    local _ch = _aliveobjects / _totalobjects
    self.currenthealth = _ch
end

function RGFactory:ProduceItems()
    self:CheckFactoryItems()
    local _currentproduction = self.production_amount * self.currenthealth
    self.storedproduction = self.storedproduction + _currentproduction
end

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