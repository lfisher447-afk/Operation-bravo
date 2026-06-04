--strict
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local ServerApp = ServerScriptService:WaitForChild('App')
local AimTrainerConfig = require(SharedApp.Config.AimTrainerConfig)
local AimTrainerService = { Name = 'AimTrainerService' }
local remotesFolder: Folder? = nil
local trainHitRemote: RemoteEvent? = nil
function AimTrainerService:Init()
    remotesFolder = ReplicatedStorage:WaitForChild('App'):WaitForChild('Remotes')
    local r = Instance.new('RemoteEvent')
    r.Name = 'TrainHit'
    r.Parent = remotesFolder
    trainHitRemote = r
end
function AimTrainerService:Start()
    assert(trainHitRemote ~= nil, 'Remotes must be initialized before boot.')
    trainHitRemote.OnServerEvent:Connect(function(player, categoryName)
        if typeof(categoryName) ~= 'string' then return end
        local catData = AimTrainerConfig.Categories[categoryName]
        if not catData then return end
        local currentCredits = player:GetAttribute('Credits') or 0
        player:SetAttribute('Credits', currentCredits + 10)
        print('[AIM TRAINER]', player.Name, 'earned 10 credits inside category:', categoryName)
    end)
end
return AimTrainerService