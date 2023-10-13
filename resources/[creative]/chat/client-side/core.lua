-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Chat",function()
	if not IsPauseMenuActive() then
		SetNuiFocus(true,true)

		local Tags = {}
		for Index,v in pairs(ClientState) do
			if LocalPlayer["state"][Index] then
				Tags[#Tags + 1] = Index
			end
		end
		SendNUIMessage({ Action = "Chat", Data = Tags, Block = Block })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT:CLIENTMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:ClientMessage")
AddEventHandler("chat:ClientMessage",function(Author,Message,Mode,Special,Custom)
	SendNUIMessage({ Action = "Message", Author = Author, Message = Message, Type = Mode, Special = Special, Custom = Custom })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT:CLIENTMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:ClientDelete")
AddEventHandler("chat:ClientDelete",function(Message)
	SendNUIMessage({ Action = "Delete", Message = Message})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATDELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ChatDelete",function(Data,Callback)
    TriggerServerEvent("chat:DeleteMessage",Data["message"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATSUBMIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ChatSubmit",function(Data,Callback)
	SetNuiFocus(false,false)
	if Data["message"] ~= "" then
		if Data["message"]:sub(1,1) == "/" then
			-- print("Command run through chat ("..Data["message"]:sub(2)..")", GetInvokingResource())
			ExecuteCommand(Data["message"]:sub(2))
		else
			local Ped = PlayerPedId()
			if GetEntityHealth(Ped) > 100 then
                if #Data["message"] > 255 then
                    TriggerEvent("Notify","vermelho","Mensagem muito longa.",false,5000)
                    return
                else
                    TriggerServerEvent("chat:ServerMessage",Data["tag"],Data["message"])
                end
			end
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Chat","Abrir o chat.","keyboard","T")

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)