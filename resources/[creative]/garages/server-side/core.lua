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
Tunnel.bindInterface("garages",Hypex)
vCLIENT = Tunnel.getInterface("garages")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawn = {}
local Signal = {}
local Searched = {}
local Propertys = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFY
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.Verify()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetFine(Passport) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Você possui multas pendentes.",10000)
			return false
		end

		if exports["hud"]:Wanted(Passport,source) and exports["hud"]:Reposed(Passport) then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Plates"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.ServerVehicle(Model,x,y,z,Heading,Plate,Nitrox,Doors,Body,Fuel)
	local Vehicle = CreateVehicle(Model,x,y,z,Heading,true,true)

	while not DoesEntityExist(Vehicle) do
		Wait(100)
	end

	if DoesEntityExist(Vehicle) then
		if Plate ~= nil then
			SetVehicleNumberPlateText(Vehicle,Plate)
		else
			Plate = vRP.GeneratePlate()
			SetVehicleNumberPlateText(Vehicle,Plate)
		end

		SetVehicleBodyHealth(Vehicle,Body + 0.0)

		if not Fuel then
			TriggerEvent("engine:tryFuel",Plate,100)
		end

		if Doors then
			local Doors = json.decode(Doors)
			if Doors ~= nil then
				for Number,Status in pairs(Doors) do
					if Status then
						SetVehicleDoorBroken(Vehicle,parseInt(Number),true)
					end
				end
			end
		end

		local Network = NetworkGetNetworkIdFromEntity(Vehicle)

		if Model ~= "wheelchair" then
			local Network = NetworkGetEntityFromNetworkId(Network)
			SetVehicleDoorsLocked(Network,2)

			local Nitro = GlobalState["Nitro"]
			Nitro[Plate] = Nitrox or 0
			GlobalState:set("Nitro",Nitro,true)
		end

		return true,Network,Vehicle
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
local Garages = {
	-- Bikes (Framework)
	["1"] = { name = "Bikes", payment = false },
	["2"] = { name = "Bikes", payment = false },
	["3"] = { name = "Bikes", payment = false },
	["4"] = { name = "Bikes", payment = false },
	["5"] = { name = "Bikes", payment = false },
	["6"] = { name = "Bikes", payment = false },
	["7"] = { name = "Bikes", payment = false },
	["8"] = { name = "Bikes", payment = false },
	["9"] = { name = "Bikes", payment = false },
	["10"] = { name = "Bikes", payment = false },
	["11"] = { name = "Bikes", payment = false },
	["12"] = { name = "Bikes", payment = false },
	["13"] = { name = "Bikes", payment = false },
	["14"] = { name = "Bikes", payment = false },
	["15"] = { name = "Bikes", payment = false },
	["16"] = { name = "Bikes", payment = false },
	["17"] = { name = "Bikes", payment = false },
	["18"] = { name = "Bikes", payment = false },

	-- Boats (Framework)
	["19"] = { name = "Boats", payment = true },
	["20"] = { name = "Boats", payment = true },
	["21"] = { name = "Boats", payment = true },
	["22"] = { name = "Boats", payment = true },

	-- Garage (Framework)
	["23"] = { name = "Garage", payment = true },
	["24"] = { name = "Garage", payment = true },
	["25"] = { name = "Garage", payment = false },
	["26"] = { name = "Garage", payment = true },
	["27"] = { name = "Garage", payment = true },
	["28"] = { name = "Garage", payment = true },
	["29"] = { name = "Garage", payment = false },
	["30"] = { name = "Garage", payment = true },
	["31"] = { name = "Garage", payment = true },
	["32"] = { name = "Garage", payment = true },
	["33"] = { name = "Garage", payment = true },
	["34"] = { name = "Garage", payment = true },
	["35"] = { name = "Garage", payment = true },
	["36"] = { name = "Garage", payment = false },
	["81"] = { name = "Garage", payment = false },
	
	-- -- Paramedico (Public)
	-- ["37"] = { name = "Paramedico", payment = false, perm = "Paramedico" },
	-- ["38"] = { name = "HwliParamedico", payment = false, perm = "Paramedico" },
	-- ["39"] = { name = "Paramedico", payment = false, perm = "Paramedico" },
	-- ["40"] = { name = "HwliParamedico", payment = false, perm = "Paramedico" },
	-- ["41"] = { name = "Paramedico", payment = false, perm = "Paramedico" },
	-- ["42"] = { name = "HwliParamedico", payment = false, perm = "Paramedico" },

	-- -- Policia (Public)
	-- ["43"] = { name = "Policia", payment = false, perm = "Policia" },
	-- ["44"] = { name = "HeliPolicia", payment = false, perm = "Policia" },
	-- ["45"] = { name = "Policia", payment = false, perm = "Policia" },
	-- ["46"] = { name = "HeliPolicia", payment = false, perm = "Policia" },
	-- ["47"] = { name = "Policia", payment = false, perm = "Policia" },
	-- ["48"] = { name = "BusPolicia", payment = false, perm = "Policia" },
	-- ["49"] = { name = "Policia", payment = false, perm = "Policia" },
	-- ["50"] = { name = "HeliPolicia", payment = false, perm = "Policia" },
	-- ["51"] = { name = "Policia", payment = false, perm = "Policia" },
	-- ["52"] = { name = "HeliPolicia", payment = false, perm = "Policia" },

	-- Mecanico (Public)
	["53"] = { name = "Mecanico", payment = false, perm = "Harmony" },
	["54"] = { name = "Mecanico", payment = false, perm = "Mecanico" },
	["55"] = { name = "Mecanico", payment = false, perm = "Bennys" },

	-- (Restaurants)
	["56"] = { name = "Pearls", payment = false, perm = "Pearls" },

	-- (Works)
	["57"] = { name = "Bus", payment = false },
	["58"] = { name = "Impound", payment = false },
	["59"] = { name = "Lumberman", payment = false },
	["60"] = { name = "Transporter", payment = false },
	["61"] = { name = "Trash", payment = false },
	["62"] = { name = "Trash", payment = false },
	["63"] = { name = "Trash", payment = false },
	["64"] = { name = "Trucker", payment = false },

	-- Contraband (Ilegal)
	["65"] = { name = "Chiliad", payment = true, perm = "Chiliad" },
	["66"] = { name = "Families", payment = true, perm = "Families" },
	["67"] = { name = "Highways", payment = true, perm = "Highways" },
	["68"] = { name = "Vagos", payment = true, perm = "Vagos" },

	-- Favelas (Ilegal)
	["69"] = { name = "Barragem", payment = true, perm = "Barragem" },
	["70"] = { name = "Farol", payment = true, perm = "Farol" },
	["71"] = { name = "Parque", payment = true, perm = "Parque" },
	["72"] = { name = "Sandy", payment = true, perm = "Sandy" },
	["73"] = { name = "Petróleo", payment = true, perm = "Petróleo" },
	["74"] = { name = "Praia-1", payment = true, perm = "Praia-1" },
	["75"] = { name = "Praia-2", payment = true, perm = "Praia-2" },
	["76"] = { name = "Zancudo", payment = true, perm = "Zancudo" },

	-- Mafias (Ilegal)
	["77"] = { name = "Madrazzo", payment = true, perm = "Madrazzo" },
	["78"] = { name = "Playboy", payment = true, perm = "Playboy" },
	["79"] = { name = "TheSouth", payment = true, perm = "TheSouth" },
	["80"] = { name = "Vineyard", payment = true, perm = "Vineyard" },
	-- PMS
	["82"] = { name = "PMESP", payment = true, perm = "Policia" },
	["83"] = { name = "ROTA", payment = true, perm = "Policia" },
	["84"] = { name = "Baep", payment = true, perm = "Policia" },
	["85"] = { name = "Choque", payment = true, perm = "Policia" },
	["86"] = { name = "Ft", payment = true, perm = "Policia" },
	["87"] = { name = "Pc", payment = true, perm = "Policia" },
	["88"] = { name = "Bprv", payment = true, perm = "Policia" },
	["89"] = { name = "heliPc", payment = true, perm = "Policia" },
	["90"] = { name = "Cavpm", payment = true, perm = "Policia" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNALREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("signalRemove",function(Plate)
	if not Signal[Plate] then
		Signal[Plate] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEREVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateReveryone",function(Plate)
	if GlobalState["Plates"][Plate] then
		local Plates = GlobalState["Plates"]
		Plates[Plate] = nil
		GlobalState:set("Plates",Plates,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateEveryone",function(Plate)
	local Plates = GlobalState["Plates"]
	Plates[Plate] = true
	GlobalState:set("Plates",Plates,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("platePlayers",function(Plate,Passport)
	if not vRP.PassportPlate(Plate) then
		local Plates = GlobalState["Plates"]
		Plates[Plate] = Passport
		GlobalState:set("Plates",Plates,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
local Works = {
	-- Bikes (Framework)
	["Bikes"] = {
		"bimx"
	},

	-- Boats (Framework)
	["Boats"] = {
		"dinghy",
		"jetmax",
		"marquis",
		"seashark",
		"speeder",
		"squalo",
		"suntrap",
		"toro",
		"tropic"
	},

	-- -- Paramedico (Public)
	-- ["Paramedico"] = {
	-- 	"ambulance2"
	-- },
	-- ["HeliParamedico"] = {
	-- 	"maverick2"
	-- },

	-- -- Policia (Public)
	-- ["BusPenal"] = {
	-- 	"pbus"
	-- },
	-- ["Policia"] = {
	-- 	"bmwm3",
	-- 	"m4cs",
	-- 	"bmwm5",
	-- 	"e63",
	-- 	"fpace",
	-- 	"jettagli",
	-- 	"tiger900",
	-- 	"WRr1200",
	-- 	"bcat",
	-- 	"nspeedo",
	-- 	"tundra",
	-- 	"wrsurus",
	-- 	"wrsgle63"
	-- },
	-- ["HeliPolicia"] = {
	-- 	"B412",
	-- 	"as350",
	-- 	"maverick2"
	-- },

	-- Mecanico (Public)
	["Mecanico"] = {
		"flatbed"
	},

	-- (Restaurants)
	["Pearls"] = {
		"pearls"
	},

	-- (Works)
	["Bus"] = {
		"bus"
	},
	["Impound"] = {
		"flatbed"
	},
	["Lumberman"] = {
		"ratloader"
	},
	["Transporter"] = {
		"stockade"
	},
	["Trash"] = {
		"trash"
	},
	["Trucker"] = {
		"hauler",
		"hauler2",
		"packer",
		"phantom"
	},

	["PMESP"] = {
		"basepm",
		"cronospmesp",
		"dusterpmesp",
		"golpmesp",
		"pmspin",
		"s10transito",
		"scorcher",
		"spinpm",
		"spintransito",
		"sw4choque",
		"sw4pm1",
		"trail15rota",
		"trail22anchieta",
		"trail22cpa",
		"trail22dpm",
		"trail22ft1",
		"trail22rota",
		"trail22rota2",
		"trail2020ft1",
		"xre19rpm",
		"xt2017pm",
		"xtchoque",
		"xttransito",
		"sw42020baep3"
	},

	["ROTA"] = {
		"sw4choque",
		"sw4pm1",
		"trail15rota",
		"trail21pm",
		"trail22anchieta",
		"trail22cpa",
		"trail22dpm",
		"trail22ft1",
		"trail22rota",
		"trail22rota2",
		"trail2020ft1",
		"xtchoque",
		"tigerpmesp",
		"sw42020baep3"
	},
	["Baep"] = {
		"trail21rota",
		"trail22rota",
		"trail21pm",
		"sw4pm",
		"trail20pm",
		"xre19rpm",
		"trail17pm",
		"xt2017pm"
	},
	["Choque"] = {
		"trail21rota",
		"trail22rota",
		"sw4pm",
		"trail20pm",
		"trail17pm",
		"trail21pm"
	},
	["Ft"] = {
		"trail21rota",
		"trail22rota",
		"trail21pm",
		"sw4pm",
		"trail20pm",
		"xre19rpm",
		"trail17pm",
		"xt2017pm"
	},
	["Pc"] = {
		"dustercivil",
		"trail21pm",
		"trail14goe",
		"s10iml",
		"s10garrasp",
		"trail20pcesp1",
		"trail21dope2",
		"trail21ger1",
		"spin20pm",
		"sw4pm1",
	},
	["Bprv"] = {
		"trail21rota",
		"trail22rota",
		"spinlegion",
		"spinaegis",
		"sw4tor",
		"corollarod",
		"xt2017pm",
		"trail21pm",
		"trail20pm"
	},
	["heliPc"] = {
		"as350pc"
	},
	["Cavpm"] = {
		"as350"
	},
	
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.Vehicles(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Wanted(Passport) then
		if Garages[Number]["perm"] then
			if not vRP.HasService(Passport,Garages[Number]["perm"]) then
				return false
			end
		end

		if string.sub(Number,1,9) == "Propertys" then
			local Consult = vRP.Query("propertys/Exist",{ name = Number })
			if Consult[1] then
				if parseInt(Consult[1]["Passport"]) == Passport or vRP.InventoryFull(Passport,"propertys-"..Consult[1]["Serial"]) then
					if os.time() > Consult[1]["Tax"] then
						TriggerClientEvent("Notify",source,"amarelo","Aluguel atrasado, procure um <b>Corretor de Imóveis</b>.",5000)
						return false
					end
				else
					return false
				end
			end
		end

		local Vehicle = {}
		local Garage = Garages[Number]["name"]
		if Works[Garage] then
			for _,v in pairs(Works[Garage]) do
				local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = v })
				if VehicleExist(v) then
					if vehicle[1] then
						Vehicle[#Vehicle + 1] = { 
							["model"] = v,
							["name"] = VehicleName(v),
	
							["type"] = VehicleMode(v),
	
							["engine"] = vehicle[1]["engine"],
							["chassi"] = vehicle[1]["health"],
							["body"] = vehicle[1]["body"],
							["gas"] = vehicle[1]["fuel"],
	
							["chest"] = VehicleChest(v),
							["tax"] = VehiclePrice(v) * 0.10
						}
					else
						Vehicle[#Vehicle + 1] = { 
							["model"] = v,
							["name"] = VehicleName(v),
	
							["type"] = VehicleMode(v),
	
							["engine"] = 1000,
							["chassi"] = 1000,
							["body"] = 1000,
							["gas"] = 100,
	
							["chest"] = VehicleChest(v),
							["tax"] = VehiclePrice(v) * 0.10
						}
					end
				end
			end
		else
			local Consult = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })
			for _,v in pairs(Consult) do
				if VehicleExist(v["vehicle"]) then
					if v["work"] == "false" then
						Vehicle[#Vehicle + 1] = { 
							["model"] = v["vehicle"],
							["name"] = VehicleName(v["vehicle"]),

							["type"] = VehicleMode(v["vehicle"]),

							["engine"] = v["engine"],
							["chassi"] = v["health"],
							["body"] = v["body"],
							["gas"] = v["fuel"],

							["chest"] = VehicleChest(v["vehicle"]),
							["tax"] = VehiclePrice(v["vehicle"]) * 0.10
						}
					end
				end
			end
		end

		return Vehicle
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.Impound()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicles = {}
		local Vehicle = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })

		for Number,v in ipairs(Vehicle) do
			if v["arrest"] >= os.time() then
				Vehicles[#Vehicles + 1] = { ["Model"] = Vehicle[Number]["vehicle"], ["name"] = VehicleName(Vehicle[Number]["vehicle"]) }
			end
		end

		return Vehicles
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Impound")
AddEventHandler("garages:Impound",function(vehName)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local VehiclePrice = VehiclePrice(vehName)
		TriggerClientEvent("dynamic:closeSystem",source)

		if vRP.Request(source,"A liberação do veículo tem o custo de <b>$"..parseFormat(VehiclePrice * 0.25).."</b> dólares, deseja prosseguir com a liberação do mesmo?","Sim, efetuar o pagamento","Não, decido depois") then
			if vRP.PaymentFull(Passport,VehiclePrice * 0.25) then
				vRP.Query("vehicles/paymentArrest",{ Passport = Passport, vehicle = vehName })
				TriggerClientEvent("Notify",source,"verde","Veículo liberado.",5000)
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TAX
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterServerEvent("garages:Tax")
-- AddEventHandler("garages:Tax",function(Name)

function Hypex.Tax(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if Consult[1] and Consult[1]["tax"] <= os.time() then
			local Price = VehiclePrice(Name) * 0.10

			if vRP.PaymentFull(Passport,Price) then
				vRP.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = Name })
				TriggerClientEvent("Notify",source,"verde","Pagamento concluído.",5000)
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SELL
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterServerEvent("garages:Sell")
-- AddEventHandler("garages:Sell",function(Name)

function Hypex.Sell(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Mode = VehicleMode(Name)
		if Mode == "rental" or Mode == "work" then
			return
		end

		local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if Consult[1] then
			local Price = VehiclePrice(Name) * 0.5
			if vRP.Request(source,"Vender o veículo <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(Price).."</b>?","Sim, concluír venda","Não, mudei de ideia") then
				local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
				if Consult[1] then
					vRP.GiveBank(Passport,Price)
					vRP.Query("vehicles/removeVehicles",{ Passport = Passport, vehicle = Name })
					vRP.Query("entitydata/RemoveData",{ dkey = "Mods:"..Passport..":"..Name })
					vRP.Query("entitydata/RemoveData",{ dkey = "Chest:"..Passport..":"..Name })
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterServerEvent("garages:Transfer")
-- AddEventHandler("garages:Transfer",function(Name)

function Hypex.Transfer(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Mode = VehicleMode(Name)
		if Mode == "rental" or Mode == "work" then
			return
		end
		
		local myVehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if myVehicle[1] then
			TriggerClientEvent("dynamic:closeSystem",source)

			local Keyboard = vKEYBOARD.keySingle(source,"Passaporte:")
			if Keyboard then
				local OtherPassport = parseInt(Keyboard[1])
				local Identity = vRP.Identity(OtherPassport)
				if Identity then
					if vRP.Request(source,"Transferir o veículo <b>"..VehicleName(Name).."</b> para <b>"..Identity["name"].." "..Identity["name2"].."</b>?","Sim, transferir","Não, mudei de ideia") then
						local Vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = parseInt(OtherPassport), vehicle = Name })
						if Vehicle[1] then
							TriggerClientEvent("Notify",source,"amarelo","<b>"..Identity["name"].." "..Identity["name2"].."</b> já possui este modelo de veículo.",5000)
						else
							vRP.Query("vehicles/moveVehicles",{ Passport = Passport, OtherPassport = parseInt(OtherPassport), vehicle = Name })

							local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..Passport..":"..Name })
							if parseInt(#Datatable) > 0 then
								vRP.Query("entitydata/SetData",{ dkey = "Mods:"..OtherPassport..":"..Name, dvalue = Datatable[1]["dvalue"] })
								vRP.Query("entitydata/RemoveData",{ dkey = "Mods:"..Passport..":"..Name })
							end

							local Datatable = vRP.GetSrvData("Chest:"..Passport..":"..Name)
							vRP.SetSrvData("Chest:"..OtherPassport..":"..Name,Datatable)
							vRP.RemSrvData("Chest:"..Passport..":"..Name)

							TriggerClientEvent("Notify",source,"verde","Transferência concluída.",5000)
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterServerEvent("garages:Spawn")
-- AddEventHandler("garages:Spawn",)

function Hypex.Spawn(Name, Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Gemstone = VehicleGems(Name)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })

		if not vehicle[1] then
			if parseInt(Gemstone) > 0 then
				if vRP.Request(source,"Alugar o veículo <b>"..VehicleName(Name).."</b> por <b>"..Gemstone.."</b> gemas?","Sim, concluír aluguel","Não, mudei de ideia") then
					if vRP.PaymentGems(Passport,Gemstone) then
						vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
						TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.",5000)
						vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
					else
						TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
						return
					end
				else
					return
				end
			else
				local VehiclePrice = VehiclePrice(Name)
				if parseInt(VehiclePrice) > 0 then
					if vRP.Request(source,"Comprar <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(VehiclePrice).."</b> dólares?","Sim, concluír pagamento","Não, mudei de ideia") then
						if vRP.PaymentFull(Passport,VehiclePrice) then
							vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
							vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
						else
							TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
						end
					else
						return
					end
				else
					vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
					vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
				end
			end
		end

		if vehicle[1] then
			local Plates = GlobalState["Plates"]
			local Plate = vehicle[1]["plate"]

			if Spawn[Plate] then
				if not Signal[Plate] then
					if not Searched[Passport] then
						Searched[Passport] = os.time()
					end

					if os.time() >= parseInt(Searched[Passport]) then
						Searched[Passport] = os.time() + 60

						local Network = Spawn[Plate][3]
						local Network = NetworkGetEntityFromNetworkId(Network)
						if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 then
							vCLIENT.SearchBlip(source,GetEntityCoords(Network))
							TriggerClientEvent("Notify",source,"amarelo","Rastreador do veículo foi ativado por <b>30</b> segundos, lembrando que se o mesmo estiver em movimento a localização pode ser imprecisa.",10000)
						else
							if Spawn[Plate] then
								Spawn[Plate] = nil
							end

							if Plates[Plate] then
								Plates[Plate] = nil
								GlobalState:set("Plates",Plates,true)
							end

							TriggerClientEvent("Notify",source,"verde","A seguradora efetuou o resgate do seu veículo e o mesmo já se encontra disponível para retirada.",5000)
						end
					else
						TriggerClientEvent("Notify",source,"amarelo","Rastreador só pode ser ativado a cada <b>60</b> segundos.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Rastreador está desativado.",5000)
				end
			else
				if vehicle[1]["tax"] <= os.time() then
					TriggerClientEvent("Notify",source,"amarelo","Taxa do veículo atrasada.",5000)
				elseif vehicle[1]["arrest"] >= os.time() then
					TriggerClientEvent("Notify",source,"amarelo","Veículo apreendido, dirija-se até o <b>Impound</b> e efetue o pagamento da liberação do mesmo.",5000)
				else
					if vehicle[1]["rental"] ~= 0 then
						if vehicle[1]["rental"] <= os.time() then
							if vRP.Request(source,"Atualizar o aluguel do veículo <b>"..VehicleName(Name).."</b> por <b>"..Gemstone.." gemas</b>?","Sim, concluír pagamento","Não, mudei de ideia") then
								if vRP.PaymentGems(Passport,Gemstone) then
									vRP.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = Name })
									TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.",5000)
								else
									TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
									return
								end
							else
								return
							end
						end
					end

					local Coords = vCLIENT.SpawnPosition(source,Number)
					if Coords then
						local Mods = nil
						local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..Passport..":"..Name })
						if parseInt(#Datatable) > 0 then
							Mods = Datatable[1]["dvalue"]
						end

						if Garages[Number]["payment"] then
							if vRP.UserPremium(Passport) then
								TriggerClientEvent("dynamic:closeSystem",source)
								local Exist,Network = Hypex.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

								if Exist then
									vCLIENT.CreateVehicle(-1,Name,Network,vehicle[1]["engine"],vehicle[1]["health"],Mods,vehicle[1]["windows"],vehicle[1]["tyres"])
									TriggerClientEvent("Notify",source,"azul",CompleteTimers(vehicle[1]["tax"] - os.time()),1000)
									TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
									Spawn[Plate] = { Passport,Name,Network }

									Plates[Plate] = Passport
									GlobalState:set("Plates",Plates,true)
								end
							else
								local VehiclePrice = VehiclePrice(Name)
								if vRP.Request(source,"Retirar o veículo por <b>$"..parseFormat(VehiclePrice * 0.05).."</b> dólares?","Sim, efetuar o pagamento","Não, volto depois") then
									local Amount = parseInt(VehiclePrice * 0.05)
									if vRP.ConsultItem(Passport,"dollars",Amount) or vRP.GetBank(source) >= parseInt(VehiclePrice * 0.05) then
										TriggerClientEvent("dynamic:closeSystem",source)
										local Exist,Network = Hypex.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

										if Exist then
											vCLIENT.CreateVehicle(-1,Name,Network,vehicle[1]["engine"],vehicle[1]["health"],Mods,vehicle[1]["windows"],vehicle[1]["tyres"])
											TriggerClientEvent("Notify",source,"azul",CompleteTimers(vehicle[1]["tax"] - os.time()),1000)
											TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
											Spawn[Plate] = { Passport,Name,Network }
											vRP.PaymentFull(Passport,VehiclePrice * 0.05)

											Plates[Plate] = Passport
											GlobalState:set("Plates",Plates,true)
										end
									else
										TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
									end
								end
							end
						else
							TriggerClientEvent("dynamic:closeSystem",source)
							local Exist,Network = Hypex.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

							if Exist then
								vCLIENT.CreateVehicle(-1,Name,Network,vehicle[1]["engine"],vehicle[1]["health"],Mods,vehicle[1]["windows"],vehicle[1]["tyres"])
								TriggerClientEvent("Notify",source,"azul",CompleteTimers(vehicle[1]["tax"] - os.time()),1000)
								TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
								Spawn[Plate] = { Passport,Name,Network }

								Plates[Plate] = Passport
								GlobalState:set("Plates",Plates,true)
							end
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") and Message[1] then
			local VehicleName = Message[1]
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local Heading = GetEntityHeading(Ped)
			local Plate = "VEH"..(10000 + Passport)
			local Exist,Network,Vehicle = Hypex.ServerVehicle(VehicleName,Coords["x"],Coords["y"],Coords["z"],Heading,Plate,2000,nil,1000)

			if not Exist then
				return
			end

			vCLIENT.CreateVehicle(-1,VehicleName,Network,1000,1000,nil,false,false)
			Spawn[Plate] = { Passport,VehicleName,Network }
			TriggerEvent("engine:tryFuel",Plate,100)
			SetPedIntoVehicle(Ped,Vehicle,-1)

			local Plates = GlobalState["Plates"]
			Plates[Plate] = Passport
			GlobalState:set("Plates",Plates,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",1) then
		TriggerClientEvent("garages:Delete",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:KEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Key")
AddEventHandler("garages:Key",function(entity)
	local source = source
	local Plate = entity[1]
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Plates"][Plate] == Passport then
		vRP.GenerateItem(Passport,"vehkey-"..Plate,1,true,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Lock")
AddEventHandler("garages:Lock",function(Network,Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Plates"][Plate] == Passport then
		TriggerEvent("garages:LockVehicle",source,Network)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("garages:LockVehicle",function(source,Network)
	local Network = NetworkGetEntityFromNetworkId(Network)
	local Doors = GetVehicleDoorLockStatus(Network)

	if parseInt(Doors) <= 1 then
		TriggerClientEvent("Notify",source,"vermelho","Veículo trancado.",5000)
		TriggerClientEvent("sounds:Private",source,"locked",0.7)
		SetVehicleDoorsLocked(Network,2)
	else
		TriggerClientEvent("Notify",source,"verde","Veículo destrancado.",5000)
		TriggerClientEvent("sounds:Private",source,"unlocked",0.7)
		SetVehicleDoorsLocked(Network,1)
	end

	if not vRP.InsideVehicle(source) then
		vRPC.playAnim(source,true,{"anim@mp_player_intmenu@key_fob@","fob_click"},false)
		Wait(350)
		vRPC.stopAnim(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.Delete(Network,Health,Engine,Body,Fuel,Doors,Windows,Tyres,Plate)
	if Spawn[Plate] then
		local Passport = Spawn[Plate][1]
		local vehName = Spawn[Plate][2]

		if parseInt(Engine) <= 100 then
			Engine = 100
		end

		if parseInt(Body) <= 100 then
			Body = 100
		end

		if parseInt(Fuel) >= 100 then
			Fuel = 100
		end

		if parseInt(Fuel) <= 0 then
			Fuel = 0
		end

		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] ~= nil then
			vRP.Query("vehicles/updateVehicles",{ Passport = Passport, vehicle = vehName, nitro = GlobalState["Nitro"][Plate] or 0, engine = parseInt(Engine), body = parseInt(Body), health = parseInt(Health), fuel = parseInt(Fuel), doors = json.encode(Doors), windows = json.encode(Windows), tyres = json.encode(Tyres) })
		end
	end

	TriggerEvent("garages:deleteVehicle",Network,Plate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:deleteVehicle")
AddEventHandler("garages:deleteVehicle",function(Network,Plate)
	if Network ~= nil and Plate ~= nil then
		if GlobalState["Plates"][Plate] then
			local Plates = GlobalState["Plates"]
			Plates[Plate] = nil
			GlobalState:set("Plates",Plates,true)
		end

		if GlobalState["Nitro"][Plate] then
			local Nitro = GlobalState["Nitro"]
			Nitro[Plate] = nil
			GlobalState:set("Nitro",Nitro,true)
		end

		if Signal[Plate] then
			Signal[Plate] = nil
		end

		if Spawn[Plate] then
			Spawn[Plate] = nil
		end

		if string.sub(Plate,1,4) == "DISM" then
			local Passport = parseInt(string.sub(Plate,5,8)) - 1000
			local source = vRP.Source(Passport)
			if source then
				TriggerClientEvent("inventory:Disreset",source)
				TriggerClientEvent("Notify",source,"amarelo","O veículo do seu contrato foi encaminhado para o <b>Impound</b> e o <b>Lester</b> disse que você pode assinar um novo contrato quando quiser.",10000)
			end
		end

		local Network = NetworkGetEntityFromNetworkId(Network)
		if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 and GetVehicleNumberPlateText(Network) == Plate then
			DeleteEntity(Network)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Propertys")
AddEventHandler("garages:Propertys",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerClientEvent("dynamic:closeSystem",source)
		TriggerClientEvent("Notify",source,"amarelo","Selecione o local da garagem.",5000)

		local Hash = "prop_offroad_tyres02"
		local Application,Coords,Heading = vRPC.objectCoords(source,Hash)
		if Application then
			if #(Coords - exports["propertys"]:Coords(Name)) <= 25 then
				TriggerClientEvent("Notify",source,"amarelo","Selecione o local do veículo.",5000)

				local Open = Coords
				local Hash = "patriot"
				local Application,Coords,Heading = vRPC.objectCoords(source,Hash)
				if Application then
					if #(Coords - exports["propertys"]:Coords(Name)) <= 25 then
						local New = {
							["1"] = { mathLength(Open["x"]),mathLength(Open["y"]),mathLength(Open["z"] + 1) },
							["2"] = { mathLength(Coords["x"]),mathLength(Coords["y"]),mathLength(Coords["z"] + 1),mathLength(Heading) }
						}

						Garages[Name] = { name = "Garage", payment = false }

						Propertys[Name] = {
							["x"] = New["1"][1],
							["y"] = New["1"][2],
							["z"] = New["1"][3],
							["1"] = New["2"]
						}

						vRP.Query("propertys/Garage",{ name = Name, garage = json.encode(New) })
						TriggerClientEvent("garages:Propertys",-1,Propertys)
					else
						TriggerClientEvent("Notify",source,"amarelo","A garagem precisa ser próximo da entrada.",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","A garagem precisa ser próximo da entrada.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Consult = vRP.Query("propertys/Garages")
	for _,v in pairs(Consult) do
		local Name = v["Name"]
		if not Propertys[Name] and v["Garage"] ~= "{}" then
			local Table = json.decode(v["Garage"])
			Garages[Name] = { name = "Garage", payment = false }

			Propertys[Name] = {
				["x"] = Table["1"][1],
				["y"] = Table["1"][2],
				["z"] = Table["1"][3],
				["1"] = Table["2"]
			}
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNAL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Signal",function(Plate)
	return Signal[Plate]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("garages:Propertys",source,Propertys)
end)