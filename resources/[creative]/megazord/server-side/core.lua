-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hypex = {}
Tunnel.bindInterface("megazord",Hypex)
vCLIENT = Tunnel.getInterface("megazord")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WARNING
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.Warning(Warn)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Identity = vRP.Identity(Passport)
		if Identity then
			TriggerClientEvent("megazord:Screenshot",source)
			TriggerEvent("Megazord",WebhookWarnings,"**Passaporte:** "..Passport.."\n**Nome:** "..Identity["name"].." "..Identity["name2"].."\n**Aviso:** "..Warn..".",3042892)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MEGAZORD
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Megazord",function(Hook,Message,Color)
	PerformHttpRequest(WebhookWarnings,function(err,text,headers) end,"POST",json.encode({
		username = ServerName,
		embeds = { { color = Color, description = Message } }
	}),{ ["Content-Type"] = "application/json" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
	GlobalState:set("Resources",Resource,true)
end)