-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Weapon = ""
local Timer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
local Drunk = 0
local DrunkTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
local Energetic = 0
local EnergeticTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- COCAINE
-----------------------------------------------------------------------------------------------------------------------------------------
local Cocaine = 0
local CocaineTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- METHAMPHETAMINE
-----------------------------------------------------------------------------------------------------------------------------------------
local Methamphetamine = 0
local MethamphetamineTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- METADONE
-----------------------------------------------------------------------------------------------------------------------------------------
local Metadone = 0
local MetadoneTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEROIN
-----------------------------------------------------------------------------------------------------------------------------------------
local Heroin = 0
local HeroinTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRACK
-----------------------------------------------------------------------------------------------------------------------------------------
local Crack = 0
local CrackTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOINT
-----------------------------------------------------------------------------------------------------------------------------------------
local Joint = 0
local JointTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- OXYCONTIN
-----------------------------------------------------------------------------------------------------------------------------------------
local Oxycontin = 0
local OxycontinTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()

		if not IsPedInAnyVehicle(Ped) then
			local Progress = 500
			local Pid = PlayerId()
			local Entitys = ClosestPed(2)
			if Entitys and not Entity(Entitys)["state"]["Drugs"] then
				TimeDistance = 1

				if IsControlJustPressed(1,38) and GetVehiclePedIsIn(Entitys,true) == 0 and GetGameTimer() >= Timer and vSERVER.CheckDrugs() then
					Timer = GetGameTimer() + 5000

					ClearPedTasks(Entitys)
					ClearPedSecondaryTask(Entitys)
					ClearPedTasksImmediately(Entitys)

					TaskSetBlockingOfNonTemporaryEvents(Entitys,true)
					SetBlockingOfNonTemporaryEvents(Entitys,true)
					SetEntityAsMissionEntity(Entitys,true,true)
					SetPedDropsWeaponsWhenDead(Entitys,false)
					SetPedSuffersCriticalHits(Entitys,false)
					TaskTurnPedToFaceEntity(Entitys,Ped,0.0)

					LocalPlayer["state"]:set("Buttons",true,true)
					LocalPlayer["state"]:set("Commands",true,true)
					Entity(Entitys)["state"]:set("Drugs",true,true)

					SetTimeout(1000,function()
						if LoadAnim("jh_1_ig_3-2") then
							TaskPlayAnim(Entitys,"jh_1_ig_3-2","cs_jewelass_dual-2",4.0,4.0,-1,16,0,0,0,0)
						end
					end)

					while true do
						local Ped = PlayerPedId()
						local Coords = GetEntityCoords(Ped)
						local EntityCoords = GetEntityCoords(Entitys)

						if #(Coords - EntityCoords) <= 2 then
							Progress = Progress - 1

							if Progress <= 0 and LoadModel("prop_anim_cash_note") then
								local Object = CreateObject("prop_anim_cash_note",Coords["x"],Coords["y"],Coords["z"],false,false,false)
								AttachEntityToEntity(Object,Entitys,GetPedBoneIndex(Entitys,28422),0.0,0.0,0.0,90.0,0.0,0.0,false,false,false,false,2,true)
								vRP.CreateObjects("mp_safehouselost@","package_dropoff","prop_paper_bag_small",16,28422,0.0,-0.05,0.05,180.0,0.0,0.0)
								SetModelAsNoLongerNeeded("prop_anim_cash_note")

								if LoadAnim("mp_safehouselost@") then
									TaskPlayAnim(Entitys,"mp_safehouselost@","package_dropoff",4.0,4.0,-1,16,0,0,0,0)
								end

								Wait(3000)

								if DoesEntityExist(Object) then
									DeleteEntity(Object)
								end

								ClearPedSecondaryTask(Entitys)
								TaskWanderStandard(Entitys,10.0,10)
								SetEntityAsNoLongerNeeded(Entitys)
								vSERVER.PaymentDrugs()
								vRP.Destroy()

								LocalPlayer["state"]:set("Buttons",false,true)
								LocalPlayer["state"]:set("Commands",false,true)

								if math.random(100) >= 75 then
									SetTimeout(5000,function()
										SetPedRelationshipGroupHash(Entitys,GetHashKey("HATES_PLAYER"))
										TaskCombatPed(Entitys,Ped,0,16)
									end)
								end

								break
							end
						else
							ClearPedSecondaryTask(Entitys)
							TaskWanderStandard(Entitys,10.0,10)
							SetEntityAsNoLongerNeeded(Entitys)

							LocalPlayer["state"]:set("Buttons",false,true)
							LocalPlayer["state"]:set("Commands",false,true)

							if math.random(100) >= 50 then
								SetTimeout(5000,function()
									SetPedRelationshipGroupHash(Entitys,GetHashKey("HATES_PLAYER"))
									TaskCombatPed(Entitys,Ped,0,16)
								end)
							end

							break
						end

						Wait(1)
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESTPED
-----------------------------------------------------------------------------------------------------------------------------------------
function ClosestPed(Radius)
	local Selected = false
	local Ped = PlayerPedId()
	local Radius = Radius + 0.0001
	local Coords = GetEntityCoords(Ped)
	local GamePool = GetGamePool("CPed")

	for _,Entity in pairs(GamePool) do
		if Entity ~= PlayerPedId() and not IsPedAPlayer(Entity) and not IsEntityDead(Entity) and not IsPedDeadOrDying(Entity,true) and NetworkGetEntityIsNetworked(Entity) and GetPedArmour(Entity) <= 0 and not IsPedInAnyVehicle(Entity) and GetPedType(Entity) ~= 28 then
			local EntityCoords = GetEntityCoords(Entity)
			local EntityDistance = #(Coords - EntityCoords)

			if EntityDistance < Radius then
				Radius = EntityDistance
				Selected = Entity
			end
		end
	end

	return Selected
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Lean")
AddEventHandler("Lean",function()
	if AnimpostfxIsRunning("Dont_tazeme_bro") then
		AnimpostfxStop("Dont_tazeme_bro")
	end

	if AnimpostfxIsRunning("MinigameTransitionIn") then
		AnimpostfxStop("MinigameTransitionIn")
	end

	if AnimpostfxIsRunning("Dont_tazeme_bro") then
		AnimpostfxStop("Dont_tazeme_bro")
	end

	if AnimpostfxIsRunning("DrugsDrivingOut") then
		AnimpostfxStop("DrugsDrivingOut")
	end

	if AnimpostfxIsRunning("DeathFailMPDark") then
		AnimpostfxStop("DeathFailMPDark")
	end

	if AnimpostfxIsRunning("DrugsMichaelAliensFight") then
		AnimpostfxStop("DrugsMichaelAliensFight")
	end

	if AnimpostfxIsRunning("HeistCelebPassBW") then
		AnimpostfxStop("HeistCelebPassBW")
	end

	if AnimpostfxIsRunning("DeathFailMPIn") then
		AnimpostfxStop("DeathFailMPIn")
	end

	if AnimpostfxIsRunning("DrugsMichaelAliensFight") then
		AnimpostfxStop("DrugsMichaelAliensFight")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Energetic")
AddEventHandler("Energetic",function(Timer,Number)
	Energetic = Energetic + Timer
	SetRunSprintMultiplierForPlayer(PlayerId(),Number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COCAINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Cocaine")
AddEventHandler("Cocaine",function()
	if AnimpostfxIsRunning("MinigameTransitionIn") then
		AnimpostfxStop("MinigameTransitionIn")
	end

	AnimpostfxPlay("MinigameTransitionIn",0,true)
	Cocaine = Cocaine + 30
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- METHAMPHETAMINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Methamphetamine")
AddEventHandler("Methamphetamine",function()
	if AnimpostfxIsRunning("Dont_tazeme_bro") then
		AnimpostfxStop("Dont_tazeme_bro")
	end

	AnimpostfxPlay("Dont_tazeme_bro",0,true)
	Methamphetamine = Methamphetamine + 30
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Drunk")
AddEventHandler("Drunk",function()
	if AnimpostfxIsRunning("DrugsDrivingOut") then
		AnimpostfxStop("DrugsDrivingOut")
	end

	AnimpostfxPlay("DrugsDrivingOut",0,true)
	Drunk = Drunk + 120

	if not LocalPlayer["state"]["Walk"] then
		LocalPlayer["state"]:set("Walk","move_m@drunk@verydrunk",false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- METADONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Metadone")
AddEventHandler("Metadone",function()
	if AnimpostfxIsRunning("DeathFailMPDark") then
		AnimpostfxStop("DeathFailMPDark")
	end

	AnimpostfxPlay("DeathFailMPDark",90000,false)

	if not LocalPlayer["state"]["Megazord"] then
		LocalPlayer["state"]:set("Megazord",true,false)
	end

	SetPlayerMeleeWeaponDamageModifier(PlayerId(),1.1)
	SetPlayerWeaponDamageModifier(PlayerId(),1.1)
	SetAiMeleeWeaponDamageModifier(7.5)
	SetAiWeaponDamageModifier(0.75)
	Metadone = Metadone + 600
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEROIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Heroin")
AddEventHandler("Heroin",function()
	if AnimpostfxIsRunning("DrugsMichaelAliensFight") then
		AnimpostfxStop("DrugsMichaelAliensFight")
	end

	AnimpostfxPlay("DrugsMichaelAliensFight",90000,false)
	SetEntityMaxHealth(PlayerPedId(),250)
	SetPedMaxHealth(PlayerPedId(),250)
	TriggerEvent("Health")

	Heroin = 900
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Crack")
AddEventHandler("Crack",function()
	if AnimpostfxIsRunning("HeistCelebPassBW") then
		AnimpostfxStop("HeistCelebPassBW")
	end

	AnimpostfxPlay("HeistCelebPassBW",90000,false)
	TriggerEvent("Hunger",180000)
	TriggerEvent("Thirst",180000)
	Crack = 900
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Joint")
AddEventHandler("Joint",function()
	if AnimpostfxIsRunning("DeathFailMPIn") then
		AnimpostfxStop("DeathFailMPIn")
	end

	AnimpostfxPlay("DeathFailMPIn",0,true)
	Joint = Joint + 30
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OXYCONTIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Oxycontin")
AddEventHandler("Oxycontin",function()
	if AnimpostfxIsRunning("DrugsMichaelAliensFight") then
		AnimpostfxStop("DrugsMichaelAliensFight")
	end

	AnimpostfxPlay("DrugsMichaelAliensFight",0,true)
	Oxycontin = 30
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMETH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Pid = PlayerId()
		local Ped = PlayerPedId()

		if Energetic > 0 and GetGameTimer() >= EnergeticTimer then
			Energetic = Energetic - 1
			RestorePlayerStamina(Pid,1.0)
			EnergeticTimer = GetGameTimer() + 1000

			if Energetic <= 0 or GetEntityHealth(Ped) <= 100 then
				if AnimpostfxIsRunning("HeistTripSkipFade") then
					AnimpostfxStop("HeistTripSkipFade")
				end

				if AnimpostfxIsRunning("MinigameTransitionIn") then
					AnimpostfxStop("MinigameTransitionIn")
				end

				SetRunSprintMultiplierForPlayer(Pid,1.0)
				EnergeticTimer = GetGameTimer()
				Energetic = 0
			end
		end

		if Drunk > 0 and GetGameTimer() >= DrunkTimer then
			Drunk = Drunk - 1
			DrunkTimer = GetGameTimer() + 1000

			if Drunk <= 0 or GetEntityHealth(Ped) <= 100 then
				if AnimpostfxIsRunning("DrugsDrivingOut") then
					AnimpostfxStop("DrugsDrivingOut")
				end

				if LocalPlayer["state"]["Walk"] then
					LocalPlayer["state"]:set("Walk",false,false)
				end

				DrunkTimer = GetGameTimer()
				Drunk = 0
			end
		end

		if Cocaine > 0 and GetGameTimer() >= CocaineTimer then
			Cocaine = Cocaine - 1
			CocaineTimer = GetGameTimer() + 1000

			if Cocaine <= 0 or GetEntityHealth(Ped) <= 100 then
				if AnimpostfxIsRunning("MinigameTransitionIn") then
					AnimpostfxStop("MinigameTransitionIn")
				end

				CocaineTimer = GetGameTimer()
				Cocaine = 0
			end
		end

		if Methamphetamine > 0 and GetGameTimer() >= MethamphetamineTimer then
			Methamphetamine = Methamphetamine - 1
			MethamphetamineTimer = GetGameTimer() + 1000

			if Methamphetamine <= 0 or GetEntityHealth(Ped) <= 100 then
				if AnimpostfxIsRunning("Dont_tazeme_bro") then
					AnimpostfxStop("Dont_tazeme_bro")
				end

				MethamphetamineTimer = GetGameTimer()
				Methamphetamine = 0
			end
		end

		if Metadone > 0 and GetGameTimer() >= MetadoneTimer then
			Metadone = Metadone - 1
			MetadoneTimer = GetGameTimer() + 1000

			if Metadone <= 0 or GetEntityHealth(Ped) <= 100 then
				if AnimpostfxIsRunning("DeathFailMPDark") then
					AnimpostfxStop("DeathFailMPDark")
				end

				Metadone = 0
				MetadoneTimer = GetGameTimer()
				SetAiWeaponDamageModifier(0.5)
				SetAiMeleeWeaponDamageModifier(5.0)
				SetPlayerWeaponDamageModifier(Pid,1.0)
				SetPlayerMeleeWeaponDamageModifier(Pid,1.0)
				LocalPlayer["state"]:set("Megazord",false,false)
			end
		end

		if Heroin > 0 and GetGameTimer() >= HeroinTimer then
			Heroin = Heroin - 1
			HeroinTimer = GetGameTimer() + 1000

			if Heroin <= 0 or GetEntityHealth(Ped) <= 100 then
				if AnimpostfxIsRunning("DrugsMichaelAliensFight") then
					AnimpostfxStop("DrugsMichaelAliensFight")
				end

				HeroinTimer = GetGameTimer()
				SetEntityMaxHealth(Ped,200)
				SetPedMaxHealth(Ped,200)
				TriggerEvent("Health")
				Heroin = 0
			end
		end

		if Crack > 0 and GetGameTimer() >= CrackTimer then
			Crack = Crack - 1
			CrackTimer = GetGameTimer() + 1000

			if Crack <= 0 or GetEntityHealth(Ped) <= 100 then
				if AnimpostfxIsRunning("HeistCelebPassBW") then
					AnimpostfxStop("HeistCelebPassBW")
				end

				TriggerEvent("Hunger",90000)
				TriggerEvent("Thirst",90000)
				CrackTimer = GetGameTimer()
				Crack = 0
			end
		end

		if Joint > 0 and GetGameTimer() >= JointTimer then
			Joint = Joint - 1
			JointTimer = GetGameTimer() + 1000

			if Joint <= 0 or GetEntityHealth(Ped) <= 100 then
				if AnimpostfxIsRunning("DeathFailMPIn") then
					AnimpostfxStop("DeathFailMPIn")
				end

				if LocalPlayer["state"]["Walk"] then
					LocalPlayer["state"]:set("Walk",false,false)
				end

				SetRunSprintMultiplierForPlayer(Pid,1.0)
				JointTimer = GetGameTimer()
				Joint = 0
			end
		end

		if Oxycontin > 0 and GetGameTimer() >= OxycontinTimer then
			Oxycontin = Oxycontin - 1
			OxycontinTimer = GetGameTimer() + 1000

			if Oxycontin <= 0 or GetEntityHealth(Ped) <= 100 then
				if AnimpostfxIsRunning("DrugsMichaelAliensFight") then
					AnimpostfxStop("DrugsMichaelAliensFight")
				end

				OxycontinTimer = GetGameTimer()
				Oxycontin = 0
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Weapon",function(Value)
	Weapon = Value
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DRUGSBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:DrugsBlips")
AddEventHandler("inventory:DrugsBlips",function(Coords)
	local Blip = AddBlipForCoord(Coords["x"],Coords["y"],Coords["z"])
	SetBlipSprite(Blip,126)
	SetBlipDisplay(Blip,4)
	SetBlipHighDetail(Blip,true)
	SetBlipAsShortRange(Blip,true)
	SetBlipColour(Blip,5)
	SetBlipScale(Blip,1.0)
	SetBlipFlashes(Blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Traficante Procurado")
	EndTextCommandSetBlipName(Blip)

	SetTimeout(10000,function()
		if DoesBlipExist(Blip) then
			RemoveBlip(Blip)
		end
	end)
end)