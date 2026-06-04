--!strict
local Runner = {}
local function execute(svc: any, step: 'Init' | 'Start')
    local method = svc[step]
    if not method then return end
    local ok, err = pcall(method, svc)
    if not ok then error(string.format('Boot Failure: %s.%s failed: %s', svc.Name, step, tostring(err)), 2) end
end
function Runner.boot(services: { any })
    for _, svc in ipairs(services) do execute(svc, 'Init') end
    for _, svc in ipairs(services) do execute(svc, 'Start') end
end
return table.freeze(Runner)