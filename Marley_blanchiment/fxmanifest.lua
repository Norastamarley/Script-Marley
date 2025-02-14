fx_version 'adamant'
lua54 'yes'
game 'gta5'

autor 'Marley'
description 'Script de blanchiment d\'argent'

shared_scripts {
    'config.lua',
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
	
	"client/*.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua"
}