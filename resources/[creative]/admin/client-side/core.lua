-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hypex = {}
Tunnel.bindInterface("admin",Hypex)
vSERVER = Tunnel.getInterface("admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVISIBLABLES
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Spectate"] = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.teleportWay()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		Ped = GetVehiclePedIsUsing(Ped)
    end

	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(GetBlipInfoIdCoord(waypointBlip,Citizen.ResultAsVector()))

	local ground
	local groundFound = false
	local groundCheckHeights = { 0.0,50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,650.0,700.0,750.0,800.0,850.0,900.0,950.0,1000.0,1050.0,1100.0 }

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(Ped,x,y,height,false,false,false)

		RequestCollisionAtCoord(x,y,z)
		while not HasCollisionLoadedAroundEntity(Ped) do
			Wait(1)
		end

		Wait(20)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if ground then
			z = z + 1.0
			groundFound = true
			break;
		end
	end

	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(Ped,0xFBAB5776,1,0)
	end

	RequestCollisionAtCoord(x,y,z)
	while not HasCollisionLoadedAroundEntity(Ped) do
		Wait(1)
	end

	SetEntityCoordsNoOffset(Ped,x,y,z,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.teleportLimbo()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local _,xCoords = GetNthClosestVehicleNode(Coords["x"],Coords["y"],Coords["z"],1,0,0,0)

	SetEntityCoordsNoOffset(Ped,xCoords["x"],xCoords["y"],xCoords["z"] + 1,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:vehicleTuning")
AddEventHandler("admin:vehicleTuning",function()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local vehicle = GetVehiclePedIsUsing(Ped)

		SetVehicleModKit(vehicle,0)
		SetVehicleMod(vehicle,11,GetNumVehicleMods(vehicle,11) - 1,false)
		SetVehicleMod(vehicle,12,GetNumVehicleMods(vehicle,12) - 1,false)
		SetVehicleMod(vehicle,13,GetNumVehicleMods(vehicle,13) - 1,false)
		SetVehicleMod(vehicle,15,GetNumVehicleMods(vehicle,15) - 1,false)
		ToggleVehicleMod(vehicle,18,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			vSERVER.buttonTxt()
-- 		end
-- 		Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONMAKERACE
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			local Ped = PlayerPedId()
-- 			local vehicle = GetVehiclePedIsUsing(Ped)
-- 			local vehCoords = GetEntityCoords(vehicle)
-- 			local leftCoords = GetOffsetFromEntityInWorldCoords(vehicle,5.0,0.0,0.0)
-- 			local rightCoords = GetOffsetFromEntityInWorldCoords(vehicle,-5.0,0.0,0.0)

-- 			vSERVER.raceCoords(vehCoords,leftCoords,rightCoords)
-- 		end

-- 		Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:INITSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:initSpectate")
AddEventHandler("admin:initSpectate",function(source)
	if not NetworkIsInSpectatorMode() then
		local Pid = GetPlayerFromServerId(source)
		local Ped = GetPlayerPed(Pid)

		LocalPlayer["state"]["Spectate"] = true
		NetworkSetInSpectatorMode(true,Ped)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:RESETSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:resetSpectate")
AddEventHandler("admin:resetSpectate",function()
	if NetworkIsInSpectatorMode() then
		NetworkSetInSpectatorMode(false)
		LocalPlayer["state"]["Spectate"] = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:KickAll")
AddEventHandler("admin:KickAll",function()
	ShakeGameplayCam("LARGE_EXPLOSION_SHAKE", 0.16)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTXTS
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxtS(x,y,width,height,scale,text,r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25,0.25)
    SetTextColour(r,g,b,a)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(1,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2,y - height / 2 + 0.005)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3DS
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)

	if onScreen then
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(204,204,204,175)
		BeginTextCommandDisplayText("STRING")
		SetTextCentre(1)
		AddTextComponentSubstringKeyboardDisplay(text)
		EndTextCommandDisplayText(_x,_y)
		DrawText(_x,_y)
		local width = string.len(text) / 300
		DrawRect(_x,_y + 0.0125,width,0.03,15,15,15,200)
	end
end
 --------------------------------------------------------------------------------------
 ---- Teste Mensagem de Assalto
 --------------------------------------------------------------------------------------
 local alerts = {
    { ['hour'] = 0, ['minute'] = 0, ['color'] = 'amarelo', ['text'] = '<b>Alerta:</b> Assaltos estão liberados a partir das <b>0h</b> às <b>6h</b> da manhã!' },
    { ['hour'] = 6, ['minute'] = 0, ['color'] = 'amarelo', ['text'] = '<b>Alerta:</b> Assaltos estão proibidos a partir das <b>6h</b> às <b>0h</b> da manhã!' }
}

CreateThread(function()
    local data = {}
    while true do
        for i=1,#alerts do
            local hour1, min1 = alerts[i]['hour'], alerts[i]['minute']
            local hour2, min2 = GetClockHours(), GetClockMinutes()
            local check = hour1 == hour2 and min1 == min2

            if check and not data['check'] then
                TriggerEvent('Notify',alerts[i]['color'],alerts[i]['text'],10000)
                data['check'] = hour2+min2
            elseif not check and data['check'] then
                if hour2+min2 > data['check'] then
                    data['check'] = nil
                end
            end
        end
        Wait(1000)
    end
end)