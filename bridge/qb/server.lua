if not Framework.qb then return end

local QBCore = exports['qb-core']:GetCoreObject()
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

function InsertInGarage(model, citizenid, garage, playerId)
    local plate = GeneratePlate()
    local properties = { plate = plate, model = joaat(model) }
    local license = QBCore.Functions.GetPlayer(playerId).PlayerData.license

    local success, err = pcall(function()
        MySQL.insert.await('INSERT INTO `player_vehicles` (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            { license, citizenid, model, joaat(model), json.encode(properties), plate, garage.garage, garage.state }
        )
    end)

    if not success then
        print(err)
    end

    return success
end