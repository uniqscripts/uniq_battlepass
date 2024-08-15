---@diagnostic disable: param-type-mismatch
if not lib then return end
local Players = {}
local steamAPI = GetConvar('steam_webApiKey', '')
local week = math.ceil(tonumber(os.date("%d")) / 7)
local Config = lib.load('config.config')
local DaysToSec = (Config.PremiumDuration * 24 * 60 * 60)

local Query = {
    INSERT = 'INSERT INTO `uniq_battlepass` (owner, battlepass) VALUES (?, ?) ON DUPLICATE KEY UPDATE battlepass = VALUES(battlepass)'
}

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

local function CreatePlayer(playerId, bp)
    if bp and table.type(bp) ~= 'empty' then
        if tonumber(bp.purchasedate) < (os.time() - DaysToSec) then
            bp.premium = false
        end
    end

    local self = {
        id = playerId,
        name = GetPlayerName(playerId),
        identifier = GetIdentifier(playerId),
        avatar = GetAvatar(playerId),
        battlepass = (bp == nil or type(bp) == 'empty') and {
            coins = 0,
            xp = 0,
            tier = 0,
            premium = false,
            FreeClaims = {},
            PremiumClaims = {},
            purchasedate = 0
        } or bp
    }

    Players[playerId] = self
end

local function AddXP(playerId, xp)
    xp = tonumber(xp)
    if Players[playerId] then
        Players[playerId].battlepass.xp += xp

        while Players[playerId].battlepass.xp >= Config.XPPerLevel do
            Players[playerId].battlepass.xp -= Config.XPPerLevel
            Players[playerId].battlepass.tier += 1
        end
    end
end

local function RemoveXP(playerId, xp)
    xp = tonumber(xp)
    if Players[playerId] then
        Players[playerId].battlepass.xp -= xp

        if 0 > Players[playerId].battlepass.xp then
            Players[playerId].battlepass.xp = 0
            Players[playerId].battlepass.tier -= 1
        end
    end
end

exports('AddXP', AddXP)
exports('RemoveXP', RemoveXP)


