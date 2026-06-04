--[[
	LightBorn - a fully fleshed and centralized Emergency Lighting System controller.
    Copyright (C) 2025-2026  ErrorCezar
	GPL-3.0 License Applied.
]]

local Players = game:GetService("Players")
local SS      = game:GetService("ServerStorage")
local RS      = game:GetService("ReplicatedStorage")
local CS      = game:GetService("CollectionService")
local SP      = game:GetService("StarterPlayer")

local Modules = script:WaitForChild("Modules")
local Helpers = script:WaitForChild("Helpers")
local src     = script:WaitForChild("src")
local Game_Assets = script:WaitForChild("Game_Assets")
local Parts   = src:WaitForChild("Parts")

local Logger = require(Modules:WaitForChild("Logger"))
local MT     = require(Modules:WaitForChild("MetaTable"))
local Helper = require(Helpers:WaitForChild("Helper"))

local LB_Settings = SS:FindFirstChild("LB_Settings") or Game_Assets:WaitForChild("default-settings")
LB_Settings.Name = "LB_Settings"
LB_Settings.Parent = SS

local SettingModule = LB_Settings:FindFirstChild("Settings") :: ModuleScript?
if not SettingModule then
	Logger.error("Settings module not found in LB_Settings")
	return
end

local Settings = require(SettingModule)
local Shared = Game_Assets:WaitForChild("Shared")
Shared.Parent = RS
Shared.Name = "LB_Shared"

local LB_CLIENT = Game_Assets:WaitForChild("LB_CLIENT")
LB_CLIENT:Clone().Parent = SP.StarterPlayerScripts

local AllowedLocations = Settings.AllowedLocations or {workspace}
local SystemData = MT.new({})
local DecendantsConnection = MT.new({})

print("[LightBorn] System Engine Booted Successfully Under Operation Bravo Workspace.")
