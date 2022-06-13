env.info("input.lua")
rlog({"Get # assets",whouse.ezor:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, "t72b")})
--rlog({"WH TEST",whouse.ezor:GetStockInfo(stock)})
_blookup = MISTEMP.BLUE.INFANTRY
for k,v in pairs(_blookup) do
    rlog({"_blookup k,v",k,v})        

end


env.info("input.lua end")