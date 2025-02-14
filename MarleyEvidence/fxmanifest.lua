fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

files {
    "data/**",
    "bridge/**/client.lua"
}

data_file "DLC_ITYP_REQUEST" "stream/cuffs_main.ytyp"
data_file "AUDIO_WAVEPACK" "audiodirectory"
data_file "AUDIO_SOUNDDATA" "audiodata/nd_police.dat"

dependencies {
    "ox_target",
    "ox_inventory",
    "ox_lib"
}

shared_scripts {
    "@ox_lib/init.lua",
    "shared/bridge.lua"
}

server_scripts {
    'server/main.lua',
    'server/evidence.lua',
}

client_scripts {
    'client/main.lua',
    'client/evidence.lua',
    'client/gsr.lua',
    'client/spikes.lua',
}
