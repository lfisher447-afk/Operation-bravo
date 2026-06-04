--strict
local AimTrainerConfig = {
    Categories = {
        Gridshot = { Name = 'Gridshot', MapName = 'GridshotArena', TargetsCount = 3, SpawnInterval = 0.5, TargetLife = 3.0, Radius = 15 },
        Microshot = { Name = 'Microshot', MapName = 'MicroshotArena', TargetsCount = 2, SpawnInterval = 0.4, TargetLife = 2.0, Radius = 6 },
        Tracking = { Name = 'Tracking', MapName = 'TrackingArena', TargetsCount = 1, SpawnInterval = 5.0, TargetLife = 10.0, Radius = 12, IsMoving = true },
        Reflex = { Name = 'Reflex', MapName = 'ReflexArena', TargetsCount = 1, SpawnInterval = 1.0, TargetLife = 0.75, Radius = 20 },
        Wallburst = { Name = 'Wallburst', MapName = 'WallburstArena', TargetsCount = 5, SpawnInterval = 0.8, TargetLife = 4.0, Radius = 25 }
    }
}
return table.freeze(AimTrainerConfig)