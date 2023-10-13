-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("bank")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    local Table = {}

    for _,v in pairs(Locations) do
        table.insert(Table,{ v[1],v[2],v[3],1.25,"E","Banco","Pressione para abrir" })
    end

    TriggerEvent("hoverfy:Insert",Table)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()

			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)
				
				for _,v in pairs(Locations) do
					local Distance = #(Coords - vec3(v[1],v[2],v[3]))
					if Distance <= 0.75 then
						if MumbleIsConnected() then
							LocalPlayer['state']['Cancel'] = false
							LocalPlayer['state']['Commands'] = false
							FreezeEntityPosition(Ped, false)
						else
							TimeDistance = 1
							LocalPlayer['state']['Cancel'] = true
							  LocalPlayer['state']['Commands'] = true
							FreezeEntityPosition(Ped, true)
						end

						TimeDistance = 1
						
						if IsControlJustPressed(1,38) and vSERVER.Wanted() then
							SetNuiFocus(true,true)
							SendNUIMessage({ Action = "Open", name = LocalPlayer["state"]["Name"] })
						end
					end
				end
			end

		end
		
		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Hide" })

	Callback(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Home",function(Data,Callback)
	Callback(vSERVER.Home())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Deposit",function(Data,Callback)
	Callback(vSERVER.Deposit(Data["value"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Withdraw",function(Data,Callback)
	Callback(vSERVER.Withdraw(Data["value"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Transfer",function(Data,Callback)
	if Data["targetId"] and Data["value"] then
		Callback(vSERVER.Transfer(Data["targetId"],Data["value"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDDEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("AddDependents",function(Data,Callback)
	if Data["passport"] then
		Callback(vSERVER.AddDependents(Data["passport"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RemoveDependents",function(Data,Callback)
	Callback(vSERVER.RemoveDependents(Data["passport"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Investments",function(Data,Callback)
	Callback(vSERVER.Investments())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Invest",function(Data,Callback)
	if Data["value"] then
		Callback(vSERVER.Invest(Data["value"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvestRescue",function(Data,Callback)
	vSERVER.InvestRescue()

	Callback(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONHISTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("TransactionHistory",function(Data,Callback)
	Callback(vSERVER.TransactionHistory())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("MakeInvoice",function(Data,Callback)
	if Data["passport"] and Data["value"] and Data["reason"] then
		Callback(vSERVER.MakeInvoice(Data["passport"],Data["value"],Data["reason"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvoicePayment",function(Data,Callback)
	Callback(vSERVER.InvoicePayment(Data["id"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvoiceList",function(Data,Callback)
	Callback(vSERVER.InvoiceList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FineList",function(Data,Callback)
	Callback(vSERVER.FineList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FinePayment",function(Data,Callback)
	Callback(vSERVER.FinePayment(Data["id"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENTALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FinePaymentAll",function(Data,Callback)
	Callback(vSERVER.FinePaymentAll())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Taxes",function(Data,Callback)
	Callback(vSERVER.TaxList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("TaxPayment",function(Data,Callback)
	Callback(vSERVER.TaxPayment(Data["id"]))
end)