--[[
	Nevermore Integration Server Bootstrap
]]
local ServerScriptService = game:GetService("ServerScriptService")

local loader = ServerScriptService:FindFirstChild("LoaderUtils", true).Parent
local require = require(loader).bootstrapGame(ServerScriptService.integration)

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("GameServiceServer"))
serviceBag:Init()
serviceBag:Start()

print("[Nevermore Server] Integration subsystems initiated successfully.")
