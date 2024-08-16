if not Framework.qb then return end

local QBCore = exports['qb-core']:GetCoreObject()


function GetIdentifier(playerId)
    return QBCore.Functions.GetPlayer(playerId).PlayerData.citizenid
end