Config = {
    Locale = 'en',

    -- image if steam image is not loaded
    DefaultImage = 'https://avatars.steamstatic.com/b5bd56c1aa4644a474a2e4972be27ef9e82e517e_full.jpg',


    Commands = {
        battlepass = {
            name = 'battlepass',
            help = '',
        }
    },

    -- where images will be taken from
    ImagePath = 'https://cfx-nui-ox_inventory/web/images/%s.png',
  
    Rewards = {
        free --[[ type of pass ]] = {
            /*
                {
                    name = item_name
                    label = 'Label of item',
                    img = '', -- if your image name is something else than item name then put it here otherwise leave it as it is
                    requiredXP = 100,
                    amount = 1000 -- how much you will get
                },
            */
            [1] = { -- 1st week of month
                { name = 'water', label = 'Water', img = '', requiredXP = 50, amount = 10 },
                { name = 'money', label = 'Money', img = '', requiredXP = 100, amount = 150 },
                { name = 'ammo-9', label = 'Pistol Ammo', img = '', requiredXP = 150, amount = 10 },
                { name = 'money', label = 'Money', img = '', requiredXP = 200, amount = 200 },
            },
            [2] = { -- 2nd week of month
                { name = 'water', label = 'Water', img = '', requiredXP = 50, amount = 10 },
                { name = 'money', label = 'Money', img = '', requiredXP = 100, amount = 150 },
                { name = 'ammo-9', label = 'Pistol Ammo', img = '', requiredXP = 150, amount = 10 },
                { name = 'money', label = 'Money', img = '', requiredXP = 200, amount = 200 },
            },
            [3] = { -- 3rd week of month
                { name = 'water', label = 'Water', img = '', requiredXP = 50, amount = 10 },
                { name = 'money', label = 'Money', img = '', requiredXP = 100, amount = 150 },
                { name = 'ammo-9', label = 'Pistol Ammo', img = '', requiredXP = 150, amount = 10 },
                { name = 'money', label = 'Money', img = '', requiredXP = 200, amount = 200 },
            },
            [4] = { -- 4th week of month
                { name = 'water', label = 'Water', img = '', requiredXP = 50, amount = 10 },
                { name = 'money', label = 'Money', img = '', requiredXP = 100, amount = 150 },
                { name = 'ammo-9', label = 'Pistol Ammo', img = '', requiredXP = 150, amount = 10 },
                { name = 'money', label = 'Money', img = '', requiredXP = 200, amount = 200 },
            },
        },

        -- type of pass
        premium = {
            [1] = { -- 1st week of month
                ['WEAPON_PISTOL'] = {
                    label = 'Pistol',
                    img = '',
                    requiredXP = 100,
                }
            },
            [2] = { -- 2nd week of month
                ['WEAPON_PISTOL'] = {
                    label = 'Pistol',
                    img = '',
                    requiredXP = 100,
                }
            },
            [3] = { -- 3rd week of month
                ['WEAPON_PISTOL'] = {
                    label = 'Pistol',
                    img = '',
                    requiredXP = 100,
                }
            },
            [4] = { -- 4th week of month
                ['WEAPON_PISTOL'] = {
                    label = 'Pistol',
                    img = '',
                    requiredXP = 100,
                }
            },
        }
    }
}