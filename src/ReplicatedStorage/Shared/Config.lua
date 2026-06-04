local Config = {
    MaxPlayers = 9,
    MinPlayersToStart = 2,
    World = {
        PlatformGridSize = 3,
        PlatformSpacing = 42,
        PlatformSize = Vector3.new(24, 2, 24),
        PlatformHeight = 40,
        PlatformSpawnOffset = Vector3.new(0, 5, 0),
        LobbyPosition = Vector3.new(-120, 50, 0),
        LobbySize = Vector3.new(56, 2, 56),
        FallDeathY = 0,
    }
}
return table.freeze(Config)