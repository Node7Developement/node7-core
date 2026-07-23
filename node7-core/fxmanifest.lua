fx_version 'cerulean'
game 'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'NODE7 DEVELOPMENT STUDIOS'
description 'NODE7 runtime-only RedM framework core'
version '2.0.0'

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
    'server/debug.lua',
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

lua54 'yes'
