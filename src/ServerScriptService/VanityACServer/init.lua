-- [[ VANITY-ANTICHEAT SERVER INITIALIZATION V2.5 ROBLOX ENHANCED ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VanityAntiCheatServer = {}

local vanityAntiCheat = ReplicatedStorage:WaitForChild("VANITY-ANTICHEAT")
VanityAntiCheatServer.Config = require(vanityAntiCheat:WaitForChild("VANITY-ANTICHEAT-CONFIG"))
VanityAntiCheatServer.Core = require(script:WaitForChild("VANITY-ANTICHEAT"))

function VanityAntiCheatServer.init()
    print("[VANITY-ANTICHEAT-SERVER] Initializing core modules...")
    VanityAntiCheatServer.Core.init()
    print("[VANITY-ANTICHEAT-SERVER] Init completed successfully!")
end

return VanityAntiCheatServer
