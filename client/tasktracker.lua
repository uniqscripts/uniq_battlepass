if not lib then return end

-- Task tracking variables
local distanceDriven = 0 -- Total distance driven in meters
local distanceTraveled = 0 -- Total distance traveled (vehicle + on foot)
local lastVehiclePos = nil
local lastPedPos = nil
local isInVehicle = false
local currentVehicle = nil
local uniqueVehicles = {} -- Track unique vehicle models driven
local itemsUsed = 0
local foodEaten = 0
local drinksConsumed = 0
local medicalUsed = 0
local vehiclesRepaired = 0
local moneySpent = 0
local jobsCompleted = 0

-- Function to save progress to server
local function SaveTaskProgress()
    local progress = {
        distanceDriven = distanceDriven,
        distanceTraveled = distanceTraveled,
        uniqueVehicles = uniqueVehicles,
        itemsUsed = itemsUsed,
        foodEaten = foodEaten,
        drinksConsumed = drinksConsumed,
        medicalUsed = medicalUsed,
        vehiclesRepaired = vehiclesRepaired,
        moneySpent = moneySpent,
        jobsCompleted = jobsCompleted
    }
    
    lib.callback('dt_battlepass:server:SaveTaskProgress', false, function(success)
        if not success and DebugPrint then
            DebugPrint('Failed to save task progress', 'error', 'dt_battlepass')
        end
    end, progress)
end

-- Function to load progress from server
local function LoadTaskProgress()
    lib.callback('dt_battlepass:server:GetTaskProgress', false, function(progress)
        if progress and type(progress) == 'table' then
            if progress.distanceDriven then distanceDriven = tonumber(progress.distanceDriven) or 0 end
            if progress.distanceTraveled then distanceTraveled = tonumber(progress.distanceTraveled) or 0 end
            if progress.uniqueVehicles and type(progress.uniqueVehicles) == 'table' then
                -- Restore uniqueVehicles table (keys are vehicle model hashes)
                uniqueVehicles = {}
                for k, v in pairs(progress.uniqueVehicles) do
                    uniqueVehicles[tonumber(k) or k] = v
                end
            end
            if progress.itemsUsed then itemsUsed = tonumber(progress.itemsUsed) or 0 end
            if progress.foodEaten then foodEaten = tonumber(progress.foodEaten) or 0 end
            if progress.drinksConsumed then drinksConsumed = tonumber(progress.drinksConsumed) or 0 end
            if progress.medicalUsed then medicalUsed = tonumber(progress.medicalUsed) or 0 end
            if progress.vehiclesRepaired then vehiclesRepaired = tonumber(progress.vehiclesRepaired) or 0 end
            if progress.moneySpent then moneySpent = tonumber(progress.moneySpent) or 0 end
            if progress.jobsCompleted then jobsCompleted = tonumber(progress.jobsCompleted) or 0 end
        end
    end)
end

-- Task completion flags to prevent duplicate submissions
local taskCompleted = {
    Drive10Miles = false,
    Drive100Miles = false,
    Travel500Miles = false,
    DriveDifferentVehicles = false,
    UseItem5 = false,
    EatFood3 = false,
    Drink3 = false,
    RepairVehicle = false,
    SpendMoney = false,
    Spend50K = false,
    Complete10Jobs = false,
    UseMedical5 = false,
}

-- Food items list
local foodItems = {
    'burger', 'baconburger', 'baconcheesemelt', 'burger-moneyshot', 'burger-heartstopper',
    'hotdogsandwich', 'hotdog', 'bread', 'taco', 'frenchfries_generic',
    'wuwpops', 'catcookie', 'rainbowcupcake', 'confetticupcake', 'bento',
    'wuwbirthdaycake', 'catdonut', 'catbowl', 'pinkmochicat', 'orangemochicat',
    'greenmochicat', 'bluemochicat', 'catcakes', 'tiramisu', 'uwutakeout',
    'donut', 'seafood_beerbatterfish', 'seafood_calamari2', 'seafood_crabcakes',
    'seafood_grilledfish', 'seafood_kingcrab', 'seafood_lobster', 'seafood_shrimpcocktail',
    'seafood_shrimppasta', 'beef_jerky', 'phatchips_bigcheese', 'phatchips_habernero',
    'phatchips_stickyribs', 'snikkel_candy'
}

