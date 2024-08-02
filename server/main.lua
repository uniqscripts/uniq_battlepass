if not lib then return end
local Players = {}
local Query = {}
local steamAPI = GetConvar('steam_webApiKey', '')


if steamAPI == '' then
    warn('To load players steam images in battle pass, please set up the steam_webApiKey in your server.cfg file.')
end


local function GetAvatar(playerId)
    local p = promise.new()
    local steam = GetPlayerIdentifierByType(playerId, 'steam')

    if steam then
        local steamID = tonumber(steam:gsub('steam:', ''), 16)

        PerformHttpRequest(('https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=%s&steamids=%s'):format(steamAPI, steamID), function(err, text, headers)
            local info = json.decode(text)

            if info then
                p:resolve(info.response.players[1].avatarfull or Config.DefaultImage)
            end
        end)
    else
        p:resolve(Config.DefaultImage)
    end

    return Citizen.Await(p)
end


local function CreatePlayer(playerId, data)
    local self = {
        id = playerId,
        name = GetPlayerName(playerId),
        data = json.decode(data[1].battlepass) or {}, --[[isto sta i u default longtext stavit]]
        identifier = GetIdentifier(playerId),
        avatar = GetAvatar(playerId)
    }

    Players[playerId] = self
end

MySQL.ready(function()
    if Framework.esx then
        Query = {
            column = 'SHOW COLUMNS FROM `users`',
            alter = 'ALTER TABLE `users` ADD COLUMN `battlepass` LONGTEXT DEFAULT "[]"',
            select = 'SELECT `battlepass` FROM `users` WHERE `identifier` = ?',
            update = 'UPDATE `users` SET `battlepass` = ? WHERE `identifier` = ?'
        }
    elseif Framework.qb then
        Query = {
            column = 'SHOW COLUMNS FROM `players`',
            alter = 'ALTER TABLE `players` ADD COLUMN `battlepass` LONGTEXT DEFAULT "[]"',
            select = 'SELECT `battlepass` FROM `players` WHERE `citizenid` = ?',
            update = 'UPDATE `players` SET `battlepass` = ? WHERE `citizenid` = ?'
        }
    end

    local found = false
    local datatype = MySQL.query.await(Query.column)

    if datatype then
        for i = 1, #datatype do
            if datatype[i].Field == 'battlepass' then
                found = true
                break
            end
        end

        if not found then
            MySQL.query(Query.alter)
            print('^2Successfully added column battlepass to database^0')
        end
    end

    local players = GetActivePlayers()

    for i = 1, #players do
        local playerId = players[i]
        local identifier = GetIdentifier(playerId)

        if identifier then
            local query = MySQL.query.await(Query.select, { identifier })

            if query then
                CreatePlayer(playerId, query)
            end
        end
    end
end)


AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
    if xPlayer then
        local query = MySQL.query.await(Query.select, { xPlayer.identifier })

        if query then
            CreatePlayer(playerId, query)
        end
    end
end)

-- qb dodat loaded

AddEventHandler("esx:playerLogout", function(playerId)
    if Players[playerId] then
        MySQL.update(Query.update, { json.encode(Players[playerId].data, { sort_keys = true }), Players[playerId].identifier})
        Players[playerId] = nil
    end
end)

-- qb dodat drop


lib.addCommand(Config.Commands.battlepass.name, {
    help = Config.Commands.battlepass.help,
}, function(source, args, raw)
    TriggerClientEvent('uniq_battlepass:client:OpenMenu', source, Players[source])
end)

-- shema
lib.callback.register('uniq_battlepass:server:GetScoreboardData', function(source)
    local options = {}

    for k,v in pairs(Players) do
        options[#options + 1] = {
            name = v.name,
            tier = 0,
            xp = 0,
            premium = false,
            taskdone = 0,
            avatar = v.avatar
        }
    end

    return options
end)