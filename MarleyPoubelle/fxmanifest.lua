fx_version 'cerulean'
game 'gta5'

author 'Marley'
description 'Script qui permet de fouiller les poubelle et de récupérer des objets aléatoires.'
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
