--strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local SharedApp = ReplicatedStorage:WaitForChild("App")
local ServerApp = ServerScriptService:WaitForChild("App")
local Cfg = require(SharedApp.Config.QBConfig)
local Geom = require(SharedApp.Utilities.MathUtils)
local Types = require(SharedApp.Types.MovementTypes)
local Reason = require(SharedApp.Enums.Reason)

local Physics = require(ServerApp.SubServices.PhysicsChecks)
local SessionMod = require(ServerApp.SubServices.PlayerSession)

type Session = SessionMod.Session
type ServerSample = Types.ServerSample
type Violation = Types.Violation

local MovementChecks = {}

local function worse(a: Violation, b: Violation?): Violation
    if b ~= nil and b.sev > a.sev then return b end
    return a
end

local function wasClimbing(p: ServerSample?): boolean
    return p ~= nil and p.state == Enum.HumanoidStateType.Climbing
end

local function checkSpeed(s: Session, prev: ServerSample?, cur: ServerSample): Violation?
    if prev == nil then return nil end
    if cur.reportedSpeed > Cfg.maxSpeed + 0.5 then
        return { kind = Reason.WalkSpeed, sev = 6, msg = "Spoofed walkspeed limit override", correct = true }
    end

    if wasClimbing(prev) or cur.state == Enum.HumanoidStateType.Climbing then
        s.speedStreak = 0
        s.speedWin:wipe()
        return nil
    end

    local dt = math.max(0.01, cur.dt)
    local disp = cur.pos - prev.pos

    if Cfg.checks.teleport and disp.Magnitude > Cfg.maxTeleport then
        s.speedStreak = 0
        return { kind = Reason.Teleport, sev = 8, msg = "Displacement limit violation", correct = true }
    end

    local fromDisp = Geom.flatMag(disp) / dt
    local fromVel = Geom.flatMag(cur.vel)
    local now = math.max(fromDisp, fromVel)
    s.speedWin:push(now)
    local avg = s.speedWin:avg()

    local cap = cur.walkSpeed * Cfg.speedMult + Cfg.speedMargin
    local fudge = 0

    if not Cfg.checks.speed or avg <= cap + fudge then
        s.speedStreak = math.max(0, s.speedStreak - 1)
        return nil
    end

    s.speedStreak += 1
    if s.speedStreak < Cfg.speedStreak then return nil end

    local bad = avg > cap * 1.45
    return { kind = Reason.Speed, sev = if bad then 6 else 4, msg = "Speed threshold exceeded", correct = bad }
end

local function checkAccel(s: Session, prev: ServerSample?, cur: ServerSample): Violation?
    if prev == nil or not Cfg.checks.accel then return nil end
    local dt = math.max(0.01, cur.dt)
    local dvx = cur.vel.X - prev.vel.X
    local dvz = cur.vel.Z - prev.vel.Z
    local a = math.sqrt(dvx * dvx + dvz * dvz) / dt
    if a <= Cfg.maxAccel then
        s.accelStreak = math.max(0, s.accelStreak - 1)
        return nil
    end
    s.accelStreak += 1
    if s.accelStreak < Cfg.accelStreak then return nil end
    return { kind = Reason.Accel, sev = 3, msg = "Abnormal acceleration spike", correct = false }
end

local function checkAir(s: Session, cur: ServerSample): Violation?
    if cur.onFloor then
        s.airTime = 0
        s.hoverFrames = 0
        s.lastLanded = cur.t
        return nil
    end

    if cur.state == Enum.HumanoidStateType.Jumping then
        s.lastJump = cur.t
    end

    s.airTime += cur.dt
    
    -- Absolute continuous flight threshold check (Concept from PolarCanse)
    if s.airTime > 5.5 then
        return { kind = Reason.Fly, sev = 8, msg = "Continuous flight time limit exceeded", correct = true }
    end

    if not Cfg.checks.airTime or s.airTime <= Cfg.maxAirTime then
        return nil
    end

    if cur.vel.Y <= Cfg.fastFallY then
        s.hoverFrames = 0
        return nil
    end

    local h = Geom.flatMag(cur.vel)
    local lowVy = math.abs(cur.vel.Y) <= Cfg.hoverTopY
    local stuck = lowVy and h <= Cfg.hoverHoldHorizSpeed

    if stuck then
        s.hoverFrames += 1
        if s.hoverFrames >= Cfg.hoverHoldFrames then
            return { kind = Reason.Fly, sev = 5, msg = "Static hover detected", correct = true }
        end
        return nil
    end

    s.hoverFrames = math.max(0, s.hoverFrames - 1)
    if lowVy and s.airTime > Cfg.maxAirTime + 0.5 then
        return { kind = Reason.Fly, sev = 4, msg = "Slow fall state anomaly", correct = true }
    end

    return nil
end

local function checkDrift(s: Session, cur: ServerSample): Violation?
    if s.lastClientPos == nil or not Cfg.checks.desync then return nil end
    local last = s.lastClientPos :: Vector3
    if (last - cur.pos).Magnitude <= Cfg.maxDesync then return nil end
    return { kind = Reason.Desync, sev = 2, msg = "Client desync from physics step", correct = false }
end

function MovementChecks.run(plr: Player, s: Session, sample: ServerSample): Violation
    if s.exempt or sample.t < s.safeUntil or sample.t < s.pauseUntil then
        s.airTime = 0
        s.hoverFrames = 0
        s.speedStreak = 0
        return { kind = Reason.None, sev = 0, msg = "ok", correct = false }
    end

    if Geom.lenientState(sample.state) then
        s.airTime = 0
        s.hoverFrames = 0
        s.speedStreak = 0
        return { kind = Reason.None, sev = 0, msg = "ok", correct = false }
    end

    local prev = s.buf:head() :: ServerSample?
    local v: Violation = { kind = Reason.None, sev = 0, msg = "ok", correct = false }

    v = worse(v, checkSpeed(s, prev, sample))
    v = worse(v, checkAccel(s, prev, sample))
    v = worse(v, checkAir(s, sample))
    v = worse(v, checkDrift(s, sample))
    v = worse(v, Physics.verticalVel(sample))
    v = worse(v, Physics.angularVel(s.root))
    v = worse(v, Physics.ownership(plr, s.root))
    v = worse(v, Physics.slope(sample, s.rayParams))
    if not wasClimbing(prev) then
        v = worse(v, Physics.noclip(prev, sample, s.rayParams))
    end

    return v
end

return table.freeze(MovementChecks)
