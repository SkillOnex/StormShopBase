-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Previous = nil
local Treatment = false
local TreatmentTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Beds = {
	-- Medical Center Sul
	{ ["Coords"] = vec3(-657.7,314.01,88.9), ["Heading"] = 354.34 },
	{ ["Coords"] = vec3(-659.85,314.6,88.01), ["Heading"] = 87.88 },
	{ ["Coords"] = vec3(-1872.19,-327.12,49.36), ["Heading"] = 323.15 },
	{ ["Coords"] = vec3(-1868.62,-330.04,49.36), ["Heading"] = 323.15 },
	{ ["Coords"] = vec3(-1865.76,-332.18,49.36), ["Heading"] = 323.15 },
	{ ["Coords"] = vec3(-1862.76,-334.49,49.36), ["Heading"] = 323.15 },
	{ ["Coords"] = vec3(-1868.78,-322.96,49.38), ["Heading"] = 144.57 },
	{ ["Coords"] = vec3(-1871.91,-320.44,49.37), ["Heading"] = 144.57 },
	{ ["Coords"] = vec3(-1875.21,-317.9,49.38), ["Heading"] = 144.57 },
	{ ["Coords"] = vec3(-1881.77,-304.17,53.71), ["Heading"] = 133.23 },
	{ ["Coords"] = vec3(-1884.12,-302.22,53.71), ["Heading"] = 136.07 },
	{ ["Coords"] = vec3(-1888.49,-299.59,53.71), ["Heading"] = 232.45 },
	{ ["Coords"] = vec3(-1893.34,-306.93,53.69), ["Heading"] = 320.32 },
	{ ["Coords"] = vec3(-1895.29,-309.06,53.68), ["Heading"] = 238.12 },
	{ ["Coords"] = vec3(-1896.87,-311.76,53.68), ["Heading"] = 195.6 },
	{ ["Coords"] = vec3(-1899.25,-314.49,53.67), ["Heading"] = 226.78 },
	{ ["Coords"] = vec3(-1901.05,-317.04,53.66), ["Heading"] = 226.78 },
	{ ["Coords"] = vec3(-1895.62,-321.61,53.66), ["Heading"] = 45.36 },
	{ ["Coords"] = vec3(-1889.78,-314.82,53.68), ["Heading"] = 42.52 },
	{ ["Coords"] = vec3(-1887.78,-312.5,53.69), ["Heading"] = 42.52 },
	{ ["Coords"] = vec3(-1885.77,-310.12,53.7), ["Heading"] = 45.36 },
	{ ["Coords"] = vec3(-1877.56,-312.76,58.06), ["Heading"] = 138.9 },
	{ ["Coords"] = vec3(-1875.6,-314.47,58.06), ["Heading"] = 138.9 },
	{ ["Coords"] = vec3(-1881.64,-324.36,58.03), ["Heading"] = 138.9 },
	{ ["Coords"] = vec3(-1884.92,-334.58,58.01), ["Heading"] = 323.15 },
	{ ["Coords"] = vec3(-1887.06,-332.86,58.01), ["Heading"] = 323.15 },
	{ ["Coords"] = vec3(-1881.2,-328.4,58.03), ["Heading"] = 229.61 },
	{ ["Coords"] = vec3(-1879.53,-326.39,58.03), ["Heading"] = 229.61 },
	{ ["Coords"] = vec3(-1871.9,-317.4,58.06), ["Heading"] = 138.9 },
	{ ["Coords"] = vec3(-1870.01,-319.09,58.06), ["Heading"] = 136.07 },
	-- Medical Center Norte Sandy
	{ ["Coords"] = vec3(1824.76,3681.69,34.19), ["Heading"] = 209.77 },
	{ ["Coords"] = vec3(1827.86,3683.42,34.19), ["Heading"] = 209.77 },
	{ ["Coords"] = vec3(1830.23,3679.29,34.19), ["Heading"] = 25.52 },
	{ ["Coords"] = vec3(1827.29,3677.57,34.19), ["Heading"] = 25.52 },
	-- Medical Center Norte Paleto
	{ ["Coords"] = vec3(-252.25,6323.07,32.35), ["Heading"] = 133.23 },
	{ ["Coords"] = vec3(-250.73,6321.67,32.35), ["Heading"] = 130.4 },
	{ ["Coords"] = vec3(-246.99,6317.99,32.35), ["Heading"] = 136.07 },
	{ ["Coords"] = vec3(-245.35,6316.21,32.35), ["Heading"] = 136.07 },
	{ ["Coords"] = vec3(-250.94,6310.49,32.35), ["Heading"] = 317.49 },
	{ ["Coords"] = vec3(-252.47,6312.21,32.35), ["Heading"] = 317.49 },
	{ ["Coords"] = vec3(-254.4,6313.8,32.35), ["Heading"] = 317.49 },
	{ ["Coords"] = vec3(-256.12,6315.49,32.35), ["Heading"] = 320.32 },
	{ ["Coords"] = vec3(-257.73,6317.26,32.35), ["Heading"] = 317.49 },
	-- Boolingbroke
	{ ["Coords"] = vec3(1761.87,2591.56,45.66), ["Heading"] = 272.13 },
	{ ["Coords"] = vec3(1761.87,2594.64,45.66), ["Heading"] = 272.13 },
	{ ["Coords"] = vec3(1761.87,2597.73,45.66), ["Heading"] = 272.13 },
	{ ["Coords"] = vec3(1771.98,2597.95,45.66), ["Heading"] = 87.88 },
	{ ["Coords"] = vec3(1771.98,2594.88,45.66), ["Heading"] = 87.88 },
	{ ["Coords"] = vec3(1771.98,2591.79,45.66), ["Heading"] = 87.88 },
	-- Clandestine
	{ ["Coords"] = vec3(-471.87,6287.56,13.63), ["Heading"] = 53.86 },
	-- DP D.P.B.C
	{ ["Coords"] = vec3(-937.12,-2059.38,9.33), ["Heading"] = 136.07 },
	{ ["Coords"] = vec3(-935.4,-2061.0,9.33), ["Heading"] = 136.07 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Beds) do
		AddBoxZone("Beds:"..Number,v["Coords"],1.0,1.0,{
			name = "Beds:"..Number,
			heading = v["Heading"],
			minZ = v["Coords"]["z"] - 0.01,
			maxZ = v["Coords"]["z"] + 0.01
		},{
			shop = Number,
			Distance = 1.25,
			options = {
				{
					event = "target:PutBed",
					label = "Deitar",
					tunnel = "client"
				},{
					event = "target:Treatment",
					label = "Tratamento",
					tunnel = "client"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:PUTBED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:PutBed")
AddEventHandler("target:PutBed",function(Number)
	if not Previous then
		local Ped = PlayerPedId()
		Previous = GetEntityCoords(Ped)
		SetEntityCoords(Ped,Beds[Number]["Coords"]["x"],Beds[Number]["Coords"]["y"],Beds[Number]["Coords"]["z"] - 1,false,false,false,false)
		vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)
		SetEntityHeading(Ped,Beds[Number]["Heading"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:UPBED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:UpBed")
AddEventHandler("target:UpBed",function()
	if Previous then
		local Ped = PlayerPedId()
		SetEntityCoords(Ped,Previous["x"],Previous["y"],Previous["z"] - 1,false,false,false,false)
		Previous = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:TREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Treatment")
AddEventHandler("target:Treatment",function(Number)
	if not Previous then
		if vSERVER.CheckIn() then
			local Ped = PlayerPedId()
			Previous = GetEntityCoords(Ped)
			SetEntityCoords(Ped,Beds[Number]["Coords"]["x"],Beds[Number]["Coords"]["y"],Beds[Number]["Coords"]["z"] - 1,false,false,false,false)
			vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)
			SetEntityHeading(Ped,Beds[Number]["Heading"])

			TriggerEvent("inventory:preventWeapon",true)
			LocalPlayer["state"]["Commands"] = true
			LocalPlayer["state"]["Cancel"] = true
			TriggerEvent("paramedic:Reset")

			if GetEntityHealth(Ped) <= 100 then
				exports["survival"]:Revive(101)
			end

			Treatment = true
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:StartTreatment")
AddEventHandler("target:StartTreatment",function()
	if not Treatment then
		LocalPlayer["state"]["Commands"] = true
		LocalPlayer["state"]["Cancel"] = true
		Treatment = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBEDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if Previous and not IsEntityPlayingAnim(Ped,"anim@gangops@morgue@table@","body_search",3) then
			SetEntityCoords(Ped,Previous["x"],Previous["y"],Previous["z"] - 1,false,false,false,false)
			Previous = nil
		end

		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Treatment then
			if GetGameTimer() >= TreatmentTimer then
				local Ped = PlayerPedId()
				local Health = GetEntityHealth(Ped)
				TreatmentTimer = GetGameTimer() + 1000

				if Health < 200 then
					SetEntityHealth(Ped,Health + 1)
				else
					Treatment = false
					LocalPlayer["state"]["Cancel"] = false
					LocalPlayer["state"]["Commands"] = false
					TriggerEvent("Notify","amarelo","Tratamento concluido.",5000)
				end
			end
		end

		Wait(1000)
	end
end)