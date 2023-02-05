fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Stevo Scripts'
description 'Advanced Moneywash Script'
version '1.0'


shared_scripts { 
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'shared/config.lua',
	'@ox_lib/init.lua',
}

client_scripts {	
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

dependencies {
	'es_extended',
	'ox_lib',
	'ox_target'
}
