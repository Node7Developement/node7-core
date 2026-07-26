fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/images/*.png'
}

author 'NODE7 Development Studios'
description 'node7-core'
version '2.4.0-node7.4'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/locale.lua',
    'locale/en.lua',
    'locale/*.lua',
    'shared/main.lua',
    'shared/functions.lua',
    'shared/items.lua',
    'shared/jobs.lua',
    'shared/vehicles.lua',
    'shared/gangs.lua',
    'shared/weapons.lua',
    'shared/locations.lua',
    'shared/keybinds.lua'
}

client_scripts {
    'client/dataview.lua',
    'client/main.lua',
    'client/functions.lua',
    'client/notifications.lua',
    'client/loops.lua',
    'client/events.lua',
    'client/drawtext.lua',
    'client/prompts.lua',
    'client/pvp.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/functions.lua',
    'server/database.lua',
    'server/moneyitems.lua',
    'server/player.lua',
    'server/events.lua',
    'server/commands.lua',
    'server/exports.lua',
    'server/compat.lua',
    'server/debug.lua',
    'server/versionchecker.lua'
}

dependencies {
    'oxmysql',
    'ox_lib'
}
