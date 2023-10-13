local loadedAnimation = false

RegisterKeyMapping("cmd","Colocar mão na porta do veiculo","keyboard","Q")
RegisterKeyMapping("ses","","keyboard","F6")

RegisterCommand('ses', function()
    loadedAnimation = false
end)

RegisterCommand('cmd', function()
    local ped = GetPlayerPed(-1)
        if not loadedAnimation then
            putHandOnWindow()
        end
end)

function putHandOnWindow()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    if GetEntityHealth(ped) > 101 then
        if IsPedInAnyVehicle(ped,false) then
           if vehModels() then
                if GetPedInVehicleSeat(veh,-1) == ped then
                    loadAnimation(1)
                    loadedAnimation = true
                end
                if GetPedInVehicleSeat(veh,1) == ped then 
                    loadAnimation(2)
                    loadedAnimation = true
                end
            end
        end
    end
end

Citizen.CreateThread(function()
	while true do
		local timeDistance = 1000
		local ped = PlayerPedId()
        local pp = PlayerId()
        if IsEntityPlayingAnim(ped,"anim@veh@lowrider@std@ds@arm@base","steer_lean_left_low_lowdoor",3) then
            if IsPlayerFreeAiming(pp) then
                timeDistance = 5
                ClearPedSecondaryTask(ped)
                loadedAnimation = false
            end
        end
		Citizen.Wait(timeDistance)
	end
end)

function loadAnimation(number)
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@veh@lowrider@std@ds@arm@base")
    while not HasAnimDictLoaded("anim@veh@lowrider@std@ds@arm@base") do
        RequestAnimDict("anim@veh@lowrider@std@ds@arm@base")
        Citizen.Wait(10)
    end
    if number == 1 then
        if HasAnimDictLoaded("anim@veh@lowrider@std@ds@arm@base") then
            TaskPlayAnim(ped,"anim@veh@lowrider@std@ds@arm@base","steer_lean_left_low_lowdoor",  5.0,-1,-1,50,0,false,false,false)
        end
    elseif number == 2 then
        if HasAnimDictLoaded("anim@veh@lowrider@std@ds@arm@base") then
            TaskPlayAnim(ped,"anim@veh@lowrider@std@ds@arm@base","steer_lean_left_high_lowdoor",  5.0,-1,-1,50,0,false,false,false)
        end
    end
end

function vehModels()
	local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
	return IsVehicleModel(vehicle,GetHashKey("kuruma")) or IsVehicleModel(vehicle,GetHashKey("sultan")) or IsVehicleModel(vehicle,GetHashKey("primo")) or IsVehicleModel(vehicle,GetHashKey("nissangtr"))
end