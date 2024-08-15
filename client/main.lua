if not lib then return end
local FreeItems = lib.load('config.config').Rewards.FreePass
local PaidItems = lib.load('config.config').Rewards.PremiumPass
local BattleShop = lib.load('config.config').BattleShop
local XPPerLevel = lib.load('config.config').XPPerLevel
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
	    SendNUIMessage({enable = true, PlayerData = data, FreeItems = FreeItems[week], PaidItems = PaidItems[week], XPPerLevel = XPPerLevel })
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
    local coins = lib.callback.await('uniq_battlepass:GetCoins', 100)

    cb({ BattleShop = BattleShop, coins = coins })
end)


RegisterNUICallback('BattleShopPurchase', function (data, cb)
    local resp, coins, item = lib.callback.await('uniq_battlepass:BuyItem', 100, data)

    cb({ resp = resp, coins = coins and coins or nil, item = item and item or nil })
end)


RegisterNUICallback('ReedemCode', function(data, cb)
    local resp = lib.callback.await('uniq_battlepass:ReedemCode', 100, data.code)

    cb(resp)
end)