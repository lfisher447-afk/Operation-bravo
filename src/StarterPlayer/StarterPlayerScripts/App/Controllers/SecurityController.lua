--strict
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local LogService = game:GetService('LogService')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local Names = require(SharedApp.Networking.AntiCheatRemotes)
local MetatableProtector = require(SharedApp.Utilities.MetatableProtector)
local SecurityController = { Name = 'SecurityController' }
local me = Players.LocalPlayer
local function verifyIndexPerformance()
    local testPart = Instance.new('Part')
    local startMemory = gcinfo()
    for i = 1, 500 do local _ = testPart.Anchored end
    if gcinfo() - startMemory > 0 then return false end
    return true
end
local function verifyPcallStack()
    local stackMatches = false
    pcall(function() if debug.info(2, 'f') == pcall then stackMatches = true end end)
    return stackMatches
end
local function initExecutionLogger()
    LogService.MessageOut:Connect(function(message, messageType)
        if messageType == Enum.MessageType.MessageError then
            if string.find(message, '[string "chunk"]') or string.find(message, '=[C]') then
                task.spawn(function() me:Kick('[DEVIOS Sentinel] Execution Anomaly Registered: '' .. tostring(message) .. ''') end)
            end
        end
    end)
end
function SecurityController:Start()
    if me == nil then return end
    MetatableProtector.freezeTable(MetatableProtector); MetatableProtector.freezeTable(SecurityController)
    local handshakeRemote = SharedApp:WaitForChild('Remotes'):WaitForChild(Names.folder):WaitForChild(Names.handshake) :: RemoteEvent
    handshakeRemote.OnClientEvent:Connect(function(action, challenge)
        if action ~= 'SecHandshake' then return end
        local solved = (challenge * 2) + 12
        handshakeRemote:FireServer('HandshakeResponse', solved)
    end)
    initExecutionLogger()
    task.spawn(function()
        while true do
            task.wait(4)
            if not verifyPcallStack() or not verifyIndexPerformance() then
                me:Kick('[DEVIOS Sentinel] Client sandbox metatable violation.')
                break
            end
        end
    end)
end
return SecurityController