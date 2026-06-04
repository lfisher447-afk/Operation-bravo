--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

ReplicatedFirst:RemoveDefaultLoadingScreen()

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

local screen = Instance.new("ScreenGui")
screen.Name = "SiegeFPS_LoadingScreen"
screen.IgnoreGuiInset = true
screen.DisplayOrder = 1000

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(13, 17, 23)
bg.Parent = screen

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.1, 0)
label.Position = UDim2.new(0, 0, 0.45, 0)
label.BackgroundTransparency = 1
label.Text = "[ LOADING TACTICAL ASSETS... ]"
label.TextColor3 = Color3.fromRGB(0, 255, 65)
label.Font = Enum.Font.Code
label.TextSize = 24
label.Parent = bg

screen.Parent = pgui

task.wait(2.5)

TweenService:Create(bg, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
TweenService:Create(label, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 1 }):Play()

task.wait(0.8)
screen:Destroy()