--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PulsarPwnzorController = { Name = "PulsarPwnzorController" }
local me = Players.LocalPlayer
local camera = workspace.CurrentCamera
local AFK_TIMEOUT = 1800
local KICK_TIMER = 30
local MAX_ASPECT_RATIO = 2.4
local MIN_ASPECT_RATIO = 1.0
local MAX_FOV = 120
local MIN_FOV = 30
local lastInputTime = os.clock()
local aspectRatioViolationStart: number? = nil
local function checkAFK()
    if os.clock() - lastInputTime > AFK_TIMEOUT then
        me:Kick("[PULSAR PWNZOR] Inactivity timeout reached.")
    end
end
local function checkAspectRatio()
    local size = camera.ViewportSize
    if size.X == 0 or size.Y == 0 then return end
    local aspect = size.X / size.Y
    if aspect > MAX_ASPECT_RATIO or aspect < MIN_ASPECT_RATIO then
        if not aspectRatioViolationStart then
            aspectRatioViolationStart = os.clock()
        elseif os.clock() - aspectRatioViolationStart > KICK_TIMER then
            me:Kick(string.format("[PULSAR PWNZOR] Aspect Ratio Breach: %.2f.", aspect))
        end
    else
        aspectRatioViolationStart = nil
    end
end
local function checkFOV()
    local fov = camera.FieldOfView
    if fov > MAX_FOV or fov < MIN_FOV then
        me:Kick(string.format("[PULSAR PWNZOR] Field Of View out of bounds: %d.", fov))
    end
end
function PulsarPwnzorController:Start()
    if me == nil then return end
    UserInputService.InputBegan:Connect(function() lastInputTime = os.clock() end)
    UserInputService.PointerAction:Connect(function() lastInputTime = os.clock() end)
    task.spawn(function()
        while true do
            task.wait(1)
            checkAFK()
            checkAspectRatio()
            checkFOV()
        end
    end)
end
return PulsarPwnzorController