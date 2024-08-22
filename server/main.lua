---@diagnostic disable: param-type-mismatch
if not lib then return end
lib.locale()
local Players, InProgress = {}, {}
local steamAPI = GetConvar('steam_webApiKey', '')
local week = math.ceil(tonumber(os.date("%d")) / 7)
local Config = lib.load('config.config')
local DaysToSec = Config.PremiumDuration * 86400
local defaultStats = {
    xp = 0,
    tier = 0,
    premium = false,
    freeClaims = {},
    premiumClaims = {},
    purchasedate = 0,
    daily = {},
    weekly = {},
    playtime = {}
}

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

local function FinishTask(playerId, task)
    if Players[playerId] then
        local daytask = Config.TaskList.Daily[task]

        if daytask then
            if not lib.table.contains(Players[playerId].battlepass.daily, task) then
                table.insert(Players[playerId].battlepass.daily, task)
                AddXP(playerId, daytask.xp or 0)
                TriggerClientEvent('uniq_battlepass:Notify', playerId, locale('notify_finished_task', daytask.title, daytask.xp or 0))
                return true
            end
        end

        local weektask = Config.TaskList.Weekly[task]

        if weektask then
            if not lib.table.contains(Players[playerId].battlepass.weekly, task) then
                table.insert(Players[playerId].battlepass.weekly, task)
                AddXP(playerId, weektask.xp or 0)
                TriggerClientEvent('uniq_battlepass:Notify', playerId, locale('notify_finished_task', weektask.title, weektask.xp or 0))
                return true
            end
        end
    end

    return false
end

local function HasPremium(playerId)
    if Players[playerId] then
        return Players[playerId].battlepass.premium
    end

    return false
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
        battlepass = (bp == nil or type(bp) == 'empty') and lib.table.deepclone(defaultStats) or bp
    }

    Players[playerId] = self
end

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
            taskdone = #v.battlepass.daily + #v.battlepass.weekly,
            avatar = v.avatar
        }
    end

    return options
end)


lib.callback.register('uniq_battlepass:BuyPass', function(source)
    if Players[source] then
        local money = GetItemAmount(source, Config.PremiumPrice.currency)

        if money >= Config.PremiumPrice.amount then
            Players[source].battlepass.premium = true
            Players[source].battlepass.purchasedate = os.time()
            RemoveItem(source, Config.PremiumPrice.currency, Config.PremiumPrice.amount)

            return true
        end
    end

    return false
end)

lib.callback.register('uniq_battlepass:GetCoins', function(source)
    if Players[source] then
        return GetItemAmount(source, Config.PremiumPrice.currency), week
    end

    return 0, week
end)


lib.callback.register('uniq_battlepass:BuyItem', function(playerId, data)
    if data.index then
        data.index = tonumber(data.index)
        if Config.BattleShop[week][data.index] then
            local item = Config.BattleShop[week][data.index]
            local money = GetItemAmount(playerId, item.currency)

            if money >= item.price then
                RemoveItem(playerId, item.currency, item.price)
                
                if item.vehicle then
                    local identifier = GetIdentifier(playerId)
                    local cb = InsertInGarage(item.name, identifier, item.vehicle, playerId)

                    if cb then
                        return cb, math.floor(money - item.price), item
                    end
                else
                    AddItem(playerId, item.name, item.amount, item.metadata or nil)
                    
                    return true, math.floor(money - item.price), item
                end
            end

            return false
        end
    end

    return false
end)


lib.callback.register('uniq_battlepass:ClaimReward', function(source, data)
    if data.pass == 'free' then
        data.index = tonumber(data.index)

        if Config.Rewards.FreePass[week][data.index] then
            local item = Config.Rewards.FreePass[week][data.index]
            local currentXP = Players[source].battlepass.xp
            local currentTier = Players[source].battlepass.tier
            local requiredXP = item.requirements.xp
            local requiredTier = item.requirements.tier
            local isTierMet = currentTier >= requiredTier
            local isXPMet = currentXP >= requiredXP
            local isClaimable = isTierMet and (isXPMet or currentTier > requiredTier)

            if isClaimable and not Players[source].battlepass.freeClaims[data.index] then
                if item.vehicle then
                    local identifier = GetIdentifier(source)
                    local cb = InsertInGarage(item.name, identifier, item.vehicle, source)

                    if cb then
                        Players[source].battlepass.freeClaims[data.index] = true
                        return cb, Config.Rewards.FreePass[week][data.index]
                    end
                else
                    AddItem(source, item.name, item.amount, item.metadata or nil)
                    Players[source].battlepass.freeClaims[data.index] = true

                    return true, Config.Rewards.FreePass[week][data.index]
                end
            end
        end
    elseif data.pass == 'premium' then
        data.index = tonumber(data.index)

        if Config.Rewards.PremiumPass[week][data.index] then
            local item = Config.Rewards.PremiumPass[week][data.index]
            local currentXP = Players[source].battlepass.xp
            local currentTier = Players[source].battlepass.tier
            local requiredXP = item.requirements.xp
            local requiredTier = item.requirements.tier
            local isTierMet = currentTier >= requiredTier
            local isXPMet = currentXP >= requiredXP
            local isClaimable = isTierMet and (isXPMet or currentTier > requiredTier)

            if isClaimable and not Players[source].battlepass.premiumClaims[data.index] then
                AddItem(source, item.name, item.amount, item.metadata or nil)
                Players[source].battlepass.premiumClaims[data.index] = true

                return true, Config.Rewards.PremiumPass[week][data.index]
            end
        end
    end

    return false, nil
end)

