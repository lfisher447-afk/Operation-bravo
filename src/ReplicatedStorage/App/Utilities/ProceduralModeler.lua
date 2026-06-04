--!strict
local ProceduralModeler = {}
local function createPart(parent: Instance, size: Vector3, color: Color3, material: Enum.Material): Part
    local p = Instance.new('Part')
    p.Size, p.Color, p.Material = size, color, material
    p.CanCollide, p.Anchored = false, false
    p.Parent = parent
    return p
end
function ProceduralModeler.buildWeapon(modelType: string): Model
    local model = Instance.new('Model')
    model.Name = modelType
    local main = createPart(model, Vector3.new(0.3, 0.5, 3), Color3.fromRGB(20, 20, 20), Enum.Material.Metal)
    main.Name = 'Handle'
    local barrel = createPart(model, Vector3.new(0.2, 0.2, 2.5), Color3.fromRGB(40, 40, 40), Enum.Material.Metal)
    barrel.Position = main.Position + Vector3.new(0, 0.25, -1.8)
    local weld = Instance.new('WeldConstraint')
    weld.Part0, weld.Part1, weld.Parent = main, barrel, main
    if modelType == 'M4A1' then
        local handguard = createPart(model, Vector3.new(0.4, 0.4, 1.8), Color3.fromRGB(50, 45, 40), Enum.Material.Pebble)
        handguard.Position = main.Position + Vector3.new(0, 0.25, -1.2)
        local w = Instance.new('WeldConstraint')
        w.Part0, w.Part1, w.Parent = main, handguard, main
    elseif modelType == 'DLQ33' then
        local scope = createPart(model, Vector3.new(0.25, 0.25, 1.2), Color3.fromRGB(15, 15, 15), Enum.Material.Metal)
        scope.Position = main.Position + Vector3.new(0, 0.5, -0.2)
        local w = Instance.new('WeldConstraint')
        w.Part0, w.Part1, w.Parent = main, scope, main
    elseif modelType == 'Saqire367' then
        local scopeBase = createPart(model, Vector3.new(0.3, 0.3, 1.5), Color3.fromRGB(218, 165, 32), Enum.Material.Neon)
        scopeBase.Position = main.Position + Vector3.new(0, 0.6, -0.2)
        local wBase = Instance.new('WeldConstraint')
        wBase.Part0, wBase.Part1, wBase.Parent = main, scopeBase, main
        for i = 1, 5 do
            local part = Instance.new('WedgePart')
            part.Size = Vector3.new(0.35, 0.35, 0.3)
            part.Color = Color3.fromRGB(139, 0, 0)
            part.Material = Enum.Material.Slate
            part.CanCollide = false
            part.Position = scopeBase.Position + Vector3.new(0, 0.1, -0.6 + (i * 0.25))
            part.Orientation = Vector3.new(0, i * 45, 0)
            part.Parent = model
            local w = Instance.new('WeldConstraint')
            w.Part0, w.Part1, w.Parent = scopeBase, part, scopeBase
        end
    end
    model.PrimaryPart = main
    return model
end
return ProceduralModeler