MySQL.ready(function()
    local success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM `uniq_battlepass`')

    if not success then
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `uniq_battlepass` (
                `owner` varchar(72) DEFAULT NULL,
                `battlepass` longtext DEFAULT NULL,
                `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                UNIQUE KEY `owner` (`owner`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
        ]])

        print('^2Successfully added table uniq_battlepass to database^0')
    end

    success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM `uniq_battlepass_codes`')

    if not success then
        MySQL.query([[
            CREATE TABLE `uniq_battlepass_codes` (
                `identifier` varchar(72) DEFAULT NULL,
                `code` varchar(100) DEFAULT NULL,
                `amount` int(11) DEFAULT NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
        ]])

        print('^2Successfully added uniq_battlepass_codes table to SQL^0')
    end


    pcall(MySQL.query.await, ('DELETE FROM `uniq_battlepass` WHERE lastupdated < (NOW() - INTERVAL %s)'):format(Config.DeletePlayer))

    local players = GetActivePlayers()

    for i = 1, #players do
        local playerId = players[i]
        local identifier = GetIdentifier(playerId)

        if identifier then
            local battlepass = MySQL.prepare.await('SELECT `battlepass` FROM `uniq_battlepass` WHERE `owner` = ?', { identifier })

            CreatePlayer(playerId, battlepass and json.decode(battlepass))
        end
    end
end)


lib.callback.register('uniq_battlepass:server:GetScoreboardData', function(source)
    local options = {}

    for k,v in pairs(Players) do
        options[#options + 1] = {
            name = v.name,
            tier = v.battlepass.tier,
            xp = v.battlepass.xp,
            premium = v.battlepass.premium,
            taskdone = 0,
            avatar = v.avatar
        }
    end

    return options
end)

lib.callback.register('uniq_battlepass:GetCoins', function(source)
    if Players[source] then
        return Players[source].battlepass.coins
    end

    return 0
end)


lib.callback.register('uniq_battlepass:BuyItem', function(playerId, data)
    if data.itemId then
        data.itemId = tonumber(data.itemId)
        if Config.BattleShop[data.itemId] then
            local item = Config.BattleShop[data.itemId]

            if Players[playerId].battlepass.coins >= item.coins then
                AddItem(playerId, item.name, item.amount)
                Players[playerId].battlepass.coins -= item.coins

                if 0 > Players[playerId].battlepass.coins then
                    Players[playerId].battlepass.coins = 0
                end

                return true, Players[playerId].battlepass.coins, item
            end

            return false
        end
    end

    return false
end)

lib.callback.register('uniq_battlepass:ReedemCode', function(source, code)
    local identifier = GetIdentifier(source)
    local cb = MySQL.single.await('SELECT `amount`, `identifier` FROM `uniq_battlepass_codes` WHERE `code` = ?', { code })

    if cb and cb.amount and cb.identifier == identifier then
        cb.amount = tonumber(cb.amount)
        Players[source].battlepass.coins += cb.amount
        MySQL.query('DELETE FROM `uniq_battlepass_codes` WHERE `code` = ?', { code })

        return cb.amount
    end

    return false
end)


lib.callback.register('uniq_battlepass:ClaimReward', function(source, data)
    if data.pass == 'free' then
        data.itemId = tonumber(data.itemId)

        if Config.Rewards.FreePass[week][data.itemId] then
            local item = Config.Rewards.FreePass[week][data.itemId]

            if (Players[source].battlepass.xp >= item.requirements.xp and Players[source].battlepass.tier >= item.requirements.tier)
            and not Players[source].battlepass.FreeClaims[data.itemId] then
                AddItem(source, item.name, item.amount)
                Players[source].battlepass.FreeClaims[data.itemId] = true

                return true, Config.Rewards.FreePass[week][data.itemId]
            end
        end
    elseif data.pass == 'premium' then
        data.itemId = tonumber(data.itemId)

        if Config.Rewards.PremiumPass[week][data.itemId] then
            local item = Config.Rewards.PremiumPass[week][data.itemId]

            if (Players[source].battlepass.xp >= item.requirements.xp and Players[source].battlepass.tier >= item.requirements.tier)
            and not Players[source].battlepass.PremiumClaims[data.itemId] then
                AddItem(source, item.name, item.amount)
                Players[source].battlepass.PremiumClaims[data.itemId] = true

                return true, Config.Rewards.PremiumPass[week][data.itemId]
            end
        end
    end

    return false, nil
end)

local function SaveDB()
    local insertTable = {}
    local size = 0

    for playerId, data in pairs(Players) do
        size += 1
        insertTable[size] = { query = Query.INSERT, values = { data.identifier, json.encode(data.battlepass, { sort_keys = true }) } }
    end

    if size > 0 then
        local success, response = pcall(MySQL.transaction, insertTable)

        if not success then print(response) end
    end
end

RegisterCommand(Config.BuyCoinsCommand, function (source, args, raw)
    if source ~= 0 then return end

    local id = tonumber(args[1])
    local amount = args[2]
    local code = args[3]

    if not id then return end
    if not amount then return end
    if not code then return end

    local identifier = GetIdentifier(id)

    if identifier then
        MySQL.insert.await('INSERT INTO `uniq_battlepass_codes` (identifier, code, amount) VALUES (?, ?, ?)', { identifier, code, amount })
        TriggerClientEvent('uniq_battlepass:Notify', id, ('You have successfully purchased %s coins'):format(amount), 'success')
    end
end)

RegisterCommand(Config.BuyPremiumPassCommand, function(source, args, raw)
    if source ~= 0 then return end

    local playerId = tonumber(args[1])
    if not playerId then return end

    if Players[playerId] then
        Players[playerId].battlepass.premium = true
        Players[playerId].battlepass.purchasedate = os.time()

        TriggerClientEvent('uniq_battlepass:Notify', playerId, ('You have successfully purchased Premium Pass.\n Pass will last for %s days'):format(Config.PremiumDuration), 'success')
    end
end)

lib.addCommand(Config.Commands.givecoins.name, {
    help = Config.Commands.givecoins.help,
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
        {
            name = 'count',
            type = 'number',
            help = 'Amount of the coints to give',
        },
    },
    restricted = Config.Commands.givecoins.restricted
}, function(source, args, raw)
    if Players[args.target] then
        Players[args.target].battlepass.coins += args.count or 10
        TriggerClientEvent('uniq_battlepass:Notify', args.target, ('You got %s coints from admin'):format(args.count or 10))
    else
        TriggerClientEvent('uniq_battlepass:Notify', source, 'No player with that id was found')
    end
end)

lib.addCommand(Config.Commands.removecoins.name, {
    help = Config.Commands.removecoins.help,
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
        {
            name = 'count',
            type = 'number',
            help = 'Amount of the coints to remove',
        },
    },
    restricted = Config.Commands.removecoins.restricted
}, function(source, args, raw)
    if Players[args.target] then
        Players[args.target].battlepass.coins -= args.count or 10

        if 0 > Players[args.target].battlepass.coins then
            Players[args.target].battlepass.coins = 0
        end

        TriggerClientEvent('uniq_battlepass:Notify', args.target, ('%s coins were removed from you by admin'):format(args.count or 10))
    else
        TriggerClientEvent('uniq_battlepass:Notify', source, 'No player with that id was found')
    end
end)

lib.addCommand(Config.Commands.battlepass.name, {
    help = Config.Commands.battlepass.help,
}, function(source, args, raw)
    TriggerClientEvent('uniq_battlepass:client:OpenMenu', source, Players[source], week)
end)


lib.addCommand(Config.Commands.givepass.name, {
    help = Config.Commands.givepass.help,
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
    },
    restricted = Config.Commands.givepass.restricted
}, function(source, args, raw)
    if Players[args.target] then
        Players[args.target].battlepass.premium = true
        Players[args.target].battlepass.purchasedate = os.time()

        TriggerClientEvent('uniq_battlepass:Notify', args.target, ('Admin gave you Premium Pass.\n Pass will last for %s days'):format(Config.PremiumDuration), 'success')
    end
end)

lib.addCommand(Config.Commands.wipe.name, {
    help = Config.Commands.wipe.help,
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
    },
    restricted = Config.Commands.wipe.restricted
}, function(source, args, raw)
    if Players[args.target] then
        Players[args.target].battlepass = { coins = 0, xp = 0, tier = 0, premium = false, FreeClaims = {}, PremiumClaims = {}, purchasedate = 0 }

        TriggerClientEvent('uniq_battlepass:Notify', args.target, 'Your battlepass progress is wiped by admin', 'warning')
    end
end)


lib.addCommand(Config.Commands.givexp.name, {
    help = Config.Commands.givexp.help,
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
        {
            name = 'count',
            type = 'number',
            help = 'Amount of the xp',
        },
    },
    restricted = Config.Commands.givexp.restricted
}, function(source, args, raw)
    AddXP(args.target, args.count)
    TriggerClientEvent('uniq_battlepass:Notify', args.target, ('You got %s xp by admin'):format(args.count), 'inform')
end)

-- resetane stats prvog
-- taskovi


if Config.PlayTimeReward.enable then
    CreateThread(function()
        while true do
            local targetIds = {}

            for k, v in pairs(Players) do
                AddXP(v.id, Config.PlayTimeReward.xp)

                if Config.PlayTimeReward.notify then
                    targetIds[#targetIds + 1] = v.id
                end
            end

            if #targetIds > 0 then
                lib.triggerClientEvent('uniq_battlepass:Notify', targetIds, ('You got %sxp for playing on server'):format(Config.PlayTimeReward.xp), 'inform')
            end

            Wait(60000 * Config.PlayTimeReward.interval)
        end
    end)
end


lib.cron.new(Config.Cron, function()

end)


AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
    if xPlayer then
        local battlepass = MySQL.prepare.await('SELECT `battlepass` FROM `uniq_battlepass` WHERE `owner` = ?', { xPlayer.identifier })

        CreatePlayer(playerId, battlepass and json.decode(battlepass))
    end
end)


AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    if Player then
        local battlepass = MySQL.prepare.await('SELECT `battlepass` FROM `uniq_battlepass` WHERE `owner` = ?', { Player.PlayerData.citizenid })

        CreatePlayer(Player.PlayerData.source, battlepass and json.decode(battlepass))
    end
end)


AddEventHandler("esx:playerLogout", function(playerId)
    if Players[playerId] then
        MySQL.insert(Query.INSERT, { Players[playerId].identifier, json.encode(Players[playerId].battlepass, { sort_keys = true }) })
        Players[playerId] = nil
    end
end)


AddEventHandler('QBCore:Server:OnPlayerUnload', function(playerId)
    if Players[playerId] then
        MySQL.insert(Query.INSERT, { Players[playerId].identifier, json.encode(Players[playerId].battlepass, { sort_keys = true }) })
        Players[playerId] = nil
    end
end)


AddEventHandler('onResourceStop', function(name)
    if cache.resource == name then SaveDB() end
end)


AddEventHandler('txAdmin:events:serverShuttingDown', function()
	SaveDB()
end)


AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining ~= 60 then return end

	SaveDB()
end)


lib.cron.new('*/5 * * * *', function()
    SaveDB()
end)