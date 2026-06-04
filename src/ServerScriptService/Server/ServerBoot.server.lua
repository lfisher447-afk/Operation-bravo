--!strict
local ServerScriptService = game:GetService('ServerScriptService')
local ServerApp = script.Parent -- Refers directly to ServerScriptService.Server
local Runner = require(ServerApp.Modules.ServiceRunner)

local services = {
    require(ServerApp.Services.QBCoreService),
    require(ServerApp.Services.WeaponService),
    require(ServerApp.Services.AimTrainerService)
}

Runner.boot(services)
