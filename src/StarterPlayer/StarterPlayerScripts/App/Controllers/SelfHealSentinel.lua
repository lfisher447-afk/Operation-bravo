--strict
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local Names = require(SharedApp.Networking.AntiCheatRemotes)
local HookSentinel = require(SharedApp.Utilities.HookSentinel)
local SelfHealSentinel = { Name = 'SelfHealSentinel' }
local me = Players.LocalPlayer
function SelfHealSentinel:Start()
    if me == nil then return end
    task.spawn(function()
        while true do
            task.wait(3)
            if not HookSentinel.checkSystemIntegrity() then
                local securePcall = HookSentinel.getSafePcall()
                securePcall(function() warn('[SENTINEL HEAL] System hook detour detected. Re-routing security telemetry channels.') end)
                local handshakeRemote = SharedApp:WaitForChild('App'):WaitForChild('Remotes'):WaitForChild(Names.folder):WaitForChild(Names.handshake) :: RemoteEvent
                handshakeRemote:FireServer('HandshakeResponse', 0)
                break
            end
        end
    end)
end
return SelfHealSentinel