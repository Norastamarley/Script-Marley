

author "Marley"
description "Pickup inventory item props"
version "1.0.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

dependencies {
    "ox_target",
    "ox_inventory"
}

shared_scripts {
    "@ox_lib/init.lua",
    "src/shared.lua"
}
server_scripts {
    "src/server.lua"
}
client_scripts {
    "src/client.lua"
}
