--strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedApp = ReplicatedStorage:WaitForChild("App")
local Geom = require(SharedApp.Utilities.MathUtils)
local Types = require(SharedApp.Types.MovementTypes)

local Sampler = {}

-- Safely calculates server-authoritative parameters without trusting client-reported states
function Sampler.snap(session: any, now: number, dt: number): Types.ServerSample?
    local root = session.root
    local hum = session.humanoid
    if not root or not hum or not root:IsDescendantOf(workspace) then
        return nil
    end

    local pos = root.Position
    local vel = root.AssemblyLinearVelocity
    local state = hum:GetState()
    local floor = hum.FloorMaterial
    local onFloor = Geom.onFloor(floor, state)
    local walkSpeed = hum.WalkSpeed

    local reportedSpeed = 0
    if session.lastClientVel then
        reportedSpeed = session.lastClientVel.Magnitude
    else
        reportedSpeed = vel.Magnitude
    end

    return {
        t = now,
        dt = Geom.clampDt(dt),
        pos = pos,
        vel = vel,
        cf = root.CFrame,
        state = state,
        floor = floor,
        onFloor = onFloor,
        walkSpeed = walkSpeed,
        reportedSpeed = reportedSpeed,
    }
end

return Sampler
