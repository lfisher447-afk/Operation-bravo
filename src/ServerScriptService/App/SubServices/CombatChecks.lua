--strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local SharedApp = ReplicatedStorage:WaitForChild("App")
local ServerApp = ServerScriptService:WaitForChild("App")
local Cfg = require(SharedApp.Config.QBConfig)
local MathUtils = require(SharedApp.Utilities.MathUtils)
local OBB = require(SharedApp.Utilities.OBB)
local Reason = require(SharedApp.Enums.Reason)
local Violations = require(ServerApp.SubServices.ViolationHandler)

local CombatChecks = {}
local targetHistory = {} -- [Player] = { {t: number, pos: Vector3, cf: CFrame, size: Vector3} }
local playerShots = {} -- [Player] = { lastFire = number, count = number, accHits = number, headshots = number }

function CombatChecks.initPlayer(player: Player)
    targetHistory[player] = {}
    playerShots[player] = { lastFire = 0, count = 0, accHits = 0, headshots = 0 }
end

function CombatChecks.clearPlayer(player: Player)
    targetHistory[player] = nil
    playerShots[player] = nil
end

local function trackPositions()
    local now = workspace:GetServerTimeNow()
    for _, player in ipairs(Players:GetPlayers()) do
        local hist = targetHistory[player]
        if not hist then continue end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:IsA("BasePart") then
            table.insert(hist, { t = now, pos = hrp.Position, cf = hrp.CFrame, size = hrp.Size })
        end
        while #hist > 0 and now - hist[1].t > Cfg.lagCompWindow do
            table.remove(hist, 1)
        end
    end
end

RunService.Heartbeat:Connect(trackPositions)

-- Linearly interpolates (Lerp) CFrame & size to reconstruct precise sub-frame coordinate snapshots
local function interpolateSnapshots(older: any, newer: any, targetTime: number)
    local alpha = (targetTime - older.t) / (newer.t - older.t)
    return {
        cf = older.cf:Lerp(newer.cf, alpha),
        size = older.size:Lerp(newer.size, alpha)
    }
end

function CombatChecks.getHistoricalSnapshot(player: Player, targetTime: number)
    local hist = targetHistory[player]
    if not hist or #hist == 0 then return nil end

    local newer, older
    for i = #hist, 1, -1 do
        local record = hist[i]
        if record.t >= targetTime then
            newer = record
        else
            older = record
            break
        end
    end

    if not older and not newer then return nil end
    if not older then return newer end
    if not newer then return older end
    
    return interpolateSnapshots(older, newer, targetTime)
end

function CombatChecks.auditHit(attacker: Player, target: Player, hitPosition: Vector3, isHeadshot: boolean, weaponData: any, rayOrigin: Vector3, rayDir: Vector3)
    if not Cfg.checks.combat then return true end
    local now = workspace:GetServerTimeNow()
    local attackerStats = playerShots[attacker]
    if not attackerStats then return false end

    local cd = weaponData.FireRate or 0.1
    local elapsed = now - attackerStats.lastFire
    if elapsed < (cd - Cfg.fireRateTolerance) then
        Violations.report(attacker, { kind = Reason.WalkSpeed, sev = 5, msg = "Weapon cooldown bypassed (TimeBalance/Firerate hack)", correct = false })
        return false
    end
    attackerStats.lastFire = now
    attackerStats.count += 1

    -- Absolute sub-frame lag rollback calculation
    local ping = math.clamp(attacker:GetNetworkPing(), 0.01, 0.8)
    local targetTime = now - ping
    local historicalSnap = CombatChecks.getHistoricalSnapshot(target, targetTime)
    if not historicalSnap then return false end

    -- Verify 3D slab OBB intersections
    local hitValid, entryDistance = OBB.intersect(rayOrigin, rayDir.Unit, historicalSnap.cf, historicalSnap.size)
    if not hitValid then
        Violations.report(attacker, { kind = Reason.Aimbot, sev = 6, msg = "Raycast intersection test failed (SilentAim / Hitbox manipulation)", correct = false })
        return false
    end

    attackerStats.accHits += 1
    if isHeadshot then
        attackerStats.headshots += 1
    end

    -- Bayesian evaluation curves
    if attackerStats.count >= 20 then
        local smoothAcc, smoothHSR = MathUtils.bayesianSmooth(
            attackerStats.accHits,
            attackerStats.count,
            attackerStats.headshots,
            Cfg.bayesianWeight,
            Cfg.globalMeanAccuracy,
            Cfg.globalMeanHSR
        )

        if smoothAcc > 0.82 or smoothHSR > 0.75 then
            Violations.report(attacker, { kind = Reason.Aimbot, sev = 7, msg = "Mathematical accuracy curves exceeded normal thresholds (Aimbot)", correct = false })
        end
    end

    return true
end

return CombatChecks
