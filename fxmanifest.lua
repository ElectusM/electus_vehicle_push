fx_version "cerulean"
author "@electus_scripts (ELECTUS SCRIPTS)"
version '1.0.0'
lua54 'yes'

games {
  "gta5",
}

files {
	'ui/build/index.html',
	'ui/build/**/*',
    'locales/*.json'
}

ui_page 'ui/build/index.html'

client_scripts {
    "client/*",
}

shared_scripts {
    "config/config.lua",
    "config/*.lua",
    '@ox_lib/init.lua',
}