-- Drink items list
local drinkItems = {
    'water', 'sprunk', 'sprunk_light', 'ecola', 'ecola_light', 'coffee',
    'juice_pineapple', 'juice_apple', 'juice_cranberry', 'juice_grape',
    'vodka', 'whiskey', 'beer', 'wine', 'martini', 'latte',
    'cataccino', 'uwububbletea', 'catcoffee', 'catlatte'
}

-- Medical items list
local medicalItems = {
    'firstaid', 'ifaks', 'bandage', 'painkillers', 'morphine', 'xanax',
    'adderal', 'vicodin'
}

-- Distance conversion: 1 mile = 1609.34 meters
local MILE_TO_METERS = 1609.34

-- Track item usage function (defined before use)
local function TrackItemUsage(item)
    if not item then return end
    
    itemsUsed = itemsUsed + 1
    if itemsUsed >= 5 and not taskCompleted.UseItem5 then
        taskCompleted.UseItem5 = true
        TriggerServerEvent('dt_battlepass:server:FinishTask', 'UseItem5')
        SaveTaskProgress() -- Save immediately when task completes
    end
    
    -- Check food items
    for _, food in ipairs(foodItems) do
        if item == food then
            foodEaten = foodEaten + 1
            if foodEaten >= 3 and not taskCompleted.EatFood3 then
                taskCompleted.EatFood3 = true
                TriggerServerEvent('dt_battlepass:server:FinishTask', 'EatFood3')
                SaveTaskProgress() -- Save immediately when task completes
            end
            break
        end
    end
    
    -- Check drink items
    for _, drink in ipairs(drinkItems) do
        if item == drink then
            drinksConsumed = drinksConsumed + 1
            if drinksConsumed >= 3 and not taskCompleted.Drink3 then
                taskCompleted.Drink3 = true
                TriggerServerEvent('dt_battlepass:server:FinishTask', 'Drink3')
                SaveTaskProgress() -- Save immediately when task completes
            end
            break
        end
    end
    
    -- Check medical items
    for _, medical in ipairs(medicalItems) do
        if item == medical then
            medicalUsed = medicalUsed + 1
            if medicalUsed >= 5 and not taskCompleted.UseMedical5 then
                taskCompleted.UseMedical5 = true
                TriggerServerEvent('dt_battlepass:server:FinishTask', 'UseMedical5')
                SaveTaskProgress() -- Save immediately when task completes
            end
            break
        end
    end
    
    -- Check repair kit usage
    if (item == 'repairkit' or item == 'advancedrepairkit') and not taskCompleted.RepairVehicle then
        vehiclesRepaired = vehiclesRepaired + 1
        if vehiclesRepaired >= 1 then
            taskCompleted.RepairVehicle = true
            TriggerServerEvent('dt_battlepass:server:FinishTask', 'RepairVehicle')
            SaveTaskProgress() -- Save immediately when task completes
        end
    end
end

-- Load progress when player spawns
CreateThread(function()
    Wait(2000) -- Wait for player to fully load
    LoadTaskProgress()
end)

-- Periodic save (every 2 minutes)
CreateThread(function()
    while true do
        Wait(120000) -- Save every 2 minutes
        SaveTaskProgress()
    end
end)

