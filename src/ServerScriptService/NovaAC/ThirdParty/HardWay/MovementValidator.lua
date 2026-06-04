--strict
local MovementValidator = {}
local Players, RunService = game:GetService("Players"), game:GetService("RunService")
local States = {}
local CONFIG = { SAMPLE_RATE = 0.3, SPEED_BUFFER = 18, AIRBORNE_THRESHOLD = 2.5 }
local function NewState() return { LastPos = nil, LastTime = 0, AirborneStart = 0, IsAirborne = false, Score = 0 } end
function MovementValidator.Start()
    RunService.Heartbeat:Connect(function()
        local now = workspace:GetServerTimeNow()
        for _, player in ipairs(Players:GetPlayers()) do
            local s = States[player.UserId] or NewState()
            States[player.UserId] = s
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and now - s.LastTime >= CONFIG.SAMPLE_RATE then
                local pos = hrp.Position
                if s.LastPos then
                    local speed = (pos - s.LastPos).Magnitude / (now - s.LastTime)
                    if speed > 100 then s.Score += 10 end
                end
                s.LastPos = pos; s.LastTime = now
            end
        end
    end)
end
return MovementValidator