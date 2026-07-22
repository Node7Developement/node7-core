fx_version '1.3.5'
game 'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'NODE7 LABS'
description 'NODE7 QBR-style, server-authoritative RedM framework core'
version '1.3.4'

ui_page 'html/index.html'

shared_scripts {
    'shared/locale.lua',
    'locale/en.lua',
    'config.lua',
    'shared/main.lua',
    'shared/items.lua',
    'shared/jobs.lua',
    'shared/horse.lua',
    'shared/vehicles.lua',
    'shared/gangs.lua',
    'shared/weapons.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/debug.lua',
    'server/modules/database.lua',
    'server/functions.lua',
    'server/modules/economy.lua',
    'server/modules/inventory.lua',
    'server/modules/organizations.lua',
    'server/modules/stables.lua',
    'server/player.lua',
    'server/events.lua',
    'server/commands.lua',
    'server/exports.lua'
}

client_scripts {
    'client/functions.lua',
    'client/loops.lua',
    'client/events.lua',
    'client/notify.js',
    'client/drawtxt.lua',
    'client/prompts.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/drawtext.css',
    'html/script.js'
}

dependencies {
    'oxmysql'
}

lua54 'yes'
