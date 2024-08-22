if not lib then return end
local FreeItems = lib.load('config.config').Rewards.FreePass
local PaidItems = lib.load('config.config').Rewards.PremiumPass
local BattleShop = lib.load('config.config').BattleShop
local XPPerLevel = lib.load('config.config').XPPerLevel
local TaskList = lib.load('config.config').TaskList
local PremiumPrice = lib.load('config.config').PremiumPrice
local UI = false


RegisterNetEvent('uniq_battlepass:Notify', function(description, type)
    lib.notify({
        title = '',
        description = description,
        type = type,
        duration = 3500,
        position = 'bottom'
    })
end)

RegisterNetEvent('uniq_battlepass:client:OpenMenu', function(data, week)
    if source == '' then return end

    if not UI then
        UI = true
        SetNuiFocus(true, true)
	    SendNUIMessage(
            {
                enable = true,
                PlayerData = data,
                FreeItems = FreeItems[week],
                PaidItems = PaidItems[week],
                XPPerLevel = XPPerLevel,
                PremiumPrice = PremiumPrice
            }
        )
    end
end)

RegisterNUICallback('quit', function(data, cb)
	SetNuiFocus(false, false)

    UI = false
    cb(1)
end)


RegisterNUICallback('OpenScoreboard', function(data, cb)
    local players = lib.callback.await('uniq_battlepass:server:GetScoreboardData', 100)

    cb(players)
end)

RegisterNUICallback('claimReward', function(data, cb)
    local resp, item = lib.callback.await('uniq_battlepass:ClaimReward', 100, data)

    cb({ resp = resp, item = item })
end)


RegisterNUICallback('OpenBattleShop', function(data, cb)
    local money, week = lib.callback.await('uniq_battlepass:GetCoins', 100)

    cb({ BattleShop = BattleShop[week], money = money })
end)


RegisterNUICallback('BuyPass', function(data, cb)
    local resp = lib.callback.await('uniq_battlepass:BuyPass', 100)

    cb(resp)
end)

RegisterNUICallback('BattleShopPurchase', function (data, cb)
    local resp, money, item = lib.callback.await('uniq_battlepass:BuyItem', 100, data)

    cb({ resp = resp, money = money and money or nil, item = item and item or nil })
end)


RegisterNUICallback('GetTasks', function (data, cb)
    local daily, weekly = lib.callback.await('uniq_battlepass:TaskList', 100)
    local day, week = {}, {}

    for taskName, v in pairs(TaskList.Daily) do
        day[#day + 1] = { title = v.title, xp = v.xp, desc = v.description, done = lib.table.contains(daily, taskName) and true or false }
    end

    for taskName, v in pairs(TaskList.Weekly) do
        week[#week + 1] = { title = v.title, xp = v.xp, desc = v.description, done = lib.table.contains(weekly, taskName) and true or false }
    end

    cb({ day = day, week = week })
end)