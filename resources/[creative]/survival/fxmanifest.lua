--
fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/ui.html"

client_scripts {
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}