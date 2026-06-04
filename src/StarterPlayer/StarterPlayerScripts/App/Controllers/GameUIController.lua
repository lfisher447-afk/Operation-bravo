--strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local SharedApp = ReplicatedStorage:WaitForChild("App")
local Cfg = require(SharedApp.Config.QBConfig)

local GameUIController = { Name = "GameUIController" }
local me = Players.LocalPlayer

-- Spring class for organic UI motion transitions
local UISpring = {}
UISpring.__index = UISpring

type Spring = {
    x: number,
    v: number,
    t: number,
    k: number,
    d: number,
    update: (self: any, dt: number) -> number
}

function UISpring.new(stiffness: number, damping: number): Spring
    return setmetatable({
        x = 0,
        v = 0,
        t = 0,
        k = stiffness,
        d = damping,
    }, UISpring) :: any
end

function UISpring:update(dt: number): number
    local d = self.t - self.x
    local accel = d * self.k - self.v * self.d
    self.v = self.v + accel * dt
    self.x = self.x + self.v * dt
    return self.x
end

function GameUIController:Start()
    if me == nil then return end
    local screen = Instance.new("ScreenGui")
    screen.Name = "SiegeTacticalHUD"
    screen.ResetOnSpawn = false
    screen.Parent = me:WaitForChild("PlayerGui")

    -- Settings panel Frame setup
    local settingsPanel = Instance.new("Frame")
    settingsPanel.Size = UDim2.new(0, 400, 0, 300)
    settingsPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    settingsPanel.BorderSizePixel = 1
    settingsPanel.BorderColor3 = Color3.fromRGB(0, 255, 65)
    settingsPanel.Parent = screen

    -- Floating settings Button
    local gear = Instance.new("TextButton")
    gear.Size = UDim2.new(0, 40, 0, 40)
    gear.Position = UDim2.new(1, -50, 0, 10)
    gear.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    gear.BorderSizePixel = 1
    gear.BorderColor3 = Color3.fromRGB(0, 255, 65)
    gear.Text = "⚙️"
    gear.TextColor3 = Color3.fromRGB(255, 255, 255)
    gear.Font = Enum.Font.Code
    gear.TextSize = 18
    gear.Parent = screen

    -- Custom UISpring instances for fluid sliding transitions
    local settingsTarget = UISpring.new(120, 14)
    local panelVisible = false

    gear.MouseButton1Click:Connect(function()
        panelVisible = not panelVisible
        settingsTarget.t = panelVisible and 0.5 or -0.5
    end)

    -- Dynamic Slider updates
    local fovInput = Instance.new("TextBox")
    fovInput.Size = UDim2.new(0.9, 0, 0, 35)
    fovInput.Position = UDim2.new(0.05, 0, 0, 80)
    fovInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    fovInput.TextColor3 = Color3.fromRGB(0, 255, 65)
    fovInput.Font = Enum.Font.Code
    fovInput.Text = "90"
    fovInput.PlaceholderText = "FOV Value (60 - 120)"
    fovInput.Parent = settingsPanel

    fovInput.FocusLost:Connect(function()
        local val = tonumber(fovInput.Text) or 90
        val = math.clamp(val, 60, 120)
        fovInput.Text = tostring(val)
        workspace.CurrentCamera.FieldOfView = val
    end)

    RunService.RenderStepped:Connect(function(dt: number)
        local curScale = settingsTarget:update(dt)
        -- smoothly slides the UI panel from off-screen to viewport center
        settingsPanel.Position = UDim2.new(curScale, -200, 0.3, 0)
    end)
end

return GameUIController
