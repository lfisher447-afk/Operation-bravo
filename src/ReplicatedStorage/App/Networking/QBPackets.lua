--!strict
local App = script.Parent.Parent
local Cfg = require(App.Config.QBConfig)
local QBPackets = {}
local function snapNum(val: number, scale: number): number return math.round(val * scale) / scale end
local function snapVec(v: Vector3, scale: number): Vector3 return Vector3.new(snapNum(v.X, scale), snapNum(v.Y, scale), snapNum(v.Z, scale)) end
function QBPackets.packSample(seq: number, clientTime: number, pos: Vector3, vel: Vector3, state: Enum.HumanoidStateType, floor: Enum.Material): { any }
    return { math.max(0, math.floor(seq)), snapNum(clientTime, 1000), snapVec(pos, 100), snapVec(vel, 10), state.Value, floor.Value }
end
function QBPackets.unpackSample(payload: any)
    if typeof(payload) ~= 'table' then return nil, 'Payload is not a table' end
    local seq, t, pos, vel, state, floor = payload[1], payload[2], payload[3], payload[4], payload[5], payload[6]
    if typeof(seq) ~= 'number' or seq < 0 then return nil, 'Bad Sequence Index' end
    if typeof(t) ~= 'number' then return nil, 'Bad Client Timestamp' end
    if typeof(pos) ~= 'Vector3' or typeof(vel) ~= 'Vector3' then return nil, 'Bad State Vectors' end
    if typeof(state) ~= 'number' or typeof(floor) ~= 'number' then return nil, 'Bad Enum Structures' end
    return { seq = math.floor(seq), clientTime = t, pos = pos, vel = vel, state = math.floor(state), floor = math.floor(floor) }, nil
end
function QBPackets.packFix(snap: any): { any }
    return { snap.seq, snapNum(snap.t, 1000), snapVec(snap.pos, 100), snapVec(snap.vel, 10), snap.reason, snap.sev }
end
function QBPackets.unpackFix(payload: any)
    if typeof(payload) ~= 'table' then return nil end
    if typeof(payload[3]) ~= 'Vector3' or typeof(payload[4]) ~= 'Vector3' then return nil end
    return { seq = tonumber(payload[1]) or 0, t = tonumber(payload[2]) or 0, pos = payload[3], vel = payload[4], reason = tonumber(payload[5]) or 0, sev = tonumber(payload[6]) or 0 }
end
function QBPackets.generateHash(seed: number, userId: number, actionValue: number): number
    return ((seed * userId) % 999983) + actionValue
end
return table.freeze(QBPackets)