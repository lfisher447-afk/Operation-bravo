--!strict
local ProceduralModeler = {}

local function createPart(parent: Instance, name: string, size: Vector3, color: Color3, material: Enum.Material, shape: Enum.PartType?): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Color = color
    p.Material = material
    p.CanCollide = false
    p.Anchored = false
    p.CastShadow = false
    if shape then p.Shape = shape end
    p.Parent = parent
    return p
end

local function weldParts(part0: BasePart, part1: BasePart, offset: CFrame)
    local weld = Instance.new("Weld")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.C0 = offset:Inverse()
    weld.Parent = part0
end

-- Generates highly detailed geometric view-model rigs natively
function ProceduralModeler.buildWeapon(modelType: string): Model
    local model = Instance.new("Model")
    model.Name = modelType
    
    -- Main Weapon Receiver (Central Handle/PrimaryPart)
    local main = createPart(model, "Handle", Vector3.new(0.3, 0.6, 2.0), Color3.fromRGB(25, 25, 25), Enum.Material.Metal)
    model.PrimaryPart = main

    -- Helper variables for offsets
    local mPos = main.Position

    if modelType == "R4C" then
        -- Compact Assault Rifle
        local barrel = createPart(model, "Barrel", Vector3.new(0.15, 0.15, 1.8), Color3.fromRGB(40, 40, 40), Enum.Material.Metal)
        weldParts(main, barrel, CFrame.new(0, 0.15, -1.5))
        
        local handguard = createPart(model, "Handguard", Vector3.new(0.35, 0.45, 1.2), Color3.fromRGB(30, 30, 30), Enum.Material.Pebble)
        weldParts(main, handguard, CFrame.new(0, 0.05, -0.6))

        local mag = createPart(model, "Magazine", Vector3.new(0.2, 0.7, 0.4), Color3.fromRGB(15, 15, 15), Enum.Material.SmoothPlastic)
        weldParts(main, mag, CFrame.new(0, -0.5, -0.3))

        local stock = createPart(model, "Stock", Vector3.new(0.25, 0.5, 0.9), Color3.fromRGB(35, 35, 35), Enum.Material.SmoothPlastic)
        weldParts(main, stock, CFrame.new(0, 0, 1.2))

        local scope = createPart(model, "HoloScope", Vector3.new(0.22, 0.35, 0.7), Color3.fromRGB(15, 15, 15), Enum.Material.Metal)
        weldParts(main, scope, CFrame.new(0, 0.45, -0.1))

    elseif modelType == "L85A2" then
        -- Bullpup Assault Rifle (Mag behind the grip)
        local barrel = createPart(model, "Barrel", Vector3.new(0.15, 0.15, 2.2), Color3.fromRGB(45, 45, 45), Enum.Material.Metal)
        weldParts(main, barrel, CFrame.new(0, 0.1, -1.6))

        local handguard = createPart(model, "Handguard", Vector3.new(0.38, 0.5, 1.5), Color3.fromRGB(50, 60, 40), Enum.Material.Pebble) -- Olive Green Handguard
        weldParts(main, handguard, CFrame.new(0, 0, -0.75))

        local stock = createPart(model, "BullpupStock", Vector3.new(0.3, 0.65, 1.2), Color3.fromRGB(50, 60, 40), Enum.Material.SmoothPlastic)
        weldParts(main, stock, CFrame.new(0, -0.05, 0.9))

        local mag = createPart(model, "RearMagazine", Vector3.new(0.2, 0.7, 0.4), Color3.fromRGB(15, 15, 15), Enum.Material.SmoothPlastic)
        weldParts(main, mag, CFrame.new(0, -0.5, 0.5)) -- Positioned in the rear stock area

        local scope = createPart(model, "Scope2.0x", Vector3.new(0.22, 0.35, 0.9), Color3.fromRGB(15, 15, 15), Enum.Material.Metal)
        weldParts(main, scope, CFrame.new(0, 0.45, -0.2))

    elseif modelType == "MP5" then
        -- Compact SMG
        local barrel = createPart(model, "Barrel", Vector3.new(0.12, 0.15, 1.2), Color3.fromRGB(30, 30, 30), Enum.Material.Metal)
        weldParts(main, barrel, CFrame.new(0, 0.1, -1.2))

        local handguard = createPart(model, "Handguard", Vector3.new(0.32, 0.4, 0.8), Color3.fromRGB(20, 20, 20), Enum.Material.Pebble)
        weldParts(main, handguard, CFrame.new(0, 0.05, -0.4))

        local mag = createPart(model, "CurvedMagazine", Vector3.new(0.18, 0.65, 0.35), Color3.fromRGB(25, 25, 25), Enum.Material.Metal)
        weldParts(main, mag, CFrame.new(0, -0.5, -0.25))

        local stock = createPart(model, "RetractableStock", Vector3.new(0.2, 0.45, 0.8), Color3.fromRGB(15, 15, 15), Enum.Material.SmoothPlastic)
        weldParts(main, stock, CFrame.new(0, -0.05, 1.0))

        local scope = createPart(model, "ScopeACOG", Vector3.new(0.2, 0.35, 0.65), Color3.fromRGB(10, 10, 10), Enum.Material.Metal)
        weldParts(main, scope, CFrame.new(0, 0.45, -0.1))

    elseif modelType == "H417" then
        -- Heavy DMR
        local barrel = createPart(model, "HeavyBarrel", Vector3.new(0.18, 0.18, 2.6), Color3.fromRGB(45, 45, 45), Enum.Material.Metal)
        weldParts(main, barrel, CFrame.new(0, 0.15, -1.9))

        local handguard = createPart(model, "Handguard", Vector3.new(0.38, 0.48, 1.8), Color3.fromRGB(35, 35, 35), Enum.Material.Metal)
        weldParts(main, handguard, CFrame.new(0, 0.05, -0.9))

        local mag = createPart(model, "StraightMagazine", Vector3.new(0.22, 0.6, 0.45), Color3.fromRGB(20, 20, 20), Enum.Material.Metal)
        weldParts(main, mag, CFrame.new(0, -0.45, -0.4))

        local stock = createPart(model, "HeavyStock", Vector3.new(0.28, 0.55, 1.1), Color3.fromRGB(30, 30, 30), Enum.Material.SmoothPlastic)
        weldParts(main, stock, CFrame.new(0, -0.05, 1.2))

        local scope = createPart(model, "MarksmanScope", Vector3.new(0.24, 0.38, 1.0), Color3.fromRGB(15, 15, 15), Enum.Material.Metal)
        weldParts(main, scope, CFrame.new(0, 0.48, -0.2))

    elseif modelType == "OTS03" then
        -- Bullpup Thermal Sniper
        local barrel = createPart(model, "LongBarrel", Vector3.new(0.18, 0.18, 3.2), Color3.fromRGB(45, 45, 45), Enum.Material.Metal)
        weldParts(main, barrel, CFrame.new(0, 0.15, -2.1))

        local handguard = createPart(model, "Handguard", Vector3.new(0.38, 0.5, 2.0), Color3.fromRGB(40, 35, 30), Enum.Material.Wood) -- Custom Wood handguard
        weldParts(main, handguard, CFrame.new(0, 0.05, -1.0))

        local stock = createPart(model, "BullpupStock", Vector3.new(0.3, 0.7, 1.3), Color3.fromRGB(40, 35, 30), Enum.Material.Wood)
        weldParts(main, stock, CFrame.new(0, -0.05, 0.95))

        local mag = createPart(model, "RearMag", Vector3.new(0.2, 0.55, 0.4), Color3.fromRGB(15, 15, 15), Enum.Material.Metal)
        weldParts(main, mag, CFrame.new(0, -0.45, 0.5))

        local scope = createPart(model, "ThermalScope", Vector3.new(0.25, 0.4, 1.1), Color3.fromRGB(255, 165, 0), Enum.Material.Neon) -- Glowing Thermal base
        weldParts(main, scope, CFrame.new(0, 0.5, -0.2))

    elseif modelType == "M590A1" then
        -- Heavy Pump-Action Shotgun
        local barrel = createPart(model, "HeavyBarrel", Vector3.new(0.2, 0.2, 2.5), Color3.fromRGB(35, 35, 35), Enum.Material.Metal)
        weldParts(main, barrel, CFrame.new(0, 0.15, -1.8))

        local pumpTube = createPart(model, "MagazineTube", Vector3.new(0.18, 0.18, 2.2), Color3.fromRGB(25, 25, 25), Enum.Material.Metal)
        weldParts(main, pumpTube, CFrame.new(0, -0.15, -1.6))

        local pumpForend = createPart(model, "PumpForend", Vector3.new(0.35, 0.35, 1.0), Color3.fromRGB(15, 15, 15), Enum.Material.Pebble)
        weldParts(main, pumpForend, CFrame.new(0, -0.15, -1.0))

        local stock = createPart(model, "ShotgunStock", Vector3.new(0.25, 0.5, 1.3), Color3.fromRGB(20, 20, 20), Enum.Material.SmoothPlastic)
        weldParts(main, stock, CFrame.new(0, -0.1, 1.1))

        local scope = createPart(model, "IronSights", Vector3.new(0.1, 0.15, 0.4), Color3.fromRGB(10, 10, 10), Enum.Material.Metal)
        weldParts(main, scope, CFrame.new(0, 0.35, -0.8))

    elseif modelType == "Saqire367" then
        -- Golden Dragon sniper setup (Central handle with coiled wedge scales)
        local barrel = createPart(model, "DragonBarrel", Vector3.new(0.2, 0.2, 3.4), Color3.fromRGB(45, 45, 45), Enum.Material.Metal)
        weldParts(main, barrel, CFrame.new(0, 0.15, -2.2))

        local scopeBase = createPart(model, "ScopeBase", Vector3.new(0.3, 0.3, 1.5), Color3.fromRGB(218, 165, 32), Enum.Material.Neon) -- Glowing gold scope foundation
        weldParts(main, scopeBase, CFrame.new(0, 0.6, -0.2))

        -- Coiled wedge parts wrapping the scope assembly
        for i = 1, 5 do
            local scale = Instance.new("WedgePart")
            scale.Name = "Scale"
            scale.Size = Vector3.new(0.35, 0.35, 0.3)
            scale.Color = Color3.fromRGB(139, 0, 0) -- Dark Crimson Dragon scale
            scale.Material = Enum.Material.Slate
            scale.CanCollide = false
            scale.Parent = model
            
            local offset = CFrame.new(0, 0.1, -0.6 + (i * 0.25)) * CFrame.Angles(0, math.rad(i * 45), 0)
            weldParts(scopeBase, scale, offset)
        end

    elseif modelType == "DLQ33" then
        -- Heavy Bolt-Action Sniper
        local barrel = createPart(model, "HeavySniperBarrel", Vector3.new(0.2, 0.2, 3.6), Color3.fromRGB(45, 45, 45), Enum.Material.Metal)
        weldParts(main, barrel, CFrame.new(0, 0.2, -2.3))

        local handguard = createPart(model, "ModularHandguard", Vector3.new(0.38, 0.48, 2.2), Color3.fromRGB(30, 30, 30), Enum.Material.Metal)
        weldParts(main, handguard, CFrame.new(0, 0.05, -1.0))

        local stock = createPart(model, "SniperStock", Vector3.new(0.26, 0.6, 1.3), Color3.fromRGB(20, 20, 20), Enum.Material.SmoothPlastic)
        weldParts(main, stock, CFrame.new(0, -0.05, 1.25))

        local mag = createPart(model, "BoxMagazine", Vector3.new(0.2, 0.65, 0.45), Color3.fromRGB(15, 15, 15), Enum.Material.SmoothPlastic)
        weldParts(main, mag, CFrame.new(0, -0.5, -0.3))

        local scope = createPart(model, "OpticSight", Vector3.new(0.25, 0.4, 1.4), Color3.fromRGB(10, 10, 10), Enum.Material.Metal)
        weldParts(main, scope, CFrame.new(0, 0.55, -0.2))

    elseif modelType == "M4A1" then
        -- Standard Carbine
        local barrel = createPart(model, "Barrel", Vector3.new(0.15, 0.15, 2.0), Color3.fromRGB(40, 40, 40), Enum.Material.Metal)
        weldParts(main, barrel, CFrame.new(0, 0.15, -1.6))

        local handguard = createPart(model, "RailSystem", Vector3.new(0.35, 0.42, 1.4), Color3.fromRGB(30, 30, 30), Enum.Material.Pebble)
        weldParts(main, handguard, CFrame.new(0, 0.05, -0.8))

        local mag = createPart(model, "STANAGMag", Vector3.new(0.2, 0.65, 0.4), Color3.fromRGB(20, 20, 20), Enum.Material.Metal)
        weldParts(main, mag, CFrame.new(0, -0.45, -0.25))

        local stock = createPart(model, "CarbineStock", Vector3.new(0.25, 0.5, 1.0), Color3.fromRGB(25, 25, 25), Enum.Material.SmoothPlastic)
        weldParts(main, stock, CFrame.new(0, -0.05, 1.1))

        local carryHandle = createPart(model, "OpticCarryHandle", Vector3.new(0.15, 0.25, 1.0), Color3.fromRGB(15, 15, 15), Enum.Material.Metal)
        weldParts(main, carryHandle, CFrame.new(0, 0.42, -0.1))
    end

    return model
end

return ProceduralModeler
