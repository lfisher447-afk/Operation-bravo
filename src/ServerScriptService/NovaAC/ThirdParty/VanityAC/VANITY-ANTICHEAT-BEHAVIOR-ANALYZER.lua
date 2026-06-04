-- [[ VANITY-ANTICHEAT BEHAVIOR ANALYZER V2.5 ]]
local BehaviorAnalyzer = {}
local behaviorData = { playerPatterns = {}, anomalyScores = {} }
function BehaviorAnalyzer.analyzeMovement(player, position, velocity)
    local pattern = behaviorData.playerPatterns[player.UserId]
    if not pattern then 
        behaviorData.playerPatterns[player.UserId] = { lastPos = position }
        return 0
    end
    local score = 0
    local distance = (position - pattern.lastPos).Magnitude
    if distance > 100 then score = 5 end
    pattern.lastPos = position
    return score
end
return BehaviorAnalyzer