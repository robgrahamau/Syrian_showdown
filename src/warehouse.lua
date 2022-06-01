whouse = {}
whcoord = {}


whouse.ezor = WAREHOUSE:New(STATIC:FindByName("ezZor"), "Deir ez-Sor")
whcoord["ezor"] = COORDINATE:New()
whouse.tanf = WAREHOUSE:New(STATIC:FindByName("tanf"), "Tanf")
whcoord["tanf"] = COORDINATE:New()
whouse.palmyra = WAREHOUSE:New(STATIC:FindByName("palmyra"),"Palmyra")
whcoord["palmyra"] = COORDINATE:New()

whouse.ezor:Start()
whouse.tanf:Start()
whouse.palmyra:Start()

function GETWAREHOUSE(_warehouse)
    local _wh = nil
    local _loc = nil
    if _warehouse == "ezor" or _warehouse == "deir ez-zor" or _warehouse == "ez-zor" then
        _wh = whouse.ezor
        _loc = "ezor"
    elseif _warehouse == "tanf" or _warehouse == "at tanf" or _warehouse == "al tanf" then
        _wh = whouse.tanf
        _loc = "tanf"
    elseif _warehouse == "palmyra" then
        _wh = whouse.palmyra
        _loc = "palmyra"
    end
    rlog({_wh,_loc})
    return _wh, _loc
end

function ADDTOWAREHOUSE(_asset,_amount,_warehouse,_attribute,_cargohold,_weight,_load,_skill)
    _attribute = _attribute or nil
    _cargohold = _cargohold or nil
    _weight = _weight or nil
    _load = _load or nil
    _skill = _skill or nil
    _warehouse:AddAsset(_asset,_amount,_attribute,_cargohold,_weight,_load,_skill)
end

function whouse.ezor:OnAfterSelfRequest(From,Event,To,groupset,request)
    -- lets grab our request
    local assignmnet = whouse.ezor:GetAssignment(request)
    if assignmnet == "To Coordinate" then
        for _,_group in pairs(groupset:GetSet()) do
            local _ToCoord = whcoord["ezor"]
            _group:RouteGroundOnRoad(_ToCoord, _group:GetSpeedMax()*0.8)
        end
    end    
end

function whouse.palmyra:OnAfterSelfRequest(From,Event,To,groupset,request)
    -- lets grab our request
    local assignmnet = whouse.palmyra:GetAssignment(request)
    if assignmnet == "To Coordinate" then
        for _,_group in pairs(groupset:GetSet()) do
            local _ToCoord = whcoord["palmyra"]
            _group:RouteGroundOnRoad(_ToCoord, _group:GetSpeedMax()*0.8)
        end
    end    
end

function whouse.tanf:OnAfterSelfRequest(From,Event,To,groupset,request)
    -- lets grab our request
    local assignmnet = whouse.tanf:GetAssignment(request)
    if assignmnet == "To Coordinate" then
        for _,_group in pairs(groupset:GetSet()) do
            local _ToCoord = whcoord["tanf"]
            _group:RouteGroundOnRoad(_ToCoord, _group:GetSpeedMax()*0.8)
        end
    end    
end

if initalstart == true then
    -- ISIS Items
    ADDTOWAREHOUSE("syrian platoon",10,whouse.ezor)
    ADDTOWAREHOUSE("syrian manpad",6,whouse.ezor)
    ADDTOWAREHOUSE("Mi8 transport",6,whouse.ezor,WAREHOUSE.Attribute.AIR_TRANSPORTHELO)
    ADDTOWAREHOUSE("t55",9,whouse.ezor)
    ADDTOWAREHOUSE("t72b",3,whouse.ezor)
    ADDTOWAREHOUSE("zsu57",12,whouse.ezor)
    ADDTOWAREHOUSE("hl zu23",12,whouse.ezor)
    ADDTOWAREHOUSE("lc kord",24,whouse.ezor)
    ADDTOWAREHOUSE("lc dshk",24,whouse.ezor)
    ADDTOWAREHOUSE("btr80",12,whouse.ezor)
    ADDTOWAREHOUSE("btr-rd",12,whouse.ezor)


    -- US Army Items
    ADDTOWAREHOUSE("us platoon",10,whouse.tanf)

end


function MAPDEPLOYMENT(_asset,_specifictype,_amount,_warehouse,_loc,_coordinate)
    local _asset = _asset or nil
    local _specifictype = _specifictype or nil
    rlog({"MAPDEPLOYMENT",_asset,_specifictype,_amount,_warehouse,_loc})
    whcoord[_loc] = _coordinate
    if _specifictype == nil then 
        _warehouse:AddRequest(_warehouse,WAREHOUSE.Descriptor.ATTRIBUTE,_asset,_amount,nil,nil,nil,"To Coordinate")
    else
        _warehouse:AddRequest(_warehouse,WAREHOUSE.Descriptor.GROUPNAME,_specifictype,_amount,nil,nil,nil,"To Coordinate")
    end
end

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
end


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
end