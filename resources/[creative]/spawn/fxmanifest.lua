--


fx_version "bodacious"
game "gta5"
lua54 "yes"

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
    "@PolyZone/client.lua",
	"@PolyZone/BoxZone.lua",
	"@PolyZone/EntityZone.lua",
	"@PolyZone/CircleZone.lua",
	"@PolyZone/ComboZone.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

files {
	'web/build/index.html',
	'web/build/*',
	'web/build/**/*',
	'web/build/static/css/**/*',
	'web/build/static/js/**/*',
	'web/build/static/media/**/*'
}

ui_page 'web/build/index.html'