--strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedApp = ReplicatedStorage:WaitForChild("App")
local Cfg = require(SharedApp.Config.QBConfig)
local Geom = require(SharedApp.Utilities.MathUtils)
local Types = require(SharedApp.Types.MovementTypes)
local Reason = require(SharedApp.Enums.Reason)

type Sample = Types.ServerSample
type Violation = Types.Violation

local Physics = {}

local function crossed(from: Vector3, d: Vector3, rp: RaycastParams?): boolean
    local hit = workspace:Raycast(from, d, rp)
    if hit == nil then return false end
    local inst = hit.Instance
    if inst.CanCollide == false then return false end
    if inst:IsA("TrussPart") then return false end
    if hit.Normal.Y > Cfg.wallNormalY then return false end
    return hit.Distance < d.Magnitude - 0.05
end

function Physics.ownership(plr: Player, hrp: BasePart?): Violation?
    if hrp == nil or not Cfg.checks.ownership then return nil end
    local ok, owner = pcall(function() return hrp:GetNetworkOwner() end)
    if not ok then return nil end
    if owner ~= nil and owner ~= plr then
        return { kind = Reason.NetworkOwnership, sev = 4, msg = "Network ownership replication mismatch", correct = true }
    end
    return nil
end

function Physics.verticalVel(s: Sample): Violation?
    if not Cfg.checks.physics then return nil end
    local vy = s.vel.Y
    if vy > Cfg.maxVyUp then
        return { kind = Reason.Physics, sev = 4, msg = "Abnormal vertical climb velocity", correct = true }
    end
    if vy < -Cfg.maxVyDown then
        return { kind = Reason.Physics, sev = 4, msg = "Terminal descent rate exceeded", correct = true }
    end
    return nil
end

function Physics.angularVel(hrp: BasePart?): Violation?
    if hrp == nil or not Cfg.checks.physics then return nil end
    local av = hrp.AssemblyAngularVelocity.Magnitude
    if av > 72 then
        hrp.AssemblyAngularVelocity = Vector3.zero
        return { kind = Reason.Physics, sev = 5, msg = "Extreme angular velocity spike (Rotation exploit/Spinbot)", correct = true }
    end
    return nil
end

function Physics.noclip(prev: Sample?, cur: Sample, rp: RaycastParams?): Violation?
    if prev == nil or not Cfg.checks.noclip then return nil end
    if prev.state == Enum.HumanoidStateType.Climbing or cur.state == Enum.HumanoidStateType.Climbing then
        return nil
    end
    local d = cur.pos - prev.pos
    if d.Magnitude < Cfg.noclipMinCast then return nil end
    if not crossed(prev.pos, d, rp) then return nil end
    return { kind = Reason.Noclip, sev = 6, msg = "Solid boundary penetration (Noclip)", correct = true }
end

function Physics.slope(s: Sample, rp: RaycastParams?): Violation?
    if not s.onFloor then return nil end
    local hit = workspace:Raycast(s.pos, Vector3.new(0, -Cfg.groundRay, 0), rp)
    if hit == nil then
        return { kind = Reason.BadGround, sev = 2, msg = "Grounded state with missing world support", correct = false }
    end
    if hit.Distance > Cfg.maxGroundDist then
        return { kind = Reason.BadGround, sev = 3, msg = "Height offsets exceed valid boundaries", correct = false }
    end
    if Geom.slopeDeg(hit.Normal) > Cfg.maxSlope then
        return { kind = Reason.BadGround, sev = 3, msg = "Slope grade limit exceeded", correct = false }
    end
    return nil
end

return table.freeze(Physics)
