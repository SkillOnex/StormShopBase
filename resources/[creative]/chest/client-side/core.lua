-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Chests = {
	
	-- Mecanico
	{ ["Name"] = "Mecanico", ["Coords"] = vec3(748.79,-825.13,26.52), ["Mode"] = "3" },
	{ ["Name"] = "Bennys", ["Coords"] = vec3(-785.07,-2607.45,13.93), ["Mode"] = "3" },
	{ ["Name"] = "Harmony", ["Coords"] = vec3(1187.25,2635.53,38.27), ["Mode"] = "3" },
	-- Restaurants
	{ ["Name"] = "Pearls", ["Coords"] = vec3(-1841.57,-1186.37,14.2), ["Mode"] = "3" },
	-- Contraband
	{ ["Name"] = "Chiliad", ["Coords"] = vec3(2188.22,5569.48,54.09), ["Mode"] = "3" },
	{ ["Name"] = "Families", ["Coords"] = vec3(-163.85,-1619.42,33.81), ["Mode"] = "3" },
	{ ["Name"] = "Highways", ["Coords"] = vec3(1433.03,6329.65,23.83), ["Mode"] = "3" },
	{ ["Name"] = "Vagos", ["Coords"] = vec3(325.13,-1999.77,24.35), ["Mode"] = "3" },
	-- Favelas
	{ ["Name"] = "Barragem", ["Coords"] = vec3(1305.39,-970.95,69.89), ["Mode"] = "2" },
	{ ["Name"] = "Helipa", ["Coords"] = vec3(1308.48,-972.35,69.89), ["Mode"] = "2" },
	{ ["Name"] = "Parque", ["Coords"] = vec3(405.68,754.49,194.58), ["Mode"] = "3" },
	{ ["Name"] = "Sandy", ["Coords"] = vec3(2177.59,4043.24,34.33), ["Mode"] = "3" },
	{ ["Name"] = "Petroleo", ["Coords"] = vec3(1546.49,-2454.71,80.33), ["Mode"] = "3" },
	{ ["Name"] = "Praia-1", ["Coords"] = vec3(-3112.42,1423.05,30.14), ["Mode"] = "3" },
	{ ["Name"] = "Praia-2", ["Coords"] = vec3(-3129.12,1704.1,41.2), ["Mode"] = "3" },
	{ ["Name"] = "Zancudo", ["Coords"] = vec3(-604.21,2199.58,126.24), ["Mode"] = "3" },
	-- Mafias
	{ ["Name"] = "Madrazzo", ["Coords"] = vec3(1391.16,1158.84,114.13), ["Mode"] = "3" },
	{ ["Name"] = "Playboy", ["Coords"] = vec3(-1524.90,148.86,60.74), ["Mode"] = "3" },
	{ ["Name"] = "Municao", ["Coords"] = vec3(977.37,-104.37,74.8), ["Mode"] = "3" },
	{ ["Name"] = "Vineyard", ["Coords"] = vec3(-1871.1,2057.21,135.44), ["Mode"] = "3" },
	-- Trays
	{ ["Name"] = "PearlsTray01", ["Coords"] = vec3(-1835.04,-1191.86,14.49), ["Mode"] = "4" },
	{ ["Name"] = "PearlsTray02", ["Coords"] = vec3(-1834.07,-1190.12,14.46), ["Mode"] = "4" },
	-- Orgs

	{ ["Name"] = "Policia", ["Coords"] = vec3(-2104.03,-437.93,12.1), ["Mode"] = "1" },
	{ ["Name"] = "Pc", ["Coords"] = vec3(278.58,-347.27,49.57), ["Mode"] = "3" },
	{ ["Name"] = "Paramedico", ["Coords"] = vec3(-674.08,338.6,83.09), ["Mode"] = "2" },
	
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELS
-----------------------------------------------------------------------------------------------------------------------------------------
local Labels = {
	["1"] = {
		{
			event = "chest:Open",
			label = "Compartimento Geral",
			tunnel = "shop",
			service = "Normal"
		},{
			event = "chest:Open",
			label = "Compartimento Pessoal",
			tunnel = "shop",
			service = "Personal"
		},{
			event = "chest:Open",
			label = "Compartimento Evidências",
			tunnel = "shop",
			service = "Evidences"
		},{
			event = "chest:Upgrade",
			label = "Aumentar",
			tunnel = "server"
		}
	},
	["2"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "shop",
			service = "Normal"
		},{
			event = "chest:Upgrade",
			label = "Aumentar",
			tunnel = "server"
		}
	},
	["3"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "shop",
			service = "Normal"
		},{
			event = "chest:Upgrade",
			label = "Aumentar",
			tunnel = "server"
		},{
			event = "chest:Open",
			label = "Cofre",
			tunnel = "shop",
			service = "Manager"
		}
	},
	["4"] = {
		{
			event = "chest:Open",
			label = "Bandeja",
			tunnel = "shop",
			service = "Tray"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Name,v in pairs(Chests) do
		exports["target"]:AddCircleZone("Chest:"..Name,v["Coords"],1.0,{
			name = "Chest:"..Name,
			heading = 3374176
		},{
			Distance = 1.5,
			shop = v["Name"],
			options = Labels[v["Mode"]]
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Open",function(Name,Init)
	if vSERVER.Permissions(Name,Init) and vSERVER.Verify() then
		SetNuiFocus(true,true)
		SendNUIMessage({ Action = "Open" })
		TriggerEvent("sounds:Private","chest",0.35)
		vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SendNUIMessage({ Action = "Close" })
	SetNuiFocus(false,false)
	vRP.Destroy()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	vSERVER.Take(Data["item"],Data["slot"],Data["amount"],Data["target"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	vSERVER.Store(Data["item"],Data["slot"],Data["amount"],Data["target"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	vSERVER.Update(Data["slot"],Data["target"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Chest",function(Data,Callback)
	local Inventory,Chest,invPeso,invMaxpeso,chestPeso,chestMaxpeso = vSERVER.Chest()
	if Inventory then
		Callback({ Inventory = Inventory, Chest = Chest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Update")
AddEventHandler("chest:Update",function(Action,invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ Action = Action, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Close")
AddEventHandler("chest:Close",function(Action)
	SendNUIMessage({ Action = "Close" })
	SetNuiFocus(false,false)
end)