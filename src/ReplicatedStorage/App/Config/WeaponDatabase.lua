--!strict
local WeaponDatabase = {
    R4C = {
        Name = "R4-C",
        Category = "Assault Rifle",
        Damage = 39,
        FireRate = 0.069, -- ~860 RPM
        Ammo = 30,
        MaxAmmo = 150,
        Range = 250,
        HeadshotMult = 1.5,
        RecoilX = 0.22,
        RecoilY = 0.55,
        ZoomFOV = 50, -- 1.5x Holo zoom
        LeanOffset = Vector3.new(0.65, -0.4, -0.9),
        ScopeType = "Holosight",
        ModelType = "R4C"
    },
    L85A2 = {
        Name = "L85A2",
        Category = "Assault Rifle",
        Damage = 47,
        FireRate = 0.089, -- ~675 RPM
        Ammo = 30,
        MaxAmmo = 150,
        Range = 300,
        HeadshotMult = 1.5,
        RecoilX = 0.12,
        RecoilY = 0.42,
        ZoomFOV = 40, -- 2.0x zoom
        LeanOffset = Vector3.new(0.7, -0.45, -1.0),
        ScopeType = "Scope2.0x",
        ModelType = "L85A2"
    },
    MP5 = {
        Name = "MP5",
        Category = "Submachine Gun",
        Damage = 27,
        FireRate = 0.075, -- ~800 RPM
        Ammo = 30,
        MaxAmmo = 150,
        Range = 150,
        HeadshotMult = 1.5,
        RecoilX = 0.09,
        RecoilY = 0.35,
        ZoomFOV = 45, -- 1.5x ACOG
        LeanOffset = Vector3.new(0.55, -0.35, -0.7),
        ScopeType = "ACOG",
        ModelType = "MP5"
    },
    H417 = {
        Name = "417",
        Category = "Designated Marksman Rifle",
        Damage = 69,
        FireRate = 0.25, -- Semi-Auto
        Ammo = 20,
        MaxAmmo = 80,
        Range = 400,
        HeadshotMult = 1.5,
        RecoilX = 0.4,
        RecoilY = 1.8,
        ZoomFOV = 30, -- 3.0x Marksman Optic
        LeanOffset = Vector3.new(0.75, -0.5, -1.1),
        ScopeType = "Scope3.0x",
        ModelType = "H417"
    },
    OTS03 = {
        Name = "OTs-03",
        Category = "Sniper Rifle",
        Damage = 78,
        FireRate = 0.35,
        Ammo = 10,
        MaxAmmo = 50,
        Range = 500,
        HeadshotMult = 2.0,
        RecoilX = 0.5,
        RecoilY = 2.5,
        ZoomFOV = 15, -- 4.0x Thermal Optic
        LeanOffset = Vector3.new(0.8, -0.55, -1.3),
        ScopeType = "Thermal",
        ModelType = "OTS03"
    },
    M590A1 = {
        Name = "M590A1",
        Category = "Shotgun",
        Damage = 48, -- Per pellet
        Pellets = 8,
        FireRate = 0.85, -- Pump action
        Ammo = 7,
        MaxAmmo = 35,
        Range = 35,
        HeadshotMult = 1.1,
        RecoilX = 0.8,
        RecoilY = 4.0,
        ZoomFOV = 65, -- Iron sights zoom
        LeanOffset = Vector3.new(0.5, -0.3, -0.6),
        ScopeType = "IronSights",
        ModelType = "M590A1"
    }
}

return table.freeze(WeaponDatabase)
