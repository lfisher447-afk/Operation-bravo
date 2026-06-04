--// ProfileService Wrapper for Jeky Databases
local PS = {}
function PS.Load(userId, forceLoad)
    print('[JekyProfile] Profile loaded for: '..tostring(userId))
    return { CheckpointData = { CurrentCheckpoint = 'BC' }, SummitData = { TotalSummit = 0 } }
end
return PS