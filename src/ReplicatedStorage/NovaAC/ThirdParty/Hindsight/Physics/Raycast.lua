--!strict
local AXES = { "X", "Y", "Z" }
local Raycast = {}
function Raycast.aabb(origin: Vector3, inverseDirection: Vector3, position: Vector3, halfSize: Vector3): boolean
    local minT, maxT = -math.huge, math.huge
    local boundsMin, boundsMax = position - halfSize, position + halfSize
    for _, axis in ipairs(AXES) do
        local lo = (boundsMin[axis] - origin[axis]) * inverseDirection[axis]
        local hi = (boundsMax[axis] - origin[axis]) * inverseDirection[axis]
        minT = math.max(minT, math.min(lo, hi))
        maxT = math.min(maxT, math.max(lo, hi))
    end
    return maxT > math.max(minT, 0) and minT < 1
end
return Raycast