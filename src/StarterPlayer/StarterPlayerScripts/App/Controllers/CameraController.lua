--!strict
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local CameraController = { Name = 'CameraController' }
local camera = workspace.CurrentCamera
local me = Players.LocalPlayer; local leanTarget, leanOffset, leanRoll = 0, 0, 0
local function updateLean(dt: number)
    local speed = 12
    leanOffset = leanOffset + (leanTarget * 1.5 - leanOffset) * math.min(1, dt * speed)
    leanRoll = leanRoll + (leanTarget * -10 - leanRoll) * math.min(1, dt * speed)
end
function CameraController:Start()
    if me == nil then return end
    game.Lighting.Ambient = Color3.fromRGB(20, 20, 25); game.Lighting.OutdoorAmbient = Color3.fromRGB(35, 35, 40); game.Lighting.GlobalShadows = true
    local bloom = Instance.new('BloomEffect'); bloom.Intensity = 0.35; bloom.Size = 12; bloom.Parent = game.Lighting
    local colorCorrection = Instance.new('ColorCorrectionEffect'); colorCorrection.Brightness = 0.05; colorCorrection.Contrast = 0.15; colorCorrection.Saturation = -0.05; colorCorrection.Parent = game.Lighting
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.Q then leanTarget = (leanTarget == -1) and 0 or -1
        elseif input.KeyCode == Enum.KeyCode.E then leanTarget = (leanTarget == 1) and 0 or 1 end
    end)
    RunService:BindToRenderStep('TacticalLeanCamera', Enum.RenderPriority.Camera.Value + 1, function(dt)
        updateLean(dt)
        camera.CFrame = camera.CFrame * CFrame.new(leanOffset, 0, 0) * CFrame.Angles(0, 0, math.rad(leanRoll))
    end)
end
return CameraController