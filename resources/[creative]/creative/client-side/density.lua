-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local MarkedPeds = {}
DecorRegister("PlayerPeds",2)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODELVALID
-----------------------------------------------------------------------------------------------------------------------------------------
function ModelValid(Entity)
	local Type = GetPedType(Entity)

	return Type ~= 0 and Type ~= 1 and Type ~= 3 and Type ~= 28 and not IsPedAPlayer(Entity)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYVALID
-----------------------------------------------------------------------------------------------------------------------------------------
function EntityValid(Entity)
	local PlayerPeds = DecorExistOn(Entity,"PlayerPeds")

	return not PlayerPeds and ModelValid(Entity) and not IsEntityAMissionEntity(Entity) and NetworkGetEntityIsNetworked(Entity) and not IsPedDeadOrDying(Entity, 1)  and IsPedStill(Entity) and IsEntityStatic(Entity) and not IsPedInAnyVehicle(Entity) and not IsPedUsingAnyScenario(Entity)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEMISSING
-----------------------------------------------------------------------------------------------------------------------------------------
function DeleteMissing(Entity)
	local Owner = NetworkGetEntityOwner(Entity)

	if Owner == -1 or Owner == PlayerId() then
		DeleteEntity(Entity)
	else
		TriggerServerEvent("DeletePed",NetworkGetNetworkIdFromEntity(Entity))
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMARKED
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local GamePool = GetGamePool("CPed")
		for _,Entity in pairs(GamePool) do
			if not MarkedPeds[Entity] and EntityValid(Entity) then
				MarkedPeds[Entity] = 1
			end
		end

		Wait(3000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Entity,Counter in pairs(MarkedPeds) do
			if Entity and DoesEntityExist(Entity) and EntityValid(Entity) then
				if Counter >= 4 and #(GetEntityCoords(Entity) - Coords) <= 100.0 then
					DeleteMissing(Entity)
				end

				MarkedPeds[Entity] = Counter + 1
			else
				MarkedPeds[Entity] = nil
			end
		end

		Wait(3000)
	end
end)