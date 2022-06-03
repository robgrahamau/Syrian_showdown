whouse = {}
whcoord = {}


whouse.ezor = WAREHOUSE:New(STATIC:FindByName("ezZor"), "Deir ez-Sor")
whouse.ezor:SetAutoDefenceOn()
whcoord["ezor"] = {}
whcoord["ezor"].coord = COORDINATE:New()
whcoord["ezor"].zone = ZONE:New("ezzor_packup")
whouse.tanf = WAREHOUSE:New(STATIC:FindByName("tanf"), "Tanf")
whouse.tanf:SetAutoDefenceOn()
whcoord["tanf"] = {}
whcoord["tanf"].coord = COORDINATE:New()
whcoord["tanf"].zone = ZONE:New("tanf_packup")
whouse.palmyra = WAREHOUSE:New(STATIC:FindByName("palmyra"),"Palmyra")
whouse.palmyra:SetAutoDefenceOn()
whcoord["palmyra"] = {}
whcoord["palmyra"].coord = COORDINATE:New()
whcoord["palmyra"].zone = ZONE:New("palmyra_packup")
whouse.h3 = WAREHOUSE:New(STATIC:FindByName("h3"),"H3")
whouse.h3:SetAutoDefenceOn()
whcoord["h3"] = {}
whcoord["h3"].coord = COORDINATE:New()
whcoord["h3"].zone = ZONE:New("h3_packup")


whouse.ezor:Start()
whouse.tanf:Start()
whouse.palmyra:Start()
whouse.h3:Start()

---Return warehouse information
---@param _warehouse string warehouse name
---@return unknown
---@return string
function GETWAREHOUSE(_warehouse)
    local _wh = nil
    local _loc = nil
    if _warehouse == "ezor" or _warehouse == "deir ez-zor" or _warehouse == "ez-zor" or _warehouse == "ezzor" or _warehouse == "deir ezzor" then
        _wh = whouse.ezor
        _loc = "ezor"
    elseif _warehouse == "tanf" or _warehouse == "at tanf" or _warehouse == "al tanf" then
        _wh = whouse.tanf
        _loc = "tanf"
    elseif _warehouse == "palmyra" then
        _wh = whouse.palmyra
        _loc = "palmyra"
    elseif _warehouse == "h3" then
        _wh = whouse.h3
        _loc = "h3"
    end
    rlog({_wh,_loc})
    return _wh, _loc
end

---Add items to a warehouse
---@param _asset string DCS GROUP NAME
---@param _amount int
---@param _warehouse WAREHOUSE
---@param _attribute WAREHOUSE.ATTRIBUTE
---@param _cargohold int cargo hold size in kg
---@param _weight int unit weight overright
---@param _loadradius int loadradius of the unit
---@param _skill AI.Skill ai skill
---@param _liveries table 
---@param _assignment string
function ADDTOWAREHOUSE(_asset,_amount,_warehouse,_attribute,_cargohold,_weight,_load,_skill,_liveries,_assignment)
    _attribute = _attribute or nil
    _cargohold = _cargohold or nil
    _weight = _weight or nil
    _load = _load or nil
    _skill = _skill or nil
    _liveries = _liveries or nil
    _assignment = _assignment or nil

    _warehouse:AddAsset(_asset,_amount,_attribute,_cargohold,_weight,_load,_skill,_liveries,_assignment)
end

---OnAfterSelfRequest
---@param From any
---@param Event Event
---@param To any
---@param groupset SET_GROUP
---@param request string
function whouse.ezor:OnAfterSelfRequest(From,Event,To,groupset,request)
    -- lets grab our request
    local assignmnet = whouse.ezor:GetAssignment(request)
    local stimer = 1
    if assignmnet == "To Coordinate" then
        for _,_group in pairs(groupset:GetSet()) do
            
            SCHEDULER:New(nil,function() 
            local _ToCoord = whcoord["ezor"].coord

            _group:RouteGroundOnRoad(_ToCoord:GetRandomCoordinateInRadius((200+(stimer/4)), (stimer/4)), _group:GetSpeedMax()*0.8)
            end,{},stimer)
            stimer = stimer + 20
        end
    end    
