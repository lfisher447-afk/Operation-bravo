local Workspace = game:GetService('Workspace')
local function buildPart(name, size, pos, mat, col)
    local p = Instance.new('Part')
    p.Name, p.Size, p.Position, p.Material, p.Color = name, size, pos, mat, col
    p.Anchored, p.CanCollide, p.Parent = true, true, Workspace
end
buildPart('Baseplate', Vector3.new(2048, 16, 2048), Vector3.new(0, -8, 0), Enum.Material.Concrete, Color3.fromRGB(80, 80, 85))
print('[WORLD ENGINE] Built core assets.')