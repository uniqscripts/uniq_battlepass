--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
version '2.0.2'

files {
	'config/config.js',
	'config/config.lua',
	'locales/**',
	'web/**'
}

shared_scripts {
	'@ox_lib/init.lua',
	'setup.lua',
	'locales/*.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'bridge/esx/server.lua',
	'bridge/qb/server.lua',
	'server/*.lua'
}
client_scripts {
	'bridge/esx/client.lua',
	'bridge/qb/client.lua',
	'client/*.lua'
}


ui_page 'web/index.html'