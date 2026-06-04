-- [[ VANITY-ANTICHEAT STARTUP SCRIPT V2.5 ROBLOX ENHANCED ]]
local success, vanityAntiCheatServer = pcall(function()
    return require(script.Parent)
end)

if not success then
    warn("Failed to load VANITY-ANTICHEAT-SERVER: " .. tostring(vanityAntiCheatServer))
    return
end

vanityAntiCheatServer.init()
print("[VANITY-ANTICHEAT] Anti-cheat system fully started and operational!")
