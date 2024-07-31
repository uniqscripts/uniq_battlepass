if not Framework.esx then return end

local ESX = exports['es_extended']:getSharedObject()

function GetIdentifier(playerId)
    return ESX.GetPlayerFromId(playerId).identifier
end