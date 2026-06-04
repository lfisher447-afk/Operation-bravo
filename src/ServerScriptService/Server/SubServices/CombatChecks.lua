--strict
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local ServerScriptService = game:GetService('ServerScriptService')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local ServerApp = ServerScriptService:WaitForChild('App')
local Cfg = require(SharedApp.Config.QBConfig)
local MathUtils = require(SharedApp.Utilities.MathUtils)
local OBB = require(SharedApp.Utilities.OBB)
local Reason = require(SharedApp.Enums.Reason)
local Violations = require(ServerApp.SubServices.ViolationHandler)
local CombatChecks = {}
function CombatChecks.initPlayer(player: Player)
end
function CombatChecks.clearPlayer(player: Player)
end
function CombatChecks.auditHit(attacker: Player, target: Player, hitPosition: Vector3, isHeadshot: boolean, weaponData: any, rayOrigin: Vector3, rayDir: Vector3)
    return true
end
return CombatChecks