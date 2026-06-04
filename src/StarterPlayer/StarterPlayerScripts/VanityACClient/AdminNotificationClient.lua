local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local vanityAntiCheat = ReplicatedStorage:WaitForChild("VANITY-ANTICHEAT")
local CONFIG = require(vanityAntiCheat:WaitForChild("VANITY-ANTICHEAT-CONFIG"))

local notificationEvent = ReplicatedStorage:WaitForChild("AdminNotification", 5) or Instance.new("RemoteEvent")
notificationEvent.Name = "AdminNotification"
notificationEvent.Parent = ReplicatedStorage

local NOTIFICATION_TYPES = {
    INFO = { COLOR = Color3.fromRGB(30, 144, 255), ICON = "ℹ️", SOUND = "rbxasset://sounds/info.mp3", PRIORITY = 1 },
    WARNING = { COLOR = Color3.fromRGB(255, 165, 0), ICON = "⚠️", SOUND = "rbxasset://sounds/warning.mp3", PRIORITY = 2 },
    ERROR = { COLOR = Color3.fromRGB(255, 0, 0), ICON = "❌", SOUND = "rbxasset://sounds/error.mp3", PRIORITY = 3 },
    CRITICAL = { COLOR = Color3.fromRGB(139, 0, 0), ICON = "🚨", SOUND = "rbxasset://sounds/critical.mp3", PRIORITY = 4, PERSISTENT = true },
}

local notificationSystem = { queue = {}, active = {}, isProcessing = false }

local function playSound(soundId)
    local s = Instance.new("Sound")
    s.SoundId = soundId
    s.Volume = 0.5
    s.Parent = SoundService
    s:Play()
    game:GetService("Debris"):AddItem(s, 3)
end

local function animate(container, typeData)
    local duration = CONFIG.NOTIFICATION_DURATION or 5
    TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Position = UDim2.new(0.35, 0, 0, 0) }):Play()
    
    if not typeData.PERSISTENT then
        task.wait(duration)
        local t = TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Position = UDim2.new(0.35, 0, -0.2, 0) })
        t:Play()
        t.Completed:Connect(function()
            container.Parent:Destroy()
        end)
    end
end

local function createUI(message, typeName)
    local typeData = NOTIFICATION_TYPES[typeName] or NOTIFICATION_TYPES.INFO
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local screen = Instance.new("ScreenGui", playerGui)
    screen.Name = "VanityNotification"
    screen.DisplayOrder = 999

    local container = Instance.new("Frame", screen)
    container.Size = UDim2.new(0.3, 0, 0.15, 0)
    container.Position = UDim2.new(0.35, 0, -0.2, 0)
    container.BackgroundColor3 = typeData.COLOR
    container.BorderSizePixel = 0

    local uiCorner = Instance.new("UICorner", container)
    uiCorner.CornerRadius = UDim.new(0, 8)

    local textLabel = Instance.new("TextLabel", container)
    textLabel.Size = UDim2.new(0.8, 0, 1, 0)
    textLabel.Position = UDim2.new(0.15, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = typeData.ICON .. " " .. message
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextWrapped = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14

    playSound(typeData.SOUND)
    animate(container, typeData)
end

notificationEvent.OnClientEvent:Connect(function(message, typeName)
    createUI(message, typeName)
end)

return { queueNotification = createUI }
