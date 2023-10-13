-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("painel",Creative)
vCLIENT = Tunnel.getInterface("painel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Panel = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function Premium(Org)
	local infos = vRP.Query("painel/GetInformations",{ Name = tostring(Org) })[1]

	if infos["premium"] > 0 then
		local premium = infos["premium"] - os.time()
		
		local Days = math.floor(premium / 86400)

		if infos["buff"] == true and Days < 1 then
			vRP.Query("painel/UpdateBuff",{ Name = tostring(Org), Buff = false })
			vRP.Query("chests/DowngradeChests",{ Name = tostring(Org) })
			vRP.Query("painel/SetPremium",{ Name = tostring(Org), Seconds = 0 })

			local Entitys = vRP.DataGroups(Panel[Passport])
			for Number,v in pairs(Entitys) do
				local Number = parseInt(Number)
				TriggerEvent("Salary:Remove", tostring(Number), "Buff")
			end
		end

		return Days
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAINEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("painel",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and Message[1] ~= "Premium" then
		if vRP.HasPermission(Passport,Message[1]) then
			Panel[Passport] = Message[1]
			local Members = {}
			local Sources = vRP.Players()
			local Entitys = vRP.DataGroups(Panel[Passport])
			local Hierarchy = vRP.Hierarchy(Panel[Passport])
			
			for Number,v in pairs(Entitys) do
				local Number = parseInt(Number)
				local Identity = vRP.Identity(Number)
				if Identity then
					if vRP.HasPermission(Number,Panel[Passport],1) then
						Members[#Members + 1] = { ["name"] = Identity["name"].." "..Identity["name2"], ["phone"] = Identity["phone"], ["online"] = Sources[Number], ["id"] = Number, ["role"] = Hierarchy[1] or Hierarchy, ["role_id"] = 1 }
					else
						Members[#Members + 1] = { ["name"] = Identity["name"].." "..Identity["name2"], ["phone"] = Identity["phone"], ["online"] = Sources[Number], ["id"] = Number, ["role"] = Hierarchy[v] or Hierarchy }
					end
				end
			end

			local Data = {
				groupName = Panel[Passport],
				members = Members,
				client_role = Entitys[tostring(Passport)]
			}

			vCLIENT.Open(source,Data,Premium(Panel[Passport]),Price)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMISS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Dismiss(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] and Number > 1 and Passport ~= Number then
		if vRP.HasPermission(Passport,Panel[Passport],1) and not vRP.HasPermission(Number,Panel[Passport],1) then
			vRP.RemovePermission(Number,Panel[Passport])

			TriggerClientEvent("Notify",source,"verde","Passaporte removido.",5000)

			local Members = {}
			local Sources = vRP.Players()
			local Entitys = vRP.DataGroups(Panel[Passport])
			local Hierarchy = vRP.Hierarchy(Panel[Passport])

			for Number,v in pairs(Entitys) do
				local Number = parseInt(Number)
				local Identity = vRP.Identity(Number)
				if Identity then
					if vRP.HasPermission(Number,Panel[Passport],1) then
						Members[#Members + 1] = { ["name"] = Identity["name"].." "..Identity["name2"], ["phone"] = Identity["phone"], ["online"] = Sources[Number], ["id"] = Number, ["role"] = Hierarchy[1] or Hierarchy, ["role_id"] = 1 }
					else
						Members[#Members + 1] = { ["name"] = Identity["name"].." "..Identity["name2"], ["phone"] = Identity["phone"], ["online"] = Sources[Number], ["id"] = Number, ["role"] = Hierarchy[v] or Hierarchy }
					end
				end
			end
			
			return Members
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVITE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Invite(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	local Identity = vRP.Identity(Passport)
	local otherSource = vRP.Source(Number)
	if Passport and Panel[Passport] and Number > 1 and Passport ~= Number and vRP.Identity(Number) and otherSource then
		if vRP.HasPermission(Passport,Panel[Passport],1) then
			TriggerClientEvent("Notify",source,"amarelo","O convite foi enviado.",5000)
			if vRP.Request(otherSource,Identity["name"].." "..Identity["name2"].." te convidou para se juntar a organização "..Panel[Passport]..", você aceita esse convite?") then
				vRP.SetPermission(Number,Panel[Passport])
	
				TriggerClientEvent("Notify",source,"verde","O convite foi aceito.",5000)
				
				local Sources = vRP.Players()
				local Entitys = vRP.DataGroups(Panel[Passport])
				local Identity = vRP.Identity(Number)
	
				return { 
					["name"] = Identity["name"].." "..Identity["name2"], 
					["phone"] = Identity["phone"], 
					["online"] = Sources[Number], 
					["id"] = Number,
					["role"] = vRP.Hierarchy(Panel[Passport])[Entitys[tostring(Number)]]
				}
			else
				TriggerClientEvent("Notify",source,"vermelho","O convite foi recusado.",5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIERARCHY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Hierarchy(OtherPassport,Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] and OtherPassport > 1 and Passport ~= OtherPassport and vRP.Identity(OtherPassport) then
		if vRP.HasPermission(Passport,Panel[Passport],1) then
			if (not vRP.HasPermission(OtherPassport,Panel[Passport],1) and not vRP.HasPermission(OtherPassport,Panel[Passport],2))or (Mode == "Demote" and not vRP.HasPermission(OtherPassport,Panel[Passport],1)) then
				vRP.SetPermission(OtherPassport,Panel[Passport],nil,Mode)

				local Entitys = vRP.DataGroups(Panel[Passport])
				return { vRP.Hierarchy(Panel[Passport])[Entitys[tostring(OtherPassport)]] }
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Transactions()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] then
		local bank = vRP.Query("painel/GetInformations",{ Name = Panel[Passport] })[1]["bank"]
		local transactions = vRP.Query("painel/GetTransactions",{ Name = Panel[Passport] })
		return {
			["Balance"] = bank,
			["Transactions"] = transactions
		}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Withdraw(Value)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] and (vRP.HasPermission(Passport,Panel[Passport],1) or vRP.HasPermission(Passport,Panel[Passport],2)) then
		local Value = tonumber(Value)
		local bank = vRP.Query("painel/GetInformations",{ Name = Panel[Passport] })[1]["bank"]
		if Value <= bank then
			vRP.Query("painel/InsertTransaction",{ Name = Panel[Passport], Type = "exit", Value = Value })
			vRP.Query("painel/DowngradeBank",{ Name = Panel[Passport], Value = Value })

			vRP.GenerateItem(Passport,"dollars",Value,true)
			
			local Bank = vRP.Query("painel/GetInformations",{ Name = Panel[Passport] })[1]["bank"]
			local Transactions = vRP.Query("painel/GetTransactions",{ Name = Panel[Passport] })
			return {
				["Balance"] = Bank,
				["Transactions"] = Transactions
			}
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Deposit(Value)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] and (vRP.HasPermission(Passport,Panel[Passport],1) or vRP.HasPermission(Passport,Panel[Passport],2)) then
		local Value = tonumber(Value)
		local bank = vRP.ItemAmount(Passport, "dollars")
		if Value <= bank then
			if vRP.TakeItem(Passport,"dollars",Value,true) then
				vRP.Query("painel/InsertTransaction",{ Name = Panel[Passport], Type = "entry", Value = Value })
				vRP.Query("painel/UpgradeBank",{ Name = Panel[Passport], Value = Value })
				
				local Bank = vRP.Query("painel/GetInformations",{ Name = Panel[Passport] })[1]["bank"]
				local Transactions = vRP.Query("painel/GetTransactions",{ Name = Panel[Passport] })
				return {
					["Balance"] = Bank,
					["Transactions"] = Transactions
				}
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Buy()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] and (vRP.HasPermission(Passport,Panel[Passport],1) or vRP.HasPermission(Passport,Panel[Passport],2)) then
		if vRP.PaymentFull(Passport, Price) then
			local Seconds = os.time() + (86400 * 30)
			vRP.Query("painel/UpdateBuff",{ Name = Panel[Passport], Buff = true })
			vRP.Query("chests/UpgradeChests2",{ Name = Panel[Passport] })
			vRP.Query("painel/SetPremium",{ Name = Panel[Passport], Seconds = Seconds })

			local Entitys = vRP.DataGroups(Panel[Passport])
			for Number,v in pairs(Entitys) do
				local Number = parseInt(Number)
				TriggerEvent("Salary:Add", tostring(Number), "Buff")
			end
		end
	end
	return Premium(Panel[Passport])
end