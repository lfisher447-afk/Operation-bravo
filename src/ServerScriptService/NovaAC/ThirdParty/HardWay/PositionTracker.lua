--strict
local PositionTracker = {}
local Players, RunService = game:GetService("Players"), game:GetService("RunService")
local positionHistory = setmetatable({}, { __mode = "k" })
local lastSampleTime = 0
local SAMPLE_INTERVAL = 0.1
local MAX_HISTORY_SECONDS = 1.5
local function sampleCharacter(character, now)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    local history = positionHistory[character] or {}
    positionHistory[character] = history
    table.insert(history, { Time = now, CFrame = hrp.CFrame })
    while #history > 0 and now - history[1].Time > MAX_HISTORY_SECONDS do table.remove(history, 1) end
end
function PositionTracker.GetHistoricalCFrame(character, targetTime)
    local history = positionHistory[character]
    if not history or #history == 0 then return character:GetPivot() end
    local newer, older
    for i = #history, 1, -1 do
        if history[i].Time >= targetTime then newer = history[i] else older = history[i]; break end
    end
    if not older then return newer.CFrame end
    if not newer then return older.CFrame end
    local alpha = (targetTime - older.Time) / (newer.Time - older.Time)
    return older.CFrame:Lerp(newer.CFrame, alpha)
end
RunService.Heartbeat:Connect(function()
    local now = workspace:GetServerTimeNow()
    if now - lastSampleTime < SAMPLE_INTERVAL then return end
    lastSampleTime = now
    for _, player in ipairs(Players:GetPlayers()) do if player.Character then sampleCharacter(player.Character, now) end end
end)
return PositionTracker