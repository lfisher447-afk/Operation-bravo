local TableUtils = {}
function TableUtils.filter(t, fn)
    local res = {}
    for k, v in pairs(t) do if fn(v) then table.insert(res, v) end end
    return res
end
return TableUtils