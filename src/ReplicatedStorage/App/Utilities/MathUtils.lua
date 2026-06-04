--!strict
local MathUtils = {}
local UP = Vector3.yAxis
function MathUtils.clampDt(dt: number): number return math.clamp(dt, 0.008, 0.5) end
function MathUtils.flat(v: Vector3): Vector3 return Vector3.new(v.X, 0, v.Z) end
function MathUtils.flatMag(v: Vector3): number return math.sqrt(v.X * v.X + v.Z * v.Z) end
function MathUtils.slopeDeg(n: Vector3): number
    if n.Magnitude < 1e-4 then return 0 end
    return math.deg(math.acos(math.clamp(n.Unit:Dot(UP), -1, 1)))
end
function MathUtils.onFloor(floor: Enum.Material, state: Enum.HumanoidStateType): boolean
    if floor == Enum.Material.Air then return false end
    return state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Flying
end
local LENIENT = { [Enum.HumanoidStateType.Seated] = true, [Enum.HumanoidStateType.Swimming] = true, [Enum.HumanoidStateType.Climbing] = true, [Enum.HumanoidStateType.Dead] = true, [Enum.HumanoidStateType.Ragdoll] = true }
function MathUtils.lenientState(s: Enum.HumanoidStateType): boolean return LENIENT[s] == true end
function MathUtils.rigOf(char: Model?): (BasePart?, Humanoid?)
    if char == nil then return nil, nil end
    local hrp = char:FindFirstChild('HumanoidRootPart')
    local hum = char:FindFirstChildOfClass('Humanoid')
    if hrp == nil or not hrp:IsA('BasePart') then return nil, hum end
    return hrp, hum
end
function MathUtils.bayesianSmooth(hits: number, pellets: number, heads: number, weight: number, globalAcc: number, globalHSR: number)
    local sPellets = pellets + weight
    local sHits = hits + (weight * globalAcc)
    local sHeads = heads + (weight * globalAcc * globalHSR)
    local acc = sHits / sPellets
    local hsr = if sHits > 0 then (sHeads / sHits) or 0 else 0
    return acc, hsr
end
function MathUtils.getVariance(list: {number}): number
    if #list < 5 then return 1.0 end
    local sum = 0
    for _, v in ipairs(list) do sum += v end
    local mean = sum / #list
    local sumSq = 0
    for _, v in ipairs(list) do sumSq += (v - mean) ^ 2 end
    return sumSq / #list
end
return table.freeze(MathUtils)