--- Main thread
CreateThread(function()

	Wait(500)

	while true do
		local ThreadDelay = 500
		local Ped = PlayerPedId()
		local PedCoords = GetEntityCoords(Ped)

		for k, v in pairs(Config.PolyZones) do
			local Dist = #(PedCoords - v.Center.Coords.xyz)
			if Dist <= v.Center.Dist then
				if not v.Peds then
					v.Peds = {}

					for l, w in pairs(v.Coords) do
						if not v.Peds[l] then
							local Model = v.Models[math.random(1, #v.Models)]
							while not HasModelLoaded(Model) do
								RequestModel(Model)
								Wait(10)
							end

							v.Peds[l] = CreatePed(5, Model, w.x, w.y, w.z - 1.0, w.w, false, false)
							SetPedConfig(v.Peds[l], k)
							SetEntityNoCollisionEntity(v.Peds[l], Ped, false)
							-- FreezeEntityPosition(v.Peds[l], true)
						end
					end
				end

				if v.Poly:isPointInside(PedCoords) and GetEntityHealth(Ped) > 101 and IsEntityVisible(Ped) then
					for _, w in pairs(v.Peds) do
						if HasEntityClearLosToEntity(w, Ped, 17) then
							-- More accuracy
							TaskShootAtEntity(w, Ped, 1000, 0x647C9B7E)

							-- Less accuracy
							-- local PedHeadCoords = GetPedBoneCoords(Ped, 31086, 0.0, 0.0, 0.0)
							-- TaskShootAtCoord(w, PedHeadCoords.x, PedHeadCoords.y, PedHeadCoords.z, 1000, 0x647C9B7E)
						end
					end
				end
			elseif v.Peds then
				for _, ShooterPed in pairs(v.Peds) do
					if DoesEntityExist(ShooterPed) then
						DeleteEntity(ShooterPed)
					end
				end
				v.Peds = nil
			end
		end

		Wait(ThreadDelay)
	end
end)

--- Set peds combat config
---@param Ped number
---@param Zone string
---@return nil
function SetPedConfig(Ped, Zone)
	while not DoesEntityExist(Ped) do
		Wait(10)
	end

	SetEntityAsMissionEntity(Ped, true, true)

	local Weapon = Config.PolyZones[Zone].Weapons[math.random(1, #Config.PolyZones[Zone].Weapons)]
	GiveWeaponToPed(Ped, Weapon, 999, false, true)
	SetPedInfiniteAmmo(Ped, true, Weapon)
	SetCurrentPedWeapon(Ped, Weapon, true)

	SetPedAccuracy(Ped, 65)
	SetPedDropsWeaponsWhenDead(Ped, false)
	SetPedCombatAbility(Ped, 2)
	TaskSetBlockingOfNonTemporaryEvents(Ped, true)
	SetEntityInvincible(Ped, true)
	SetPedCombatAttributes(Ped, 292, true)
	SetPedCombatAttributes(Ped, 46, true)
	SetCanAttackFriendly(Ped, false, false)
end