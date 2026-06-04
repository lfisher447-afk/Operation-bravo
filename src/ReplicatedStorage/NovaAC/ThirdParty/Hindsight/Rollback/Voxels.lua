--!strict
local Voxels = {}
function Voxels.createSpace(voxelSize: number, gridCenter: Vector3, gridSize: Vector3)
    return { voxelSize = voxelSize, gridCorner = CFrame.new(gridCenter - gridSize / 2) }
end
function Voxels.buildGrid(space, inputs)
    local grid = {}
    for value, pos in pairs(inputs) do
        local loc = space.gridCorner:PointToObjectSpace(pos) / space.voxelSize
        local cell = Vector3.new(math.floor(loc.X), math.floor(loc.Y), math.floor(loc.Z))
        if not grid[cell] then grid[cell] = {} end
        grid[cell][value] = true
    end
    return grid
end
return Voxels