end

---OnAfterSelfRequest
---@param From any
---@param Event Event
---@param To any
---@param groupset SET_GROUP
---@param request string
function whouse.palmyra:OnAfterSelfRequest(From,Event,To,groupset,request)
    -- lets grab our request
    local assignmnet = whouse.palmyra:GetAssignment(request)
    if assignmnet == "To Coordinate" then
        for _,_group in pairs(groupset:GetSet()) do
            local _ToCoord = whcoord["palmyra"].coord
            _group:RouteGroundOnRoad(_ToCoord, _group:GetSpeedMax()*0.8)
        end
    end    
end

---OnAfterSelfRequest
---@param From any
---@param Event Event
---@param To any
---@param groupset SET_GROUP
---@param request string
function whouse.tanf:OnAfterSelfRequest(From,Event,To,groupset,request)
    -- lets grab our request
    local assignmnet = whouse.tanf:GetAssignment(request)
    if assignmnet == "To Coordinate" then
        for _,_group in pairs(groupset:GetSet()) do
            local _ToCoord = whcoord["tanf"].coord
            _group:RouteGroundOnRoad(_ToCoord, _group:GetSpeedMax()*0.8)
        end
    end    
end

---Sends a warehouse request to the system
---@param _asset WAREHOUSE.Attribute
---@param _specifictype string DCS GROUP NAME
---@param _amount int
---@param _warehouse WAREHOUSE
---@param _loc string WAREHOUSE name for loc for storing the _coordinate.
---@param _coordinate COORDINATE move to coord.
function MAPDEPLOYMENT(_asset,_specifictype,_amount,_warehouse,_loc,_coordinate)
    local _asset = _asset or nil
    local _specifictype = _specifictype or nil
    rlog({"MAPDEPLOYMENT",_asset,_specifictype,_amount,_warehouse,_loc})
    whcoord[_loc].coord = _coordinate
    if _specifictype == nil then 
        _warehouse:AddRequest(_warehouse,WAREHOUSE.Descriptor.ATTRIBUTE,_asset,_amount,nil,nil,nil,"To Coordinate")
    else
        _warehouse:AddRequest(_warehouse,WAREHOUSE.Descriptor.GROUPNAME,_specifictype,_amount,nil,nil,nil,"To Coordinate")
    end
end

---Transfers from one warehouse to another
---@param _asset WAREHOUSE.Attribute
---@param _specifictype string DCS GROUP NAME
---@param _amount int
---@param _warehouse WAREHOUSE
---@param _destination WAREHOUSE
---@param _transporttype WAREHOUSE.TransportType
---@param _transportamount int
function MAPTRANSFER(_asset,_specifictype,_amount,_warehouse,_destination,_transporttype,_transportamount)
    local _asset = _asset or nil
    local _specifictype = _specifictype or nil
    local _transporttype = _transporttype or WAREHOUSE.TransportType.SELFPROPELLED
    local _transportamount = _transportamount or nil
    rlog({"Map Transfer",_asset,_specifictype,_amount,_warehouse,_destination,_transporttype,_transportamount})
    if _specifictype == nil then
        _warehouse:AddRequest(_destination,WAREHOUSE.Descriptor.ATTRIBUTE,_asset,_amount,_transporttype,_transportamount,nil,"Transfer")
    else
        _warehouse:AddRequest(_destination,WAREHOUSE.Descriptor.GROUPNAME,_specifictype,_amount,_transporttype,_transportamount,nil,"Transfer")
    end

