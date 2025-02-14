fx_version 'cerulean'
games { 'gta5' }
autor 'Marley & bibi'
description ''
lua54 'yes'

shared_script{
'@ox_lib/init.lua',

}

server_scripts{
}

client_scripts{
'client.lua',
'client.js',
}
shared_script '@es_extended/imports.lua'
server_script 'server.lua'