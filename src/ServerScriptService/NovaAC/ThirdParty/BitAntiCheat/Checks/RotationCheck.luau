--strict
local RotationCheck = {}
function RotationCheck:checkPlayer(bitPlayer)
    local char = bitPlayer.player.Character
    if char and char.PrimaryPart then
        if char.PrimaryPart.AssemblyAngularVelocity.Magnitude > 72 then
            bitPlayer:strike(1, "High Angular Velocity")
            char.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
        end
    end
    return 3
end
return RotationCheck