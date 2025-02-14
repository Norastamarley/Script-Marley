fx_version 'cerulean'
game 'gta5'

-- Import ESX shared functions
shared_script '@es_extended/imports.lua'

-- Server scripts
server_scripts {
    '@mysql-async/lib/MySQL.lua',  -- MySQL async library
    'server/main.lua'              -- Main server-side script
}

-- Client scripts
client_scripts {
    'client/main.lua'              -- Main client-side script
}

-- User Interface
ui_page 'html/ui.html'

-- Files to be loaded (HTML, CSS, JS)
files {
    'html/ui.html',                -- Main HTML file
    'html/css/app.css',            -- CSS styles
    'html/js/mustache.min.js',     -- Mustache template engine
    'html/js/app.js',              -- Custom JS script
    'html/image/image.png'           
}

-- Metadata
author 'Marley'
description 'script cagoule'
version '1.0.0'
