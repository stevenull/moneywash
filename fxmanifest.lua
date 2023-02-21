fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Stevo Scripts'
description 'Advanced Moneywash Script'
version '1.2'


shared_scripts { 
	'shared/config.lua',
	'@ox_lib/init.lua'
}

client_scripts {	
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

dependencies {
	'ox_lib',
	'ox_target',
	'ox_inventory'
}
