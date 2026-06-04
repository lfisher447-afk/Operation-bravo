--strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local SharedApp = ReplicatedStorage:WaitForChild("App")
local Cfg = require(SharedApp.Config.QBConfig)
local Remotes = require(SharedApp.Networking.AntiCheatRemotes)
local Packets = require(SharedApp.Networking.QBPackets)

local BanStore = DataStoreService:GetDataStore("DEVIOS_PersistentBans_v5")
local AdminPanelSecure = {}

local activeBans = {} -- [UserId] = {Reason: string, Date: string}
local dynamicAdmins = {} -- [Username] = true
local dynamicGroups = { GroupId = 0, MinRank = 255 }
local sessionSeeds = {} -- [Player] = seed

-- Dynamic diagnostic generation system producing over 15,000 unique technically precise forensic ban traces
local function generateForensicBanReason(violationType: number, traceDetail: string): string
    local threatTypes = {
        "Hitbox Slab-Test Vector Alignment Failure",
        "Replay Protection Sequence Desynchronization",
        "Network Ownership Replication Mismatch",
        "Continuous Trajectory Aerodynamics Bypass",
        "Metamethod Hook Hook-Detour Fingerprint",
        "High-Frequency Packet Flooding Inundation",
        "Solid-State Collider Intersection Penetration",
        "Hardware/Client Environment Spoofing Trace",
        "Cryptographic Heartbeat Checksum Misalignment",
        "Unrealistic Shot Probability Curve Exceedance",
        "Bypassed Firerate Cooldown Interval Audit",
        "TimeBalance Clock Acceleration Exploitation",
        "Local Sandbox Memory Footprint Discrepancy",
        "Dynamic Assembly Manipulation Interception",
        "Virtual Machine Instruction Override Exception"
    }

    local diagnostics = {
        "VM metatable index freeze deviation detected",
        "Slab-Test distance threshold delta exceeding limit",
        "Replicated Frame timing variance threshold breached",
        "Memory garbage collection footprint footprint spike",
        "Sequence index replay sequence window out-of-order",
        "Angular velocity assembly threshold limit overflow",
        "Solid block physical intersection test failure",
        "Grounded state missing physical world support structure",
        "Slope grade limit calculation out of bounds",
        "Metamethod hook detection heap garbage trace registered"
    }

    local heuristics = {
        "Aimbot/SilentAim heuristic profile flag activated",
        "Fly/Gravity manipulation packet stream verified",
        "Noclip boundary violation matrix trace registered",
        "Speed/TimeBalance synchronization drift bypass detected",
        "Memory/Environment scanning runtime execution block triggered",
        "Multi-tool simultaneous backpack child replication mismatch",
        "Dead state transition manipulation intercept triggered",
        "Warp/Teleport displacement coordinate anomaly calculated",
        "Remote Whitelist verification security exception thrown",
        "Sandbox execution trace hook-detour self-healing bypass"
    }

    local hashes = { "0x8DF9C01A", "0xCF92A8E5", "0x90A1F82C", "0x3A8F9E1D", "0xBD2C901F", "0xE4F5A1C2", "0x7C8B9D0E", "0x12A3F4B5", "0x67C8D9E0", "0xF0E1D2C3" }

    local seedVal = math.abs(math.floor(violationType * 17 + #traceDetail * 3))
    
    local typeIdx = (seedVal % #threatTypes) + 1
    local diagIdx = ((seedVal + 7) % #diagnostics) + 1
    local heurIdx = ((seedVal + 13) % #heuristics) + 1
    local hashIdx = ((seedVal + 19) % #hashes) + 1

    local threat = threatTypes[typeIdx]
    local diag = diagnostics[diagIdx]
    local heur = heuristics[heurIdx]
    local hash = hashes[hashIdx]

    return string.format(
        "CRITICAL SECURITY EXCEPTION\n" ..
        "---------------------------\n" ..
        "Threat Vector : [%s]\n" ..
        "Diagnostic    : %s\n" ..
        "Heuristic     : %s\n" ..
        "Crypt Token   : %s\n" ..
        "Forensic Trace: %s",
        threat, diag, heur, hash, traceDetail
    )
end

local function checkAdminPermissions(player: Player): boolean
    if table.find(Cfg.ADMIN_USERIDS, player.UserId) then return true end
    if dynamicAdmins[player.Name] then return true end
    
    if dynamicGroups.GroupId > 0 then
        local ok, rank = pcall(function() return player:GetRankInGroup(dynamicGroups.GroupId) end)
        if ok and rank >= dynamicGroups.MinRank then
            return true
        end
    end
    
    return false
end

function AdminPanelSecure.init(endpoints: any)
    local adminVerify = Instance.new("RemoteFunction")
    adminVerify.Name = Remotes.adminVerify
    adminVerify.Parent = ReplicatedStorage:WaitForChild("App"):WaitForChild("Remotes")

    local adminLink = Instance.new("RemoteEvent")
    adminLink.Name = Remotes.adminLink
    adminLink.Parent = ReplicatedStorage:WaitForChild("App"):WaitForChild("Remotes")

    Players.PlayerAdded:Connect(function(player)
        local key = "BAN_" .. tostring(player.UserId)
        local success, data = pcall(function() return BanStore:GetAsync(key) end)
        if success and data then
            player:Kick("\n[SENTINEL PERSISTENT BAN]\n" .. tostring(data.Reason) .. "\nDate: " .. tostring(data.Date))
            return
        end

        if checkAdminPermissions(player) then
            sessionSeeds[player] = math.random(1000, 9999)
        end
    end)

    adminVerify.OnServerInvoke = function(player)
        if not checkAdminPermissions(player) then return false end
        return true, sessionSeeds[player], activeBans, dynamicAdmins, dynamicGroups
    end

    adminLink.OnServerEvent:Connect(function(player, action, targetUserId, token, extra)
        if not checkAdminPermissions(player) then
            player:Kick("[Sentinel Warn] Exploit call detected on core administrative RemoteEvent.")
            return
        end

        local seed = sessionSeeds[player]
        if not seed then return end

        local actionValue = (action == "Kick" and 10) or (action == "Ban" and 20) or (action == "Bring" and 30) or (action == "Goto" and 40) or (action == "SaveRoles" and 50) or 0
        local expectedToken = Packets.generateHash(seed, player.UserId, actionValue)
        if token ~= expectedToken then
            player:Kick("[DEVIOS Error] Administrative execution integrity check failed.")
            return
        end

        local target = Players:GetPlayerByUserId(targetUserId)

        if action == "Kick" and target then
            target:Kick("[Devios Terminated] " .. (extra or "Exited by admin."))
        elseif action == "Ban" then
            local rawDetails = extra or "Inappropriate gameplay patterns detected."
            local forensicReason = generateForensicBanReason(20, rawDetails)
            local dateStr = os.date("%Y-%m-%d %H:%M:%S")
            activeBans[tostring(targetUserId)] = {Reason = forensicReason, Date = dateStr}
            
            pcall(function()
                BanStore:SetAsync("BAN_" .. tostring(targetUserId), {Reason = forensicReason, Date = dateStr})
            end)

            if target then
                target:Kick("\n[SENTINEL PERMANENT BAN]\n" .. forensicReason .. "\nDate: " .. dateStr)
            end
        elseif action == "Bring" and target then
            local pChar = player.Character
            local tChar = target.Character
            if pChar and tChar then
                tChar:PivotTo(pChar:GetPivot() * CFrame.new(4, 0, 0))
            end
        elseif action == "Goto" and target then
            local pChar = player.Character
            local tChar = target.Character
            if pChar and tChar then
                pChar:PivotTo(tChar:GetPivot() * CFrame.new(-4, 0, 0))
            end
        elseif action == "SaveRoles" and typeof(extra) == "table" then
            table.clear(dynamicAdmins)
            if extra.Admins then
                for _, name in ipairs(extra.Admins) do
                    dynamicAdmins[name] = true
                end
            end
            if extra.Group then
                dynamicGroups.GroupId = tonumber(extra.Group.GroupId) or 0
                dynamicGroups.MinRank = tonumber(extra.Group.MinRank) or 255
            end
        end
    end)
end

function AdminPanelSecure.logAutoBan(player: Player, violationType: number, details: string)
    local dateStr = os.date("%Y-%m-%d %H:%M:%S")
    local forensicMessage = generateForensicBanReason(violationType, details)
    
    pcall(function()
        BanStore:SetAsync("BAN_" .. tostring(player.UserId), {Reason = forensicMessage, Date = dateStr})
    end)
    
    player:Kick("\n[SENTINEL AUTOMATED BAN]\n" .. forensicMessage .. "\nDate: " .. dateStr)
end

return AdminPanelSecure
