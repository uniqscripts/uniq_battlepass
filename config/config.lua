return {
    -- Default image to use if the Steam image is not loaded.
    DefaultImage = 'https://avatars.steamstatic.com/b5bd56c1aa4644a474a2e4972be27ef9e82e517e_full.jpg',

    -- Automatically deletes a player's progress if they haven't logged in for a certain time.
    -- Currently set to delete progress after 2 months of inactivity.
    DeletePlayer = '2 MONTH',

    -- Plate format for vehicles. Check the documentation at https://overextended.dev/ox_lib/Modules/String/Shared for more details.
    PlateFormat = '........',

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
    XPPerLevel = 1000,

    -- Reward players with XP for playing on the server.
    -- NOTE: Any task that has "repeatTillFinish" option will go trough this function if its turned on so make sure that you sync task with this
    PlayTimeReward = {
        enable = true,  -- Set to false if you don't want to enable this feature.
        interval = 5,   -- Time interval in minutes to give XP.
        xp = 250,       -- The amount of XP given at each interval.
        notify = true   -- Notify the player when they receive XP for playing.
    },

    Rewards = {
        FreePass = {
            [1] = { -- Rewards for the 1st week of the month.
                { name = 'water', label = 'Water', requirements = { tier = 0, xp = 150 }, amount = 10, metadata = { description = 'This is metadata' } },
            },
            [2] = { -- Rewards for the 2nd week of the month.
                { name = 'money', label = 'Money', requirements = { tier = 1, xp = 150 }, amount = 150 },
            },
            [3] = { -- Rewards for the 3rd week of the month.

                /*
                    Example for a vehicle reward. The vehicle will be added to the player's owned_vehicles or player_vehicles depending on your framework.
                    If img is left empty, it will use the image from the web/img folder.
                    Configure the properties table based on your function for setting vehicle properties. We recommend using lib.setVehicleProperties for more options (like RGB colors).
                    For QBCore, you can use the following example (example down there is for esx):
                    vehicle = { garage = 'pillboxgarage', state = 1, drivingdistance = 0, properties = {...} }
                */

                {
                    name = 'zentorno',
                    label = 'Zentorno',
                    img = 'https://docs.fivem.net/vehicles/zentorno.webp',
                    requirements = { tier = 5, xp = 150 },
                    vehicle = { type = 'car', stored = 1, garage = 'SanAndreasAvenue', properties = { color1 = 0, color2 = 27, neonEnabled = { 1, 2, 3, 4 } } }
                },
            },
            [4] = { -- Rewards for the 4th week of the month.
                { name = 'water', label = 'Water', requirements = { tier = 0, xp = 150 }, amount = 10, metadata = { description = 'This is metadata' } },
            },
            [5] = { -- Rewards for the 4th week of the month.
                { name = 'water', label = 'Water', requirements = { tier = 0, xp = 150 }, amount = 10, metadata = { description = 'This is metadata' } },
            },
        },

        -- Rewards for players with a Premium Pass.
        PremiumPass = {
            [1] = { -- Rewards for the 1st week of the month.
                { name = 'WEAPON_PISTOL', label = 'Pistol', requirements = { tier = 0, xp = 150 }, amount = 1 },
            },
            [2] = { -- Rewards for the 2nd week of the month.
                { name = 'WEAPON_PISTOL', label = 'Pistol', requirements = { tier = 0, xp = 150 }, amount = 1 },
            },
            [3] = { -- Rewards for the 3rd week of the month.
                {
                    name = 'zentorno',
                    label = 'Zentorno',
                    img = 'https://docs.fivem.net/vehicles/zentorno.webp',
                    requirements = { tier = 5, xp = 150 },
                    vehicle = { type = 'car', stored = 1, garage = 'SanAndreasAvenue', properties = { color1 = 0, color2 = 27, neonEnabled = { 1, 2, 3, 4 } }}
                },
            },
            [4] = { -- Rewards for the 4th week of the month.
                { name = 'WEAPON_PISTOL', label = 'Pistol', requirements = { tier = 0, xp = 150 }, amount = 1 },
            },
            [5] = { -- Rewards for the 4th week of the month.
                { name = 'WEAPON_PISTOL', label = 'Pistol', requirements = { tier = 0, xp = 150 }, amount = 1 },
            },
        }
    },

    BattleShop = {
        [1] = { -- Items available in the shop during the 1st week of the month.
            { name = 'water', label = 'Water', price = 50, currency = 'money', amount = 10, metadata = { description = 'This is metadata' } },
        },
        [2] = { -- Items available in the shop during the 2nd week of the month.
            { name = 'water', label = 'Water', price = 50, currency = 'money', amount = 10, metadata = { description = 'This is metadata' } },
        },
        [3] = { -- Items available in the shop during the 3rd week of the month.
            { name = 'water', label = 'Water', price = 50, currency = 'money', amount = 10, metadata = { description = 'This is metadata' } },
            {
                name = 'zentorno',
                label = 'Zentorno',
                img = 'https://docs.fivem.net/vehicles/zentorno.webp',
                currency = 'money',
                price = 50,
                vehicle = { type = 'car', stored = 1, garage = 'SanAndreasAvenue', properties = { color1 = 0, color2 = 27, neonEnabled = { 1, 2, 3, 4 } }}
            },

        },
        [4] = { -- Items available in the shop during the 4th week of the month.
            { name = 'water', label = 'Water', price = 50, currency = 'money', amount = 10, metadata = { description = 'This is metadata' } },
        },
        [5] = { -- Items available in the shop during the 4th week of the month.
            { name = 'water', label = 'Water', price = 50, currency = 'money', amount = 10, metadata = { description = 'This is metadata' } },
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
    ResetPlaytime = true,

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
                repeatTillFinish = 12 -- how many times interval needs to repeat to finish this (Your desired time / PlayTimeReward.interval | 60 / 5 = 12)
            }
        },

        Weekly = {
            ['Play120'] = {
                title = 'Play 120min',
                description = 'Play for 120 min on server <br> Reward: 1200XP', -- supports HTML elements
                xp = 1200,
                repeatTillFinish = 24
            }
        }
    }
}