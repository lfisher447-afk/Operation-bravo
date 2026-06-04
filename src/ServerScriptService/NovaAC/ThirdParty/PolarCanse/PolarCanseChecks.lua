--strict
local PolarCanseChecks = {}
function PolarCanseChecks.validateFly(player, isAirborne, duration)
    if isAirborne and duration > 5.5 then
        return false, "Airborne threshold breached"
    end
    return true
end
return PolarCanseChecks