end
---comment
---@param _group GROUP
---@param _warehouse string warehouse name
---@param _unittype string DCS GROUP Name
---@param _specifictype WAREHOUSE.Attribute
---@param _col int 0 = neutral, 1 = red, 2 = blue
function WAREHOUSEAMOUNTS(_group,_warehouse,_unittype,_specifictype,_col)
    local _wh = nil
    local _loc = nil
    local _unittype = _unittype or nil
    local _specifictype = _specifictype or nil
    _wh, _loc = GETWAREHOUSE(_warehouse)

    if _wh:GetCoalition() == _col then
        if _specifictype ~= nil then
        local stock = _wh:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME,_specifictype)
        RGUTILS.msg(string.format("Current Stock Levels for %n at warehouse %n are %d",_specifictype,_warehouse,stock),_group,30)
        rlog({"Warehouseamounts:",stock})
        else
        local stock = _wh:GetNumberOfAssets(WAREHOUSE.Descriptor.ATTRIBUTE,_unittype)
        RGUTILS.msg(string.format("Current Stock Levels for %n at warehouse %n are %d",_unittype,_warehouse,stock),_group,30)
        rlog({"Warehouseamounts:",stock})
        end
    end
end

---Main Handler for warehouse movement
---@param _group GROUP
---@param _warehouse string Warehouse name
---@param _unittype dcs group type
---@param _specifictype WAREHOUSE.Attribute
---@param _amount int
---@param _requesttype string currently only takes route
---@param _coordinate COORDINATE
---@param _col int 0 = neutral, 1 = red, 2 = blue
---@return boolean
function WAREHOUSEHANDLER(_group,_warehouse,_unittype,_specifictype,_amount,_requesttype,_coordinate,_col)
    rlog({"WAREHOUSEHANDLER:",_group,_warehouse,_unittype,_specifictype,_amount,_requesttype,_towarehouse,_col})
    local checker = RGUTILS.groupchecker()
    if _col == 1 then
        local afterspawncount = checker.redunits + (_amount * 4)
        if checker.redunits > REDUNITLIMIT or afterspawncount > REDUNITLIMIT then
            MessageToRed(string.format("Unable to process requests for new units at this time. The RedFor unit cap is %d and you currently have %d units active on the map if we fullfilled this request you would have %d units active",REDUNITLIMIT,checker.redunits,afterspawncount),30,"Server Info")
            return false
        else
            MessageToRed(string.format("Request for units has been processed, Redfor Limit is: %d Current Count is: %d after deployment: %d ",REDUNITLIMIT,checker.redunits,afterspawncount),30,"Server Info")
        end
    else
        local afterspawncount = checker.blueunits + (_amount * 4)
        if checker.blueunits > BLUEUNITLIMIT or afterspawncount > BLUEUNITLIMIT then
            MessageToBlue(string.format("Unable to process requests for new units at this time. The BlueFor unit cap is %d and you currently have %d units active on the map if we fullfilled this request you would have %d units active",BLUEUNITLIMIT,checker.blueunits,afterspawncount),30,"Server Info")
            return false
        else
            MessageToBlue(string.format("Request for units has been processed, Bluefor Limit is: %d Current Count is: %d after deployment: %d ",BLUEUNITLIMIT,checker.blueunits,afterspawncount),30,"Server Info")
        end
    end
    
    if _requesttype == "route" then 
        local _wh = nil
        local _loc = nil
        _wh, _loc = GETWAREHOUSE(_warehouse)
        if _wh == nil or _loc == nil then
            rlog({"ERROR IN WAREHOUSEHANDLER, Route _wh,_loc",_wh,_loc})
        end
        MAPDEPLOYMENT(_unittype,_specifictype,_amount,_wh,_loc,_coordinate)
    end
    return true
end

