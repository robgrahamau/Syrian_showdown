if initalstart == true then
   -- ISIS Items
   ADDTOWAREHOUSE("syrian platoon",30,whouse.ezor)
   ADDTOWAREHOUSE("syrian manpad",10,whouse.ezor)
   ADDTOWAREHOUSE("Mi8 transport",6,whouse.ezor,WAREHOUSE.Attribute.AIR_TRANSPORTHELO)
   ADDTOWAREHOUSE("t55",9,whouse.ezor)
   ADDTOWAREHOUSE("t72b",3,whouse.ezor)
   ADDTOWAREHOUSE("zsu57",12,whouse.ezor)
   ADDTOWAREHOUSE("hl zu23",12,whouse.ezor)
   ADDTOWAREHOUSE("lc kord",24,whouse.ezor)
   ADDTOWAREHOUSE("lc dshk",24,whouse.ezor)
   ADDTOWAREHOUSE("btr80",12,whouse.ezor)
   ADDTOWAREHOUSE("btr-rd",12,whouse.ezor)
   ADDTOWAREHOUSE("plz-05",3,whouse.ezor)
   ADDTOWAREHOUSE("hq7",6,whouse.ezor)
   ADDTOWAREHOUSE("sa6",2,whouse.ezor)
   ADDTOWAREHOUSE("sa19",4,whouse.ezor)
   ADDTOWAREHOUSE("sa9",10,whouse.ezor)
   ADDTOWAREHOUSE("shilka",10,whouse.ezor)
   ADDTOWAREHOUSE("zsu57",14,whouse.ezor)
   ADDTOWAREHOUSE("ural",30,whouse.ezor)
   ADDTOWAREHOUSE("t55",9,whouse.tiyas)
   ADDTOWAREHOUSE("t72b",3,whouse.tiyas)
   ADDTOWAREHOUSE("sa6",2,whouse.tiyas)
   ADDTOWAREHOUSE("sa15",2,whouse.tiyas)
   ADDTOWAREHOUSE("syrian platoon",10,whouse.tiyas)
   ADDTOWAREHOUSE("syrian manpad",5,whouse.tiyas)
   ADDTOWAREHOUSE("sa15",2,whouse.tabqa)
   ADDTOWAREHOUSE("sa6",2,whouse.tabqa)
   ADDTOWAREHOUSE("t72b",3,whouse.tabqa)
   ADDTOWAREHOUSE("syrian platoon",10,whouse.tabqa)
   ADDTOWAREHOUSE("syrian manpad",5,whouse.tabqa)
   ADDTOWAREHOUSE("Mi8 transport",2,whouse.tabqa,WAREHOUSE.Attribute.AIR_TRANSPORTHELO)
   ADDTOWAREHOUSE("Mi8 transport",2,whouse.tiyas,WAREHOUSE.Attribute.AIR_TRANSPORTHELO)
end



EZORFACTORY = RGFactory:New("Ez-Zor Factory","hl zu23",1,(60*60*24*3.5),(60*60*24*4),true,1)
EZORFACTORY:AddParts(197492779,"hanger")
EZORFACTORY:AddParts(118065130,"hanger")
EZORFACTORY:AddParts(197492772,"industrial")
EZORFACTORY:AddParts(197492805,"industrial")
EZORFACTORY:AddParts(118065223,"hanger")

EZORFACTORY:AddWarehouse(whouse.ezor)
EZORFACTORY:enableMarkers(true)
EZORFACTORY:Start()

EZORFACTORY1 = RGFactory:New("Ez-zor Factory 1","syrian platoon",1,(60*60*24*2),(60*60*24*4),true,1)
EZORFACTORY1:AddParts("118065666","hanger")
EZORFACTORY1:AddParts("197492801","Building")
EZORFACTORY1:AddParts("197492802","Building")
EZORFACTORY1:AddParts("197492755","Building")
EZORFACTORY1:AddWarehouse(whouse.ezor)
EZORFACTORY1:enableMarkers(true)
EZORFACTORY1:Start()





local prespawnsa10 = CTLD_CARGO:New(nil,"SA10",{"sa10"},CTLD_CARGO.Enum.FOB,true,true,24,nil,false,750,3,"SAM SYSTEMS")
redctld:InjectVehicles(ZONE:New("sa10"),prespawnsa10)
redctld:InjectVehicles(Z_PALSA10,prespawnsa10)



-- Ai items -- 
Ezorplatoon = PLATOON:New("syrian platoon",6,"Ez-zor Infantry")
Ezorplatoon:AddMissionCapability({AUFTRAG.Type.PATROLZONE},40)

EzorBrigade = BRIGADE:New("ezZor","Syrian 2nd Brigade")
EzorBrigade:SetSpawnZone(ZONE:New("ezzor_packup"))
EzorBrigade:AddPlatoon(Ezorplatoon)

syriancommander = COMMANDER:New(coalition.side.RED)
syriancommander:AddLegion(EzorBrigade)
syriancommander:AddLegion(S12thTransport1)

syriancommander:Start()

function syriancommander:onafterOpsOnMission(From,Event,To,OpsGroup,Mission)
    local opsgroup = OpsGroup
    local mission = Mission
    local text = string.format("Group %s is on %s mission %s",opsgroup:GetName(),mission:GetType(),mission:GetName())
    MESSAGE:New(text,120):ToRed()
    env.info(text)
end

local missionPatrolZone1 = AUFTRAG:NewPATROLZONE(Z_PATROLZONE1)
missionPatrolZone1:SetRequiredAssets(2)
missionPatrolZone1:SetRequiredTransport(Z_PATROLZONE1,1,3)
missionPatrolZone1:SetRepeatOnFailure(1000)
missionPatrolZone1:SetRepeatOnSuccess(1000)

syriancommander:AddMission(missionPatrolZone1)
