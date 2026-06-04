--!strict
local HookSentinel = {}
local cachedPcall = pcall
local cachedXpcall = xpcall
local cachedGetfenv = getfenv
local cachedDebugInfo = debug.info
function HookSentinel.checkSystemIntegrity(): boolean
    local success, _ = cachedPcall(string.dump, cachedPcall)
    if success then return false end
    local source = cachedDebugInfo(cachedPcall, 's')
    if source ~= '=[C]' then return false end
    local envSource = cachedDebugInfo(cachedGetfenv, 's')
    if envSource ~= '=[C]' then return false end
    return true
end
function HookSentinel.getSafePcall()
    if not HookSentinel.checkSystemIntegrity() then return cachedPcall end
    return pcall
end
function HookSentinel.getSafeXpcall() return cachedXpcall end
return HookSentinel