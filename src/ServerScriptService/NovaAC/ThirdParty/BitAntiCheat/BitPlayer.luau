--strict
local Players = game:GetService("Players")
local BitPlayer = {}
BitPlayer.__index = BitPlayer
function BitPlayer:init()
    print("[BitAntiCheat] Player system integrated successfully.")
end
return BitPlayer