if not lib then return end
local Config = lib.load('config.config')
local FreeItems = Config.Rewards.FreePass
local PaidItems = Config.Rewards.PremiumPass
local BattleShop = Config.BattleShop
local XPPerLevel = Config.XPPerLevel
local TaskList = Config.TaskList
local PremiumPrice = Config.PremiumPrice
local UI = false
local resourceName = cache and cache.resource or GetCurrentResourceName()
local METERS_PER_MILE = 1609.34

local function getTaskStats()
    local ok, stats = pcall(function()
        return exports[resourceName]:GetTaskStats()
    end)

    if ok and type(stats) == 'table' then
        return stats
    end

    return {}
end

local function buildProgress(current, goal, options)
    if not goal or goal <= 0 then return nil end

    current = tonumber(current) or 0
    goal = tonumber(goal) or 0

    local percent = goal == 0 and 0 or (current / goal) * 100
    percent = math.max(0, math.min(100, percent))

    local detail
    if options and options.format == 'miles' then
        detail = ('%.1f / %.1f mi'):format(current, goal)
    elseif options and options.format == 'currency' then
        detail = ('$%d / $%d'):format(math.floor(current + 0.5), math.floor(goal + 0.5))
    elseif options and options.format == 'minutes' then
        detail = ('%d / %d min'):format(math.floor(current + 0.5), math.floor(goal + 0.5))
    else
        detail = ('%d / %d'):format(math.floor(current + 0.5), math.floor(goal + 0.5))
    end

    return {
        label = options and options.label or 'Progress',
        detail = detail,
        percent = math.floor(percent + 0.5)
    }
end

local function countEntries(tbl)
    if type(tbl) ~= 'table' then return 0 end

    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

local TaskStatGoals = {
    Drive10Miles = {
        label = 'Miles Driven',
        format = 'miles',
        goal = 10,
        getCurrent = function(stats) return (stats.distanceDriven or 0) / METERS_PER_MILE end
    },
    Drive100Miles = {
        label = 'Miles Driven',
        format = 'miles',
        goal = 100,
        getCurrent = function(stats) return (stats.distanceDriven or 0) / METERS_PER_MILE end
    },
    Travel500Miles = {
        label = 'Miles Traveled',
        format = 'miles',
        goal = 500,
        getCurrent = function(stats) return (stats.distanceTraveled or 0) / METERS_PER_MILE end
    },
    UseItem5 = {
        label = 'Items Used',
        goal = 5,
        getCurrent = function(stats) return stats.itemsUsed or 0 end
    },
    EatFood3 = {
        label = 'Food Items Eaten',
        goal = 3,
        getCurrent = function(stats) return stats.foodEaten or 0 end
    },
    Drink3 = {
        label = 'Drinks Consumed',
        goal = 3,
        getCurrent = function(stats) return stats.drinksConsumed or 0 end
    },
    RepairVehicle = {
        label = 'Vehicles Repaired',
        goal = 1,
        getCurrent = function(stats) return stats.vehiclesRepaired or 0 end
    },
    UseMedical5 = {
        label = 'Medical Items Used',
        goal = 5,
        getCurrent = function(stats) return stats.medicalUsed or 0 end
    },
    SpendMoney = {
        label = 'Money Spent',
        format = 'currency',
        goal = 5000,
        getCurrent = function(stats) return stats.moneySpent or 0 end
    },
    Spend50K = {
        label = 'Money Spent',
        format = 'currency',
        goal = 50000,
        getCurrent = function(stats) return stats.moneySpent or 0 end
    },
    Complete10Jobs = {
        label = 'Jobs Completed',
        goal = 10,
        getCurrent = function(stats) return stats.jobsCompleted or 0 end
    },
    DriveDifferentVehicles = {
        label = 'Unique Vehicles Driven',
        goal = 10,
        getCurrent = function(stats) return countEntries(stats.uniqueVehicles) end
    },
}

local function buildTaskProgress(taskName, stats, playtime)
    local settings = TaskStatGoals[taskName]
    if settings then
        local current = settings.getCurrent and settings.getCurrent(stats) or 0
        return buildProgress(current, settings.goal, settings)
    end

    local config = TaskList.Daily[taskName] or TaskList.Weekly[taskName]
    if config and config.repeatTillFinish and config.repeatTillFinish > 0 then
        local currentIntervals = (playtime and playtime[taskName]) or 0
        local goalIntervals = config.repeatTillFinish
        local percent = math.max(0, math.min(100, (currentIntervals / goalIntervals) * 100))

        return {
            label = 'Playtime Steps',
            detail = ('%d / %d'):format(math.min(math.floor(currentIntervals + 0.5), goalIntervals), goalIntervals),
            percent = math.floor(percent + 0.5)
        }
    end

    return nil
end


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
    local daily, weekly, playtime, taskProgress = lib.callback.await('uniq_battlepass:TaskList', 100)
    local day, week = {}, {}
    local stats = getTaskStats()

    daily = daily or {}
    weekly = weekly or {}
    playtime = playtime or {}
    -- taskProgress is handled separately in tasktracker.lua

    for taskName, v in pairs(TaskList.Daily) do
        local done = lib.table.contains(daily, taskName) and true or false
        local progress = buildTaskProgress(taskName, stats, playtime)

        if done and progress then
            progress.percent = 100
        end

        day[#day + 1] = {
            title = v.title,
            xp = v.xp,
            desc = v.description,
            done = done,
            progress = progress
        }
    end

    for taskName, v in pairs(TaskList.Weekly) do
        local done = lib.table.contains(weekly, taskName) and true or false
        local progress = buildTaskProgress(taskName, stats, playtime)

        if done and progress then
            progress.percent = 100
        end

        week[#week + 1] = {
            title = v.title,
            xp = v.xp,
            desc = v.description,
            done = done,
            progress = progress
        }
    end

    cb({ day = day, week = week })
end)