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
        givecoins = {
            name = 'givecoins',
            help = 'Gives coins to a player',
            restricted = 'group.admin'
        },
        removecoins = {
            name = 'removecoins',
            help = 'Removes coins from a player',
            restricted = 'group.admin'
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
                { name = 'ammo-9', label = 'Pistol Ammo', requirements = { tier = 2, xp = 150 }, amount = 200 },
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
        }
    },

    BattleShop = {
        [1] = { -- Items available in the shop during the 1st week of the month.
            { name = 'water', label = 'Water', coins = 50, amount = 10, metadata = { description = 'This is metadata' } },
        },
        [2] = { -- Items available in the shop during the 2nd week of the month.
            { name = 'water', label = 'Water', coins = 50, amount = 10, metadata = { description = 'This is metadata' } },
        },
        [3] = { -- Items available in the shop during the 3rd week of the month.
            { name = 'water', label = 'Water', coins = 50, amount = 10, metadata = { description = 'This is metadata' } },
            {
                name = 'zentorno',
                label = 'Zentorno',
                img = 'https://docs.fivem.net/vehicles/zentorno.webp',
                coins = 50,
                vehicle = { type = 'car', stored = 1, garage = 'SanAndreasAvenue', properties = { color1 = 0, color2 = 27, neonEnabled = { 1, 2, 3, 4 } }}
            },

        },
        [4] = { -- Items available in the shop during the 4th week of the month.
            { name = 'water', label = 'Water', coins = 50, amount = 10, metadata = { description = 'This is metadata' } },
        },
    },

    /*
        To give 100 coins to a player, use the command example shown in the file code_example.png.

        The command format must always be: "command {sid} amount".

        The "Requires Player To Be Online" option must be enabled, or this won't work.

        For more details, check the tutorial: https://www.youtube.com/watch?v=it-eiJDwV5E

        The CFX account used to purchase coins must be authorized in the player's FiveM client. 
        The player must be online on the server when purchasing.

        After creating a new package, we recommend waiting a few hours before allowing people to purchase it.
        Sometimes it takes over 5 minutes for a new package to process, but after a few hours, it executes within 30 seconds.
    */
    BuyCoinsCommand = 'purchase_coins_for_battlepass',

    /*
        Same requirements as above. The player must be online on the server when purchasing & the CFX account must be the same.

        The command format must always be: "command {sid}"
    */

    BuyPremiumPassCommand = 'buy_premium_pass',

    /*
        Duration of the Premium Pass for players. The pass is valid from the start date to the end date, currently set to 30 days.
        This uses os.time, meaning it will use the time from your VPS/dedicated server, so ensure the time & date are correct.
    */
    PremiumDuration = 30,

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

    TaskList = {
        Daily = {
            ['SignIn'] = { -- if you want to keep this dont rename key
                title = 'Sign In',
                description = 'Sign in and receive 300XP',
                xp = 300,
            },

            ['Play60'] = {
                title = 'Play 60min',
                description = 'Play for 60 min on server <br> Reward: 600XP', -- supports HTML elements
                xp = 600,
            }
        },

        Weekly = {
            ['Play120'] = {
                title = 'Play 120min',
                description = 'Play for 120 min on server <br> Reward: 1200XP', -- supports HTML elements
                xp = 1200,
            }
        }
    }
}