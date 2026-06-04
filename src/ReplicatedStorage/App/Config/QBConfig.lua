--!strict
local Config = {
    -- Execution Frequency Rates
    serverHz = 60,
    clientHz = 20,
    bufSize = 64,
    fixBufSize = 30,

    -- Speed & Movement Physics Constraints
    defaultSpeed = 12,
    maxSpeed = 20,
    maxTeleport = 22,
    speedMult = 1.30,
    speedMargin = 5.0,
    speedStreak = 3,
    maxAccel = 320,
    accelStreak = 3,

    -- Flight & Gravity Parameters
    maxAirTime = 2.0,
    hoverTopY = 12,
    hoverHoldFrames = 6,
    hoverHoldHorizSpeed = 3,
    fastFallY = -35,

    -- Rollback & Combat Diagnostics
    lagCompWindow = 1.5,
    maxViewAngleDifference = 12,
    maxTargetSwitchRate = 7,
    targetSwitchTimeWindow = 0.8,
    inputAnalysisWindow = 0.4,
    smoothnessThreshold = 0.99,
    snapThreshold = 5,
    hitValidationEnabled = true,
    maxRaycastDistance = 250,
    projectileOriginCheckEnabled = true,
    maxProjectileOriginDistance = 2,
    headshotRatioThreshold = 0.6,
    aimbotSnapThreshold = 0.8,
    bayesianWeight = 12,
    globalMeanAccuracy = 0.35,
    globalMeanHSR = 0.20,
    minVariance = 0.02,
    fireRateTolerance = 0.05,

    -- Remote Event Security Protocols
    RemoteEventSecurity = {
        StrictWhitelistEnabled = true,
        WhitelistedRemoteEvents = { 'UpdateInventory', 'PurchaseItem', 'DealDamage', 'FireWeapon', 'TrainHit', 'RequestUI' },
        ArgumentValidationEnabled = true,
        RateLimitingEnabled = true,
        MaxRemoteEventsPerSecond = 8,
        RateLimitTimeFrame = 1,
        EnableDistanceCheck = true,
        MaxRemoteDistance = 300,
    },

    -- Ground & Collision Slopes
    maxVyUp = 90,
    maxVyDown = 320,
    maxSlope = 65,
    groundRay = 8,
    maxGroundDist = 4.5,
    noclipMinCast = 0.25,
    wallNormalY = 0.45,

    -- Reconciler & Correction Feedback
    fixGrace = 1.2,
    fixDist = 3,
    fixCooldown = 0.18,
    fixSmooth = 0.12,
    scoreDecay = 2,
    punishDecay = 1.5,
    fixScore = 4,
    hardSev = 7,
    minVizOffset = 0.1,

    -- Auto-Punishment & Terminations
    kickEnabled = true,
    kickScore = 18,
    minKickSev = 6,
    requireFix = true,
    kickMessage = '[DEVIOS SENTINEL v5.0] Terminated.',
    webhookUrl = 'YOUR_WEBHOOK_HERE',

    -- Integrated Sub-System Configurations
    pkRateLimit = 22,
    pkBurst = 30,
    spawnGrace = 4.0,
    maxDesync = 4.0,
    ADMIN_USERIDS = { 0 },
    logEnabled = true,

    -- Role and Integration Rules
    ROLES = {
        GroupIntegration = { Enabled = false, GroupId = 000000, MinRank = 250 },
        UserWhitelist = { ['UsernamePlaceholder'] = true }
    },

    -- Toggleable Heuristic Checks
    checks = {
        speed = true,
        teleport = true,
        accel = true,
        airTime = true,
        noclip = true,
        physics = true,
        ownership = true,
        desync = true,
        combat = true,
    }
}

return table.freeze(Config)
