--- Syria Client lua, this handles our client information and data.
RGCLIENT = {
    coalition = 2,
    playerlist ={},
    playermap = {},
    playermenu = {},
    self.menuadded = {},
    Mainmenu = nil,
    clients = nil,
    motd = "",
    roe = "",
}
function RGCLIENT:New(_coalition)
    local self = BASE:Inherit(self,BASE:New())
    self.coalition = _coalition
    self:HandleEvent(EVENTS.PlayerEnterAircraft)
    self:HandleEvent(EVENTS.PlayerEnterUnit)
    self.clients = SET_CLIENT:New():FilterCoalitions(_coalition):FilterPrefixes(prefix):FilterActive(true):FilterStart()
end

function RGCLIENT:SetMOTD(_msg)
    self.motd = _msg
end

function RGCLIENT:SetROE(_msg)
    self.roe = _msg
end

function RGCLIENT:CreateMenu(_client)
    local group = _client:GetGroup()
    local gid = group:GetID()
    if group and gid then
        if not self.menuadded[gid] then
            self.menuadded[gid] = true
            local _rootPath = missionCommands.addSubMenuForGroup(gid,"" .. self.name .. " Farp Control")
            local temptable = {
            _rootpath,
            }
            table.insert(self.playermenu,temptable)
        end
    end
end

function self:OnEventPlayerEnterUnit(EventData)
    BASE:E({EventData})
end

function self:OnEventPlayerEnterAircraft(EventData)
    BASE:E({EventData})
end
function self:SendROE(_Client)
    MESSAGE:New(self.roe,60,"Server Info"):ToClient(_Client)
end

function self:SendMOTD(_Client)
    MESSAGE:New(self.motd,60,"Server Info"):ToClient(_Client)
end