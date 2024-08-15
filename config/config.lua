return {
    Locale = 'en',

    -- image if steam image is not loaded
    DefaultImage = 'https://avatars.steamstatic.com/b5bd56c1aa4644a474a2e4972be27ef9e82e517e_full.jpg',

    -- When to restart stats, currently At 00:00 on day-of-month 1
    Cron = '0 0 1 * *',


    -- if player doesn't log for certain time, delete his progress, currently after 2 months of inactivity
    DeletePlayer = '2 MONTH',

    Commands = {
        battlepass = {
            name = 'battlepass',
            help = '',
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
            help = 'Gives premium to desired player',
            restricted = 'group.admin'
        },
        wipe = {
            name = 'wipeplayer',
            help = 'Wipes players battle pass progress (including preium pass status)',
            restricted = 'group.admin'
        },
        givexp = {
            name = 'givexp',
            help = 'Gives xp to player',
            restricted = 'group.admin'
        },
    },

    -- how much each level have xp
    XPPerLevel = 1000,

    -- giving xp to player for playing on server
    PlayTimeReward = {
        enable = true,  -- if you dont want this then disable
        interval = 5,   -- in min
        xp = 250,       -- how much xp player will get,
        notify = true   -- notify player that he got xp for playing on server
    },

    Rewards = {
        FreePass --[[ type of pass ]] = {
            /*
                {
                    name = item_name
                    label = 'Label of item',
                    img = '', -- if your image name is something else than item name then put it here otherwise leave it as it is
                    needXP = 100,
                    amount = 1000 -- how much you will get
                },
            */
            [1] = { -- 1st week of month
                { name = 'water', label = 'Water', img = '', requirements = { tier = 0, xp = 150 }, amount = 10 },
                { name = 'money', label = 'Money', img = '', requirements = { tier = 1, xp = 150 }, amount = 150 },
                { name = 'ammo-9', label = 'Pistol Ammo', img = '', requirements = { tier = 2, xp = 150 }, amount = 10 },
                { name = 'money', label = 'Money', img = '', requirements = { tier = 3, xp = 150 }, amount = 200 },
            },
            [2] = { -- 2nd week of month
                { name = 'water', label = 'Water', img = '', requirements = { tier = 0, xp = 150 }, amount = 10 },
                { name = 'money', label = 'Money', img = '', requirements = { tier = 1, xp = 150 }, amount = 150 },
                { name = 'ammo-9', label = 'Pistol Ammo', img = '', requirements = { tier = 2, xp = 150 }, amount = 10 },
                { name = 'money', label = 'Money', img = '', requirements = { tier = 3, xp = 150 }, amount = 200 },
            },
            [3] = { -- 3rd week of month
                { name = 'water', label = 'Water', img = '', requirements = { tier = 0, xp = 150 }, amount = 10 },
                { name = 'money', label = 'Money', img = '', requirements = { tier = 1, xp = 150 }, amount = 150 },
                { name = 'ammo-9', label = 'Pistol Ammo', img = '', requirements = { tier = 2, xp = 150 }, amount = 10 },
                { name = 'money', label = 'Money', img = '', requirements = { tier = 10, xp = 150 }, amount = 200 },
            },
            [4] = { -- 4th week of month
                { name = 'water', label = 'Water', img = '', requirements = { tier = 0, xp = 150 }, amount = 10 },
                { name = 'money', label = 'Money', img = '', requirements = { tier = 1, xp = 150 }, amount = 150 },
                { name = 'ammo-9', label = 'Pistol Ammo', img = '', requirements = { tier = 2, xp = 150 }, amount = 10 },
                { name = 'money', label = 'Money', img = '', requirements = { tier = 3, xp = 150 }, amount = 200 },
            },
        },

        -- type of pass
        PremiumPass = {
            [1] = { -- 1st week of month
                { name = 'WEAPON_PISTOL', label = 'Pistol', img = '', requirements = { tier = 0, xp = 150 }, amount = 1 },
            },
            [2] = { -- 2nd week of month
                { name = 'WEAPON_PISTOL', label = 'Pistol', img = '', requirements = { tier = 0, xp = 150 }, amount = 1 },
            },
            [3] = { -- 3rd week of month
                { name = 'WEAPON_PISTOL', label = 'Pistol', img = '', requirements = { tier = 0, xp = 150 }, amount = 1 },
            },
            [4] = { -- 4th week of month
                { name = 'WEAPON_PISTOL', label = 'Pistol', img = '', requirements = { tier = 0, xp = 150 }, amount = 1 },
            },
        }
    },

    BattleShop = {
        [1] = { -- week of month
            { name = 'water', label = 'Water', img = '', coins = 50, amount = 10 },
        },
        [2] = { -- week of month
            { name = 'water', label = 'Water', img = '', coins = 50, amount = 10 },
        },
        [3] = { -- week of month
            { name = 'WEAPON_PISTOL', label = 'Pistol', img = '', coins = 50, amount = 10 },
        },
        [4] = { -- week of month
            { name = 'water', label = 'Water', img = '', coins = 50, amount = 10 },
        },
    },

    /*
        The example command to give 100 coins can be found in the file code_example.png.

        The order must always be: "command {sid} amount".

        "Requires Player To Be Online" must be "Only execute command when the player is online" otherwise this won't work

        For more details, check tutorial: https://www.youtube.com/watch?v=it-eiJDwV5E

        The CFX account used to purchase coins must be authorized in the FiveM client of the player; otherwise, this won't work; player must be online on server when purchasing.

        We recommend that after creating a new package, you wait a few hours before allowing people to purchase it. 
        Sometimes it takes over 5 minutes to execute something from a new package, but after a few hours, it executes withing 30 sec
    */
    BuyCoinsCommand = 'purchase_coins_for_battlepass',

    /*
        Same as above, player must be online on server when purchasing & cfx accounts must be same

        The order must always be: "command {sid}"
    */

    BuyPremiumPassCommand = 'buy_premium_pass',

    /*
        How long will premium pass last for player, premium is valid from date to date, currently 30 days.
        Using os.time which means it will use time from your VPS/dedicated server so make sure time & data are correct
    */
    PremiumDuration = 30
}