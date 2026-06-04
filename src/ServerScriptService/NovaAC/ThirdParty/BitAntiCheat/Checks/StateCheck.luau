--strict
local StateCheck = {}
function StateCheck:characterAdded(bitPlayer, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.StateChanged:Connect(function(old, new)
            if old == Enum.HumanoidStateType.Dead then
                bitPlayer:strike(1, "Dead State Exploitation")
            end
        end)
    end
end
return StateCheck