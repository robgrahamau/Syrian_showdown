RedSpawn = 1
BlueSpawn = 1
local unitType

UNITSPAWNER = {
    ClassName = "Unit Spawner",
    name = "",
    redtemplates = {
        fulltable = {'Ural-375 ZU-23','BTR-80','ZSU-23-4 Shilka','Strela-1 9P31','Strela-10M3','BMD-1','BMP-1','BMP-2','BMP-3','BRDM-2','T-55','T-72B','T-80UD','T-90','T-55','Tor 9A331','Osa 9A33 ln','Ural-375','Soldier AK','SA-18 Igla-S manpad','Stinger manpad','Paratrooper RPG-16'},
        mechtable = {'Ural-375 ZU-23','BTR-80','ZSU-23-4 Shilka','Strela-1 9P31','Strela-10M3','BMD-1','BMP-1','BMP-2','BMP-3','BRDM-2','Tor 9A331','Osa 9A33 ln','Ural-375','Soldier AK','SA-18 Igla-S manpad','Stinger manpad','Paratrooper RPG-16'},
        lightmechtable = {'Ural-375 ZU-23','BTR-80','Strela-1 9P31','Strela-10M3','BMD-1','BMP-1','BMP-2','BMP-3','BRDM-2','Osa 9A33 ln','Ural-375','Soldier AK','SA-18 Igla-S manpad','Stinger manpad','Paratrooper RPG-16'},
        armortable = {'Ural-375 ZU-23','BTR-80','ZSU-23-4 Shilka','Strela-1 9P31','Tor 9A331','Strela-10M3','BMD-1','BMP-1','BMP-2','BMP-3','BRDM-2','T-55','T-72B','T-80UD','T-90','T-55','Tor 9A331','Osa 9A33 ln','Ural-375'},
        infantrytable = {'Ural-375','Soldier AK','SA-18 Igla-S manpad','Stinger manpad','Paratrooper RPG-16','Ural-375 ZU-23'},
    },
    bluetemplates = {},
    neutraltemplates = {},
    blueprefix = "cjtf_blue_",
    bluecountry = country.id.CJTF_BLUE,
    redprefix = "cjtf_red_",
    redcountry = country.id.CJTF_RED,
    neutralprefix = "untf_",
    neutralcountry = country.id.UN_PEACEKEEPERS,
    usemarks = false,
    autospawninf = false,
}
function UNITSPAWNER:New(_name)
    self = BASE:Inherit(self,BASE:New())
    self.name = _name
    return self
end

function UNITSPAWNER:AddTemplate(_type,_template,side)
    local temptable = {
        type = _type,
        template = _template,
    }
    if side == "red" then
        table.insert(self.redtemplates,temptable)
    elseif side == "blue" then
        table.insert(self.bluetemplates,temptable)
    else
        table.insert(self.neutraltemplates,_template)
    end
end
function UNITSPAWNER:SetAutoSpawnInf(_val)
    self.autospawninf = _val or false
end

function UNITSPAWNER:SetUseMarks(_val)
    self.usemarks = _val or false
end
function UNITSPAWNER:randomtype()
    local _r math.random(1,10)
    if _r == 1 then
        return "full"
    elseif _r == 2 then
        return "mech"
    elseif _r == 3 then
        return "lightmech"
    elseif _r == 4 then
        return "armour"
    else
        return "inf"
    end
end

