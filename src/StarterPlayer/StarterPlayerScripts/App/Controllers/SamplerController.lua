--strict
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local Cfg = require(SharedApp.Config.QBConfig)
local Wire = require(SharedApp.Networking.QBPackets)
local Names = require(SharedApp.Networking.AntiCheatRemotes)
local Geom = require(SharedApp.Utilities.MathUtils)
local PUSH_INTERVAL = 1 / Cfg.clientHz
local SamplerController = { Name = 'SamplerController' }
local me = Players.LocalPlayer; local sampleRemote = nil; local char, root, humanoid = nil, nil, nil; local seq, clock = 0, 0
local function findSampleRemote(): RemoteEvent
    local remotes = SharedApp:WaitForChild('Remotes')
    local box = remotes:WaitForChild(Names.folder)
    return box:WaitForChild(Names.sample) :: RemoteEvent
end
local function bindCharacter(newChar: Model?) char = newChar; root, humanoid = Geom.rigOf(char) end
local function pushSample()
    if sampleRemote == nil then return end
    if root == nil or humanoid == nil or not root:IsDescendantOf(workspace) then root, humanoid = Geom.rigOf(char) end
    if root == nil or humanoid == nil then return end
    seq += 1
    local payload = Wire.packSample(seq, workspace:GetServerTimeNow(), root.Position, root.AssemblyLinearVelocity, humanoid:GetState(), humanoid.FloorMaterial)
    sampleRemote:FireServer(payload)
end
function SamplerController:Start()
    if me == nil then return end
    sampleRemote = findSampleRemote()
    me.CharacterAdded:Connect(bindCharacter); me.CharacterRemoving:Connect(function() bindCharacter(nil) end)
    RunService.Heartbeat:Connect(function(dt) clock += dt; if clock < PUSH_INTERVAL then return end; clock = 0; pushSample() end)
    bindCharacter(me.Character)
end
return SamplerController