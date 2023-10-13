-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Peds = nil
local Camera = nil
local Characters = {}
local selected = nil
local isFirstLogin = true
local Active = false
local NewPlayer = false
local Default = true
local model =  "mp_m_freemode_01"
cityName = "Hypex"
local SelectionCoord = {
    Player = vector4(560.01,-436.53,-69.66,337.33),
    Peds = vector4(559.06,-438.6,-70.66,331.66)
}
spawnValue = nil


Citizen.CreateThread(function()
    while true do
        if Active then
            vSERVER.updateTime()
        end
        Citizen.Wait(60 * 1000)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Locate = {
}

if cityName == "Hypex" then
    SelectionCoord["Player"] = vector4(560.01,-436.53,-69.66,337.33)
    SelectionCoord["Peds"] = vector4(559.06,-438.6,-70.66,331.66)
    Locate = {
        { ["Coords"] = vec3(-1647.74,-1102.27,13.02), ["name"] = "SPAWNAR NO PIER" },
        { ["Coords"] = vec3(1334.21,4328.63,37.9), ["name"] = "SPAWNAR NO PIER DO NORTE" },
        { ["Coords"] = vec3(-911.23,-2042.28,9.4), ["name"] = "SPAWNAR NA DP SUL" },
        { ["Coords"] = vec3(1855.89,3681.93,34.27), ["name"] = "SPAWNAR NA DP NORTE" },
        { ["Coords"] = vec3(-677.77,308.26,83.09), ["name"] = "SPAWNAR NO HP" }
    }
end
local SpawnCoords = {
    ["Hypex"] = vector3(560.01,-436.53,-69.66),

}

local defaultClothing = json.decode('{"watch":{"texture":0,"item":-1},"torso":{"texture":0,"item":0},"hat":{"texture":0,"item":-1},"accessory":{"texture":0,"item":0},"tshirt":{"texture":0,"item":1},"backpack":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"vest":{"texture":0,"item":0},"bracelet":{"texture":0,"item":-1},"pants":{"texture":0,"item":0},"mask":{"texture":0,"item":0},"ear":{"texture":0,"item":-1},"shoes":{"texture":0,"item":0},"decals":{"texture":0,"item":0}}')
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMS
-----------------------------------------------------------------------------------------------------------------------------------------
local Anims = {
	{ ["Dict"] = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", ["Name"] = "hi_dance_crowd_17_v2_male^2" },
	{ ["Dict"] = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", ["Name"] = "high_center_down" },
	{ ["Dict"] = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", ["Name"] = "med_center_up" }
}
local FirstZone = PolyZone:Create({
    vector2(-1639.77, -1015.15),
    vector2(-1571.21, -1065.91),
    vector2(-1639.77, -1150.00),
    vector2(-1719.32, -1097.73)
},{
    name="FirstZone",
})
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONCLIENTRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
function SendReactMessage(action, data)
	SendNUIMessage({
	  action = action,
	  data = data
	})
end

local function toggleNuiFrame(shouldShow)
	SetNuiFocus(shouldShow, shouldShow)
	SendReactMessage('setVisible', shouldShow)
end



if not SpawnCoords["Hypex"] then
    SpawnCoords = vector4(559.86,-438.96,-69.66,334.49)
else
    SpawnCoords = SpawnCoords["Hypex"]
    Default = false
    LocalPlayer["state"]["DefaultSpawn"] = true
end

function executePlayerLogin()
    DoScreenFadeOut(0)
    TriggerEvent("timeSet","Day")
    local Count = 0
    ::WaitModel::

    while not HasModelLoaded(model) do
        Count = Count + 1
        if Count == 1000 then
            if GetIsLoadingScreenActive() then
                TriggerEvent("CloseLoadingScreen")
                Wait(100)
                DoScreenFadeIn(500)
            end
            TriggerEvent("Notify","vermelho","Econtramos problemas ao tentar carregar seu personagem aguarde mais <b>15</> Segundos.",15000,"SPAWN")
            break
        end
        Wait(100)
    end

    exports['pma-voice']:overrideProximityCheck(function(player)
        return false
    end)

    if not HasModelLoaded(model)  then
        goto WaitModel
    end

    SetPlayerModel(PlayerId(),model)
    SetModelAsNoLongerNeeded(model)
    local Ped = PlayerPedId()
    SetEntityCoordsNoOffset(Ped,-312.68,194.50,144.37, false, false, false, true)
    SetEntityHeading(Ped,0.0)


    FreezeEntityPosition(Ped,true)
    LocalPlayer["state"]["Invincible"] = true
    SetEntityInvincible(Ped,true)
    LocalPlayer["state"]["Invisible"] = true
    SetEntityVisible(Ped,false,false)
    SetPlayerControl(Ped,false,false)
    ClearPedTasksImmediately(Ped)
    Characters,Slots,isFirstLogin = vSERVER.Characters()
    TriggerEvent("CloseLoadingScreen")
    Wait(100)

    while GetIsLoadingScreenActive() do
        TriggerEvent("CloseLoadingScreen")
        Wait(100)
        DoScreenFadeIn(500)
        Wait(1)
    end
	DisplayRadar(false)
    FreezeEntityPosition(Ped,false)
	SetEntityCoords(Ped,SelectionCoord["Player"]["x"],SelectionCoord["Player"]["y"],SelectionCoord["Player"]["z"]-1,false,false,false,false)
    FreezeEntityPosition(Ped,true)
    LocalPlayer["state"]["Invisible"] = true
	SetEntityVisible(Ped,false,false)
	FreezeEntityPosition(Ped,true)
    LocalPlayer["state"]["Invincible"] = true
	SetEntityInvincible(Ped,true)
	SetEntityHealth(Ped,100)
	SetPedArmour(Ped,0)
    while Ped == 0 do
        Ped = PlayerPedId()
        Wait(10)
    end
    exports['pma-voice']:overrideProximityCheck(function(player)
        return false
    end)
	if parseInt(#Characters) > 0 then
        SetEntityCoords(Ped,SelectionCoord["Player"]["x"],SelectionCoord["Player"]["y"],SelectionCoord["Player"]["z"]-1,false,false,false,false)
		PedCreated(Characters[1])
        Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
        SetCamCoord(Camera,SelectionCoord["Player"]["x"],SelectionCoord["Player"]["y"],SelectionCoord["Player"]["z"])
        RenderScriptCams(true,true,1,true,true)
        SetCamRot(Camera,0.0,0.0,150.00,2)
        local Spawns = {}
        for i=1,#Locate do
            Spawns[#Spawns+1] = { title = Locate[i]["name"] }
        end
        if not isFirstLogin then
            Spawns = {}
        end
        Wait(1)
        DoScreenFadeIn(500)
        SetCamActive(Camera,true)
        SendNUIMessage({
            action = "Router",
            data = { path = "/" }
        })
        local Status = { Characters = Characters, Slot = Slots }
        SendNUIMessage({ action = "SetCharacters", data = { status = Status, spawns = Spawns } })
        toggleNuiFrame(true)
        SetNuiFocus(true,true)
        TriggerEvent("timeSet","Night")
    else
        -- if not LocalPlayer["state"]["DefaultSpawn"] then
        --     TriggerServerEvent("vRP:BucketClient",false,true)
        -- end
        Wait(100)
        exports["barbershop"]:Apply({},Ped)
        exports["skinshop"]:Apply(defaultClothing,Peds)
        SetEntityCoords(Ped,SpawnCoords,false,false,false,false)
        SetEntityHeading(Ped, 269.3)
        Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
        SetCamCoord(Camera,SelectionCoord["Player"]["x"],SelectionCoord["Player"]["y"],SelectionCoord["Player"]["z"])
        RenderScriptCams(true,true,1,true,true)
        SetCamRot(Camera,270.0)
        Wait(250)
        DoScreenFadeIn(500)
        SendNUIMessage({
            action = "Router",
            data = { path = "/NewPlayer" }
        })
        Wait(250)
        toggleNuiFrame(true)
        Wait(250)
        SendNUIMessage({
            action = "newPlayer",
            data = true
        })
        NewPlayer = true
        -- if not LocalPlayer["state"]["DefaultSpawn"] then
        --     CreateThread(function()
        --         while NewPlayer do 
        --             local Ped = PlayerPedId()
        --             local Coords = GetEntityCoords(Ped)
        --             if not FirstZone:isPointInside(Coords) then
        --                 TriggerServerEvent("vRP:BucketClient","Exit")
        --                 NewPlayer = false
        --             end
        --             Wait(10)
        --         end
        --     end)
        -- end
	end
end

RegisterNetEvent("onClientResourceStart")
AddEventHandler("onClientResourceStart",function(Resource)
	if (GetCurrentResourceName() ~= Resource) then
		return
    end
    RequestModel(model)
end)

RegisterNUICallback('Init', function(data, Callback)
    exports['pma-voice']:overrideProximityCheck(function(player)
        return false
    end)
    Wait(500)
    executePlayerLogin()
    LocalPlayer["state"]["Loading"] = true
    TriggerServerEvent("Queue:Connect")
    Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('ChoseCharacter', function(data, Callback)
    if Characters[1] and data["Character"] and Characters[parseInt(data["Character"])] then
        selected = parseInt(data["Character"])
        if DoesEntityExist(Peds) then
            DeleteEntity(Peds)
        end

        for k,v in pairs(Characters) do
            if k == selected then
                PedCreated(v)
                break
            end
        end
    end
    Callback("Ok")
end)

RegisterNUICallback('ClickSpawn', function(data, Callback)
    DoScreenFadeOut(0)
    toggleNuiFrame(false)
    if not selected then
        if Characters[1] then
            selected = 1
        else
            return
        end
    end
    local Ped = PlayerPedId()
    spawnValue = data["location"]
    if DoesEntityExist(Peds) then
        DeleteEntity(Peds)
    end

    SetCamRot(Camera,0.0,0.0,0.0,2)

    RenderScriptCams(false,false,0,true,true)
    SetCamActive(Camera,false)
    DestroyCam(Camera,true)
    Camera = nil
    
    vSERVER.CharacterChosen(Characters[parseInt(selected)].id,Coords)

    --SetEntityVisible(Ped,true,false)
  --  LocalPlayer["state"]["Invisible"] = false
    --Active = true
   -- TriggerServerEvent("vRP:justObjects")
   -- Wait(2500)
   -- DoScreenFadeIn(1000)
   -- Wait(500)
   -- TriggerEvent("hud:Active",true)
   -- exports['pma-voice']:resetProximityCheck()
    TriggerEvent("spawn:Finish", true,false)
    Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CreateCharacter",function(Data,Callback)
    local sexo = "mp_f_freemode_01"
    local Ped = PlayerPedId()
    if Data["sexo"] == "M" then
        sexo = "mp_m_freemode_01"
    end
    SendNUIMessage({
        action = "DeleteModal",
        data = { nones = "none" }
    })
    if DoesEntityExist(Peds) then
        DeleteEntity(Peds)
    end
    
    SetCamRot(Camera,0.0,0.0,0.0,2)

    RenderScriptCams(false,false,0,true,true)
    SetCamActive(Camera,false)
    DestroyCam(Camera,true)
    Camera = nil
-- SetEntityHeading(Ped,19.85)

	vSERVER.NewCharacter(Data["nome"],Data["nome2"],sexo)
    -- TriggerEvent("notify:Tutorial")
   
    
     if cityName == "Hypex" then
        Wait(1000)
        TriggerEvent("initial:Open")
    end
    TriggerEvent("spawn:Finish", false,true)
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SWITCHCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ChangeCharacter",function(Data,Callback)
	if DoesEntityExist(Peds) then
		DeleteEntity(Peds)
	end

	for _,v in pairs(Characters) do
		if v["id"] == Data["id"] then
			PedCreated(v)
			break
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN:FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:Finish")
AddEventHandler("spawn:Finish",function(Open, Barbershop)
    local Ped = PlayerPedId()
    if Open then
        toggleNuiFrame(false)
        SetEntityVisible(Ped,true,false)
        LocalPlayer["state"]["Invisible"] = false
        Active = true
        TriggerServerEvent("vRP:justObjects")
        Wait(1500)
        DoScreenFadeOut(6500)
        Wait(500)
        TriggerEvent("hud:Active",true)
        exports['pma-voice']:resetProximityCheck()
        if spawnValue and Locate[spawnValue] and isFirstLogin then
		    SetEntityCoords(Ped,Locate[spawnValue]["Coords"]["x"],Locate[spawnValue]["Coords"]["y"],Locate[spawnValue]["Coords"]["z"])
        else
            local loc = vSERVER.getPos()
            SetEntityCoords(Ped,loc.x,loc.y,loc.z)
        end
        Wait(1000)
        DoScreenFadeIn(3500)
	else
		toggleNuiFrame(false)
        SetEntityVisible(Ped,true,false)
        LocalPlayer["state"]["Invisible"] = false
        Active = true
        TriggerServerEvent("vRP:justObjects")
        TriggerEvent("hud:Active",true)
        exports['pma-voice']:resetProximityCheck()
        Wait(1000)
		end
	-- local Ped = PlayerPedId()

    -- SetEntityVisible(Ped,true,false)
    -- LocalPlayer["state"]["Invisible"] = false
    -- TriggerEvent("hud:Active",true)
    -- toggleNuiFrame(false)

    -- RenderScriptCams(false,false,0,true,true)
    -- SetCamActive(Camera,false)
    -- DestroyCam(Camera,true)
    -- Camera = nil
    -- Active = true
    -- exports['pma-voice']:resetProximityCheck()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDCREATED
-----------------------------------------------------------------------------------------------------------------------------------------
function PedCreated(Table)
    if Table["Skin"] then
        local Hash = GetHashKey(Table["Skin"])
        RequestModel(Hash)
        while not HasModelLoaded(Hash) do
            Wait(1)
        end
        Peds = CreatePed(4,Table["Skin"],SelectionCoord["Peds"]["x"],SelectionCoord["Peds"]["y"],SelectionCoord["Peds"]["z"],SelectionCoord["Peds"]["w"],false,false)
        SetEntityInvincible(Peds,true)
        FreezeEntityPosition(Peds,true)
        SetBlockingOfNonTemporaryEvents(Peds,true)
        SetModelAsNoLongerNeeded(Table["Skin"])

        local Random = math.random(#Anims)
        if LoadAnim(Anims[Random]["Dict"]) then
            TaskPlayAnim(Peds,Anims[Random]["Dict"],Anims[Random]["Name"],8.0,8.0,-1,1,0,0,0,0)
        end

        exports["skinshop"]:Apply(Table["Clothes"],Peds)
        exports["barbershop"]:Apply(Table["Barber"],Peds)

        for Hash,Component in pairs(Table["Tattoos"]) do
            SetPedDecoration(Peds,GetHashKey(Component[1]),GetHashKey(Hash))
        end
    end
end

RegisterNetEvent("spawn:SetNewPlayer")
AddEventHandler("spawn:SetNewPlayer",function()
    local NewPlayer = true
    -- if not LocalPlayer["state"]["DefaultSpawn"] then
    --     CreateThread(function()
    --         while NewPlayer do 
    --             local Ped = PlayerPedId()
    --             local Coords = GetEntityCoords(Ped)
    --             if not FirstZone:isPointInside(Coords) then
    --                 TriggerServerEvent("vRP:BucketClient","Exit")
    --                 NewPlayer = false
    --             end
    --             Wait(10)
    --         end
    --     end)
    -- else
    --     TriggerServerEvent("vRP:BucketClient","Exit")
    -- end
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = "Hypex"
    Callback(string.lower(cityName))
end)