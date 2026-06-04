--!strict
local MapService = { Name = "MapService" }
local Workspace = game:GetService("Workspace")
local Teams = game:GetService("Teams")

local function buildPart(parent: Instance, name: string, size: Vector3, position: Vector3, material: Enum.Material, color: Color3, anchored: boolean, canCollide: boolean): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = position
    p.Material = material
    p.Color = color
    p.Anchored = anchored
    p.CanCollide = canCollide
    p.Parent = parent
    return p
end

local function buildSpawn(parent: Instance, name: string, position: Vector3, teamColor: string): SpawnLocation
    local spawn = Instance.new("SpawnLocation")
    spawn.Name = name
    spawn.Size = Vector3.new(6, 1, 6)
    spawn.Position = position
    spawn.Material = Enum.Material.Neon
    spawn.Color = BrickColor.new(teamColor).Color
    spawn.BrickColor = BrickColor.new(teamColor)
    spawn.Anchored = true
    spawn.CanCollide = true
    spawn.Neutral = false
    spawn.Parent = parent
    return spawn
end

local function buildHouse(parent: Instance, centerPos: Vector3, wallColor: Color3)
    local houseModel = Instance.new("Model")
    houseModel.Name = "ProceduralHouse"
    houseModel.Parent = parent

    -- Concrete Foundation plate
    buildPart(houseModel, "Foundation", Vector3.new(50, 1, 40), centerPos + Vector3.new(0, 0.5, 0), Enum.Material.Concrete, Color3.fromRGB(80, 80, 80), true, true)
    
    -- Ground floor walls
    buildPart(houseModel, "Wall_Back", Vector3.new(50, 12, 1), centerPos + Vector3.new(0, 7, -20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall_Left", Vector3.new(1, 12, 40), centerPos + Vector3.new(-25, 7, 0), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall_Right", Vector3.new(1, 12, 40), centerPos + Vector3.new(25, 7, 0), Enum.Material.Concrete, wallColor, true, true)
    
    -- Front Wall (With dynamic doorway entrance)
    buildPart(houseModel, "Wall_Front_Left", Vector3.new(20, 12, 1), centerPos + Vector3.new(-15, 7, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall_Front_Right", Vector3.new(20, 12, 1), centerPos + Vector3.new(15, 7, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall_Front_Header", Vector3.new(10, 4, 1), centerPos + Vector3.new(0, 11, 20), Enum.Material.Concrete, wallColor, true, true)

    -- Stair Steps
    for i = 1, 12 do
        buildPart(houseModel, "Step", Vector3.new(6, 1, 2), centerPos + Vector3.new(-20, i, -18 + (i * 1.5)), Enum.Material.Wood, Color3.fromRGB(120, 80, 50), true, true)
    end

    -- Upper Level floor partition
    buildPart(houseModel, "Floor_Lvl2", Vector3.new(50, 1, 40), centerPos + Vector3.new(0, 12.5, 0), Enum.Material.Wood, Color3.fromRGB(100, 70, 40), true, true)

    -- Second Floor walls with window cutouts for line-of-sight angles
    buildPart(houseModel, "Wall2_Back", Vector3.new(50, 10, 1), centerPos + Vector3.new(0, 18, -20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Left", Vector3.new(1, 10, 40), centerPos + Vector3.new(-25, 18, 0), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Right", Vector3.new(1, 10, 40), centerPos + Vector3.new(25, 18, 0), Enum.Material.Concrete, wallColor, true, true)
    
    -- Front balcony window frame
    buildPart(houseModel, "Wall2_Front_L", Vector3.new(15, 10, 1), centerPos + Vector3.new(-17.5, 18, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Front_R", Vector3.new(15, 10, 1), centerPos + Vector3.new(17.5, 18, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Front_B", Vector3.new(20, 3, 1), centerPos + Vector3.new(0, 14.5, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Front_T", Vector3.new(20, 3, 1), centerPos + Vector3.new(0, 21.5, 20), Enum.Material.Concrete, wallColor, true, true)
end

local function buildBus(parent: Instance, position: Vector3)
    local bus = Instance.new("Model")
    bus.Name = "CentralYellowBus"
    bus.Parent = parent

    -- Yellow Bus Chassis Block
    buildPart(bus, "Body", Vector3.new(10, 9, 28), position + Vector3.new(0, 5, 0), Enum.Material.Metal, Color3.fromRGB(240, 180, 20), true, true)
    
    -- Tyres
    for i = -1, 1, 2 do
        for j = -1, 1, 2 do
            buildPart(bus, "Wheel", Vector3.new(2, 3, 3), position + Vector3.new(i * 5.2, 1.5, j * 10), Enum.Material.CorrodedMetal, Color3.fromRGB(15, 15, 15), true, true)
        end
    end
end

local function buildTruck(parent: Instance, position: Vector3)
    local truck = Instance.new("Model")
    truck.Name = "GrayObstacleTruck"
    truck.Parent = parent

    -- Cab & Container
    buildPart(truck, "Cab", Vector3.new(9, 7, 8), position + Vector3.new(0, 4, 8), Enum.Material.Metal, Color3.fromRGB(220, 220, 220), true, true)
    buildPart(truck, "Trailer", Vector3.new(10, 10, 18), position + Vector3.new(0, 5.5, -5), Enum.Material.Metal, Color3.fromRGB(50, 50, 50), true, true)
end

local function buildAimTrainerArena(parent: Instance, position: Vector3)
    local arena = Instance.new("Model")
    arena.Name = "AimTrainerConcreteChamber"
    arena.Parent = parent

    -- Ground & Ceiling
    buildPart(arena, "Floor", Vector3.new(120, 1, 120), position, Enum.Material.Concrete, Color3.fromRGB(30, 30, 35), true, true)
    buildPart(arena, "Ceiling", Vector3.new(120, 1, 120), position + Vector3.new(0, 40, 0), Enum.Material.Concrete, Color3.fromRGB(20, 20, 25), true, true)

    -- Enclosed boundaries
    buildPart(arena, "Wall_North", Vector3.new(120, 40, 1), position + Vector3.new(0, 20, -60), Enum.Material.Concrete, Color3.fromRGB(45, 45, 50), true, true)
    buildPart(arena, "Wall_South", Vector3.new(120, 40, 1), position + Vector3.new(0, 20, 60), Enum.Material.Concrete, Color3.fromRGB(45, 45, 50), true, true)
    buildPart(arena, "Wall_East", Vector3.new(1, 40, 120), position + Vector3.new(60, 20, 0), Enum.Material.Concrete, Color3.fromRGB(45, 45, 50), true, true)
    buildPart(arena, "Wall_West", Vector3.new(1, 40, 120), position + Vector3.new(-60, 20, 0), Enum.Material.Concrete, Color3.fromRGB(45, 45, 50), true, true)
end

function MapService:Init()
    local mapFolder = Instance.new("Folder")
    mapFolder.Name = "TacticalMap"
    mapFolder.Parent = Workspace

    -- Huge Natural Grass Baseplate setup
    buildPart(mapFolder, "GrassBaseplate", Vector3.new(1024, 8, 1024), Vector3.new(0, -4, 0), Enum.Material.Grass, Color3.fromRGB(50, 110, 45), true, true)

    -- central road tarmac street
    buildPart(mapFolder, "CenterStreet", Vector3.new(160, 1, 350), Vector3.new(0, -0.5, 0), Enum.Material.Concrete, Color3.fromRGB(40, 40, 45), true, true)

    -- Back fences
    buildPart(mapFolder, "BackFence_North", Vector3.new(160, 8, 2), Vector3.new(0, 3.5, -170), Enum.Material.Wood, Color3.fromRGB(90, 70, 50), true, true)
    buildPart(mapFolder, "BackFence_South", Vector3.new(160, 8, 2), Vector3.new(0, 3.5, 170), Enum.Material.Wood, Color3.fromRGB(90, 70, 50), true, true)

    -- South Orange House & North Green House
    buildHouse(mapFolder, Vector3.new(0, 0, -80), Color3.fromRGB(46, 125, 50))
    buildHouse(mapFolder, Vector3.new(0, 0, 80), Color3.fromRGB(230, 81, 0))

    -- Middle street blockades
    buildBus(mapFolder, Vector3.new(-15, 0, 0))
    buildTruck(mapFolder, Vector3.new(15, 0, 10))

    -- Standalone Isolated Aim Trainer Arena
    buildAimTrainerArena(mapFolder, Vector3.new(350, 0, 0))

    -- Team Spawn-Points (Raider Spawn South, Republic Spawn North)
    buildSpawn(mapFolder, "RepublicSpawn", Vector3.new(0, 1, -120), "Bright blue")
    buildSpawn(mapFolder, "RaiderSpawn", Vector3.new(0, 1, 120), "Bright red")

    print("[MAP SERVICE] Procedural grass terrain, Nuketown properties, and Team Spawns generated successfully.")
end

function MapService:Start() end

return MapService
