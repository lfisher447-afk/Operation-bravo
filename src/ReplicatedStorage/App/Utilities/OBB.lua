--!strict
local OBB = {}
function OBB.intersect(rayOrigin: Vector3, rayDir: Vector3, boxCFrame: CFrame, boxSize: Vector3): (boolean, number)
    local tMin, tMax = 0.0, math.huge
    local delta = boxCFrame.Position - rayOrigin
    local axes = {boxCFrame.RightVector, boxCFrame.UpVector, boxCFrame.LookVector}
    local extents = {boxSize.X / 2, boxSize.Y / 2, boxSize.Z / 2}
    for i = 1, 3 do
        local axis, e = axes[i], extents[i]
        local nomLen, denomLen = axis:Dot(delta), axis:Dot(rayDir)
        if math.abs(denomLen) > 1e-5 then
            local t1, t2 = (nomLen - e) / denomLen, (nomLen + e) / denomLen
            if t1 > t2 then t1, t2 = t2, t1 end
            if t1 > tMin then tMin = t1 end
            if t2 < tMax then tMax = t2 end
            if tMin > tMax then return false, 0 end
        else
            if -nomLen - e > 0 or -nomLen + e < 0 then return false, 0 end
        end
    end
    return tMax > 0, tMin
end
return OBB