---Handles the marker side of the transfer
---@param _group GROUP
---@param _warehouse string
---@param _unittype string dcs group name
---@param _specifictype WAREHOUSE.Attribute
---@param _amount int
---@param _towarehouse string
---@param _transporttype WAREHOUSE.TransportType
---@param _transportamount int 
---@param _col int 0 = neutral, 1 = red, 2 = blue
---@return boolean
function WAREHOUSETRANSFER(_group,_warehouse,_unittype,_specifictype,_amount,_towarehouse,_transporttype,_transportamount,_col)
    rlog({"WAREHOUSEHANDLER:",_group,_warehouse,_unittype,_specifictype,_amount,_requesttype,_towarehouse,_col})
    local checker = RGUTILS.groupchecker()
    if _col == 1 then
        local afterspawncount = checker.redunits + (_amount * 4)
        if checker.redunits > REDUNITLIMIT or afterspawncount > REDUNITLIMIT then
            MessageToRed(string.format("Unable to process requests for new units at this time. The RedFor unit cap is %d and you currently have %d units active on the map if we fullfilled this request you would have %d units active",REDUNITLIMIT,checker.redunits,afterspawncount),30,"Server Info")
            return false
        else
            MessageToRed(string.format("Request for units has been processed, Redfor Limit is: %d Current Count is: %d after deployment: %d ",REDUNITLIMIT,checker.redunits,afterspawncount),30,"Server Info")
        end
    else
        local afterspawncount = checker.blueunits + (_amount * 4)
        if checker.blueunits > BLUEUNITLIMIT or afterspawncount > BLUEUNITLIMIT then
            MessageToBlue(string.format("Unable to process requests for new units at this time. The BlueFor unit cap is %d and you currently have %d units active on the map if we fullfilled this request you would have %d units active",BLUEUNITLIMIT,checker.blueunits,afterspawncount),30,"Server Info")
            return false
        else
            MessageToBlue(string.format("Request for units has been processed, Bluefor Limit is: %d Current Count is: %d after deployment: %d ",BLUEUNITLIMIT,checker.blueunits,afterspawncount),30,"Server Info")
        end
    end

    local _wh = nil
    local _dest = nil
    local _loc = nil
    _wh, _loc = GETWAREHOUSE(_warehouse)
    _dest, _loc = GETWAREHOUSE(_towarehouse)

    MAPTRANSFER(_unittype,_specifictype,_amount,_wh,_dest,_transporttype,_transportamount)
    return true
end

---Packup objects if they are in the right zone.
---@param _group GROUP
---@param _warehouse string warehouse name
---@param _col int 0 = neutral, 1 = red, 2 = blue
function WAREHOUSEPACKUP(_group,_warehouse,_col)
    -- ook so we basically want to go through any in the warehouse zone and pack them up
    -- so we need to check the coalition and the like make certain it can and yeah
    -- first lets check that the coalition sending the command owns the warehouse.
    local _wh,_loc = GETWAREHOUSE(_warehouse)
    if _wh:GetCoalition() == _col then
        local _zone = whcoord[_loc].zone
        if _col == 1 then
            MessageToRed(string.format("Now scanning %s warehouse zone for active units, any found will be stored this may take up to 1 minute",_warehouse),30)
            ACTIVEREDGROUPS:ForeEachGroupAnyInZone(_zone,function(_group)  
                if _group:AllOnGround() == true then
                    _wh:__AddAsset(10,_group)
                    SCHEDULER:New(nil,function() 
                        MessageToRed(string.format("Group %s has been stored in warehouse %s",_group.GroupName,_warehouse))
                        _group:Destroy()
                    end,{},15)
                end
            end)
        else
            MessageToBlue(string.format("Now scanning %s warehouse zone for active units, any found will be stored this may take up to 1 minute",_warehouse),30)
            ACTIVEBLUEGROUPS:ForeEachGroupAnyInZone(_zone,function(_group)  
                if _group:AllOnGround() == true then
                    _wh:__AddAsset(10,_group)
                    SCHEDULER:New(nil,function() 
                        MessageToBlue(string.format("Group %s has been stored in warehouse %s",_group.GroupName,_warehouse))
                        _group:Destroy()
                    end,{},15)
                end
            end)
        end
    end
end

---Eventually handle stock checking.
---@param _group GROUP
---@param warehouse string
---@param _type string dcs group name
---@param _col int 0 = neutral, 1 = red, 2 = blue
function WAREHOUSESTOCKCHECK(_group,warehouse,_type,_col)
    _wh,_loc = GETWAREHOUSE(_warehouse)


end