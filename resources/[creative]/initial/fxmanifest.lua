--
fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/build/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/config/Vehicle.lua",
	"@vrp/lib/utils.lua",
	"server-side/*"
}

shared_scripts {
	"shared-side/*"
}
files {
	"web-side/*",
	"web-side/**/*"
}
