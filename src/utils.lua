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