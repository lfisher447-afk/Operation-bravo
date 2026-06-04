local ReplicatedStorage = game:GetService('ReplicatedStorage')
local remotesFolder = ReplicatedStorage:WaitForChild('Remotes')
local RemoteDefinitions = {
    Announcement = remotesFolder:WaitForChild('Announcement', 5),
    RoundState = remotesFolder:WaitForChild('RoundState', 5),
    HealthUpdate = remotesFolder:WaitForChild('HealthUpdate', 5),
}
return table.freeze(RemoteDefinitions)