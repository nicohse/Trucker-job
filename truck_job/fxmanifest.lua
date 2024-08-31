fx_version 'cerulean'
game 'gta5'

author 'Nico'
description 'Truck Job'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
}

shared_script '@es_extended/imports.lua'
