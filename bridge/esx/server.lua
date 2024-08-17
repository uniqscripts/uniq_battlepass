if not Framework.esx then return end

local ESX = exports['es_extended']:getSharedObject()
local PlateFormat = lib.load('config.config').PlateFormat

function GetIdentifier(playerId)
    return ESX.GetPlayerFromId(playerId).identifier
end

local function IsPlateAvailable(plate)
	return not MySQL.scalar.await('SELECT 1 FROM `owned_vehicles` WHERE `plate` = ?', { plate })
end

function GeneratePlate()
    local plate

    while true do
        plate = lib.string.random(PlateFormat)

        if IsPlateAvailable(plate) then return plate end

        Wait(0)
    end
end

function InsertInGarage(model, identifier, vehicle, playerId)
    local plate = GeneratePlate()

    if not vehicle.properties then
        vehicle.properties = {}
    end

    vehicle.properties.model = model
    vehicle.properties.plate = plate

    local success, err = pcall(function()
        MySQL.insert.await('INSERT INTO `owned_vehicles` (owner, plate, vehicle, type, stored, parking) VALUES (?, ?, ?, ?, ?, ?)',
            { identifier, plate, json.encode(vehicle.properties), vehicle.type, vehicle.stored, vehicle.garage }
        )
    end)

    if not success then
        print(err)
    end

    return success
end