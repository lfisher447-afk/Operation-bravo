--!strict
local WeaponConfig = {
    M4A1 = { Name = 'M4A1', Damage = 34, FireRate = 0.075, Ammo = 30, MaxAmmo = 120, Range = 250, HeadshotMult = 1.4, LeanOffset = Vector3.new(0.6, -0.4, -0.8), RecoilX = 0.15, RecoilY = 0.4, ModelType = 'M4A1' },
    DLQ33 = { Name = 'DLQ33', Damage = 95, FireRate = 1.2, Ammo = 5, MaxAmmo = 15, Range = 500, HeadshotMult = 2.0, LeanOffset = Vector3.new(0.8, -0.5, -1.2), RecoilX = 0.5, RecoilY = 2.0, ModelType = 'DLQ33' },
    Saqire367 = { Name = 'Saqire367', Damage = 120, FireRate = 1.5, Ammo = 7, MaxAmmo = 21, Range = 600, HeadshotMult = 2.5, LeanOffset = Vector3.new(0.9, -0.6, -1.5), RecoilX = 0.8, RecoilY = 3.5, ModelType = 'Saqire367' },
    MP5 = { Name = 'MP5', Damage = 28, FireRate = 0.065, Ammo = 30, MaxAmmo = 150, Range = 150, HeadshotMult = 1.3, LeanOffset = Vector3.new(0.5, -0.3, -0.6), RecoilX = 0.1, RecoilY = 0.3, ModelType = 'MP5' }
}
return table.freeze(WeaponConfig)