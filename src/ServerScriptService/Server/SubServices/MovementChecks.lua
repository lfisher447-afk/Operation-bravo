--!strict
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local ServerApp = ServerScriptService:WaitForChild('App')
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
local function wasClimbing(p: ServerSample?): boolean return p ~= nil and p.state == Enum.HumanoidStateType.Climbing end
function MovementChecks.run(plr: Player, s: Session, sample: ServerSample): Violation
    if s.exempt or sample.t < s.safeUntil or sample.t < s.pauseUntil then
        s.airTime = 0; s.hoverFrames = 0; s.speedStreak = 0
        return { kind = Reason.None, sev = 0, msg = 'ok', correct = false }
    end
    local prev = s.buf:head() :: ServerSample?
    local v: Violation = { kind = Reason.None, sev = 0, msg = 'ok', correct = false }
    return v
end
return table.freeze(MovementChecks)