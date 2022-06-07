env.info("transporters.lua start")
TRANSPORTTABLE = {}
TRANSPORTTIMER = TIMER:New(function() transporttablecheck() end,{})
TRANSPORTTIMER:Start(2,63)
function rgembark(_infantrygroup,_transportgroup)
    local transportname = _transportgroup:GetName()
    local transportset = SET_GROUP:New()
    if transportset ~= nil then
        transportset:AddGroup(_infantrygroup)
    end
    BASE:E({_transportgroup:GetTypeName()})
    local routetransporttask = _transportgroup:TaskEmbarking(_infantrygroup:GetCoordinate(),transportset,300)
    local routeembarktask = _infantrygroup:TaskEmbarkToTransport(_infantrygroup:GetCoordinate(),200)
    TRANSPORTTABLE[transportname] = transportset
    -- set the task.
    _transportgroup:SetTask(routetransporttask,2)
    _infantrygroup:SetTask(routeembarktask,2)

    BASE:E({"should be trying to move and embark."})

end

function transporttablecheck(transportname)
    transportname = transportname or nil
    local temptable = {}
    for key,v in pairs(TRANSPORTTABLE) do
        if GROUP:FindByName(k):IsAlive() == true and k ~= transportname then
            temptable[k] = v
        end
    end
    TRANSPORTTABLE = temptable
end
function rgdisembark(_transportgroup,_coordinate,_group)
    local transportname = _transportgroup:GetName()
    local transportset = TRANSPORTTABLE[transportname]
    if transportset == nil then
        MessageToGroup(_group,string.format("Unable to dismount troops from group %s as it does not exist in the transport table if you believe this is in error please report it on discord",transportname),30)
    end
    local transporttask = _transportgroup:TaskDisembarking(_coordinate,transportset)
    _transportgroup:SetTask(transporttask,2)
    -- lets update the transporttable to remove the current key
    BASE:E({"Should be disembarking."})
end


env.info("transporters.lua end")