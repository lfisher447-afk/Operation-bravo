--!strict
local MapService = { Name = "MapService" }
local Workspace = game:GetService("Workspace")

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

local function buildHouse(parent: Instance, centerPos: Vector3, wallColor: Color3)
    local houseModel = Instance.new("Model")
    houseModel.Name = "ProceduralHouse"
    houseModel.Parent = parent

    -- Foundation
    buildPart(houseModel, "Foundation", Vector3.new(50, 1, 40), centerPos + Vector3.new(0, 0.5, 0), Enum.Material.Concrete, Color3.fromRGB(80, 80, 80), true, true)
    
    -- Ground Floor Walls
    buildPart(houseModel, "Wall_Back", Vector3.new(50, 12, 1), centerPos + Vector3.new(0, 7, -20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall_Left", Vector3.new(1, 12, 40), centerPos + Vector3.new(-25, 7, 0), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall_Right", Vector3.new(1, 12, 40), centerPos + Vector3.new(25, 7, 0), Enum.Material.Concrete, wallColor, true, true)
    
    -- Front Wall with Doorway
    buildPart(houseModel, "Wall_Front_Left", Vector3.new(20, 12, 1), centerPos + Vector3.new(-15, 7, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall_Front_Right", Vector3.new(20, 12, 1), centerPos + Vector3.new(15, 7, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall_Front_Header", Vector3.new(10, 4, 1), centerPos + Vector3.new(0, 11, 20), Enum.Material.Concrete, wallColor, true, true)

    -- Staircase
    for i = 1, 12 do
        buildPart(houseModel, "Step", Vector3.new(6, 1, 2), centerPos + Vector3.new(-20, i, -18 + (i * 1.5)), Enum.Material.Wood, Color3.fromRGB(120, 80, 50), true, true)
    end

    -- Second Floor Plate
    buildPart(houseModel, "Floor_Lvl2", Vector3.new(50, 1, 40), centerPos + Vector3.new(0, 12.5, 0), Enum.Material.Wood, Color3.fromRGB(100, 70, 40), true, true)

    -- Upper Level Walls with Window Cutouts
    buildPart(houseModel, "Wall2_Back", Vector3.new(50, 10, 1), centerPos + Vector3.new(0, 18, -20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Left", Vector3.new(1, 10, 40), centerPos + Vector3.new(-25, 18, 0), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Right", Vector3.new(1, 10, 40), centerPos + Vector3.new(25, 18, 0), Enum.Material.Concrete, wallColor, true, true)
    
    -- Front Window View
    buildPart(houseModel, "Wall2_Front_L", Vector3.new(15, 10, 1), centerPos + Vector3.new(-17.5, 18, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Front_R", Vector3.new(15, 10, 1), centerPos + Vector3.new(17.5, 18, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Front_B", Vector3.new(20, 3, 1), centerPos + Vector3.new(0, 14.5, 20), Enum.Material.Concrete, wallColor, true, true)
    buildPart(houseModel, "Wall2_Front_T", Vector3.new(20, 3, 1), centerPos + Vector3.new(0, 21.5, 20), Enum.Material.Concrete, wallColor, true, true)
end

local function buildBus(parent: Instance, position: Vector3)
    local bus = Instance.new("Model")
    bus.Name = "YellowBus"
    bus.Parent = parent

    buildPart(bus, "Chassis", Vector3.new(10, 9, 28), position + Vector3.new(0, 5, 0), Enum.Material.Metal, Color3.fromRGB(240, 180, 20), true, true)
    
    for i = -1, 1, 2 do
        for j = -1, 1, 2 do
            buildPart(bus, "Wheel", Vector3.new(2, 3, 3), position + Vector3.new(i * 5.2, 1.5, j * 10), Enum.Material.CorrodedMetal, Color3.fromRGB(15, 15, 15), true, true)
        end
    end
end

local function buildTruck(parent: Instance, position: Vector3)
    local truck = Instance.new("Model")
    truck.Name = "BoxTruck"
    truck.Parent = parent

    buildPart(truck, "Cab", Vector3.new(9, 7, 8), position + Vector3.new(0, 4, 8), Enum.Material.Metal, Color3.fromRGB(220, 220, 220), true, true)
    buildPart(truck, "Container", Vector3.new(10, 10, 18), position + Vector3.new(0, 5.5, -5), Enum.Material.Metal, Color3.fromRGB(50, 50, 50), true, true)
end

local function buildAimTrainerArena(parent: Instance, position: Vector3)
    local arena = Instance.new("Model")
    arena.Name = "AimTrainerChamber"
    arena.Parent = parent

    -- Floor & Ceiling
    buildPart(arena, "Floor", Vector3.new(100, 1, 100), position, Enum.Material.Concrete, Color3.fromRGB(30, 30, 35), true, true)
    buildPart(arena, "Ceiling", Vector3.new(100, 1, 100), position + Vector3.new(0, 40, 0), Enum.Material.Concrete, Color3.fromRGB(20, 20, 25), true, true)

    -- Perimeter Walls
    buildPart(arena, "Wall_N", Vector3.new(100, 40, 1), position + Vector3.new(0, 20, -50), Enum.Material.Concrete, Color3.fromRGB(40, 40, 45), true, true)
    buildPart(arena, "Wall_S", Vector3.new(100, 40, 1), position + Vector3.new(0, 20, 50), Enum.Material.Concrete, Color3.fromRGB(40, 40, 45), true, true)
    buildPart(arena, "Wall_E", Vector3.new(1, 40, 100), position + Vector3.new(50, 20, 0), Enum.Material.Concrete, Color3.fromRGB(40, 40, 45), true, true)
    buildPart(arena, "Wall_W", Vector3.new(1, 40, 100), position + Vector3.new(-50, 20, 0), Enum.Material.Concrete, Color3.fromRGB(40, 40, 45), true, true)
end

function MapService:Init()
    local mapFolder = Instance.new("Folder")
    mapFolder.Name = "TacticalMap"
    mapFolder.Parent = Workspace

    -- General Asphalt Baseplate
    buildPart(mapFolder, "Tarmac", Vector3.new(160, 1, 350), Vector3.new(0, -0.5, 0), Enum.Material.Concrete, Color3.fromRGB(40, 40, 45), true, true)

    -- Fence Lines
    buildPart(mapFolder, "BackFence_North", Vector3.new(160, 8, 2), Vector3.new(0, 3.5, -170), Enum.Material.Wood, Color3.fromRGB(90, 70, 50), true, true)
    buildPart(mapFolder, "BackFence_South", Vector3.new(160, 8, 2), Vector3.new(0, 3.5, 170), Enum.Material.Wood, Color3.fromRGB(90, 70, 50), true, true)

    -- Static Nuketown Properties (Green House North, Orange House South)
    buildHouse(mapFolder, Vector3.new(0, 0, -80), Color3.fromRGB(46, 125, 50))
    buildHouse(mapFolder, Vector3.new(0, 0, 80), Color3.fromRGB(230, 81, 0))

    -- Central Key Obstacles
    buildBus(mapFolder, Vector3.new(-15, 0, 0))
    buildTruck(mapFolder, Vector3.new(15, 0, 10))

    -- Separate Aim-Training Sandbox Chamber
    buildAimTrainerArena(mapFolder, Vector3.new(200, 0, 0))

    print("[MAP SERVICE] Procedural Nuketown & Aim Arena fully instantiated.")
end

function MapService:Start() end

return MapService
