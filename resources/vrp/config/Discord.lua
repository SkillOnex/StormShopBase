-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDS
-----------------------------------------------------------------------------------------------------------------------------------------
Discords = {
	["Connect"] = "",
	["Disconnect"] = "",
	["Airport"] = "",
	["Deaths"] = "",
	["Policia"] = "",
	["Paramedico"] = "",
	["Gemstone"] = "",
	["Login"] = "",
	-- Contraband
	["Chiliad"] = "",
	["Families"] = "",
	["Highways"] = "",
	["Vagos"] = "",
	-- Favelas
	["Barragem"] = "",
	["Farol"] = "",
	["Parque"] = "",
	["Sandy"] = "",
	["Petroleo"] = "",
	["Praia-1"] = "",
	["Praia-2"] = "",
	["Zancudo"] = "",
    -- Mafias
	["Madrazzo"] = "",
	["Playboy"] = "",
	["TheSouth"] = "",
	["Vineyard"] = "",
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Discord",function(Hook,Message,Color)
	PerformHttpRequest(Discords[Hook],function(err,text,headers) end,"POST",json.encode({
		username = ServerName,
		embeds = { { color = Color, description = Message } }
	}),{ ["Content-Type"] = "application/json" })
end)