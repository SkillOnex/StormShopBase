-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hypex = {}
Tunnel.bindInterface("shops",Hypex)
vCLIENT = Tunnel.getInterface("shops")
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
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local shops = {
	-- (Framework)
	["Ammunation"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["WEAPON_BAT"] = 975,
			["WEAPON_MACHETE"] = 975,
			["WEAPON_KARAMBIT"] = 975,
			["WEAPON_KATANA"] = 975,
			["WEAPON_FLASHLIGHT"] = 975,
			["WEAPON_HATCHET"] = 975,
			["WEAPON_BATTLEAXE"] = 975,
			["WEAPON_HAMMER"] = 975,
			["GADGET_PARACHUTE"] = 225,
			["WEAPON_PICKAXE"] = 525,
			["WEAPON_KNUCKLE"] = 975,
			["WEAPON_GOLFCLUB"] = 975,
			["WEAPON_POOLCUE"] = 975,
			["repairkit01"] = 525,
			["repairkit02"] = 3225,
			["repairkit03"] = 5225,
			["repairkit04"] = 7225
		}
	},
	["Departament"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["notepad"] = 10,
			["coffee"] = 20,
			["chocolate"] = 15,
			["cigarette"] = 10,
			["cola"] = 15,
			["energetic"] = 15,
			["emptybottle"] = 30,
			["hamburger"] = 25,
			["lighter"] = 175,
			["bread"] = 5,
			["sandwich"] = 15,
			["soda"] = 15,
			["tacos"] = 22
		}
	},
	["DepartamentMecanico"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["notepad"] = 10,
			["coffee"] = 20,
			["chocolate"] = 15,
			["cigarette"] = 10,
			["cola"] = 15,
			["energetic"] = 15,
			["emptybottle"] = 30,
			["hamburger"] = 25,
			["lighter"] = 175,
			["bread"] = 5,
			["sandwich"] = 15,
			["soda"] = 15,
			["tacos"] = 22,
			["WEAPON_WRENCH"] = 975,
			["WEAPON_CROWBAR"] = 725,
			["advtoolbox"] = 3075,
			["toolbox"] = 975,
			["tyres"] = 375,
		}
	},
	["Fuel"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["WEAPON_PETROLCAN"] = 250
		}
	},
	-- (Ilegal)
	["Criminal"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["lampshade"] = 75,
			["cup"] = 100,
			["switch"] = 45,
			["blender"] = 75,
			["mouse"] = 75,
			["pan"] = 100,
			["playstation"] = 75,
			["dish"] = 75,
			["keyboard"] = 75,
			["fan"] = 100,
			["xbox"] = 75
		}
	},
	["Criminal2"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["goldring"] = 125,
			["silverring"] = 100,
			["bracelet"] = 125,
			["slipper"] = 75,
			["spray01"] = 75,
			["spray02"] = 75,
			["spray03"] = 75,
			["spray04"] = 75,
			["brush"] = 75,
			["watch"] = 500,
			["rimel"] = 75,
			["soap"] = 75,
			["dildo"] = 75
		}
	},
	["Criminal3"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["eraser"] = 75,
			["deck"] = 75,
			["dices"] = 45,
			["floppy"] = 45,
			["domino"] = 45,
			["horseshoe"] = 75,
			["legos"] = 75,
			["ominitrix"] = 75
		}
	},
	["Criminal4"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["pliers"] = 55,
			["pistolbody"] = 125,
			["smgbody"] = 225,
			["riflebody"] = 325,
			["pager"] = 125,
			["pendrive"] = 325
		}
	},
	["Danger"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["adrenaline"] = 4000,
			["pliers"] = 75,
			["lockpick"] = 475,
			["credential"] = 890,
			["plate"] = 425,
			["pager"] = 100,
			["pendrive"] = 500,
			["WEAPON_NAIL_AMMO"] = 5
		}
	},
	["Drinks"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["absolut"] = 15,
			["chandon"] = 15,
			["dewars"] = 15,
			["hennessy"] = 15
		}
	},
	-- (Center)
	["Cassino"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["chips"] = 1
		}
	},
	["Cassino2"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["chips"] = 1
		}
	},
	["Pharmacy"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["medkit"] = 575,
			["bandage"] = 225,
			["gauze"] = 100,
			["analgesic"] = 125
		}
	},
	["Premium"] = {
		["mode"] = "Buy",
		["type"] = "Premium",
		["List"] = {
			["newchars"] = 75,
			["chip"] = 25,
			["diagram"] = 5,
			["gemstone"] = 1,
			["premium"] = 65,
			["WEAPON_PICKAXE_PLUS"] = 20,
			["rolepass"] = 110,
			["premiumplate"] = 35,
			["namechange"] = 25
		}
	},
	["Properties"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["diagram"] = 10000
		}
	},
	["Townhall"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["identity"] = 5000
		}
	},
	-- (Public)
	["Paramedico"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Paramedico",
		["List"] = {
			["adrenaline"] = 425,
			["badge02"] = 10,
			["syringe"] = 2,
			["bandage"] = 85,
			["gauze"] = 40,
			["gdtkit"] = 20,
			["medkit"] = 275,
			["sinkalmy"] = 175,
			["analgesic"] = 85,
			["ritmoneury"] = 175,
		}
	},
	["Policia"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Policia",
		["List"] = {
			["gsrkit"]  = 35,
			["gdtkit"] = 35,
			["handcuff"] = 450,
			["vest"] = 250,
			["WEAPON_PISTOL_AMMO"] = 14,
			["WEAPON_SMG_AMMO"] = 16,
			["WEAPON_RIFLE_AMMO"] = 18,
			["ATTACH_FLASHLIGHT"] = 250,
			["ATTACH_CROSSHAIR"] = 250,
			["ATTACH_SILENCER"] = 250,
			["ATTACH_MAGAZINE"] = 250,
			["ATTACH_GRIP"] = 250,
			["WEAPON_NIGHTSTICK"] = 250,
			["WEAPON_STUNGUN"] = 250,
			["WEAPON_COMBATPISTOL"] = 1375,
			["WEAPON_APPISTOL"] = 2000,
			["WEAPON_SMG"] = 1625,
			["WEAPON_SMG_MK2"] = 1700,
			["WEAPON_COLTXM177"] = 2600,
			["WEAPON_TACTICALRIFLE"] = 2375,
			["WEAPON_HEAVYRIFLE"] = 2625,
			["WEAPON_CARBINERIFLE"] = 2500,
			["WEAPON_CARBINERIFLE_MK2"] = 5750,
			["WEAPON_BULLPUPRIFLE"] = 2125,
			["WEAPON_BULLPUPRIFLE_MK2"] = 2875
		}
	},
	["Harmony"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Harmony",
		["List"] = {
			["WEAPON_WRENCH"] = 375,
			["WEAPON_CROWBAR"] = 225,
			["advtoolbox"] = 1375,
			["toolbox"] = 375,
			["tyres"] = 85
		}
	},
	["Mecanico"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["WEAPON_WRENCH"] = 375,
			["WEAPON_CROWBAR"] = 225,
			["advtoolbox"] = 1375,
			["lockpick"] = 1750,
			["toolbox"] = 375,
			["tyres"] = 85
		}
	},
	["Bennys"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["WEAPON_WRENCH"] = 375,
			["WEAPON_CROWBAR"] = 225,
			["advtoolbox"] = 1375,
			["lockpick"] = 1750,
			["toolbox"] = 375,
			["tyres"] = 85
		}
	},
	-- (Market)
	["Brewery"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["absolut"] = 15,
			["chandon"] = 15,
			["dewars"] = 15,
			["hennessy"] = 15,
			["energetic"] = 15
		}
	},
	["CoolBeans"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hamburger2"] = 350,
			["hamburger3"] = 350,
			["orangejuice"] = 250,
			["tangejuice"] = 250,
			["cupcake"] = 60
		}
	},
	["LastTrain"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["pizzamozzarella"] = 125,
			["pizzabanana"] = 125,
			["pizzachocolate"] = 125,
			["calzone"] = 125,
			["chickenfries"] = 100,
			["hamburger2"] = 125,
			["sandwich"] = 150,
			["tacos"] = 25,
			["onionrings"] = 100,
			["fries"] = 70,
			["guarananatural"] = 75,
			["orangejuice"] = 100,
			["tangejuice"] = 100,
			["grapejuice"] = 100,
			["bananajuice"] = 100,
			["strawberryjuice"] = 100,
			["passionjuice"] = 100,
			["acerolajuice"] = 125
		}
	},
	["DigitalDen"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["cellphone"] = 575,
			["binoculars"] = 275,
			["camera"] = 275,
			["radio"] = 875
		}
	},
	["LDOrganies"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["cigarette"] = 10,
			["firecracker"] = 100,
			["lighter"] = 175,
			["vape"] = 4750,
			["ziplock"] = 5,
			["bottle"] = 5,
			["syringe"] = 5,
			["acetone"] = 5,
			["silk"] = 5,
			["wheatflour"] = 5
		}
	},
	["Masquerade"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["rope"] = 875,
			["rose"] = 25,
			["teddy"] = 75,
			["backpack"] = 4750
		}
	},
	["PopsPills"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["medkit"] = 575,
			["bandage"] = 225,
			["gauze"] = 100,
			["analgesic"] = 125
		}
	},
	["Truthorganic"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["tomato"] = 10,
			["banana"] = 10,
			["guarana"] = 10,
			["acerola"] = 10,
			["passion"] = 10,
			["grape"] = 10,
			["tange"] = 10,
			["orange"] = 10,
			["apple"] = 10,
			["strawberry"] = 10,
			["coffee2"] = 10
		}
	},
	-- (Works)
	["Fishing"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["anchovy"] = 45,
			["herring"] = 50,
			["orangeroughy"] = 45,
			["catfish"] = 45,
			["yellowperch"] = 45,
			["salmon"] = 55,
			["sardine"] = 35,
			["smalltrout"] = 40,
			["smallshark"] = 100
		}
	},
	["Hunting"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["WEAPON_SWITCHBLADE"] = 525,
			["WEAPON_MUSKET"] = 3250,
			["WEAPON_MUSKET_AMMO"] = 7
		}
	},
	["Hunting2"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["deer1star"] = 225,
			["deer2star"] = 375,
			["deer3star"] = 575,
			["coyote1star"] = 225,
			["coyote2star"] = 375,
			["coyote3star"] = 575,
			["boar1star"] = 225,
			["boar2star"] = 375,
			["boar3star"] = 575,
			["mtlion1star"] = 225,
			["mtlion2star"] = 375,
			["mtlion3star"] = 575
		}
	},
	["Miners"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["lead_pure"] = 50,
			["copper_pure"] = 60,
			["tin_pure"] = 50,
			["iron_pure"] = 50,
			["gold_pure"] = 70,
			["diamond_pure"] = 70,
			["sulfur_pure"] = 50,
			["emerald_pure"] = 80,
			["ruby_pure"] = 80,
			["sapphire_pure"] = 80
		}
	},
	["Recycle"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["plastic"] = 10,
			["propertys"] = 5,
			["glass"] = 10,
			["rubber"] = 10,
			["aluminum"] = 15,
			["copper"] = 15,
			["emptybottle"] = 15,
			["rose"] = 15,
			["teddy"] = 35,
			["firecracker"] = 50,
			["plate"] = 125,
			["techtrash"] = 60,
			["tarp"] = 20,
			["sheetmetal"] = 20,
			["roadsigns"] = 20,
			["explosives"] = 30,
			["cotton"] = 20,
			["plaster"] = 15,
			["sulfuric"] = 2,
			["saline"] = 20,
			["alcohol"] = 15
		}
	},
		-- Machine
	["Coffee"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["coffee"] = 40
		}
	},
	["Soda"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["cola"] = 30,
			["soda"] = 30
		}
	},
	["Donut"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["donut"] = 30,
			["chocolate"] = 30
		}
	},
	["Burger"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hamburger"] = 30
		}
	},
	["Hotdog"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hotdog"] = 30
		}
	},
	["Chihuahua"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hotdog"] = 30,
			["hamburger"] = 50,
			["coffee"] = 40,
			["cola"] = 30,
			["soda"] = 30
		}
	},
	["Water"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["water"] = 60
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NAMES
-----------------------------------------------------------------------------------------------------------------------------------------
local nameMale = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio" }
local nameFemale = { "Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local userName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.requestPerm(Type)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if exports["hud"]:Wanted(Passport,source) then
			return false
		end

		if shops[Type]["perm"] ~= nil then
			if not vRP.HasGroup(Passport,shops[Type]["perm"]) then
				return false
			end
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.requestShop(name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local shopSlots = 20
		local inventoryShop = {}
		for k,v in pairs(shops[name]["List"]) do
			inventoryShop[#inventoryShop + 1] = { key = k, price = parseInt(v), name = itemName(k), index = itemIndex(k), peso = itemWeight(k), economy = parseFormat(itemEconomy(k)), max = itemMaxAmount(k), desc = itemDescription(k) }
		end

		local inventoryUser = {}
		local inventory = vRP.Inventory(Passport)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			inventoryUser[k] = v
		end

		if parseInt(#inventoryShop) > 20 then
			shopSlots = parseInt(#inventoryShop)
		end

		return inventoryShop,inventoryUser,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),shopSlots
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.getShopType(Type)
    return shops[Type]["mode"]
end---------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.functionShops(Type,Item,Amount,Slot)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if shops[Type] then
			if Amount <= 0 then Amount = 1 end

			local inventory = vRP.Inventory(Passport)
			if (inventory[tostring(Slot)] and inventory[tostring(Slot)]["item"] == Item) or not inventory[tostring(Slot)] then
				if shops[Type]["mode"] == "Buy" then
					if vRP.MaxItens(Passport,Item,Amount) then
						TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
						vCLIENT.updateShops(source,"requestShop")
						return
					end

					if (vRP.InventoryWeight(Passport) + itemWeight(Item) * Amount) <= vRP.GetWeight(Passport) then
						if shops[Type]["type"] == "Cash" then
							if shops[Type]["List"][Item] then
								if vRP.PaymentFull(Passport,shops[Type]["List"][Item] * Amount) then
									if Item == "identity" or string.sub(Item,1,5) == "badge" then
										vRP.GiveItem(Passport,Item.."-"..Passport,Amount,false,Slot)
									elseif Item == "fidentity" then
										local Identity = vRP.Identity(Passport)
										if Identity then
											if Identity["sex"] == "M" then
												vRP.Query("fidentity/NewIdentity",{ name = nameMale[math.random(#nameMale)], name2 = userName2[math.random(#userName2)], blood = math.random(4) })
											else
												vRP.Query("fidentity/NewIdentity",{ name = nameFemale[math.random(#nameFemale)], name2 = userName2[math.random(#userName2)], blood = math.random(4) })
											end

											local Identity = vRP.Identity(Passport)
											local consult = vRP.Query("fidentity/GetIdentity")
											if consult[1] then
												vRP.GiveItem(Passport,Item.."-"..consult[1]["id"],Amount,false,Slot)
											end
										end
									else
										vRP.GenerateItem(Passport,Item,Amount,false,Slot)

										if Item == "WEAPON_PETROLCAN" then
											vRP.GenerateItem(Passport,"WEAPON_PETROLCAN_AMMO",4500,false)
										end
									end

									TriggerClientEvent("sounds:Private",source,"cash",0.1)
								else
									TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
								end
							end
						elseif shops[Type]["type"] == "Consume" then
							if vRP.TakeItem(Passport,shops[Type]["item"],parseInt(shops[Type]["List"][Item] * Amount)) then
								vRP.GenerateItem(Passport,Item,Amount,false,Slot)
								TriggerClientEvent("sounds:Private",source,"cash",0.1)
							else
								TriggerClientEvent("Notify",source,"vermelho","<b>"..itemName(shops[Type]["item"]).."</b> insuficiente.",5000)
							end
						elseif shops[Type]["type"] == "Premium" then
							if vRP.PaymentGems(Passport,shops[Type]["List"][Item] * Amount) then
								TriggerClientEvent("sounds:Private",source,"cash",0.1)
								vRP.GenerateItem(Passport,Item,Amount,false,Slot)
								TriggerClientEvent("Notify",source,"verde","Comprou <b>"..Amount.."x "..itemName(Item).."</b> por <b>"..shops[Type]["List"][Item] * Amount.." Gemas</b>.",5000)
							else
								TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					end
				elseif shops[Type]["mode"] == "Sell" then
					local splitName = splitString(Item,"-")

					if shops[Type]["List"][splitName[1]] then
						local itemPrice = shops[Type]["List"][splitName[1]]

						if itemPrice > 0 then
							if vRP.CheckDamaged(Item) then
								TriggerClientEvent("Notify",source,"vermelho","Itens danificados não podem ser vendidos.",5000)
								vCLIENT.updateShops(source,"requestShop")
								return
							end
						end

						if shops[Type]["type"] == "Cash" then
							if vRP.TakeItem(Passport,Item,Amount,true,Slot) then
								if itemPrice > 0 then
									vRP.GenerateItem(Passport,"dollars",parseInt(itemPrice * Amount),false)
									TriggerClientEvent("sounds:Private",source,"cash",0.1)
								end
							end
						elseif shops[Type]["type"] == "Consume" then
							if vRP.TakeItem(Passport,Item,Amount,true,Slot) then
								if itemPrice > 0 then
									vRP.GenerateItem(Passport,shops[Type]["item"],parseInt(itemPrice * Amount),false)
									TriggerClientEvent("sounds:Private",source,"cash",0.1)
								end
							end
						end
					end
				end
			end
		end

		vCLIENT.updateShops(source,"requestShop")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("shops:populateSlot")
AddEventHandler("shops:populateSlot",function(Item,Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
			vRP.GiveItem(Passport,Item,Amount,false,Target)
			vCLIENT.updateShops(source,"requestShop")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("shops:updateSlot")
AddEventHandler("shops:updateSlot",function(Item,Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		local inventory = vRP.Inventory(Passport)
		if inventory[tostring(Slot)] and inventory[tostring(Target)] and inventory[tostring(Slot)]["item"] == inventory[tostring(Target)]["item"] then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.GiveItem(Passport,Item,Amount,false,Target)
			end
		else
			vRP.SwapSlot(Passport,Slot,Target)
		end

		vCLIENT.updateShops(source,"requestShop")
	end
end)