fx_version 'cerulean'
game 'gta5'

name "Novel_KevlarV2"
description "Kevlar Script"
author "aRii0 from Novel Devolution"
version "1.0.0"

client_scripts {
    'shared/config.lua',
    'client/*.lua'
}

server_scripts {
	'@es_extended/imports.lua',
    '@mysql-async/lib/MySQL.lua',
    'shared/config.lua',
    'server/*.lua'
}

escrow_ignore {
    'server/*.lua',
    'client/*.lua',
    'shared/config.lua'
}

dependencies {
    'es_extended',
    'mysql-async'
}

lua54 "yes"
