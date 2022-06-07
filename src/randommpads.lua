RANDOMMPZONES = {}
rmpadident = 1
for i=1,25 do
    local zonename = string.format("mp1-%d",i)
    local _zone = ZONE:New(zonename)
    table.insert(RANDOMMPZONES,_zone)
    BASE:E({"zc",zonename})
end

function randommanpad()
    local despawn = math.random((60*30),(60*120))
    local _spawnunit = SPAWN:NewWithAlias("syrian manpad",string.format("ghostpad %d",rmpadident)):InitRandomizePosition(500,100):InitRandomizeZones(RANDOMMPZONES):Spawn()
    local mpaddespawner = TIMER:New(function() if _spawnunit:IsAlive() == true then _spawnunit:Destroy() end end,{})
    BASE:E({"randommpad times",despawn,_spawnunit})
    mpaddespawner:Start(nil,despawn)
end

MPADS = TIMER:New(function() randommanpad() end)
MPADS:Start(15,math.random(60*30,60*60))