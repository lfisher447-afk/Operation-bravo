--!strict
local EPSILON = 1e-6
local Kinematics = {}
function Kinematics.positionAt(origin: Vector3, velocity: Vector3, gravity: Vector3, time: number): Vector3
    return origin + velocity * time + 0.5 * gravity * (time * time)
end
function Kinematics.velocityAt(velocity: Vector3, gravity: Vector3, time: number): Vector3
    return velocity + gravity * time
end
return Kinematics