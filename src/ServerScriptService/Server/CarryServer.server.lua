local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PhysicsService = game:GetService('PhysicsService')
pcall(function() PhysicsService:RegisterCollisionGroup('CarriedGroup'); PhysicsService:CollisionGroupSetCollidable('CarriedGroup', 'Default', false) end)
local CarryRemote = ReplicatedStorage:FindFirstChild('CarryRemote') or Instance.new('RemoteEvent', ReplicatedStorage)
CarryRemote.Name = 'CarryRemote'
print('[CARRY SYSTEM] Carry Server operational.')