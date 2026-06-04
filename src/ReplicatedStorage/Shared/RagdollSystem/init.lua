local RagdollSystem = {}
RagdollSystem.RagdollFactory = require(script.RagdollFactory)
function RagdollSystem:getRagdoll(model)
    return self.RagdollFactory.new(model)
end
return RagdollSystem