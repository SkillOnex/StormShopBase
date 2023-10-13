-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hypex = {}
Tunnel.bindInterface("taskbar",Hypex)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Status = ""
local Progress = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- FAILURE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("failure",function(Data,Callback)
	SetNuiFocus(false,false)
	Status = "failure"
	Progress = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUCESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("success",function(Data,Callback)
	SetNuiFocus(false,false)
	Status = "success"
	Progress = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIGAME
-----------------------------------------------------------------------------------------------------------------------------------------
function Minigame(Timer)
	if Progress then return end

	Progress = true
	SetNuiFocus(true,false)
	SendNUIMessage({ name = "Open", payload = Timer })

	while Progress do
		Wait(0)
	end

	if Status == "success" then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASK
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Task",function(Amount,Speed)
	local Return = true

	for Number = 1,Amount do
		if not Minigame(Speed) then
			Return = false
			break
		end
	end

	return Return
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASK
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.Task(Amount,Speed)
	local Return = true

	for Number = 1,Amount do
		if not Minigame(Speed) then
			Return = false
			break
		end
	end

	return Return
end