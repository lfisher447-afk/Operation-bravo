--strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedApp = ReplicatedStorage:WaitForChild("App")
local Cfg = require(SharedApp.Config.QBConfig)

local GameUIController = { Name = "GameUIController" }
local me = Players.LocalPlayer

local function buildScoreboard(parent: Instance): Frame
    local board = Instance.new("Frame")
    board.Name = "Scoreboard"
    board.Size = UDim2.new(0, 600, 0, 350)
    board.Position = UDim2.new(0.5, -300, 0.25, 0)
    board.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    board.BorderSizePixel = 2
    board.BorderColor3 = Color3.fromRGB(0, 255, 65)
    board.Visible = false
    board.Parent = parent

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    header.Text = "  TEAM SCOREBOARD  |  SIEG_TACTICAL_FPS"
    header.TextColor3 = Color3.fromRGB(0, 255, 65)
    header.Font = Enum.Font.Code
    header.TextSize = 13
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = board

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -20, 1, -55)
    list.Position = UDim2.new(0, 10, 0, 45)
    list.BackgroundTransparency = 1
    list.CanvasSize = UDim2.new(0, 0, 5, 0)
    list.Parent = board

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = list

    local function updateScores()
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -10, 0, 30)
            row.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
            row.BorderSizePixel = 0
            row.Parent = list

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "  " .. p.Name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.Code
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row

            local stats = Instance.new("TextLabel")
            stats.Size = UDim2.new(0.6, 0, 1, 0)
            stats.Position = UDim2.new(0.4, 0, 0, 0)
            stats.BackgroundTransparency = 1
            local kills = p:GetAttribute("Kills") or 0
            local deaths = p:GetAttribute("Deaths") or 0
            local credits = p:GetAttribute("Credits") or 0
            stats.Text = string.format("KILLS: %d  |  DEATHS: %d  |  CREDITS: %d", kills, deaths, credits)
            stats.TextColor3 = Color3.fromRGB(0, 255, 65)
            stats.Font = Enum.Font.Code
            stats.TextSize = 11
            stats.TextXAlignment = Enum.TextXAlignment.Right
            stats.Parent = row
        end
    end

    Players.PlayerAdded:Connect(updateScores)
    Players.PlayerRemoving:Connect(updateScores)
    updateScores()

    return board
end

local function buildSettings(parent: Instance): Frame
    local panel = Instance.new("Frame")
    panel.Name = "SettingsPanel"
    panel.Size = UDim2.new(0, 400, 0, 300)
    panel.Position = UDim2.new(0.5, -200, 0.3, 0)
    panel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    panel.BorderSizePixel = 1
    panel.BorderColor3 = Color3.fromRGB(0, 255, 65)
    panel.Visible = false
    panel.Parent = parent

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    header.Text = "  TACTICAL SETTINGS OVERRIDES"
    header.TextColor3 = Color3.fromRGB(0, 255, 65)
    header.Font = Enum.Font.Code
    header.TextSize = 12
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = panel

    -- FOV Settings Option
    local fovLabel = Instance.new("TextLabel")
    fovLabel.Size = UDim2.new(0.9, 0, 0, 25)
    fovLabel.Position = UDim2.new(0.05, 0, 0, 50)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "Field of View: 90"
    fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fovLabel.Font = Enum.Font.Code
    fovLabel.TextSize = 11
    fovLabel.TextXAlignment = Enum.TextXAlignment.Left
    fovLabel.Parent = panel

    local fovSlider = Instance.new("TextBox")
    fovSlider.Size = UDim2.new(0.9, 0, 0, 30)
    fovSlider.Position = UDim2.new(0.05, 0, 0, 80)
    fovSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    fovSlider.TextColor3 = Color3.fromRGB(0, 255, 65)
    fovSlider.Font = Enum.Font.Code
    fovSlider.Text = "90"
    fovSlider.Parent = panel

    fovSlider.FocusLost:Connect(function(enterPressed)
        local val = tonumber(fovSlider.Text) or 90
        val = math.clamp(val, 60, 120)
        fovSlider.Text = tostring(val)
        fovLabel.Text = "Field of View: " .. tostring(val)
        workspace.CurrentCamera.FieldOfView = val
    end)

    -- Sensitivity Control
    local sensLabel = Instance.new("TextLabel")
    sensLabel.Size = UDim2.new(0.9, 0, 0, 25)
    sensLabel.Position = UDim2.new(0.05, 0, 0, 130)
    sensLabel.BackgroundTransparency = 1
    sensLabel.Text = "Mouse Sensitivity Factor:"
    sensLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sensLabel.Font = Enum.Font.Code
    sensLabel.TextSize = 11
    sensLabel.TextXAlignment = Enum.TextXAlignment.Left
    sensLabel.Parent = panel

    local sensSlider = Instance.new("TextBox")
    sensSlider.Size = UDim2.new(0.9, 0, 0, 30)
    sensSlider.Position = UDim2.new(0.05, 0, 0, 160)
    sensSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    sensSlider.TextColor3 = Color3.fromRGB(0, 255, 65)
    sensSlider.Font = Enum.Font.Code
    sensSlider.Text = "1.0"
    sensSlider.Parent = panel

    sensSlider.FocusLost:Connect(function()
        local val = tonumber(sensSlider.Text) or 1.0
        val = math.clamp(val, 0.1, 5.0)
        sensSlider.Text = string.format("%.2f", val)
    end)

    return panel
end

function GameUIController:Start()
    if me == nil then return end
    local screen = Instance.new("ScreenGui")
    screen.Name = "SiegeScoreboardUI"
    screen.ResetOnSpawn = false
    screen.Parent = me:WaitForChild("PlayerGui")

    local board = buildScoreboard(screen)
    local settings = buildSettings(screen)

    -- floating UI Settings Button
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

    gear.MouseButton1Click:Connect(function()
        settings.Visible = not settings.Visible
    end)

    -- Tab Key Inputs
    UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.Tab then
            board.Visible = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.Tab then
            board.Visible = false
        end
    end)
end

return GameUIController
