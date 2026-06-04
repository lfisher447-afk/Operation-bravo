--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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
local clientSequence = 0

-- 3D Physical Spring Solver Class for organic recoil, sway, and ADS transitions
local Spring = {}
Spring.__index = Spring

type SpringSolver = {
    x: Vector3,
    v: Vector3,
    t: Vector3,
    m: number,
    f: number,
    d: number,
    s: number,
    update: (self: any, dt: number) -> Vector3,
    shove: (self: any, force: Vector3) -> ()
}

function Spring.new(mass: number, force: number, damping: number, speed: number): SpringSolver
    return setmetatable({
        x = Vector3.zero,
        v = Vector3.zero,
        t = Vector3.zero,
        m = mass,
        f = force,
        d = damping,
        s = speed,
    }, Spring) :: any
end

function Spring:update(dt: number): Vector3
    local d = self.t - self.x
    local accel = (d * self.f - self.v * self.d) / self.m
    self.v = self.v + accel * dt * self.s
    self.x = self.x + self.v * dt * self.s
    return self.x
end

function Spring:shove(force: Vector3)
    self.v = self.v + force
end

-- Initialize organic sway and kick spring mechanics
local swaySpring = Spring.new(1.0, 180, 14, 4)
local recoilSpring = Spring.new(1.0, 220, 16, 5)
local adsSpring = Spring.new(1.0, 120, 15, 4)

local function renderViewModel()
    if activeViewModel then activeViewModel:Destroy() end
    
    local model = ProceduralModeler.buildWeapon(currentWeaponName)
    model.Parent = camera
    activeViewModel = model
    
    local lastMouseDelta = Vector2.zero
    
    RunService:BindToRenderStep("ViewModelRig", Enum.RenderPriority.Camera.Value - 1, function(dt: number)
        if not activeViewModel or not activeViewModel.PrimaryPart then return end
        
        -- 1. Update Weapon Sway Springs
        local mouseDelta = UserInputService:GetMouseDelta()
        local swayForce = Vector3.new(-mouseDelta.X * 0.005, mouseDelta.Y * 0.005, 0)
        swaySpring:shove(swayForce)
        local curSway = swaySpring:update(dt)
        
        -- 2. Update Recoil Springs
        local curRecoil = recoilSpring:update(dt)
        
        -- 3. Update ADS Springs
        adsSpring.t = adsActive and Vector3.new(0, -0.35, -1.0) or Vector3.new(0.5, -0.6, -1.5)
        local curPos = adsSpring:update(dt)
        
        -- 4. Apply Spring forces to Weapon viewmodel pivot
        local targetCF = camera.CFrame 
            * CFrame.new(curPos + curSway + Vector3.new(0, 0, curRecoil.Z)) 
            * CFrame.Angles(curRecoil.Y, curRecoil.X, 0)
        
        activeViewModel:PivotTo(targetCF)
        
        -- Smooth FOV Zoom transitions
        local targetFOV = adsActive and 45 or 90
        camera.FieldOfView = camera.FieldOfView + (targetFOV - camera.FieldOfView) * math.min(1, dt * 15)
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

    -- Capture Aim Down Sights (MouseButton2) & Combat Fire (MouseButton1)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            adsActive = true
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ray = camera:ViewportPointToRay(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            
            -- Cast local ray to find hit targets and physical objects
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = { me.Character, activeViewModel }
            
            local hit = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
            
            -- Apply organic visual recoil kicks
            recoilSpring:shove(Vector3.new(
                math.random(-10, 10) * 0.002, 
                math.random(15, 30) * 0.002, 
                math.random(10, 20) * 0.01
            ))
            
            if hit then
                local hitInstance = hit.Instance
                local hitPosition = hit.Position
                
                -- Route Aim Trainer Hits if target is hit locally
                if hitInstance.Name == "AimTrainerTarget" then
                    local trainer = require(script.Parent.AimTrainerController)
                    trainer:RegisterRaycastHit(hitInstance, hitPosition)
                    return
                end
                
                -- Find valid players and transmit verified damage remotes
                local targetPlayer: Player? = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= me and p.Character and hitInstance:IsDescendantOf(p.Character) then
                        targetPlayer = p
                        break
                    end
                end
                
                if targetPlayer then
                    clientSequence += 1
                    
                    -- Encrypt payload with server rolling-seed clock
                    local rotatingSeed = math.floor(workspace:GetServerTimeNow())
                    local securityHash = Packets.generateHash(rotatingSeed, me.UserId, math.floor(hitPosition.X * 10) + clientSequence)
                    
                    local remotes = SharedApp:WaitForChild("Remotes")
                    local dealDamage = remotes:WaitForChild("DealDamage") :: RemoteEvent
                    
                    dealDamage:FireServer(
                        targetPlayer,
                        hitPosition,
                        hitInstance.Name == "Head" or hitInstance.Name == "UpperTorso",
                        currentWeaponName,
                        ray.Origin,
                        ray.Direction,
                        workspace:GetServerTimeNow(),
                        clientSequence,
                        securityHash
                    )
                end
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
