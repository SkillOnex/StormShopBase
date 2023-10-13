-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("races")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Race = 1
local Saved = 0
local Blips = {}
local BlipsRaces = {}
local Points = 0
local Objects = {}
local Progress = 0
local Circuits = {}
local Checkpoint = 1
local Actived = false
local Ranking = false
local TyreExplodes = 0
local CreateRaces = false
local melhortempo = 0
local nuser_id = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Race"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if IsControlJustPressed(1,38) then
			vSERVER.buttonTxt()
		end
		Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONMAKERACE
-----------------------------------------------------------------------------------------------------------------------------------------
local RaceTable = {}
local CheckPoint = 0
local leftoffset = 4.5
local rightofset = 4.5
local initialcoord = nil
RegisterCommand("CreateRaces",function(source,args)
	local Ped = PlayerPedId()
	if args[1] then
		if CreateRaces then
			CreateRaces = false
			TriggerEvent("Notify","amarelo","Criação de Corridas Finalizada.",5000)
			SetUserRadioControlEnabled(true)
		else
			CreateRaces = true
			TriggerEvent("Notify","verde","Criação de Corridas Iniciada.",5000)
			--Criar objeto
			local mHash = GetHashKey("prop_offroad_tyres02")
			local mHash2 = GetHashKey("w_pi_flaregun")
			RequestModel(mHash)
			while not HasModelLoaded(mHash) do
				Wait(1)
			end
			local coords = GetEntityCoords(Ped)
			initialcoord = coords
			local pedHeading = GetEntityHeading(Ped)
			newObject = CreateObjectNoOffset(mHash,coords["x"],coords["y"],coords["z"],false,false,false)
			SetEntityCollision(newObject,false,false)
			SetEntityHeading(newObject,pedHeading)
			SetEntityAlpha(newObject,100,false)
			SetModelAsNoLongerNeeded(mHash)
			newObject2 = CreateObjectNoOffset(mHash,coords["x"],coords["y"],coords["z"],false,false,false)
			SetEntityCollision(newObject2,false,false)
			SetEntityHeading(newObject2,pedHeading)
			SetEntityAlpha(newObject2,100,false)
			SetModelAsNoLongerNeeded(mHash)

			SetUserRadioControlEnabled(false)
		end
		CreateThread(function()
			while CreateRaces do
				if CreateRaces then
					if IsPedInAnyVehicle(Ped) then
						local vehicle = GetVehiclePedIsUsing(Ped)
						local coords = GetEntityCoords(Ped)
						local heading = GetEntityHeading(Ped)
						local vehCoords = GetEntityCoords(vehicle)
						local leftCoords = GetOffsetFromEntityInWorldCoords(vehicle,leftoffset,0.0,-0.45)
						local rightCoords = GetOffsetFromEntityInWorldCoords(vehicle,-rightofset,0.0,-0.45)
						SetEntityHeading(newObject,heading)
						SetEntityCoords(newObject,leftCoords["x"],leftCoords["y"],leftCoords["z"],false,false,false,false)
						SetEntityHeading(newObject2,heading)
						SetEntityCoords(newObject2,rightCoords["x"],rightCoords["y"],rightCoords["z"],false,false,false,false)
						dwText("~g~E~w~  Novo CheckPoint",4,0.015,0.69,0.38,255,255,255,255)
						dwText("~g~H~w~  Finalizar Corrida",4,0.015,0.72,0.38,255,255,255,255)
						dwText("~g~X~w~  Resetar Corrida",4,0.015,0.75,0.38,255,255,255,255)
						dwText("~g~SCROLLWHEEL UP~w~ e ~g~SCROLLWHEEL DOWN~w~  Aumentar/Diminuir Distancia Entre os Pneus",4,0.015,0.78,0.38,255,255,255,255)
						if IsControlJustPressed(1,38) then
							CheckPoint = CheckPoint + 1
							TriggerEvent("Notify","verde","Checkpoint "..CheckPoint.." inserido",5000)
							table.insert(RaceTable, { vehCoords = vehCoords, leftCoords = leftCoords, rightCoords = rightCoords })
							CleanBlipsRace()
							MakeBlipsRace()
						end
						if IsControlJustPressed(1,74) then
							vSERVER.CreateNewRace(RaceTable,args[1],initialcoord)
							CleanBlipsRace()
							RaceTable = {}
							CheckPoint = 0
							TriggerEvent("Notify","verde","Corrida Finalizada.",5000)
							CreateRaces = false
						end
						if IsControlJustPressed(1,73) then
							RaceTable = {}
							CleanBlipsRace()
							CheckPoint = 0
							TriggerEvent("Notify","verde","Corrida resetada.",5000)
						end

						if IsControlJustPressed(1,14) then
							leftoffset = leftoffset - 0.5
							rightofset = rightofset - 0.5
						end

						if IsControlJustPressed(1,15) then
							leftoffset = leftoffset + 0.5
							rightofset = rightofset + 0.5
						end

						for k,v in pairs(RaceTable) do
							DrawMarker(1,RaceTable[k]["vehCoords"][1],RaceTable[k]["vehCoords"][2],RaceTable[k]["vehCoords"][3] - 0.4,0.0,0.0,0.0,0.0,0.0,0.0,8.0,8.0,100.0,162,124,219,100,0,0,0,0)
						end
					else
						TriggerEvent("Notify","vermelho","Você precisa estar em um veiculo para pegar as coords.",5000)
						CreateRaces = false
						TriggerEvent("Notify","amarelo","Criação de Corridas Finalizada.",5000)
						DeleteEntity(newObject)
						DeleteEntity(newObject2)
						CleanBlipsRace()
						CheckPoint = 0
						return
					end
				else
					DeleteEntity(newObject)
					DeleteEntity(newObject2)
					return
				end
				Wait(1)
			end
			DeleteEntity(newObject)
			DeleteEntity(newObject2)
		end)
	else
		TriggerEvent("Notify","vermelho","Insira um nome para a corrida.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRACES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if not LocalPlayer["state"]["Race"] then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)
			if Actived then
				TimeDistance = 100
				Points = GetGameTimer() - Saved
				local assinatura = Circuits[Race]["Assinatura"]

				if not melhortempo then
					melhortempo = "zulasgostoso"
				end

				if not  Circuits[Race]["Assinatura"]  then
					assinatura = "zulasgostoso"
				end

				SendNUIMessage({ Action = "Progress", Points = Points, Timer = Progress - GetGameTimer(), melhortempo = melhortempo , name = nuser_id, assinatura = assinatura  })

				if GetGameTimer() >= Progress or not IsPedInAnyVehicle(Ped) then
					Leave()
				end

				local Distance = #(Coords - vec3(Circuits[Race]["Coords"][Checkpoint][1][1],Circuits[Race]["Coords"][Checkpoint][1][2],Circuits[Race]["Coords"][Checkpoint][1][3]))
				if Distance <= 5 then
					if Checkpoint >= #Circuits[Race]["Coords"] then
						SendNUIMessage({ Action = "Display", Status = false })
						vSERVER.Finish(Race,Points)
						CleanObjects()
						CleanBlips()

						Race = 1
						Saved = 0
						Points = 0
						Checkpoint = 1
						Actived = false
						melhortempo = 0
						nuser_id = 0
					else
						if DoesBlipExist(Blips[Checkpoint]) then
							RemoveBlip(Blips[Checkpoint])
							Blips[Checkpoint] = nil
						end

						SendNUIMessage({ Action = "Checkpoint" })
						SetBlipRoute(Blips[Checkpoint + 1],true)
						Checkpoint = Checkpoint + 1
						MakeObjects()
					end
				end
			else
				for Number,v in pairs(Circuits) do
					local Distance = #(Coords - v["Init"])
					if Distance <= 25 then
						local Vehicle = GetVehiclePedIsUsing(Ped)
						if GetPedInVehicleSeat(Vehicle,-1) == Ped then
							DrawMarker(5,v["Init"]["x"],v["Init"]["y"],v["Init"]["z"] - 0.4,0.0,0.0,5.0,0.0,0.0,0.0,10.0,10.0,10.0,162,124,219,100,0,0,0,0)
							TimeDistance = 1

							if Distance <= 5 then
								if IsControlJustPressed(1,47) then
									Ranking = not Ranking
									SendNUIMessage({ Action = "Ranking", Ranking = vSERVER.Ranking(Number) or false })
								end

								if IsControlJustPressed(1,38) then
									if vSERVER.Start(Number) then
										if Ranking then
											SendNUIMessage({ Action = "Ranking", Ranking = false })
											Ranking = false
										end

										SendNUIMessage({ Action = "Display", Status = true, Max = #Circuits[Number]["Coords"] })
										Progress = GetGameTimer() + (v["Timer"] * 1000)
										Saved = GetGameTimer()
										Checkpoint = 1
										Race = Number
										Points = 0

										MakeBlips()
										MakeObjects()
										Actived = true
										melhortempo, nuser_id = vSERVER.getmelhortempo(Number)
									end
								end
							else
								if Ranking then
									SendNUIMessage({ Action = "Ranking", Ranking = false })
									Ranking = false
								end
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function MakeBlips()
	for Number = 1,#Circuits[Race]["Coords"] do
		Blips[Number] = AddBlipForCoord(Circuits[Race]["Coords"][Number][1][1],Circuits[Race]["Coords"][Number][1][2],Circuits[Race]["Coords"][Number][1][3])
		SetBlipSprite(Blips[Number],1)
		SetBlipColour(Blips[Number],83)
		SetBlipScale(Blips[Number],0.85)
		SetBlipRoute(Blips[Checkpoint],true)
		ShowNumberOnBlip(Blips[Number],Number)
		SetBlipAsShortRange(Blips[Number],true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPSRACE
-----------------------------------------------------------------------------------------------------------------------------------------
function MakeBlipsRace()
	for k,v in pairs(RaceTable) do
		DrawMarker(1,RaceTable[k]["vehCoords"][1],RaceTable[k]["vehCoords"][2],RaceTable[k]["vehCoords"][3] - 0.4,0.0,0.0,0.0,0.0,0.0,0.0,8.0,8.0,100.0,162,124,219,100,0,0,0,0)
		BlipsRaces[k] = AddBlipForCoord(RaceTable[k]["vehCoords"][1],RaceTable[k]["vehCoords"][2],RaceTable[k]["vehCoords"][3])
		SetBlipSprite(BlipsRaces[k],1)
		SetBlipColour(BlipsRaces[k],83)
		SetBlipScale(BlipsRaces[k],0.85)
		ShowNumberOnBlip(BlipsRaces[k],k)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function MakeObjects()
	for Number,Object in pairs(Objects) do
		if DoesEntityExist(Object) then
			DeleteEntity(Object)
			Objects[Number] = nil
		end
	end

	if LoadModel("prop_offroad_tyres02") then
		Objects[1] = CreateObjectNoOffset("prop_offroad_tyres02",Circuits[Race]["Coords"][Checkpoint][2][1],Circuits[Race]["Coords"][Checkpoint][2][2],Circuits[Race]["Coords"][Checkpoint][2][3],false,false,false)
		Objects[2] = CreateObjectNoOffset("prop_offroad_tyres02",Circuits[Race]["Coords"][Checkpoint][3][1],Circuits[Race]["Coords"][Checkpoint][3][2],Circuits[Race]["Coords"][Checkpoint][3][3],false,false,false)

		PlaceObjectOnGroundProperly(Objects[1])
		PlaceObjectOnGroundProperly(Objects[2])

		SetEntityCollision(Objects[1],false,false)
		SetEntityCollision(Objects[2],false,false)

		SetEntityLodDist(Objects[1],0xFFFF)
		SetEntityLodDist(Objects[2],0xFFFF)

		SetModelAsNoLongerNeeded("prop_offroad_tyres02")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanBlips()
	for Number,Bliped in pairs(Blips) do
		if DoesBlipExist(Bliped) then
			RemoveBlip(Bliped)
			Blips[Number] = nil
		end
	end

	Blips = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanBlipsRace()
	for Number,Bliped in pairs(BlipsRaces) do
		if DoesBlipExist(Bliped) then
			RemoveBlip(Bliped)
			BlipsRaces[Number] = nil
		end
	end

	BlipsRaces = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanObjects()
	for Number,Object in pairs(Objects) do
		if DoesEntityExist(Object) then
			DeleteEntity(Object)
			Objects[Number] = nil
		end
	end

	Objects = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Leave()
	SendNUIMessage({ Action = "Display", Status = false })
	vSERVER.Cancel()
	Actived = false
	melhortempo = 0
	nuser_id = 0

	CleanObjects()
	CleanBlips()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:Table")
AddEventHandler("races:Table",function(Table)
	Circuits = Table

	for _,Info in pairs(Circuits) do
		local Inits = AddBlipForRadius(Info["Init"]["x"],Info["Init"]["y"],Info["Init"]["z"],10.0)
		SetBlipAlpha(Inits,200)
		SetBlipColour(Inits,83)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTYREEXPLODES
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(Event,args)
	if Event == "CEventNetworkPlayerEnteredVehicle" then
		CreateThread(function()
			while true do
				local TimeDistance = 999
				if not Actived then
					local Ped = PlayerPedId()
					if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
						TimeDistance = 1

						DisableControlAction(0,345,true)

						local Vehicle = GetVehiclePedIsUsing(Ped)
						if GetPedInVehicleSeat(Vehicle,-1) == Ped then
							if GetVehicleDirtLevel(Vehicle) ~= 0.0 then
								SetVehicleDirtLevel(Vehicle,0.0)
							end

							local Speed = GetEntitySpeed(Vehicle) * 3.6
							if Speed ~= TyreExplodes then
								if (TyreExplodes - Speed) >= 125 then
									local Tyre = math.random(4)
									if Tyre == 1 then
										if GetTyreHealth(Vehicle,0) == 1000.0 then
											SetVehicleTyreBurst(Vehicle,0,true,1000.0)
										end
									elseif Tyre == 2 then
										if GetTyreHealth(Vehicle,1) == 1000.0 then
											SetVehicleTyreBurst(Vehicle,1,true,1000.0)
										end
									elseif Tyre == 3 then
										if GetTyreHealth(Vehicle,4) == 1000.0 then
											SetVehicleTyreBurst(Vehicle,4,true,1000.0)
										end
									elseif Tyre == 4 then
										if GetTyreHealth(Vehicle,5) == 1000.0 then
											SetVehicleTyreBurst(Vehicle,5,true,1000.0)
										end
									end
								end

								TyreExplodes = Speed
							end
						end
					else
						if TyreExplodes ~= 0 then
							TyreExplodes = 0
						end
						return
					end
				end

				Wait(TimeDistance)
			end
		end)
	end
end)