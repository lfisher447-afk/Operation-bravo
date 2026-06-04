--!strict
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')
local SharedApp = ReplicatedStorage:WaitForChild('App')
local ServerApp = ServerScriptService:WaitForChild('App')
local Cfg = require(SharedApp.Config.QBConfig)
local WeaponConfig = require(SharedApp.Config.WeaponConfig)
local CombatChecks = require(ServerApp.SubServices.CombatChecks)
local WeaponService = { Name = 'WeaponService' }
local remotesFolder: Folder? = nil
local dealDamageRemote: RemoteEvent? = nil
function WeaponService:Init()
    remotesFolder = ReplicatedStorage:WaitForChild('App'):WaitForChild('Remotes')
    local d = Instance.new('RemoteEvent')
    d.Name = 'DealDamage'
    d.Parent = remotesFolder
    dealDamageRemote = d
end
function WeaponService:Start()
    assert(dealDamageRemote ~= nil, 'Remotes must be initialized before boot.')
    dealDamageRemote.OnServerEvent:Connect(function(player, targetPlayer, hitPosition, isHeadshot, weaponName, rayOrigin, rayDir)
        if typeof(targetPlayer) ~= 'Instance' or not targetPlayer:IsA('Player') then return end
        if typeof(hitPosition) ~= 'Vector3' or typeof(rayOrigin) ~= 'Vector3' or typeof(rayDir) ~= 'Vector3' then return end
        if typeof(weaponName) ~= 'string' or typeof(isHeadshot) ~= 'boolean' then return end
        local weaponData = WeaponConfig[weaponName]
        if not weaponData then return end
        local ok = CombatChecks.auditHit(player, targetPlayer, hitPosition, isHeadshot, weaponData, rayOrigin, rayDir)
        if not ok then return end
        local char = targetPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        if hum and hum.Health > 0 then
            local dmg = weaponData.Damage
            if isHeadshot then dmg = dmg * weaponData.HeadshotMult end
            hum:TakeDamage(dmg)
            print('[WEAPON AUTHORIZER]', player.Name, 'landed a shot on', targetPlayer.Name, 'for', dmg, 'damage.')
        end
    end)
end
return WeaponService