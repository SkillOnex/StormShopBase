-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("service")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	-- Public
	{ vec3(-681.57,328.63,83.09),"Paramedico-1",1.0 },
	{ vec3(448.17,-973.38,30.68),"Policia-1",1.0 },
	--{ vec3(1320.48,1267.63,109.25),"Policia-2",1.0 },
	{ vec3(265.46,-340.27,45.8),"Policia-2",1.0 },
	{ vec3(751.53,-824.42,26.52),"Mecanico",1.0 },
	{ vec3(-787.21,-2605.84,13.93),"Bennys",1.0 },
	-- Restaurants
	{ vec3(-1840.55,-1183.9,14.24),"Pearls",2.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number = 1,#List do
		exports["target"]:AddCircleZone("Service:"..List[Number][2],List[Number][1],4.15,{
			name = "Service:"..List[Number][2],
			heading = 0.0
		},{
			shop = Number,
			Distance = List[Number][3],
			options = {
				{
					label = "Entrar em Serviço",
					event = "service:Toggle",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Toggle")
AddEventHandler("service:Toggle",function(Service)
	if not exports["hud"]:Wanted() then
		TriggerServerEvent("service:Toggle",List[Service][2])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:LABEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Label")
AddEventHandler("service:Label",function(Service,Text)
	if Service == "Paramedico" then
		exports["target"]:LabelText("Service:Paramedico-1",Text)
    elseif Service == "Policia" then
		exports["target"]:LabelText("Service:Policia-1",Text)
	elseif Service == "Civil" then
		exports["target"]:LabelText("Service:Policia-2",Text)
	elseif Service == "Mecanico" then
		exports["target"]:LabelText("Service:Mecanico",Text)
	elseif Service == "Bennys" then
		exports["target"]:LabelText("Service:Bennys",Text)
	elseif Service == "Pearls" then
		exports["target"]:LabelText("Service:Pearls",Text)
	else
		exports["target"]:LabelText("Service:"..Service,Text)
	end
end)