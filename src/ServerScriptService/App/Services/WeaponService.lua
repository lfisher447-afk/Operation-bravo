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

local clientSequences = {} -- [Player] = lastClientSeq

function WeaponService:Init()
    remotesFolder = ReplicatedStorage:WaitForChild("App"):WaitForChild("Remotes")
    
    local d = Instance.new("RemoteEvent")
    d.Name = "DealDamage"
    d.Parent = remotesFolder
    dealDamageRemote = d
end

local function verifyTOTPSignature(player: Player, hash: number, hitPosX: number, seq: number): boolean
    local now = math.floor(workspace:GetServerTimeNow())
    
    -- Checks local timeline window drift to allow high-ping synchronizations safely
    for offset = -1, 1 do
        local testSeed = now + offset
        local expected = Packets.generateHash(testSeed, player.UserId, math.floor(hitPosX * 10) + seq)
        if hash == expected then
            return true
        end
    end
    return false
end

function WeaponService:Start()
    assert(dealDamageRemote ~= nil, "Remotes must be initialized before boot.")
    
    dealDamageRemote.OnServerEvent:Connect(function(player, targetPlayer, hitPosition, isHeadshot, weaponName, rayOrigin, rayDir, clientTime, clientSeq, securityHash)
        if typeof(targetPlayer) ~= "Instance" or not targetPlayer:IsA("Player") then return end
        if typeof(hitPosition) ~= "Vector3" or typeof(rayOrigin) ~= "Vector3" or typeof(rayDir) ~= "Vector3" then return end
        if typeof(weaponName) ~= "string" or typeof(isHeadshot) ~= "boolean" then return end
        if typeof(clientTime) ~= "number" or typeof(clientSeq) ~= "number" or typeof(securityHash) ~= "number" then return end
        
        -- 1. Sequential Packet protection
        local lastSeq = clientSequences[player] or -1
        if clientSeq <= lastSeq then
            Violations.report(player, { kind = Reason.SpoofedPacket, sev = 6, msg = "Sequential transaction replay interception (Packet injection)", correct = false })
            return
        end
        clientSequences[player] = clientSeq

        -- 2. Secure dynamic seed verification
        if not verifyTOTPSignature(player, securityHash, hitPosition.X, clientSeq) then
            Violations.report(player, { kind = Reason.MetamethodHook, sev = 9, msg = "TOTP Cryptographic dynamic signature check failed (Argument Hooking)", correct = false })
            player:Kick("[DEVIOS Sentinel] Critical Security Breach: Encryption Handshake Violation.")
            return
        end

        -- 3. Run weapon checks
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
            print("[RECONCILED FIRE]", player.Name, "landed shot on", targetPlayer.Name, "for", dmg, "damage.")
        end
    end)
end

return WeaponService
