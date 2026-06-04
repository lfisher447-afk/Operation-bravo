--[[
	Nevermore Integration Client Bootstrap
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loader = ReplicatedStorage:WaitForChild("integration"):WaitForChild("loader")
local require = require(loader).bootstrapGame(loader.Parent)

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("GameServiceClient"))
serviceBag:Init()
serviceBag:Start()

print("[Nevermore Client] Subsystems resolved and initialized.")
