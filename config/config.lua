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
            [1] = {
                ['WEAPON_PISTOL' --[[item name]] ] = {
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