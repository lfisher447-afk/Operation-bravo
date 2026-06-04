--strict
local VelocityCheck = {}
function VelocityCheck:checkPlayer(bitPlayer)
    local char = bitPlayer.player.Character
    if char and char.PrimaryPart then
        local vel = char.PrimaryPart.AssemblyLinearVelocity
        if vel.Y > 200 or vel.Y < -250 then
            bitPlayer:strike(1, "Invalid Velocity Bound")
        end
    end
    return 1.5
end
return VelocityCheck