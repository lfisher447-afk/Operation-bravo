-- [[ VANITY-ANTICHEAT V2.5 ENHANCED SECURITY created by Luvmadison ]]
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vanityAntiCheat = ReplicatedStorage:WaitForChild("VANITY-ANTICHEAT")
local CONFIG = require(vanityAntiCheat:WaitForChild("VANITY-ANTICHEAT-CONFIG"))
local NetworkOptimizer = require(vanityAntiCheat:WaitForChild("VANITY-ANTICHEAT-NETWORK-OPTIMISER"))

local stats = {
    totalDetections = 0,
    activeMonitoring = 0,
    bannedPlayers = 0,
    suspendedPlayers = 0,
    totalViolations = 0,
    serverUptime = os.time(),
}

local violationTracking = { players = {} }

local function getDataStore(name)
    local success, store = pcall(function() return DataStoreService:GetDataStore(name) end)
    return success and store or DataStoreService:GetDataStore(name .. "_backup")
end

local bannedPlayersStore = getDataStore("BannedPlayers")

local function alertAdmins(msg, level)
    print(string.format("[%s ALERT] %s", level, msg))
end

local function banPlayer(player, reason)
    pcall(function()
        bannedPlayersStore:SetAsync(player.UserId, { banned = true, reason = reason })
        player:Kick("[VANITY-ANTICHEAT] Banned: " .. reason)
    end)
end

local VanityAntiCheat = {}

function VanityAntiCheat.init()
    Players.PlayerAdded:Connect(function(player)
        violationTracking.players[player.UserId] = { violations = {}, anomalyScore = 0 }
        
        local successCheck, isBanned = pcall(function() return bannedPlayersStore:GetAsync(player.UserId) end)
        if successCheck and isBanned then
            player:Kick("[VANITY-ANTICHEAT] Persistent ban active.")
        end
    end)
end

return VanityAntiCheat
