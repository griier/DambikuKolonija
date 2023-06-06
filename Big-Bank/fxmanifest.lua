fx_version 'griier'
game 'gta5'

name "Big bank robbery"
description "divi ruki taisa scriptu"
author "griier"
version "1.0.8"

dependencies {
    "PolyZone",
    "mka-lasers-main"
}

client_scripts {
    '@mka-lasers-main/client/client.lua',
    "@PolyZone/client.lua",
    'configs/config.lua',
    'client/mainLoop.lua',
    'client/events.lua',
    'client/nuiEvents.lua',
    'client/safeCracking.lua',
    'configs/functions.lua',
    'garbageCollector.lua',
}

server_scripts {
    'configs/config.lua',
    'server/pacificBankRobbery.lua',
    'server/events.lua',
    'configs/functions.lua',
}

