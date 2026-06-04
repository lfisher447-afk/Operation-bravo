--strict
local ToolCheck = {}
function ToolCheck:characterAdded(bitPlayer, character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("BackpackItem") then
            local count = 0
            for _, c in ipairs(character:GetChildren()) do
                if c:IsA("BackpackItem") then count += 1 end
            end
            if count > 1 then
                bitPlayer:strike(2, "Multi-Tool Equip Exploit")
            end
        end
    end)
end
return ToolCheck