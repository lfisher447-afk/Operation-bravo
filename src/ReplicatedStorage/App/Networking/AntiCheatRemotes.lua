--!strict
local Remotes = {
    folder = 'SentinelRemotes',
    sample = 'VectorTelemetry',
    correction = 'VectorCorrection',
    handshake = 'SecHandshake',
    adminLink = 'DeviosSecureLink',
    adminVerify = 'DeviosAdminVerify'
}
return table.freeze(Remotes)