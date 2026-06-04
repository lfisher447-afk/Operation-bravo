--strict
local Session = {}
Session.__index = Session
function Session.new(player: Player)
    return setmetatable({}, Session)
end
function Session:destroy()
end
return Session