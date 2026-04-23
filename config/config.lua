return {
    -- Default image to use if the Steam image is not loaded.
    DefaultImage = 'https://avatars.steamstatic.com/b5bd56c1aa4644a474a2e4972be27ef9e82e517e_full.jpg',

    -- Automatically deletes a player's progress if they haven't logged in for a certain time.
    -- Currently set to delete progress after 2 months of inactivity.
    DeletePlayer = '2 MONTH',

    -- Plate format for vehicles. Check the documentation at https://overextended.dev/ox_lib/Modules/String/Shared for more details.
    PlateFormat = 'AAAA 111',

    Commands = {
        battlepass = {
            name = 'battlepass',
            help = 'Open Battlepass Menu',
        },
        givepass = {
            name = 'givepremium',
            help = 'Gives premium pass to a player',
            restricted = 'group.admin'
        },
        wipe = {
            name = 'wipeplayer',
            help = 'Wipes a player\'s Battle Pass progress (including premium pass status)',
            restricted = 'group.admin'
        },
        givexp = {
            name = 'givexp',
            help = 'Gives XP to a player',
            restricted = 'group.admin'
        },
        removexp = {
            name = 'removexp',
            help = 'Remove XP from player',
            restricted = 'group.admin'
        },
        addplaytime = {
            name = 'addplaytime',
            help = 'Add playtime intervals to a player',
            restricted = 'group.admin'
        },
        wipeall = {
            name = 'wipeall',
            help = 'Wipes Battle Pass progress of all players (online & offline)',
            restricted = 'group.admin'
        },
        premiumDuration = {
            name = 'checkpremium',
            help = 'Shows you how long your battlepass will last'
        }
    },

    -- The amount of XP required for next tier.
    XPPerLevel = 5001,

    -- Reward players with XP for playing on the server.
    -- NOTE: Any task that has "repeatTillFinish" option will go trough this function if its turned on so make sure that you sync task with this
    PlayTimeReward = {
        enable = true,  -- Set to false if you don't want to enable this feature.
        interval = 30,   -- Time interval in minutes to give XP.
        xp = 250,       -- The amount of XP given at each interval.
        notify = true   -- Notify the player when they receive XP for playing.
    },

    Rewards = {
        FreePass = {
            [1] = { -- Tier 1 - Starter Supplies
                { name = 'water', label = 'Water', requirements = { tier = 1, xp = 0 }, amount = 10 },
                { name = 'burger', label = 'Burger', requirements = { tier = 1, xp = 1250 }, amount = 6 },
                { name = 'frenchfries_generic', label = 'FrenchFries', requirements = { tier = 1, xp = 2500 }, amount = 4 },
                { name = 'coffee', label = 'Coffee', requirements = { tier = 1, xp = 3750 }, amount = 4 },
                { name = 'bandage', label = 'Bandage', requirements = { tier = 1, xp = 5000 }, amount = 6 },
            },
            [2] = { -- Tier 2 - Daily Essentials
                { name = 'firstaid', label = 'First Aid Kit', requirements = { tier = 2, xp = 0 }, amount = 3 },
                { name = 'phone', label = 'Phone', requirements = { tier = 2, xp = 1250 }, amount = 1 },
                { name = 'radio', label = 'Radio', requirements = { tier = 2, xp = 2500 }, amount = 1 },
                { name = 'lockpick', label = 'Lockpick', requirements = { tier = 2, xp = 3750 }, amount = 3 },
                { name = 'repairkit', label = 'Repair Kit', requirements = { tier = 2, xp = 5000 }, amount = 2 },
            },
            [3] = { -- Tier 3 - Emergency Response
                { name = 'bandage', label = 'Bandage', requirements = { tier = 3, xp = 0 }, amount = 6 },
                { name = 'painkillers', label = 'Painkillers', requirements = { tier = 3, xp = 1250 }, amount = 4 },
                { name = 'firstaid', label = 'First Aid Kit', requirements = { tier = 3, xp = 2500 }, amount = 3 },
                { name = 'ifaks', label = 'IFAK', requirements = { tier = 3, xp = 3750 }, amount = 2 },
                { name = 'armour', label = 'Bulletproof Vest', requirements = { tier = 3, xp = 5000 }, amount = 1 },
            },
            [4] = { -- Tier 4 - Workshop Tools
                { name = 'tirekit', label = 'Tire Kit', requirements = { tier = 4, xp = 0 }, amount = 3 },
                { name = 'repairkit', label = 'Repair Kit', requirements = { tier = 4, xp = 1250 }, amount = 3 },
                { name = 'advancedrepairkit', label = 'Advanced Repair Kit', requirements = { tier = 4, xp = 2500 }, amount = 1 },
                { name = 'screwdriverset', label = 'Screwdriver Set', requirements = { tier = 4, xp = 3750 }, amount = 1 },
                { name = 'lighter', label = 'Lighter', requirements = { tier = 4, xp = 5000 }, amount = 1 },
            },
            [5] = { -- Tier 5 - Mobility & Safety
                { name = 'coca_seed', label = 'Coca Seed', requirements = { tier = 5, xp = 0 }, amount = 1 },
                { name = 'parachute', label = 'Parachute', requirements = { tier = 5, xp = 1250 }, amount = 1 },
                { name = 'harness', label = 'Harness', requirements = { tier = 5, xp = 2500 }, amount = 1 },
                { name = 'stancerkit', label = 'Stancer Kit', requirements = { tier = 5, xp = 3750 }, amount = 1 },
                { name = 'advancedlockpick', label = 'Advanced Lockpick', requirements = { tier = 5, xp = 5000 }, amount = 1 },
            },
            [6] = { -- Tier 6 - Utility Toolkit
                { name = 'lockpick', label = 'Lockpick', requirements = { tier = 6, xp = 0 }, amount = 3 },
                { name = 'repairkit', label = 'Repair Kit', requirements = { tier = 6, xp = 1250 }, amount = 2 },
                { name = 'tirekit', label = 'Tire Kit', requirements = { tier = 6, xp = 2500 }, amount = 2 },
                { name = 'radio', label = 'Radio', requirements = { tier = 6, xp = 3750 }, amount = 1 },
                { name = 'electronickit', label = 'Electronic Kit', requirements = { tier = 6, xp = 5000 }, amount = 1 },
            },
            [7] = { -- Tier 7 - Supply Crate
                { name = 'water', label = 'Water', requirements = { tier = 7, xp = 0 }, amount = 12 },
                { name = 'burger', label = 'Burger', requirements = { tier = 7, xp = 1250 }, amount = 8 },
                { name = 'sprunk', label = 'Sprunk', requirements = { tier = 7, xp = 2500 }, amount = 6 },
                { name = 'coffee', label = 'Coffee', requirements = { tier = 7, xp = 3750 }, amount = 6 },
                { name = 'bandage', label = 'Bandage', requirements = { tier = 7, xp = 5000 }, amount = 8 },
            },
            [8] = { -- Tier 8 - Medical & Defense
                { name = 'bandage', label = 'Bandage', requirements = { tier = 8, xp = 0 }, amount = 8 },
                { name = 'painkillers', label = 'Painkillers', requirements = { tier = 8, xp = 1250 }, amount = 4 },
                { name = 'firstaid', label = 'First Aid Kit', requirements = { tier = 8, xp = 2500 }, amount = 4 },
                { name = 'ifaks', label = 'IFAK', requirements = { tier = 8, xp = 3750 }, amount = 2 },
                { name = 'armour', label = 'Bulletproof Vest', requirements = { tier = 8, xp = 5000 }, amount = 1 },
            },
            [9] = { -- Tier 9 - Field Support
                { name = 'repairkit', label = 'Repair Kit', requirements = { tier = 9, xp = 0 }, amount = 2 },
                { name = 'tirekit', label = 'Tire Kit', requirements = { tier = 9, xp = 1250 }, amount = 2 },
                { name = 'screwdriverset', label = 'Screwdriver Set', requirements = { tier = 9, xp = 2500 }, amount = 1 },
                { name = 'coca_seed', label = 'Coca Seed', requirements = { tier = 9, xp = 3750 }, amount = 1 },
                { name = 'harness', label = 'Harness', requirements = { tier = 9, xp = 5000 }, amount = 1 },
            },
            [10] = { -- Tier 10 - Covert Ops
                { name = 'advancedrepairkit', label = 'Advanced Repair Kit', requirements = { tier = 10, xp = 0 }, amount = 1 },
                { name = 'advancedlockpick', label = 'Advanced Lockpick', requirements = { tier = 10, xp = 1250 }, amount = 1 },
                { name = 'electronickit', label = 'Electronic Kit', requirements = { tier = 10, xp = 2500 }, amount = 1 },
                { name = 'drillbit', label = 'Drill Bit', requirements = { tier = 10, xp = 3750 }, amount = 2 },
                { name = 'miningdrill', label = 'Mining Drill', requirements = { tier = 10, xp = 5000 }, amount = 1 },
            },
        },

        -- Rewards for players with a Premium Pass.
        PremiumPass = {
            [1] = { -- Tier 1 - Premium Starter
                { name = 'money', label = 'Money', requirements = { tier = 1, xp = 0 }, amount = 20000 },
                { name = 'water', label = 'Water', requirements = { tier = 1, xp = 1250 }, amount = 15 },
                { name = 'burger', label = 'Burger', requirements = { tier = 1, xp = 2500 }, amount = 12 },
                { name = 'coffee', label = 'Coffee', requirements = { tier = 1, xp = 3750 }, amount = 10 },
                { name = 'firstaid', label = 'First Aid Kit', requirements = { tier = 1, xp = 5000 }, amount = 5 },
            },
            [2] = { -- Tier 2 - Premium Utilities
                { name = 'phone', label = 'Phone', requirements = { tier = 2, xp = 0 }, amount = 2 },
                { name = 'radio', label = 'Radio', requirements = { tier = 2, xp = 1250 }, amount = 2 },
                { name = 'lockpick', label = 'Lockpick', requirements = { tier = 2, xp = 2500 }, amount = 5 },
                { name = 'advancedlockpick', label = 'Advanced Lockpick', requirements = { tier = 2, xp = 3750 }, amount = 2 },
                { name = 'repairkit', label = 'Repair Kit', requirements = { tier = 2, xp = 5000 }, amount = 4 },
            },
            [3] = { -- Tier 3 - Premium Medical
                { name = 'bandage', label = 'Bandage', requirements = { tier = 3, xp = 0 }, amount = 10 },
                { name = 'painkillers', label = 'Painkillers', requirements = { tier = 3, xp = 1250 }, amount = 6 },
                { name = 'firstaid', label = 'First Aid Kit', requirements = { tier = 3, xp = 2500 }, amount = 5 },
                { name = 'ifaks', label = 'IFAK', requirements = { tier = 3, xp = 3750 }, amount = 4 },
                { name = 'armour', label = 'Bulletproof Vest', requirements = { tier = 3, xp = 5000 }, amount = 2 },
            },
            [4] = { -- Tier 4 - Premium Workshop
                { name = 'tirekit', label = 'Tire Kit', requirements = { tier = 4, xp = 0 }, amount = 4 },
                { name = 'repairkit', label = 'Repair Kit', requirements = { tier = 4, xp = 1250 }, amount = 4 },
                { name = 'advancedrepairkit', label = 'Advanced Repair Kit', requirements = { tier = 4, xp = 2500 }, amount = 3 },
                { name = 'screwdriverset', label = 'Screwdriver Set', requirements = { tier = 4, xp = 3750 }, amount = 2 },
                { name = 'lighter', label = 'Lighter', requirements = { tier = 4, xp = 5000 }, amount = 2 },
            },
            [5] = { -- Tier 5 - Premium Mobility
                { name = 'coca_seed', label = 'Coca Seed', requirements = { tier = 5, xp = 0 }, amount = 2 },
                { name = 'parachute', label = 'Parachute', requirements = { tier = 5, xp = 1250 }, amount = 2 },
                { name = 'harness', label = 'Harness', requirements = { tier = 5, xp = 2500 }, amount = 2 },
                { name = 'stancerkit', label = 'Stancer Kit', requirements = { tier = 5, xp = 3750 }, amount = 2 },
                { name = 'miningdrill', label = 'Mining Drill', requirements = { tier = 5, xp = 5000 }, amount = 2 },
            },
            [6] = { -- Tier 6 - Contraband Cache
                { name = 'advancedlockpick', label = 'Advanced Lockpick', requirements = { tier = 6, xp = 0 }, amount = 3 },
                { name = 'repairkit', label = 'Repair Kit', requirements = { tier = 6, xp = 1250 }, amount = 4 },
                { name = 'electronickit', label = 'Electronic Kit', requirements = { tier = 6, xp = 2500 }, amount = 2 },
                { name = 'miningdrill', label = 'Mining Drill', requirements = { tier = 6, xp = 3750 }, amount = 2 },
                { name = 'armour', label = 'Bulletproof Vest', requirements = { tier = 6, xp = 5000 }, amount = 2 },
            },
            [7] = { -- Tier 7 - Premium Support Haul
                { name = 'coca_seed', label = 'Coca Seed', requirements = { tier = 7, xp = 0 }, amount = 2 },
                { name = 'harness', label = 'Harness', requirements = { tier = 7, xp = 1250 }, amount = 2 },
                { name = 'stancerkit', label = 'Stancer Kit', requirements = { tier = 7, xp = 2500 }, amount = 2 },
                { name = 'lighter', label = 'Lighter', requirements = { tier = 7, xp = 3750 }, amount = 2 },
                { name = 'advancedrepairkit', label = 'Advanced Repair Kit', requirements = { tier = 7, xp = 5000 }, amount = 2 },
            },
            [8] = { -- Tier 8 - Premium Heist Arsenal
                { name = 'drillbit', label = 'Drill Bit', requirements = { tier = 8, xp = 0 }, amount = 2 },
                { name = 'trojan_usb', label = 'Trojan USB', requirements = { tier = 8, xp = 1250 }, amount = 2 },
                { name = 'drill', label = 'Drill', requirements = { tier = 8, xp = 2500 }, amount = 2 },
                { name = 'thermite', label = 'Thermite', requirements = { tier = 8, xp = 3750 }, amount = 2 },
                { name = 'security_card_02', label = 'Security Card 2', requirements = { tier = 8, xp = 5000 }, amount = 2 },
            },
            [9] = { -- Tier 9 - Premium Exploration Kit
                { name = 'diving_gear', label = 'Diving Gear', requirements = { tier = 9, xp = 0 }, amount = 1 },
                { name = 'diving_fill', label = 'Diving Tube', requirements = { tier = 9, xp = 1250 }, amount = 2 },
                { name = 'antipatharia_coral', label = 'Antipatharia', requirements = { tier = 9, xp = 2500 }, amount = 2 },
                { name = 'dendrogyra_coral', label = 'Dendrogyra', requirements = { tier = 9, xp = 3750 }, amount = 2 },
                { name = 'cactusbulb', label = 'Cactus Bulb', requirements = { tier = 9, xp = 5000 }, amount = 3 },
            },
            [10] = { -- Tier 10 - Premium Specialist Cache
                { name = 'money', label = 'Money', requirements = { tier = 10, xp = 0 }, amount = 50000 },
                { name = 'security_card_01', label = 'Security Card 1', requirements = { tier = 10, xp = 1250 }, amount = 3 },
                { name = 'mininglaser', label = 'Mining Laser', requirements = { tier = 10, xp = 2500 }, amount = 1 },
                { name = 'fakeplate', label = 'Fake Plate', requirements = { tier = 10, xp = 3750 }, amount = 1 },
                { name = 'customplate', label = 'Custom Plate', requirements = { tier = 10, xp = 5000 }, amount = 1 },
            },
        }
    },

    BattleShop = {
        [1] = { -- Week 1 - Basic Consumables & Essentials (Discounted prices)
            { name = 'water', label = 'Water (x10)', price = 50, currency = 'money', amount = 10 }, -- $5 each (vs $10 in shops)
            { name = 'burger', label = 'Burger (x5)', price = 50, currency = 'money', amount = 5 }, -- $10 each
            { name = 'coffee', label = 'Coffee (x5)', price = 400, currency = 'money', amount = 5 }, -- $80 each (Pearls price)
            { name = 'bandage', label = 'Bandage (x10)', price = 50, currency = 'money', amount = 10 }, -- $5 each (vs $10 in shops)
            { name = 'lockpick', label = 'Lockpick (x5)', price = 100, currency = 'money', amount = 5 }, -- $20 each (YouTool price)
        },
        [2] = { -- Week 2 - Better Items & Tools (Discounted prices)
            { name = 'firstaid', label = 'First Aid Kit (x3)', price = 15, currency = 'money', amount = 3 }, -- $5 each (MedicalSupply price)
            { name = 'repairkit', label = 'Repair Kit (x2)', price = 500, currency = 'money', amount = 2 }, -- $250 each (MechanicSupply price)
            { name = 'tirekit', label = 'Tire Kit (x3)', price = 450, currency = 'money', amount = 3 }, -- $150 each (MechanicSupply price)
            { name = 'coca_seed', label = 'Coca Seed', price = 750, currency = 'money', amount = 1 },
            { name = 'radio', label = 'Radio', price = 1500, currency = 'money', amount = 1 }, -- DigitalDen price
            { name = 'phone', label = 'Phone', price = 1000, currency = 'money', amount = 1 }, -- DigitalDen price
        },
        [3] = { -- Week 3 - Advanced Items & Rare Consumables
            { name = 'ifaks', label = 'IFAK (x3)', price = 15, currency = 'money', amount = 3 }, -- $5 each (MedicalSupply price)
            { name = 'advancedrepairkit', label = 'Advanced Repair Kit (x2)', price = 2000, currency = 'money', amount = 2 }, -- Estimated $1000 each
            { name = 'advancedlockpick', label = 'Advanced Lockpick (x3)', price = 300, currency = 'money', amount = 3 }, -- Estimated $100 each
            { name = 'armour', label = 'Bulletproof Vest', price = 11700, currency = 'money', amount = 1 }, -- BlackMarketArms price
            { name = 'parachute', label = 'Parachute', price = 20000, currency = 'money', amount = 1 }, -- Estimated price
            { name = 'screwdriverset', label = 'Screwdriver Set', price = 20000, currency = 'money', amount = 1 }, -- Estimated price
            { name = 'harness', label = 'Harness', price = 15000, currency = 'money', amount = 1 }, -- Estimated price
        },
        [4] = { -- Week 4 - Premium Items & Raid Gear
            { name = 'drillbit', label = 'Drill Bit', price = 7500, currency = 'money', amount = 1 },
            { name = 'trojan_usb', label = 'Trojan USB', price = 6500, currency = 'money', amount = 1 },
            { name = 'drill', label = 'Drill', price = 10000, currency = 'money', amount = 1 },
            { name = 'thermite', label = 'Thermite', price = 8500, currency = 'money', amount = 1 },
            { name = 'electronickit', label = 'Electronic Kit', price = 4680, currency = 'money', amount = 1 }, -- BlackMarketArms price
            { name = 'screwdriverset', label = 'Screwdriver Set', price = 2000, currency = 'money', amount = 1 }, -- Estimated
            { name = 'harness', label = 'Harness', price = 15000, currency = 'money', amount = 1 }, -- Estimated
            { name = 'handcuffs', label = 'Handcuffs (x2)', price = 50000, currency = 'money', amount = 2 }, -- $2 each (PoliceArmoury price)
        },
        [5] = { -- Week 5 - Exclusive Exploration & Utility Stock
            { name = 'diving_gear', label = 'Diving Gear', price = 25000, currency = 'money', amount = 1 },
            { name = 'diving_fill', label = 'Diving Tube (x2)', price = 8000, currency = 'money', amount = 2 },
            { name = 'antipatharia_coral', label = 'Antipatharia', price = 6000, currency = 'money', amount = 1 },
            { name = 'dendrogyra_coral', label = 'Dendrogyra', price = 6000, currency = 'money', amount = 1 },
            { name = 'miningdrill', label = 'Mining Drill', price = 15000, currency = 'money', amount = 1 },
            { name = 'lighter', label = 'Lighter', price = 6000, currency = 'money', amount = 1 },
            { name = 'mininglaser', label = 'Mining Laser', price = 20000, currency = 'money', amount = 1 },
            { name = 'miningdrill', label = 'Mining Drill', price = 18000, currency = 'money', amount = 1 },
        },
    },

    /*
        Duration of the Premium Pass for players. The pass is valid from the start date to the end date, currently set to 30 days.
        This uses os.time, meaning it will use the time from your VPS/dedicated server, so ensure the time & date are correct.
    */
    PremiumDuration = 30,

    PremiumPrice = { currency = 'money', amount = 100000 },

    -- when to restart daily tasks, currently ever day at 00, https://crontab.guru/
    DailyReset = '0 0 * * *',

    -- when to restart daily tasks, currently ever monday at 00
    WeeklyRestart = '0 0 * * 1',


    -- The schedule for resetting all players' Battle Pass stats. 
    -- Currently set to reset at 00:00 on the 1st day of every month.
    -- If your server is offline at that time, you can manually reset using the /wipeall command.
    MonthlyRestart = {
        enabled = true,
        cron = '0 0 1 * *' -- every 1st day of month at 00:00
    },

    -- When player leaves server does play time resets, player played for 59 min, left, came back after few days and finished that 60min play task
    ResetPlaytime = false,

    TaskList = {
        Daily = {
            ['SignIn'] = { -- if you want to keep this dont rename key
                title = 'Sign In',
                description = 'Sign in and receive 300XP',
                xp = 300,
            },

            ['Play60'] = { -- dont name daily and weekly tasks table key same
                title = 'Play 60min',
                description = 'Play for 60 min on server <br> Reward: 600XP', -- supports HTML elements
                xp = 600,
                repeatTillFinish = 2 -- how many times interval needs to repeat to finish this (Your desired time / PlayTimeReward.interval | 60 / 5 = 12)
            },

            ['Drive10Miles'] = {
                title = 'Road Warrior',
                description = 'Drive 10 miles in any vehicle <br> Reward: 500XP',
                xp = 500,
                -- Note: Requires client-side tracking integration (16,093 meters = 10 miles)
                -- Call: exports['dt_battlepass']:FinishTask('Drive10Miles') when distance reached
            },

            ['UseItem5'] = {
                title = 'Item User',
                description = 'Use any item 5 times <br> Reward: 400XP',
                xp = 400,
                -- Note: Track item usage and call: exports['dt_battlepass']:FinishTask('UseItem5')
            },

            ['EatFood3'] = {
                title = 'Foodie',
                description = 'Eat food items 3 times <br> Reward: 300XP',
                xp = 300,
                -- Note: Track food consumption and call: exports['dt_battlepass']:FinishTask('EatFood3')
            },

            ['Drink3'] = {
                title = 'Hydration Station',
                description = 'Drink beverages 3 times <br> Reward: 300XP',
                xp = 300,
                -- Note: Track drink consumption and call: exports['dt_battlepass']:FinishTask('Drink3')
            },

            ['RepairVehicle'] = {
                title = 'Mechanic',
                description = 'Repair a vehicle using a repair kit <br> Reward: 450XP',
                xp = 450,
                -- Note: Track repairkit usage and call: exports['dt_battlepass']:FinishTask('RepairVehicle')
            },

            ['SpendMoney'] = {
                title = 'Big Spender',
                description = 'Spend $5,000 or more <br> Reward: 400XP',
                xp = 400,
                -- Note: Track money spent and call: exports['dt_battlepass']:FinishTask('SpendMoney')
            },
        },

        Weekly = {
            ['Play120'] = {
                title = 'Play 120min',
                description = 'Play for 120 min on server <br> Reward: 1200XP', -- supports HTML elements
                xp = 1200,
                repeatTillFinish = 4
            },

            ['Drive100Miles'] = {
                title = 'Cross Country Driver',
                description = 'Drive 100 miles total this week <br> Reward: 2000XP',
                xp = 2000,
                -- Note: Requires client-side tracking integration (160,934 meters = 100 miles)
                -- Track cumulative distance and call: exports['dt_battlepass']:FinishTask('Drive100Miles')
            },

            ['Complete10Jobs'] = {
                title = 'Workaholic',
                description = 'Complete 10 job tasks/activities <br> Reward: 1500XP',
                xp = 1500,
                -- Note: Track job completions and call: exports['dt_battlepass']:FinishTask('Complete10Jobs')
            },

            ['Travel500Miles'] = {
                title = 'Globetrotter',
                description = 'Travel 500 miles total this week <br> Reward: 3000XP',
                xp = 3000,
                -- Note: Track all travel (vehicle + on foot) and call: exports['dt_battlepass']:FinishTask('Travel500Miles')
            },

            ['UseMedical5'] = {
                title = 'Medic',
                description = 'Use medical items 5 times <br> Reward: 800XP',
                xp = 800,
                -- Note: Track medical item usage (firstaid, ifaks, bandage, etc.) and call: exports['dt_battlepass']:FinishTask('UseMedical5')
            },

            ['Spend50K'] = {
                title = 'High Roller',
                description = 'Spend $50,000 or more this week <br> Reward: 1200XP',
                xp = 1200,
                -- Note: Track cumulative spending and call: exports['dt_battlepass']:FinishTask('Spend50K')
            },

            ['DriveDifferentVehicles'] = {
                title = 'Vehicle Collector',
                description = 'Drive 10 different vehicle models <br> Reward: 1500XP',
                xp = 1500,
                -- Note: Track unique vehicles driven and call: exports['dt_battlepass']:FinishTask('DriveDifferentVehicles')
            },

            ['TruckerMiles'] = {
                title = 'Long Haul Trucker',
                description = 'Drive 50 miles while doing trucker deliveries <br> Reward: 2500XP',
                xp = 2500,
                -- Note: Integrate with qbx_truckerjob distance tracking (80,467 meters = 50 miles)
                -- Call from truckerjob when distance reached: exports['dt_battlepass']:FinishTask('TruckerMiles')
            },
        }
    }
}