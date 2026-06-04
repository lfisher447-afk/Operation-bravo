--strict
local ClientTypes = require(script.Parent.Parent.Types.ClientTypes)
type Controller = ClientTypes.Controller
local Runner = {}
local function execute(c: Controller, step: "Init" | "Start")
    local method = c[step]
    if not method then return end
    local ok, err = pcall(method, c)
    if not ok then error(string.format("Boot Failure: %s.%s failed: %s", c.Name, step, tostring(err)), 2) end
end
function Runner.boot(controllers: { Controller })
    for _, c in ipairs(controllers) do execute(c, "Init") end
    for _, c in ipairs(controllers) do execute(c, "Start") end
end
return table.freeze(Runner)