--strict
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local Names = require(SharedApp.Networking.AntiCheatRemotes)
local Packets = require(SharedApp.Networking.QBPackets)
local DeviosUIController = { Name = 'DeviosUIController' }
local me = Players.LocalPlayer
local function buildUI(adminLink: RemoteEvent, sessionSeed: number, bansList: any, currentAdmins: any, currentGroup: any)
    local screen = Instance.new('ScreenGui')
    screen.Name = 'DeviosPanel'; screen.ResetOnSpawn = false; screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local main = Instance.new('Frame')
    main.Size = UDim2.new(0, 500, 0, 320); main.Position = UDim2.new(0.5, -250, 0.5, -160); main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); main.BorderSizePixel = 2; main.BorderColor3 = Color3.fromRGB(0, 255, 65); main.Parent = screen
    local header = Instance.new('TextLabel')
    header.Size = UDim2.new(1, 0, 0, 35); header.BackgroundColor3 = Color3.fromRGB(5, 5, 5); header.Text = ' [ DEVIOS SENTINEL v5.0 CONTROL DECK ]'; header.TextColor3 = Color3.fromRGB(0, 255, 65); header.Font = Enum.Font.Code; header.TextSize = 13; header.TextXAlignment = Enum.TextXAlignment.Left; header.Parent = main
    screen.Parent = me:WaitForChild('PlayerGui')
end
function DeviosUIController:Start()
    if me == nil then return end
    local remotes = SharedApp:WaitForChild('Remotes')
    local adminVerify = remotes:WaitForChild(Names.adminVerify) :: RemoteFunction
    local adminLink = remotes:WaitForChild(Names.adminLink) :: RemoteEvent
    local authorized, sessionSeed, activeBans, currentAdmins, currentGroup = adminVerify:InvokeServer()
    if not authorized then return end
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
            if me.PlayerGui:FindFirstChild('DeviosPanel') then
                me.PlayerGui.DeviosPanel:Destroy()
            else
                buildUI(adminLink, sessionSeed, activeBans, currentAdmins, currentGroup)
            end
        end
    end)
end
return DeviosUIController