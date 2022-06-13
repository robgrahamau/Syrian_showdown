function TANKERMISSION(_coord,_altitude,_speed,_heading,_leg,_system,_airwing,_repeats,_duration,_radiofreq,_radiomod,_tacan,_morse)
    local TankerMission = AUFTRAG:NewTANKER(_coord,_altitude,_speed,_heading,_leg,_system)
    if TankerMission == nil then
        return
    end
    TankerMission:SetRepeatOnFailure(_repeats)
    TankerMission:SetRepeatOnSuccess(_repeats)
    TankerMission:SetDuration(_duration)
    TankerMission:SetRadio(_radiofreq,_radiomod)
    TankerMission:SetTACAN(_tacan,_morse)
    _airwing:AddMission(TankerMission)
end

function MISSIONPATROLZONE(_Command,_assets,_transport,_transportmin,_transportmax,_zone,_speed,_altitude,_formation,_repeat,_repeatamount)
    local _altitude = _altitude or 2000
    local _formation = _formation or "Off Road"
    local _transportmin = _transportmin or nil
    local _transportmax = _transportmax or nil
    local _assets = _assets or 1
    local _transport = _transport or false
    local _Command = _Command or nil
    local _repeat = _repeat or false
    local _repeatamount = _repeatamount or 1
    if _Command == nil then
        rlog("Unable to do missionpatrolzone, _Command was nil")
        return false
    end
    local missionPatrolZone = AUFTRAG:NewPATROLZONE(_zone,_speed,_altitude,_formation)
    if missionPatrolZone == nil then
        return
    end
    missionPatrolZone:SetRequiredAssets(_assets)
    if _transport == true then
        missionPatrolZone:SetRequiredTransport(_zone,_transportmin,_transportmax)
    end
    if _repeat then
        missionPatrolZone:SetRepeatOnFailure(_repeatamount)
        missionPatrolZone:SetRepeatOnSuccess(_repeatamount)
    end
    _Command:AddMission(missionPatrolZone)
end