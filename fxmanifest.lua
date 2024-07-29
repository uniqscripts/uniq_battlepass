--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
version '1.0'

shared_scripts {
	'@ox_lib/init.lua',
	'setup.lua',
	'config/config.lua',
	'locales.lua',
	'locales/*.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}
client_scripts {
	'client/*.lua'
}