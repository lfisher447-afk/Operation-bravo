-- [[ VANITY-ANTICHEAT ADMIN PANEL V2.5 ROBLOX ENHANCED ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local vanityAntiCheat = ReplicatedStorage:WaitForChild("VANITY-ANTICHEAT")
local CONFIG = require(vanityAntiCheat:WaitForChild("VANITY-ANTICHEAT-CONFIG"))
local BehaviorAnalyzer = require(vanityAntiCheat:WaitForChild("VANITY-ANTICHEAT-BEHAVIOR-ANALYZER"))
local PhysicsValidator = require(vanityAntiCheat:WaitForChild("VANITY-ANTICHEAT-PHYSICS-VALIDATOR"))
local CombatMonitor = require(vanityAntiCheat:WaitForChild("VANITY-ANTICHEAT-COMBAT-MONITOR"))

local AdminPanel = {}

function AdminPanel.createUI(player)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VanityAntiCheatAdmin"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainPanel"
    mainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
    mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Parent = screenGui
    
    local uiCorner = Instance.new("UICorner", mainFrame)
    uiCorner.CornerRadius = UDim.new(0, 10)
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0.08, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "VANITY ANTI-CHEAT PANEL v" .. CONFIG.VERSION
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    local statsLabel = Instance.new("TextLabel", mainFrame)
    statsLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
    statsLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "ACTIVE PLAYERS: " .. tostring(#Players:GetPlayers()) .. "\nHEALTH LIMITS VALIDATED: " .. tostring(CONFIG.GOD_MODE_DETECTION)
    statsLabel.TextColor3 = Color3.new(1, 1, 1)
    statsLabel.Font = Enum.Font.Gotham
    statsLabel.TextSize = 14
    
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

return AdminPanel
