--!strict
local StarterPlayerScripts = script.Parent
local ClientApp = StarterPlayerScripts:WaitForChild('App')
local Runner = require(ClientApp.Modules.ControllerRunner)
local controllers = {
    require(ClientApp.Controllers.SamplerController),
    require(ClientApp.Controllers.SecurityController),
    require(ClientApp.Controllers.SelfHealSentinel),
    require(ClientApp.Controllers.CameraController),
    require(ClientApp.Controllers.WeaponController),
    require(ClientApp.Controllers.AimTrainerController),
    require(ClientApp.Controllers.DeviosUIController),
    require(ClientApp.Controllers.PulsarPwnzorController),
}
Runner.boot(controllers)