--strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local SharedApp = ReplicatedStorage:WaitForChild("App")
local ServerApp = ServerScriptService:WaitForChild("App")
local Cfg = require(SharedApp.Config.QBConfig)
local Wire = require(SharedApp.Networking.QBPackets)
local Janitor = require(SharedApp.Utilities.Janitor)
local Reason = require(SharedApp.Enums.Reason)

local Logger = require(ServerApp.Debug.Logger)
local Endpoints = require(ServerApp.SubServices.MovementRemotes)
local SessionMod = require(ServerApp.SubServices.PlayerSession)
local MovementChecks = require(ServerApp.SubServices.MovementChecks)
local CombatChecks = require(ServerApp.SubServices.CombatChecks)
local Sampler = require(ServerApp.SubServices.MoveSampler)
local Reconciler = require(ServerApp.SubServices.Reconciler)
local Violations = require(ServerApp.SubServices.ViolationHandler)
local AdminSecure = require(ServerApp.SubServices.AdminPanelSecure)
local BypassChecks = require(ServerApp.SubServices.BypassChecks)
local RemoteEventSecurity = require(ServerApp.SubServices.RemoteEventSecurity)

local QBCoreService = {}
QBCoreService.__index = QBCoreService

function QBCoreService.new()
    return setmetatable({
        Name = "QBCoreService",
        _sessions = {},
        _bin = Janitor.new(),
        _endpoints = nil,
        _clock = 0,
    }, QBCoreService)
end

function QBCoreService:attach(player: Player)
    if self._sessions[player] then return end
    self._sessions[player] = SessionMod.new(player)
    CombatChecks.initPlayer(player)
end

function QBCoreService:detach(player: Player)
    Violations.forget(player)
    CombatChecks.clearPlayer(player)
    local session = self._sessions[player]
    if session then
        session:destroy()
        self._sessions[player] = nil
    end
end

function QBCoreService:onClientPacket(player: Player, payload: any)
    local session = self._sessions[player]
    if not session then return end

    local now = workspace:GetServerTimeNow()
    if not session.throttle:take(tostring(player.UserId), now) then
        Violations.report(player, { kind = Reason.SpoofedPacket, sev = 2, msg = "Packet Flooding", correct = false })
        return
    end

    local packet, err = Wire.unpackSample(payload)
    if packet == nil then
        Violations.report(player, { kind = Reason.SpoofedPacket, sev = 4, msg = err or "Malformed Wire payload", correct = false })
        return
    end

    if packet.seq <= session.lastSeq then
        Violations.report(player, { kind = Reason.SpoofedPacket, sev = 5, msg = "Seq index replay / desync", correct = false })
        return
    end

    local age = now - packet.clientTime
    if age > 1.5 or age < -0.25 then
        Violations.report(player, { kind = Reason.SpoofedPacket, sev = 4, msg = "Timestamp offset anomaly", correct = false })
        return
    end

    session.lastSeq = packet.seq
    session.lastClientTime = packet.clientTime
    if now >= session.pauseUntil then
        session.lastClientPos = packet.pos
        session.lastClientVel = packet.vel
    end
end

function QBCoreService:tick(dt: number)
    local now = workspace:GetServerTimeNow()
    local fixRemote = if self._endpoints then self._endpoints.fix else nil

    for player, session in pairs(self._sessions) do
        -- Sampling loop evaluates authoritative server states natively
        local sample = Sampler.snap(session, now, dt)
        if not sample then continue end

        local v = MovementChecks.run(player, session, sample)
        if v.sev > 0 then
            session.score += v.sev
            if v.correct then
                session.punish += v.sev
            end
            Violations.report(player, v)

            if Cfg.kickEnabled and now >= session.pauseUntil and session.punish >= Cfg.kickScore then
                AdminSecure.logAutoBan(player, v.kind, v.msg)
                continue
            end

            if fixRemote and Reconciler.apply(session, sample, v, fixRemote) then
                session.buf:wipe()
                session.speedWin:wipe()
                session.score = 0
                session.airTime = 0
                session.hoverFrames = 0
                session.speedStreak = 0
                continue
            end
        else
            session.score = math.max(0, session.score - Cfg.scoreDecay * dt)
            session.punish = math.max(0, session.punish - Cfg.punishDecay * dt)
            session.lastSafeCf = sample.cf
        end

        session.buf:push(sample)
    end
end

function QBCoreService:Init()
    self._endpoints = Endpoints.build()
    Logger.enable(Cfg.logEnabled)
    AdminSecure.init(self._endpoints)
end

function QBCoreService:Start()
    local eps = self._endpoints
    assert(eps ~= nil, "Remotes must be registered during boot.")

    self._bin:hook(eps.sample.OnServerEvent:Connect(function(player: Player, payload: any)
        self:onClientPacket(player, payload)
    end))

    self._bin:hook(Players.PlayerAdded:Connect(function(player: Player)
        self:attach(player)
    end))

    self._bin:hook(Players.PlayerRemoving:Connect(function(player: Player)
        self:detach(player)
    end))

    self._bin:hook(RunService.Heartbeat:Connect(function(dt: number)
        self._clock += dt
        if self._clock < (1 / Cfg.serverHz) then return end
        local elapsed = self._clock
        self._clock = 0
        self:tick(elapsed)
    end))

    BypassChecks.initHandshake(eps.handshake)
    RemoteEventSecurity.init()

    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(function() self:attach(player) end)
    end
end

return QBCoreService.new()
