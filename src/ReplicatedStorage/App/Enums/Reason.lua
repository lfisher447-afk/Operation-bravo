--strict
local ViolationReason = {
    None = 0,
    Speed = 1,
    Fly = 2,
    Noclip = 3,
    Teleport = 4,
    Physics = 5,
    Accel = 6,
    Desync = 7,
    SpoofedPacket = 8,
    NetworkOwnership = 9,
    BadGround = 10,
    WalkSpeed = 11,
    Aimbot = 12,
    SilentAim = 13,
    MetamethodHook = 14,
}
return table.freeze(ViolationReason)