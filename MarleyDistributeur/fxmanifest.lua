fx_version 'cerulean'
game 'gta5'

author 'Marley'
description 'Script qui permet d\'utilisé les distributeur.'
version '1.0.0'

lua54 'yes'


shared_scripts {
	'config.lua',
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
}

client_scripts {
	'client.lua',
}
server_scripts {
	'server.lua',
}
