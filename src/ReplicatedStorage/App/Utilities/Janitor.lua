--strict
local Janitor = {}
Janitor.__index = Janitor
function Janitor.new() return setmetatable({ _links = {} }, Janitor) end
function Janitor:hook(link: RBXScriptConnection): RBXScriptConnection
    table.insert(self._links, link)
    return link
end
function Janitor:clear()
    for i = #self._links, 1, -1 do
        local link = self._links[i]
        if link.Connected then link:Disconnect() end
        self._links[i] = nil
    end
end
return Janitor