-- Initialize position tracking
CreateThread(function()
    while true do
        Wait(1000) -- Check every second
        
        local ped = cache.ped
        local pedCoords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        -- Track vehicle distance
        if vehicle ~= 0 then
            if not isInVehicle or currentVehicle ~= vehicle then
                -- Player just entered a vehicle
                isInVehicle = true
                currentVehicle = vehicle
                lastVehiclePos = pedCoords
                
                -- Track unique vehicle model
                local vehicleModel = GetEntityModel(vehicle)
                if not uniqueVehicles[vehicleModel] then
                    uniqueVehicles[vehicleModel] = true
                end
            else
                -- Player is still in vehicle, track distance
                if lastVehiclePos then
                    local distance = #(pedCoords - lastVehiclePos)
                    distanceDriven = distanceDriven + distance
                    distanceTraveled = distanceTraveled + distance
                    lastVehiclePos = pedCoords
                else
                    lastVehiclePos = pedCoords
                end
            end
        else
            -- Player is on foot
            if isInVehicle then
                -- Player just exited vehicle
                isInVehicle = false
                currentVehicle = nil
            end
            
            -- Track on-foot distance
            if lastPedPos then
                local distance = #(pedCoords - lastPedPos)
                distanceTraveled = distanceTraveled + distance
            end
            lastPedPos = pedCoords
        end
        
        -- Check daily distance task (10 miles = 16,093 meters)
        if distanceDriven >= 16093 and not taskCompleted.Drive10Miles then
            taskCompleted.Drive10Miles = true
            TriggerServerEvent('dt_battlepass:server:FinishTask', 'Drive10Miles')
            SaveTaskProgress() -- Save immediately when task completes
        end
        
        -- Check weekly distance tasks
        if distanceDriven >= 160934 and not taskCompleted.Drive100Miles then -- 100 miles
            taskCompleted.Drive100Miles = true
            TriggerServerEvent('dt_battlepass:server:FinishTask', 'Drive100Miles')
            SaveTaskProgress() -- Save immediately when task completes
        end
        
        if distanceTraveled >= 804670 and not taskCompleted.Travel500Miles then -- 500 miles
            taskCompleted.Travel500Miles = true
            TriggerServerEvent('dt_battlepass:server:FinishTask', 'Travel500Miles')
            SaveTaskProgress() -- Save immediately when task completes
        end
        
        -- Check unique vehicles task (10 different vehicles)
        local uniqueCount = 0
        for _ in pairs(uniqueVehicles) do
            uniqueCount = uniqueCount + 1
        end
        if uniqueCount >= 10 and not taskCompleted.DriveDifferentVehicles then
            taskCompleted.DriveDifferentVehicles = true
            TriggerServerEvent('dt_battlepass:server:FinishTask', 'DriveDifferentVehicles')
            SaveTaskProgress() -- Save immediately when task completes
        end
    end
end)

-- Track item usage (ox_inventory events)
RegisterNetEvent('ox_inventory:itemUsed', function(item)
    if not item then return end
    TrackItemUsage(item)
end)

-- Alternative event names for item usage
RegisterNetEvent('ox_inventory:usedItem', function(item)
    if not item then return end
    TrackItemUsage(item)
end)

-- Track money spent (via ox_inventory or framework events)
RegisterNetEvent('ox_inventory:transactionComplete', function(data)
    if data and data.type == 'purchase' and data.price then
        moneySpent = moneySpent + data.price
        
        -- Check daily spending task ($5,000)
        if moneySpent >= 5000 and not taskCompleted.SpendMoney then
            taskCompleted.SpendMoney = true
            TriggerServerEvent('dt_battlepass:server:FinishTask', 'SpendMoney')
            SaveTaskProgress() -- Save immediately when task completes
        end
        
        -- Check weekly spending task ($50,000)
        if moneySpent >= 50000 and not taskCompleted.Spend50K then
            taskCompleted.Spend50K = true
            TriggerServerEvent('dt_battlepass:server:FinishTask', 'Spend50K')
            SaveTaskProgress() -- Save immediately when task completes
        end
    end
end)

