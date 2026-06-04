--!strict
local MetatableProtector = {}
function MetatableProtector.freezeTable(target: any)
    if typeof(target) ~= 'table' then return target end
    local mt = {
        __newindex = function(_, k, v)
            error('DEVIOS Protection Violation: Mutation attempt on locked environment structural key '' .. tostring(k) .. ''', 2)
        end,
        __metatable = 'Metatable structure is securely locked.'
    }
    for k, v in pairs(target) do
        if typeof(v) == 'table' then
            target[k] = MetatableProtector.freezeTable(v)
        end
    end
    return setmetatable(target, mt)
end
return MetatableProtector