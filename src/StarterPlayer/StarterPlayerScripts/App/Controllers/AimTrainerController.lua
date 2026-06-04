--!strict
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local AimTrainerConfig = require(SharedApp.Config.AimTrainerConfig)
local AimTrainerController = { Name = 'AimTrainerController' }
local me = Players.LocalPlayer
local function createTarget(parent: Instance, pos: Vector3, categoryName: string)
    local part = Instance.new('Part')
    part.Size = Vector3.new(2, 2, 2); part.Shape = Enum.PartType.Ball; part.Color = Color3.fromRGB(0, 255, 65); part.Material = Enum.Material.Neon; part.Position = pos; part.CanCollide = false; part.Anchored = true; part.Parent = parent
    local clickDetector = Instance.new('ClickDetector')
    clickDetector.MaxActivationDistance = 300; clickDetector.Parent = part
    clickDetector.MouseClick:Connect(function()
        part:Destroy()
        local remotes = SharedApp:WaitForChild('Remotes')
        local trainHit = remotes:WaitForChild('TrainHit') :: RemoteEvent
        trainHit:FireServer(categoryName)
    end)
end
function AimTrainerController:StartAimTrainer(categoryName: string)
    local catData = AimTrainerConfig.Categories[categoryName]
    if not catData then return end
    local arena = Instance.new('Folder'); arena.Name = 'TrainerArena'; arena.Parent = workspace
    for i = 1, catData.TargetsCount do
        local offset = Vector3.new(math.random(-catData.Radius, catData.Radius), math.random(5, catData.Radius), math.random(-catData.Radius, catData.Radius))
        createTarget(arena, me.Character.PrimaryPart.Position + offset, categoryName)
    end
end
function AimTrainerController:Start() end
return AimTrainerController