RGUTILS = {}

-- porting in Slmod's serialize_slmod2
RGUTILS.oneLineSerialize = function( tbl ) -- serialization of a table all on a single line, no comments, made to replace old get_table_string function

    lookup_table = {}
  
    local function _Serialize( tbl )
  
      if type( tbl ) == 'table' then -- function only works for tables!
  
        if lookup_table[tbl] then
          return lookup_table[object]
        end
  
        local tbl_str = {}
  
        lookup_table[tbl] = tbl_str
  
        tbl_str[#tbl_str + 1] = '{'
  
        for ind, val in pairs( tbl ) do -- serialize its fields
          local ind_str = {}
          if type( ind ) == "number" then
            ind_str[#ind_str + 1] = '['
            ind_str[#ind_str + 1] = tostring( ind )
            ind_str[#ind_str + 1] = ']='
          else -- must be a string
            ind_str[#ind_str + 1] = '['
            ind_str[#ind_str + 1] = RGUTILS.basicSerialize( ind )
            ind_str[#ind_str + 1] = ']='
          end
  
          local val_str = {}
          if ((type( val ) == 'number') or (type( val ) == 'boolean')) then
            val_str[#val_str + 1] = tostring( val )
            val_str[#val_str + 1] = ','
            tbl_str[#tbl_str + 1] = table.concat( ind_str )
            tbl_str[#tbl_str + 1] = table.concat( val_str )
          elseif type( val ) == 'string' then
            val_str[#val_str + 1] = RGUTILS.basicSerialize( val )
            val_str[#val_str + 1] = ','
            tbl_str[#tbl_str + 1] = table.concat( ind_str )
            tbl_str[#tbl_str + 1] = table.concat( val_str )
          elseif type( val ) == 'nil' then -- won't ever happen, right?
            val_str[#val_str + 1] = 'nil,'
            tbl_str[#tbl_str + 1] = table.concat( ind_str )
            tbl_str[#tbl_str + 1] = table.concat( val_str )
          elseif type( val ) == 'table' then
            if ind == "__index" then
              --	tbl_str[#tbl_str + 1] = "__index"
              --	tbl_str[#tbl_str + 1] = ','   --I think this is right, I just added it
            else
  
              val_str[#val_str + 1] = _Serialize( val )
              val_str[#val_str + 1] = ',' -- I think this is right, I just added it
              tbl_str[#tbl_str + 1] = table.concat( ind_str )
              tbl_str[#tbl_str + 1] = table.concat( val_str )
            end
          elseif type( val ) == 'function' then
            --	tbl_str[#tbl_str + 1] = "function " .. tostring(ind)
            --	tbl_str[#tbl_str + 1] = ','   --I think this is right, I just added it
          else
            --					env.info('unable to serialize value type ' .. routines.utils.basicSerialize(type(val)) .. ' at index ' .. tostring(ind))
            --					env.info( debug.traceback() )
          end
  
        end
        tbl_str[#tbl_str + 1] = '}'
        return table.concat( tbl_str )
      else
        if type( tbl ) == 'string' then
          return tbl
        else
          return tostring( tbl )
        end
      end
    end
  
    local objectreturn = _Serialize( tbl )
    return objectreturn
  end
  
  -- porting in Slmod's "safestring" basic serialize
RGUTILS.basicSerialize = function( s )
  if s == nil then
    return "\"\""
  else
    if ((type( s ) == 'number') or (type( s ) == 'boolean') or (type( s ) == 'function') or (type( s ) == 'table') or (type( s ) == 'userdata')) then
      return tostring( s )
    elseif type( s ) == 'string' then
      s = string.format( '%s', s:gsub( "%%", "%%%%" ) )
      return s
    end
  end
end

RGUTILS.msg = function(_msg,_group,_duration,_infotype,_clear)
  _infotype = infotype or nil
  _clear = clear or false
  if _group == nil then
    MESSAGE:New(_msg,_duration,_infotype,_clear):ToAll()
    self:E({_msg,_duration,_group})
  else
    MESSAGE:New(_msg,_duration,_infotype,_clear):ToGroup(_group)
    self:E({_msg,_duration,_group})
  end
end
RGUTILS.groupchecker = function()
  local tempset = SET_UNIT:New():FilterActive():FilterOnce()
  local checker = {}
  local ucounter = 0
  local ub = 0
  local ur = 0
  local un = 0
  tempset:ForEach(function(g) 
    ucounter = ucounter + 1
    local uc = g:GetCoalition()
    if uc == 1 then
      ur = ur + 1
    elseif uc == 2 then
      ub = ub + 1
    else
      un = un + 1
    end
  end)
  tempset = SET_GROUP:New():FilterActive():FilterOnce()
  local gcounter = 0
  local gb = 0
  local gr = 0
  local gn = 0
  tempset:ForEach(function(g) 
    gcounter = gcounter + 1
    local gc = g:GetCoalition()
    if gc == 1 then
      gr = gr + 1
    elseif gc == 2 then
      gb = gb + 1
    else
      gn = gn + 1
    end
  end)
  checker.activegroups = gcounter
  checker.bluegroups = gb
  checker.redgroups = gr
  checker.neutralgroups = gn
  checker.activeunits = ucounter
  checker.blueunits = ub
  checker.redunits = ur
  checker.neutralunits = un
  return checker
end