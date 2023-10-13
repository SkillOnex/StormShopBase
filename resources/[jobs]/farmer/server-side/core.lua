-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FRUITMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Fruitman")
AddEventHandler("farmer:Fruitman",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local Ped = GetPlayerPed(source)
				if GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_HATCHET") then
					local Amount = math.random(3,5)
					local Items = { "tomato","banana","passion","grape","tange","orange","strawberry" }
					local Select = math.random(#Items)

					if (vRP.InventoryWeight(Passport) + itemWeight(Items[Select]) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.playAnim(source,false,{"lumberjackaxe@idle","idle"},true)
						TriggerClientEvent("Progress",source,"Colhendo",11000)
						Objects[Number]["Time"] = GlobalState["Work"] + 25
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true

						local timeProgress = 10

						repeat
							if timeProgress ~= 10 then
								Wait(400)
							end

							Wait(700)
							TriggerClientEvent("sounds:Private",source,"lumberman",0.1)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(400)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,Items[Select],Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Machado</b> não encontrado.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUMBERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Lumberman")
AddEventHandler("farmer:Lumberman",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local Ped = GetPlayerPed(source)
				if GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_HATCHET") then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight("woodlog") * Amount) <= vRP.GetWeight(Passport) then
						vRPC.playAnim(source,false,{"lumberjackaxe@idle","idle"},true)
						TriggerClientEvent("Progress",source,"Cortando",11000)
						Objects[Number]["Time"] = GlobalState["Work"] + 15
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							if timeProgress ~= 10 then
								Wait(400)
							end

							Wait(700)
							TriggerClientEvent("sounds:Private",source,"lumberman",0.1)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(400)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"woodlog",Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Machado</b> não encontrado.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSPORTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Transporter")
AddEventHandler("farmer:Transporter",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				if (vRP.InventoryWeight(Passport) + itemWeight("pouch")) <= vRP.GetWeight(Passport) then
					vRPC.playAnim(source,false,{"pickup_object","pickup_low"},true)
					TriggerClientEvent("Progress",source,"Coletando",1000)
					Objects[Number]["Time"] = GlobalState["Work"] + 10
					Player(source)["state"]["Buttons"] = true
					Player(source)["state"]["Cancel"] = true

					Wait(1000)

					TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
					Player(source)["state"]["Buttons"] = false
					Player(source)["state"]["Cancel"] = false
					vRP.GenerateItem(Passport,"pouch",1,true)
					vRP.UpgradeStress(Passport,1)
					vRPC.Destroy(source)
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERCOPPER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerCopper")
AddEventHandler("farmer:MinerCopper",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "copper_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERGOLD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerGold")
AddEventHandler("farmer:MinerGold",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "gold_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERIRON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerIron")
AddEventHandler("farmer:MinerIron",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "iron_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERLEAD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerLead")
AddEventHandler("farmer:MinerLead",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "lead_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERTIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerTin")
AddEventHandler("farmer:MinerTin",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "tin_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERCRYSTALB
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerCrystalB")
AddEventHandler("farmer:MinerCrystalB",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "sapphire_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERCRYSTALG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerCrystalG")
AddEventHandler("farmer:MinerCrystalG",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "emerald_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERCRYSTALR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerCrystalR")
AddEventHandler("farmer:MinerCrystalR",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "ruby_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERDIAMOND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerDiamond")
AddEventHandler("farmer:MinerDiamond",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "diamond_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERSULFUR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:MinerSulfur")
AddEventHandler("farmer:MinerSulfur",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local List = { "sulfur_ore" }
				local RandomList = math.random(#List)
				local Selected = List[RandomList]
				if vRP.ConsultItem(Passport,"WEAPON_PICKAXE",1) then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 7
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",Amount,true)
						vRP.GenerateItem(Passport,Selected,Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,2)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				elseif vRP.ConsultItem(Passport,"WEAPON_PICKAXE_PLUS",1) then
					local PlusAmount = math.random(4,6)
					if (vRP.InventoryWeight(Passport) + itemWeight(Selected) * PlusAmount) <= vRP.GetWeight(Passport) then
						vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",5000)
						Objects[Number]["Time"] = GlobalState["Work"] + 5
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 5

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"coal",PlusAmount,true)
						vRP.GenerateItem(Passport,Selected,PlusAmount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.","Aviso",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Picareta</b> não encontrada.","Atenção",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("farmer:Table",source,Objects)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)