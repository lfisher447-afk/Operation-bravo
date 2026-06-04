--!strict
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local WeaponConfig = require(SharedApp.Config.WeaponConfig)
local ProceduralModeler = require(SharedApp.Utilities.ProceduralModeler)
local WeaponController = { Name = 'WeaponController' }
local me = Players.LocalPlayer; local currentWeaponName = 'Saqire367'; local activeViewModel = nil
local function renderViewModel()
    if activeViewModel then activeViewModel:Destroy() end
    local model = ProceduralModeler.buildWeapon(currentWeaponName)
    local camera = workspace.CurrentCamera
    model.Parent = camera; activeViewModel = model
    RunService:BindToRenderStep('ViewModelRig', Enum.RenderPriority.Camera.Value - 1, function()
        if not activeViewModel or not activeViewModel.PrimaryPart then return end
        activeViewModel:PivotTo(camera.CFrame * CFrame.new(0.5, -0.6, -1.5))
    end)
end
function WeaponController:Start()
    if me == nil then return end
    me.CharacterAdded:Connect(function(char) renderViewModel() end)
    if me.Character then renderViewModel() end
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local camera = workspace.CurrentCamera
            local ray = camera:ViewportPointToRay(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            local targetPlayer = Players:GetPlayers()[2]
            if targetPlayer then
                local remotes = SharedApp:WaitForChild('Remotes')
                local dealDamage = remotes:WaitForChild('DealDamage') :: RemoteEvent
                dealDamage:FireServer(targetPlayer, targetPlayer.Character.PrimaryPart.Position, true, currentWeaponName, ray.Origin, ray.Direction)
            end
        end
    end)
end
return WeaponController