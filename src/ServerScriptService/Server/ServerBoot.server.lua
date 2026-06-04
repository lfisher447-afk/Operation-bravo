--!strict
local ServerScriptService = game:GetService('ServerScriptService')
local ServerApp = ServerScriptService:WaitForChild('App')
local Runner = require(ServerApp.Modules.ServiceRunner)
local services = {
    require(ServerApp.Services.QBCoreService),
    require(ServerApp.Services.WeaponService),
    require(ServerApp.Services.AimTrainerService)
}
Runner.boot(services)