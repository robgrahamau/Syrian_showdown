env.info("warehouse.lua")

whouse = {}
whcoord = {}


whouse.ezor = WAREHOUSE:New(STATIC:FindByName("ezZor"), "Deir ez-Sor")
whouse.ezor:SetAutoDefenceOn()
whouse.ezor:SetSpawnZone(ZONE:New("ezzor_packup"))
whcoord["ezor"] = {}
whcoord["ezor"].coord = COORDINATE:New()
whcoord["ezor"].zone = ZONE:New("ezzor_packup")

whouse.tanf = WAREHOUSE:New(STATIC:FindByName("tanf"), "Tanf")
whouse.tanf:SetAutoDefenceOn()
whouse.tanf:SetSpawnZone(ZONE:New("tanf_packup"))
whcoord["tanf"] = {}
whcoord["tanf"].coord = COORDINATE:New()
whcoord["tanf"].zone = ZONE:New("tanf_packup")

whouse.palmyra = WAREHOUSE:New(STATIC:FindByName("palmyra"),"Palmyra")
whouse.palmyra:SetAutoDefenceOn()
whouse.palmyra:SetSpawnZone(ZONE:New("palmyra_packup"))
whcoord["palmyra"] = {}
whcoord["palmyra"].coord = COORDINATE:New()
whcoord["palmyra"].zone = ZONE:New("palmyra_packup")

whouse.h3 = WAREHOUSE:New(STATIC:FindByName("h3"),"H3")
whouse.h3:SetAutoDefenceOn()
whouse.h3:SetSpawnZone(ZONE:New("h3_packup"))
whcoord["h3"] = {}
whcoord["h3"].coord = COORDINATE:New()
whcoord["h3"].zone = ZONE:New("h3_packup")

whouse.tabqa = WAREHOUSE:New(STATIC:FindByName("tabqa"),"Tabqa")
whouse.tabqa:SetAutoDefenceOn()
whouse.tabqa:SetSpawnZone(ZONE:New("tabqa_packup"))
whcoord["tabqa"] = {}
whcoord["tabqa"].coord = COORDINATE:New()
whcoord["tabqa"].zone = ZONE:New("tabqa_packup")

whouse.tiyas = WAREHOUSE:New(STATIC:FindByName("tiyas"),"Tiyas")
whouse.tiyas:SetAutoDefenceOn()
whouse.tiyas:SetSpawnZone(ZONE:New("tiyas_packup"))
whcoord["tiyas"] = {}
whcoord["tiyas"].coord = COORDINATE:New()
whcoord["tiyas"].zone = ZONE:New("tiyas_packup")


-- these are the farp ones
whouse.farp1 = nil
whouse.farp2 = nil
whouse.farp3 = nil
whcoord["farp1"] = {}
whcoord["farp1"].coord = COORDINATE:New()
whcoord["farp1"].zone = nil
whcoord["farp2"] = {}
whcoord["farp2"].coord = COORDINATE:New()
whcoord["farp2"].zone = nil
whcoord["farp3"] = {}
whcoord["farp3"].coord = COORDINATE:New()
whcoord["farp3"].zone = nil
---


whouse.ezor:Start()
whouse.tanf:Start()
whouse.palmyra:Start()
whouse.h3:Start()
whouse.tabqa:Start()
whouse.tiyas:Start()


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
    elseif _warehouse == "tabqa" then
        _wh = whouse.tabqa
        _loc = "tabqa"
    elseif _warehouse == "farp1" then
        _wh = whouse.farp1
        _loc = "farp1"
    elseif _warehouse == "farp2" then
        _wh = whouse.farp2
        _loc = "farp2"
    elseif _warehouse == "farp3" then
        _wh = whouse.farp3
        _loc = "farp3"
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


