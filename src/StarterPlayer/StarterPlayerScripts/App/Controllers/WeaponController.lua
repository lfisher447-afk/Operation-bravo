--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local SharedApp = ReplicatedStorage:WaitForChild("App")
local WeaponConfig = require(SharedApp.Config.WeaponConfig)
local ProceduralModeler = require(SharedApp.Utilities.ProceduralModeler)
local Packets = require(SharedApp.Networking.QBPackets)

local WeaponController = { Name = "WeaponController" }
local me = Players.LocalPlayer
local camera = workspace.CurrentCamera

local currentWeaponName = "Saqire367"
local activeViewModel: Model? = nil
local adsActive = false
local currentZoomFOV = 90

local clientSequence = 0

local function renderViewModel()
    if activeViewModel then activeViewModel:Destroy() end
    
    local model = ProceduralModeler.buildWeapon(currentWeaponName)
    model.Parent = camera
    activeViewModel = model
    
    RunService:BindToRenderStep("ViewModelRig", Enum.RenderPriority.Camera.Value - 1, function(dt: number)
        if not activeViewModel or not activeViewModel.PrimaryPart then return end
        
        -- Interpolate view-model coordinates for ADS Scoping
        local targetOffset = CFrame.new(0.5, -0.6, -1.5)
        if adsActive then
            targetOffset = CFrame.new(0, -0.35, -1.0) -- Scope aligns perfectly to viewport center
        end
        
        local cf = camera.CFrame * targetOffset
        activeViewModel:PivotTo(cf)
        
        -- Smooth optic zoom translation
        local zoomSpeed = 15
        local targetFOV = adsActive and 45 or 90
        currentZoomFOV = currentZoomFOV + (targetFOV - currentZoomFOV) * math.min(1, dt * zoomSpeed)
        camera.FieldOfView = currentZoomFOV
    end)
end

function WeaponController:Start()
    if me == nil then return end
    
    me.CharacterAdded:Connect(function()
        renderViewModel()
    end)
    
    if me.Character then
        renderViewModel()
    end

    -- Capture Aim Down Sights (ADS MouseButton2)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            adsActive = true
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Tactical Ticking Remote dispatch
            local ray = camera:ViewportPointToRay(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            local targetPlayer = Players:GetPlayers()[2] -- Mock target index
            
            if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
                clientSequence += 1
                local hitPos = targetPlayer.Character.PrimaryPart.Position
                
                -- Encrypt & sign arguments dynamically (Metamethod Hook Defense)
                local seed = me.UserId
                local securityHash = Packets.generateHash(seed, me.UserId, math.floor(hitPos.X * 10) + clientSequence)
                
                local remotes = SharedApp:WaitForChild("Remotes")
                local dealDamage = remotes:WaitForChild("DealDamage") :: RemoteEvent
                
                dealDamage:FireServer(
                    targetPlayer,
                    hitPos,
                    true,
                    currentWeaponName,
                    ray.Origin,
                    ray.Direction,
                    workspace:GetServerTimeNow(),
                    clientSequence,
                    securityHash
                )
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            adsActive = false
        end
    end)
end

return WeaponController