-- Track money spent via server callback (for shops, etc.)
-- This will be called from server-side when money is spent
RegisterNetEvent('dt_battlepass:client:TrackSpending', function(amount)
    if amount and amount > 0 then
        moneySpent = moneySpent + amount
        
        if moneySpent >= 5000 and not taskCompleted.SpendMoney then
            taskCompleted.SpendMoney = true
            TriggerServerEvent('dt_battlepass:server:FinishTask', 'SpendMoney')
            SaveTaskProgress() -- Save immediately when task completes
        end
        
        if moneySpent >= 50000 and not taskCompleted.Spend50K then
            taskCompleted.Spend50K = true
            TriggerServerEvent('dt_battlepass:server:FinishTask', 'Spend50K')
            SaveTaskProgress() -- Save immediately when task completes
        end
    end
end)

-- Track job completions (generic event - adjust based on your job system)
RegisterNetEvent('qbx_truckerjob:server:getPaid', function()
    jobsCompleted = jobsCompleted + 1
    if jobsCompleted >= 10 and not taskCompleted.Complete10Jobs then
        taskCompleted.Complete10Jobs = true
        TriggerServerEvent('dt_battlepass:server:FinishTask', 'Complete10Jobs')
        SaveTaskProgress() -- Save immediately when task completes
    end
end)

-- Listen for other job completion events (add more as needed)
RegisterNetEvent('qb-jobs:server:JobCompleted', function()
    jobsCompleted = jobsCompleted + 1
    if jobsCompleted >= 10 and not taskCompleted.Complete10Jobs then
        taskCompleted.Complete10Jobs = true
        TriggerServerEvent('dt_battlepass:server:FinishTask', 'Complete10Jobs')
        SaveTaskProgress() -- Save immediately when task completes
    end
end)

-- Reset daily counters (called by server on daily reset)
RegisterNetEvent('dt_battlepass:client:ResetDailyCounters', function()
    distanceDriven = 0
    itemsUsed = 0
    foodEaten = 0
    drinksConsumed = 0
    vehiclesRepaired = 0
    moneySpent = 0
    lastVehiclePos = nil
    lastPedPos = nil
    -- Reset daily task completion flags
    taskCompleted.Drive10Miles = false
    taskCompleted.UseItem5 = false
    taskCompleted.EatFood3 = false
    taskCompleted.Drink3 = false
    taskCompleted.RepairVehicle = false
    taskCompleted.SpendMoney = false
    -- Save reset progress
    SaveTaskProgress()
end)

-- Reset weekly counters (called by server on weekly reset)
RegisterNetEvent('dt_battlepass:client:ResetWeeklyCounters', function()
    distanceDriven = 0
    distanceTraveled = 0
    uniqueVehicles = {}
    jobsCompleted = 0
    medicalUsed = 0
    moneySpent = 0
    -- Reset weekly task completion flags
    taskCompleted.Drive100Miles = false
    taskCompleted.Travel500Miles = false
    taskCompleted.DriveDifferentVehicles = false
    taskCompleted.Complete10Jobs = false
    taskCompleted.UseMedical5 = false
    taskCompleted.Spend50K = false
    -- Save reset progress
    SaveTaskProgress()
end)

-- Save progress on resource stop or player disconnect
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SaveTaskProgress()
    end
end)

-- Save progress when player is about to disconnect
AddEventHandler('playerDropped', function()
    SaveTaskProgress()
end)

-- Export function to get current stats (for debugging)
exports('GetTaskStats', function()
    return {
        distanceDriven = distanceDriven,
        distanceTraveled = distanceTraveled,
        uniqueVehicles = uniqueVehicles,
        itemsUsed = itemsUsed,
        foodEaten = foodEaten,
        drinksConsumed = drinksConsumed,
        medicalUsed = medicalUsed,
        vehiclesRepaired = vehiclesRepaired,
        moneySpent = moneySpent,
        jobsCompleted = jobsCompleted
    }
end)


