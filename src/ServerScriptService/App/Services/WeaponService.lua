--strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local SharedApp = ReplicatedStorage:WaitForChild("App")
local ServerApp = ServerScriptService:WaitForChild("App")
local Cfg = require(SharedApp.Config.QBConfig)
local WeaponConfig = require(SharedApp.Config.WeaponConfig)
local CombatChecks = require(ServerApp.SubServices.CombatChecks)
local Packets = require(SharedApp.Networking.QBPackets)
local Violations = require(ServerApp.SubServices.ViolationHandler)
local Reason = require(SharedApp.Enums.Reason)

local WeaponService = { Name = "WeaponService" }
local remotesFolder: Folder? = nil
local dealDamageRemote: RemoteEvent? = nil

local clientTickRates = {} -- [Player] = lastClientSeq

function WeaponService:Init()
    remotesFolder = ReplicatedStorage:WaitForChild("App"):WaitForChild("Remotes")
    
    local d = Instance.new("RemoteEvent")
    d.Name = "DealDamage"
    d.Parent = remotesFolder
    dealDamageRemote = d
end

function WeaponService:Start()
    assert(dealDamageRemote ~= nil, "Remotes must be initialized before boot.")
    
    dealDamageRemote.OnServerEvent:Connect(function(player, targetPlayer, hitPosition, isHeadshot, weaponName, rayOrigin, rayDir, clientTime, clientSeq, securityHash)
        -- 1. Ensure type-conformance
        if typeof(targetPlayer) ~= "Instance" or not targetPlayer:IsA("Player") then return end
        if typeof(hitPosition) ~= "Vector3" or typeof(rayOrigin) ~= "Vector3" or typeof(rayDir) ~= "Vector3" then return end
        if typeof(weaponName) ~= "string" or typeof(isHeadshot) ~= "boolean" then return end
        if typeof(clientTime) ~= "number" or typeof(clientSeq) ~= "number" or typeof(securityHash) ~= "number" then return end
        
        -- 2. Prevent replay/backward sequence injections
        local lastSeq = clientTickRates[player] or -1
        if clientSeq <= lastSeq then
            Violations.report(player, { kind = Reason.SpoofedPacket, sev = 5, msg = "Client transaction replay/desync sequence bypassed", correct = false })
            return
        end
        clientTickRates[player] = clientSeq

        -- 3. Verify Argument-Hook Protections via salt token validations
        local seed = player.UserId -- Rotated salt value
        local expectedHash = Packets.generateHash(seed, player.UserId, math.floor(hitPosition.X * 10) + clientSeq)
        if securityHash ~= expectedHash then
            Violations.report(player, { kind = Reason.MetamethodHook, sev = 8, msg = "Remote Argument hook manipulation verification failed", correct = false })
            player:Kick("[DEVIOS Sentinel] Remote Transaction Exception: Hash Verification Failure.")
            return
        end

        -- 4. Audit combat rules
        local weaponData = WeaponConfig[weaponName]
        if not weaponData then return end
        
        local ok = CombatChecks.auditHit(player, targetPlayer, hitPosition, isHeadshot, weaponData, rayOrigin, rayDir)
        if not ok then return end
        
        local char = targetPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local dmg = weaponData.Damage
            if isHeadshot then
                dmg = dmg * weaponData.HeadshotMult
            end
            hum:TakeDamage(dmg)
            print("[TACTICAL REPLICATION]", player.Name, "landed shot on", targetPlayer.Name, "for", dmg, "damage.")
        end
    end)
end

return WeaponService
