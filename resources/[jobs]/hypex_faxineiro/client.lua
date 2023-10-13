local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

CLIENT_TUNNEL = {}
Tunnel.bindInterface(GetCurrentResourceName(), CLIENT_TUNNEL)
SERVER_TUNNEL = Tunnel.getInterface(GetCurrentResourceName())

---@type boolean
local Working = false

---@type boolean | number
local WorkingAtHome = false

---@type table
local HomesBlips = {}

---@type table
local ServicesBlips = {}

---@type table
local ServicesDone = {}

Citizen.CreateThread(function()
    while true do
        local ThreadDelay = 999
        local Ped = PlayerPedId()
        local PedCoords = GetEntityCoords(Ped)

        if not Working then
            local Dist = #(PedCoords - vec3(Config.ServiceStart[1], Config.ServiceStart[2], Config.ServiceStart[3]))
            if Dist < 5 then
                ThreadDelay = 1

                if Dist <= 1.5 then
                    DrawText3D(Config.ServiceStart[1], Config.ServiceStart[2], Config.ServiceStart[3], "~g~[H]   ~w~INICIAR")
                    if IsControlJustPressed(1,304) and not IsPedInAnyVehicle(Ped) then
                        StartWorking()
                    end
                end
            end
        end
        Wait(ThreadDelay)
    end
end)

--- Starts working
---@return nil
function StartWorking()
    TriggerServerEvent("player:jobClothes", "Faxineiro", true)
    ManageBlips("Homes", true)
    Working = true
    WorkingThread()
    TriggerEvent("Notify", "verde", "Você iniciou o serviço de <b>limpeza de residência</b>.", 5000)
end

--- Finishes working
---@return nil
function FinishWorking()
    Working = false
    FinishService()
    ManageBlips("Homes", false)
    TriggerEvent("Notify", "azul", "Você finalizou o serviço de <b>limpeza de residência</b>.", 5000)
end

--- Working thread
---@return nil
function WorkingThread()
    CreateThread(function()
        while Working do
            local Ped = PlayerPedId()
            local PedCoords = GetEntityCoords(Ped)

            -- if IsControlJustPressed(0,168) then
            --     FinishWorking()
            --     return
            -- end

            local Dist = #(PedCoords - vec3(Config.ServiceStart[1], Config.ServiceStart[2], Config.ServiceStart[3]))
            if Dist < 5 then
                ThreadDelay = 1

                if Dist <= 1.5 then
                    DrawText3D(Config.ServiceStart[1], Config.ServiceStart[2], Config.ServiceStart[3], "~g~[H]   ~w~FINALIZAR")
                    if IsControlJustPressed(1,304) and not IsPedInAnyVehicle(Ped) then
                        FinishWorking()
                        return
                    end
                end
            end

            if not WorkingAtHome then

                for k,v in pairs(Config.Homes) do

                    local Dist = #(PedCoords - vec3(v.entrance[1], v.entrance[2], v.entrance[3]))

                    if Dist < 10 then
                        DrawMarker(0, v.entrance[1], v.entrance[2], v.entrance[3] - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.75, 1.75, 0.0, 46, 171, 0, 70, 0, 0, 0, 0)

                        if Dist <= 0.7 then
                            DrawText3D(v.entrance[1], v.entrance[2], v.entrance[3], "~g~[H]   ~w~INICIAR")
                            if IsControlJustPressed(1,304) and not IsPedInAnyVehicle(Ped) then
                                if SERVER_TUNNEL.CheckHouseDelay(k) then
                                    WorkingAtHome = k
                                    TriggerEvent("Notify", "verde", "Você iniciou a limpeza da casa <b>" .. WorkingAtHome .. "</b>.", 5000)
                                    ManageBlips("Services", true)
                                end
                            end
                        end
                    end
                end

            else
                for k , v in pairs(Config.Homes[WorkingAtHome]["services"]) do
                    if not ServicesDone[k] then
                        local Dist = #(PedCoords - vec3(v[1], v[2], v[3]))

                        DrawMarker(0, v[1], v[2], v[3] - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 0.0, 46, 171, 0, 70, 0, 0, 0, 0)
                        DrawText3D(v[1], v[2], v[3], "~g~[E]   ~w~" .. (v[4]):upper())

                        if Dist <= 1.5 then
                            if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(Ped) then
                                ServicesDone[k] = true

                                if v[8] then
                                    vRP.CreateObjects(v[5], v[6], v[7], v[8], v[9])
                                elseif v[6] then
                                    vRP.playAnim(false, {v[5], v[6]}, true)
                                else
                                    vRP.playAnim(false, {task = v[5]}, false)
                                end

                                FreezeEntityPosition(Ped, true)

                                TriggerEvent("Progress", "Limpando" ,(Config.AnimDuration * 1000))
                                Wait(Config.AnimDuration * 1000)

                                FreezeEntityPosition(Ped, false)
                                vRP.Destroy()

                                if DoesBlipExist(ServicesBlips[k]) then
                                    RemoveBlip(ServicesBlips[k])
                                end

                                if GetServicesComplete() >= #Config.Homes[WorkingAtHome]["services"] then
                                    SERVER_TUNNEL._FinishHouseService(WorkingAtHome, ServicesDone)
                                    TriggerEvent("Notify", "verde", "Você finalizou a limpeza da residência <b>" .. WorkingAtHome .. "</b>.", 5000)
                                    FinishService()
                                else
                                    TriggerEvent("Notify", "verde", "Continue trabalhando na residência.", 5000)
                                end
                            end
                        end
                    end
                end
            end

            Wait(1)
        end
    end)
end

--- Check if all services from a certain home are complete
---@return number
function GetServicesComplete()
    local Count = 0
    for _, v in pairs(ServicesDone) do
        if v then
            Count = Count + 1
        end
    end
    return Count
end

--- Finishes the service and resets all variables
---@return nil
function FinishService()
    WorkingAtHome = false
    ManageBlips("Services", false)
    ServicesDone = {}
end

--- Function that manages blips
---@param BlipType string
---@param Create boolean
---@return nil
function ManageBlips(BlipType, Create)
    if Create then
        ManageBlips(BlipType, false)

        local TableToUse = BlipType == "Homes" and Config.Homes or Config.Homes[WorkingAtHome]["services"]
        local BlipTable = BlipType == "Homes" and HomesBlips or ServicesBlips
        local BlipConfig = Config.Blips[BlipType]

        for k, v in pairs(TableToUse) do
            local x, y, z = 0.0, 0.0, 0.0
            local BlipName = BlipType == "Homes" and "Serviço" or "~y~Tarefa:~w~ " .. v[4]

            if BlipType == "Homes" then
                x, y, z = v.entrance[1], v.entrance[2], v.entrance[3]
            elseif BlipType == "Services" then
                x, y, z = v[1], v[2], v[3]
            end

            BlipTable[k] = AddBlipForCoord(x, y, z)
            SetBlipSprite(BlipTable[k], BlipConfig.Sprite)
            SetBlipColour(BlipTable[k], BlipConfig.Color)
            SetBlipScale(BlipTable[k], BlipConfig.Scale)
            SetBlipAsShortRange(BlipTable[k], false)
            SetBlipRoute(BlipTable[k], false)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(BlipName)
            EndTextCommandSetBlipName(BlipTable[k])
        end
    else
        local TableToDelete = BlipType == "Homes" and HomesBlips or ServicesBlips
        for k, v in pairs(TableToDelete) do
            if DoesBlipExist(v) then
                RemoveBlip(v)
            end
        end
    end
end

--- Draws a 3D text
---@param x number
---@param y number
---@param z number
---@param text string
---@return nil
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end