---OnAfterSelfRequest
---@param From any
---@param Event Event
---@param To any
---@param groupset SET_GROUP
---@param request string
function whouse.h3:OnAfterSelfRequest(From,Event,To,groupset,request)
    -- lets grab our request
    local assignmnet = whouse.tanf:GetAssignment(request)
    if assignmnet == "To Coordinate" then
        for _,_group in pairs(groupset:GetSet()) do
            local _ToCoord = whcoord["tanf"].coord
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
function whouse.tabqa:OnAfterSelfRequest(From,Event,To,groupset,request)
    -- lets grab our request
    local assignmnet = whouse.tanf:GetAssignment(request)
    if assignmnet == "To Coordinate" then
        for _,_group in pairs(groupset:GetSet()) do
            local _ToCoord = whcoord["tanf"].coord
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
function whouse.tiyas:OnAfterSelfRequest(From,Event,To,groupset,request)
    -- lets grab our request
    local assignmnet = whouse.tanf:GetAssignment(request)
    if assignmnet == "To Coordinate" then
        for _,_group in pairs(groupset:GetSet()) do
            local _ToCoord = whcoord["tanf"].coord
            _group:RouteGroundOnRoad(_ToCoord, _group:GetSpeedMax()*0.8)
        end
    end    
end


function buildselfrequests()
    for k,v in pairs(whouse) do
        BASE:E({"KEY IS:",k,"V is",v})
        if v ~= nil then
            
            function v:OnAfterDefeated(From, Event, To)
                local txt = string.format("Warning warehouse %s has repelled its attackers", v.alias)
                MessageToAll(txt,30)
            end
            function v:OnAfterAttacked(From, Event, To, Coalition, Country)
                local txt = string.format("Warning warehouse %s is under attack", v.alias)
                if Coalition == 1 then
                    MessageToBlue(txt,30)
                else
                    MessageToRed(txt,30)
                end
            end

            function v:OnAfterSelfRequest(From,Event,To,groupset,request)
                -- lets grab our request
                local assignmnet = whouse.tanf:GetAssignment(request)
                if assignmnet == "To Coordinate" then
                    for _,_group in pairs(groupset:GetSet()) do
                        local _ToCoord = whcoord["tanf"].coord
                        _group:RouteGroundOnRoad(_ToCoord, _group:GetSpeedMax()*0.8)
                    end
                end
            end

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
    if _unittype ~= nil then
        local _exists = GROUP:FindByName(_unittype)
        if _exists == nil then
            local _tmsg = string.format("Unable to Process request as unit type %s that was requested does not exist",_unittype)
            if _group == nil then
                if _col == 1 then             
                    MessageToRed(_tmsg,30)
                else
                    MessageToBlue(_tmsg,30)
                end
            else
                MessageToGroup(_group,_tmsg,30)
            end
            return false
        end
    end
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
    if _unittype ~= nil then
        local _exists = GROUP:FindByName(_unittype)
        if _exists == nil then
            local _tmsg = string.format("Unable to Process request as unit type %s that was requested does not exist",_unittype)
            if _group == nil then
                if _col == 1 then             
                    MessageToRed(_tmsg,30)
                else
                    MessageToBlue(_tmsg,30)
                end
            else
                MessageToGroup(_group,_tmsg,30)
            end
            return false
        end
    end
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
    BASE:E({_col,_warehouse})
    if _wh:GetCoalition() == _col then
        local _zone = whcoord[_loc].zone
        if _col == 1 then
            MessageToRed(string.format("Now scanning %s warehouse zone for active units, any found will be stored this may take up to 1 minute",_warehouse),30)
            ACTIVEREDGROUPS:ForEachGroupAnyInZone(_zone,function(_group)  
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
            ACTIVEBLUEGROUPS:ForEachGroupAnyInZone(_zone,function(_group)  
                if _group:AllOnGround() == true then
                    _wh:__AddAsset(10,_group)
                    SCHEDULER:New(nil,function() 
                        MessageToBlue(string.format("Group %s has been stored in warehouse %s",_group.GroupName,_warehouse))
                        _group:Destroy()
                    end,{},15)
                end
            end)
        end
    else
        if _group ~= nil then
            MessageToGroup(_group,"Unable to put troops into that warehouse you don't own it",30)
        else
            if _col == 1 then
                MessageToRed("Unable to put those groups into that warehouse asa its not owned by the right coalition",30)
            else
                MessageToBlue("Unable to put those groups into that warehouse asa its not owned by the right coalition",30)
            end
        end
    end
end

---Eventually handle stock checking.
---@param _group GROUP
---@param warehouse string
---@param _type string dcs group name
---@param _col int 0 = neutral, 1 = red, 2 = blue
function WAREHOUSESTOCKCHECK(_group,_warehouse,_type,_col)
    _wh,_loc = GETWAREHOUSE(_warehouse)
    local _blookup = nil
    local _rlookup = nil
    local msg = ""
    if _type == "infantry" or _type == "inf" or _type == "troops" then
        _blookup = MISTEMP.BLUE.INFANTRY
        _rlookup = MISTEMP.RED.INFANTRY
    end
    if _type == "ifv" or _type == "apc" or _type == "carrier" then
        _blookup = MISTEMP.BLUE.IFV
        _rlookup = MISTEMP.RED.IFV
    end
    if _type == "tank" or _type == "armour" or _type == "armor" then
        _blookup = MISTEMP.BLUE.ARMOUR
        _rlookup = MISTEMP.RED.ARMOUR
    end
    if _type == "aaa" or _type == "antiair" or _type == "anti-air" then
        _blookup = MISTEMP.BLUE.AAA
        _rlookup = MISTEMP.RED.AAA
    end
    if _type == "sam" or _type == "mobile sam" or _type == "surface to air missile" then
        _blookup = MISTEMP.BLUE.MOBILESAM
        _rlookup = MISTEMP.RED.MOBILESAM
    end
    if _type == "art" or _type == "artilery" or _type == "arty" then
        _blookup = MISTEMP.BLUE.ART
        _rlookup = MISTEMP.RED.ART
    end
    if _type == "truck" or _type == "unarmed" or _type == "logistic" or _type == "logi" then
        _blookup = MISTEMP.BLUE.UNARMED
        _rlookup = MISTEMP.RED.UNARMED
    end
    if _type == "heli" or _type == "helicopter" or _type == "chopper" then
        _blookup = MISTEMP.BLUE.HELICOPTER
        _rlookup = MISTEMP.RED.HELICOPTER
    end
    if _wh:GetCoalition() ~= _col then
        local msg1 = string.format("Unable to list contents of %s you don't own that warehouse.",_warehouse)
        if _group == nil then
            if _col == 1 then
                MessageToRed(msg1,30)
                return
            else
                MessageToBlue(msg1,30)
                return
            end
        else
            MessageToGroup(_group,msg1,30)
            return
        end
    end
    if _blookup == nil or _rlookup == nil then
        return
    end
    local msgtxt = string.format("WAREHOUSE STOCK INFORMATION FOR %s of TYPE %s",_warehouse,_type)
    msgtxt = string.format("%s \n Coalition Produced Units",msgtxt)
    for k,v in pairs(_blookup) do
        local tname = v
        local wamount = _wh:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, v)
        local mtxt = string.format("Type: %s | Amount: %d",tname,wamount)
        msgtxt = string.format("%s \n %s ",msgtxt,mtxt)
    end
    msgtxt = string.format("%s \n Russian & Chinese Produced Units",msgtxt)
    for k,v in pairs(_rlookup) do 
        local tname = v
        local wamount = _wh:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, v)
        local mtxt = string.format("Type: %s | Amount: %d",tname,wamount)
        msgtxt = string.format("%s \n %s ",msgtxt,mtxt)
    end
    if _group ~= nil then
        MessageToGroup(_group,msgtxt,60,"Warehouse Info")
    else
        if _col == 1 then
            MessageToRed(msgtxt,60,"Warehouse Info")
        else
            MessageToBlue(msgtxt,60,"Warehouse Info")
        end

    end
end
buildselfrequests()
env.info("hound.lua end")