lib.callback.register('uniq_battlepass:TaskList', function(source)
    if Players[source] then
        return Players[source].battlepass.daily, Players[source].battlepass.weekly
    end
end)


local function SaveDB()
    local insertTable = {}
    local size = 0

    for playerId, data in pairs(Players) do
        size += 1

        if Config.ResetPlaytime then
            data.battlepass.playtime = {}
        end

        insertTable[size] = { query = Query.INSERT, values = { data.identifier, json.encode(data.battlepass, { sort_keys = true }) } }
    end

    if size > 0 then
        local success, response = pcall(MySQL.transaction, insertTable)

        if not success then print(response) end
    end
end

function SecondsToClock(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)

    return locale('time', days, hours, mins, secs)
end

lib.addCommand(Config.Commands.premiumDuration.name, {
    help = Config.Commands.premiumDuration.help,
}, function(source, args, raw)
    if Players[source] then
        if Players[source].battlepass.premium == false then
            return TriggerClientEvent('uniq_battlepass:Notify', source, locale('notify_no_premium'), 'warning')
        end

        local purchaseDate = Players[source].battlepass.purchasedate
        local currentTime = os.time()

        local expirationTime = purchaseDate + DaysToSec
        local timeLeft = expirationTime - currentTime

        local time = SecondsToClock(timeLeft)
        TriggerClientEvent('uniq_battlepass:Notify', source, locale('notify_expiress', time), 'inform')
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
        TriggerClientEvent('uniq_battlepass:Notify', args.target, locale('notify_got_coins', args.count or 10))
    else
        TriggerClientEvent('uniq_battlepass:Notify', source, locale('notify_no_player'))
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

        TriggerClientEvent('uniq_battlepass:Notify', args.target, locale('notify_removed_coins', args.count or 10))
    else
        TriggerClientEvent('uniq_battlepass:Notify', source, locale('notify_no_player'))
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

        TriggerClientEvent('uniq_battlepass:Notify', args.target, locale('notify_got_pass_admin', Config.PremiumDuration), 'success')
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
        Players[args.target].battlepass = lib.table.deepclone(defaultStats)

        TriggerClientEvent('uniq_battlepass:Notify', args.target, locale('notify_wiped'), 'warning')
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
            help = 'Amount of the xp to give',
        },
    },
    restricted = Config.Commands.givexp.restricted
}, function(source, args, raw)
    AddXP(args.target, args.count)
    TriggerClientEvent('uniq_battlepass:Notify', args.target, locale('notify_got_xp', args.count), 'inform')
end)


lib.addCommand(Config.Commands.removexp.name, {
    help = Config.Commands.removexp.help,
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
        {
            name = 'count',
            type = 'number',
            help = 'Amount of the xp to remove',
        },
    },
    restricted = Config.Commands.removexp.restricted
}, function(source, args, raw)
    RemoveXP(args.target, args.count or 0)
end)