function UNITSPAWNER:randomredunit(tablevalue,lookup)
    local unitType = nil  
    if tablevalue == "full" then
        local fulltable = lookup.fulltable
        unitType = fulltable[math.random(#fulltable)]
    elseif tablevalue == "mech" then
        local mechtable = lookup.mech
        unitType = mechtable[math.random(#mechtable)]
    elseif tablevalue == "lightmech" then
        local lightmechtable = lookup.lightmechtable
        unitType = lightmechtable[math.random(#lightmechtable)]
    elseif tablevalue == "armor" then
        local armortable = lookup.armortable
        unitType = armortable[math.random(#armortable)]
    else
        local infantrytable = lookup.infantrytable
        unitType = infantrytable[math.random(#infantrytable)]
    end
    BASE:E({"randomredunit",unitType})
    return unitType
end

function UNITSPAWNER:randomblueunit(tablevalue)
    local unitType
    local fulltable = {}
    local mechtable = {}
    local marinetable = {}
    local armortable = {}
    local infantrytable = {}
    if tablevalue == "full" then
        unitType = fulltable[math.random(#fulltable)]
    elseif tablevalue == "mech" then
        unitType = mechtable[math.random(#mechtable)]
    elseif tablevalue == "marine" then
        unitType = marinetable[math.random(#lightmechtable)]
    elseif tablevalue == "armor" then
        unitType = armortable[math.random(#armortable)]
    else
        unitType = infantrytable[math.random(#infantrytable)]
    end
    return unitType
end

function UNITSPAWNER:createredfor(unitSpawnPoint,_type,_groupSize,_spread,_m,_spawninf,countryid)
    BASE:E({"Debug-Createredfor",unitSpawnPoint,_type,_groupSize,_spread,_m})
    local _countryid = countryid or self.redcountry
    local spread = _spread or 150
    local groupSize = _groupSize or 16
    local minspread = 30
    local spawninf = _spawninf or self.autospawninf
    BASE:E({"createredfor: Spawning New Group"})
    local unitType
    local _coord = unitSpawnPoint
    local unitPosition = _coord
    local _mark = _m or self.usemarks
    BASE:E({"Debug-Createredfor1",_countryid,spread,groupSize,_mark})
    if land.getSurfaceType(unitSpawnPoint) ~= land.SurfaceType.LAND then
        BASE:E({"createredfor error: Land Value was not a valid spawn type"})
        return nil
    end
    local units = {}
    local i = 1
    if spread < (groupSize * 3) then
        spread = groupSize * 3
    end
    if minspread < (groupSize /2 ) then
        minspread = groupSize /2
    end
    BASE:E({"MAIN GROUP"})
    for i = 1, groupSize do --Insert a random number (min 1, max 5)of random (selection 14 possible) vehicles into table units{}
        unitType = self:randomredunit(_type,self.redtemplates)
        BASE:E({{"Debug:",type,i,groupSize}})
        y = 1
        repeat --Place every unit within a 150m radius circle from the spot previously randomly chosen
            unitPosition = _coord:GetRandomCoordinateInRadius(spread,minspread)
            y = y + 1
            if y == 60 then
                BASE:E({"We hit 60... we shouldn't do this, setting unitposition to coord"})
                unitPosition = _coord
            end
        until (land.getSurfaceType(unitPosition) == land.SurfaceType.LAND) or (y > 60)
        table.insert(units,
            {
                ["x"] = unitPosition.x,
                ["y"] = unitPosition.z,
                ["type"] = unitType,
                ["name"] = self.redprefix .. '_' .. RedSpawn..'_' .. i,
                ["heading"] = math.random(0,359),
                ["skill"] = "Random",
                ["playerCanDrive"]=true,  --hardcoded but easily changed.  
        })            
    end
    if spawninf == true then
        BASE:E({"INF GROUP"})
        local manpad = 0
        local infantryGroupSize = math.random(0,groupSize)
        local passinf = infantryGroupSize
        for i = 1, infantryGroupSize do --Insert three times as many infantry soldiers as there are vehicles in the group into the table units{}
            local randomNumber = math.random(10)
            
            unitType = self:randomredunit("inf",self.redtemplates)

            repeat --Place every unit within a 100m radius circle from the spot previously randomly chosen
                unitPosition = _coord:GetRandomCoordinateInRadius(spread,minspread)
            until land.getSurfaceType(unitPosition) == land.SurfaceType.LAND
            table.insert(units,
        {
                ["x"] = unitPosition.x,
                ["y"] = unitPosition.z,
                ["type"] = unitType,
                ["name"] = self.redprefix .. '_' .. RedSpawn .. '_i_' .. i,
                ["heading"] = math.random(0,359),
                ["skill"] = "Random",
                ["playerCanDrive"]=true,
                ["transportable"]= {["randomTransportable"] = true,}, 
            })
        end
    end
    BASE:E({"SPAWNGROUP units should be",units})
    local grouppoint = _coord:GetVec2()
    local groupData = 
    {
        ["visible"] = true,
        ["tasks"] = {}, -- end of ["tasks"]
        ["uncontrollable"] = false,
        ["task"] = "Ground Nothing",
        ["route"] = {},
        ["hidden"] = false,
        ["units"] = units,
        ["y"] = grouppoint.z,
        ["x"] = grouppoint.x,
        ["name"] = 'Insurgent_Group#' .. RedSpawn,
    }
    BASE:E({"Should be making a new Insurgent Group called ",'Insurgent_Group#' .. RedSpawn,})
    BASE:E({"Scheduled Spawn of group now happening.... "})
    coalition.addGroup(_countryid,Unit.Category['GROUND_UNIT'],groupData) 
    local _offsetcoord = _coord:GetRandomCoordinateInRadius(2000,100)
    if _mark == false then
        MESSAGE:New(string.format("Intel is reporting sightings of insurgents near %s , investigate with caution",_offsetcoord:ToStringMGRS()),30,"INTEL"):ToBlue()
    else
        local newmark = _offsetcoord:MarkToAll("Intelligence Reports insurgent group near this location",false)
    end

    local tempgroup = GROUP:FindByName(groupData.name)
    RedSpawn = RedSpawn + 1
    return tempgroup
end