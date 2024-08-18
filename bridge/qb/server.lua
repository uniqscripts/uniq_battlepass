if not Framework.qb then return end

QBCore = exports['qb-core']:GetCoreObject()
local PlateFormat = lib.load('config.config').PlateFormat


function GetIdentifier(playerId)
    return QBCore.Functions.GetPlayer(playerId).PlayerData.citizenid
end

local function IsPlateAvailable(plate)
	return not MySQL.scalar.await('SELECT 1 FROM `player_vehicles` WHERE `plate` = ?', { plate })
end

function GeneratePlate()
    local plate

    while true do
        plate = lib.string.random(PlateFormat)

        if IsPlateAvailable(plate) then return plate end

        Wait(0)
    end
end

function InsertInGarage(model, citizenid, vehicle, playerId)
    local plate = GeneratePlate()
    local license = QBCore.Functions.GetPlayer(playerId).PlayerData.license

    if not vehicle.properties then
        vehicle.properties = {}
    end

    vehicle.properties.model = model
    vehicle.properties.plate = plate

    local success, err = pcall(function()
        MySQL.insert.await('INSERT INTO `player_vehicles` (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            { license, citizenid, model, joaat(model), json.encode(vehicle.properties), plate, vehicle.garage, vehicle.state }
        )
    end)

    if not success then
        print(err)
    end

    return success
end