local function WipeAll()
    local targetIds = {}

    for k, v in pairs(Players) do
        targetIds[#targetIds + 1] = v.id

        v.battlepass = lib.table.deepclone(defaultStats)
    end

    if #targetIds > 0 then
        lib.triggerClientEvent('uniq_battlepass:Notify', targetIds, locale('notify_wiped'), 'inform')
    end

    MySQL.query('DELETE FROM `uniq_battlepass`')
end

lib.addCommand(Config.Commands.wipeall.name, {
    help = Config.Commands.wipeall.help,
    restricted = Config.Commands.wipeall.restricted
}, function(source, args, raw)
    WipeAll()
end)


if Config.PlayTimeReward.enable then
    CreateThread(function()
        while true do
            local targetIds = {}

            for k, v in pairs(Players) do
                if Config.PlayTimeReward.xp > 0 then AddXP(v.id, Config.PlayTimeReward.xp) end

                if Config.PlayTimeReward.notify then
                    targetIds[#targetIds + 1] = v.id
                end

                for taskName, data in pairs(Config.TaskList.Daily) do
                    if data.repeatTillFinish and not lib.table.contains(v.battlepass.daily, taskName) then
                        if not v.battlepass.playtime[taskName] then
                            v.battlepass.playtime[taskName] = 0
                        end

                        v.battlepass.playtime[taskName] += 1

                        if v.battlepass.playtime[taskName] == data.repeatTillFinish then
                            FinishTask(v.id, taskName)
                        end
                    end
                end

                for taskName, data in pairs(Config.TaskList.Weekly) do
                    if data.repeatTillFinish and not lib.table.contains(v.battlepass.weekly, taskName) then
                        if not v.battlepass.playtime[taskName] then
                            v.battlepass.playtime[taskName] = 0
                        end

                        v.battlepass.playtime[taskName] += 1

                        if v.battlepass.playtime[taskName] == data.repeatTillFinish then
                            FinishTask(v.id, taskName)
                        end
                    end
                end
            end

            if #targetIds > 0 and Config.PlayTimeReward.xp > 0 then
                lib.triggerClientEvent('uniq_battlepass:Notify', targetIds, locale('notify_got_xp_playing', Config.PlayTimeReward.xp), 'inform')
            end

            Wait(60000 * Config.PlayTimeReward.interval)
        end
    end)
end


AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
    if xPlayer then
        local battlepass = MySQL.prepare.await('SELECT `battlepass` FROM `uniq_battlepass` WHERE `owner` = ?', { xPlayer.identifier })

        CreatePlayer(playerId, battlepass and json.decode(battlepass))

        Wait(750)

        if Config.TaskList.Daily['SignIn'] then
            if not Players[playerId].battlepass.daily['SignIn'] then
                FinishTask(playerId, 'SignIn')
            end
        end
    end
end)


AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    if Player then
        local battlepass = MySQL.prepare.await('SELECT `battlepass` FROM `uniq_battlepass` WHERE `owner` = ?', { Player.PlayerData.citizenid })

        CreatePlayer(Player.PlayerData.source, battlepass and json.decode(battlepass))

        Wait(750)

        if Config.TaskList.Daily['SignIn'] then
            if not Players[Player.PlayerData.source].battlepass.daily['SignIn'] then
                FinishTask(Player.PlayerData.source, 'SignIn')
            end
        end
    end
end)


AddEventHandler("esx:playerLogout", function(playerId)
    if Players[playerId] then
        if Config.ResetPlaytime then
            Players[playerId].battlepass.playtime = {}
        end
        MySQL.insert(Query.INSERT, { Players[playerId].identifier, json.encode(Players[playerId].battlepass, { sort_keys = true }) })
        Players[playerId] = nil
    end
end)


AddEventHandler('QBCore:Server:OnPlayerUnload', function(playerId)
    if Players[playerId] then
        if Config.ResetPlaytime then
            Players[playerId].battlepass.playtime = {}
        end
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

if Config.MonthlyRestart.enabled then
    lib.cron.new(Config.MonthlyRestart.cron, function ()
        WipeAll()
    end)
end

lib.cron.new(Config.DailyReset, function()
    for k,v in pairs(Players) do
        v.battlepass.daily = {}
    end

    local query = MySQL.query.await('SELECT * FROM `uniq_battlepass`')

    if query[1] then
        local insertTable = {}

        for k, v in pairs(query) do
            v.battlepass = json.decode(v.battlepass)
            v.battlepass.daily = {}

            insertTable[#insertTable + 1] = { query = Query.INSERT, values = { v.owner, json.encode(v.battlepass, { sort_keys = true }) } }
        end

        local success, response = pcall(MySQL.transaction, insertTable)

        if not success then print(response) end
    end
end)

lib.cron.new(Config.WeeklyRestart, function()
    for k,v in pairs(Players) do
        v.battlepass.weekly = {}
    end

    local query = MySQL.query.await('SELECT * FROM `uniq_battlepass`')

    if query[1] then
        local insertTable = {}

        for k, v in pairs(query) do
            v.battlepass = json.decode(v.battlepass)
            v.battlepass.weekly = {}

            insertTable[#insertTable + 1] = { query = Query.INSERT, values = { v.owner, json.encode(v.battlepass, { sort_keys = true }) } }
        end

        local success, response = pcall(MySQL.transaction, insertTable)

        if not success then print(response) end
    end
end)

exports('AddXP', AddXP)
exports('RemoveXP', RemoveXP)
exports('FinishTask', FinishTask)
exports('HasPremium', HasPremium)


lib.versionCheck('uniqscripts/uniq_battlepass')