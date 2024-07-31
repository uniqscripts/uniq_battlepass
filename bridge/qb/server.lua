if not Framework.qb then return end

local QBCore = exports['qb-core']:GetCoreObject()


function GetIdentifier(playerId)
    return QBCore.GetPlayer(playerId).PlayerData.citizenid
end