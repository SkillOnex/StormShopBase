-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("calladmin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local CallTypes = {
    ["denounce"] = 1,
    ["Admin"] =  2,
}
Player = GetPlayerServerId(PlayerId())
local Statistics, Ranking, TicketsInfo = {}, {}, {}
local isAdmin = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
local ActiveTicket = false
RegisterNUICallback("sendCall",function(Data,Callback)
    if #Data["text"] > 255 then
        TriggerEvent("Notify","vermelho","A descrição não pode ultrapassar 255 caracteres.",5000,"CHAMADOS")
        cb(false)
        return
    end
    ActiveTicket = vSERVER.CreateTicket(CallTypes[Data["type"]],Data["text"])
    Wait(200)
    Callback(ActiveTicket)
end)

RegisterNUICallback("getCallData",function(Data,Callback)
    Wait(200)
    if not isAdmin then
        SetNuiFocus(false,false)
    end
    TransitionFromBlurred(50)
    Callback({
        time = SecondsToMinutes(parseInt(GlobalState["AnswerTime"])),
        id = ActiveTicket
    })
end)

RegisterNUICallback("cancelCall",function(Data,Callback)
    local Cancelled = vSERVER.CancellTicket(parseInt(Data["id"]))
    if Cancelled then
        TransitionFromBlurred(50)
        if not isAdmin then
            SetNuiFocus(false,false)
        end
        ActiveTicket = false
    end
    Callback(Cancelled)
end)

RegisterNUICallback("callInProgress",function(Data,Callback)
    Callback(vSERVER.AnswerTicket(parseInt(Data["id"])))
end)

RegisterNUICallback("callConcluded",function(Data,Callback)
    Callback(vSERVER.FinishTicket(parseInt(Data["id"])))
end)

RegisterNUICallback("callFeedback",function(Data,Callback)
    TransitionFromBlurred(500)
    if not isAdmin then
        SetNuiFocus(false,false)
    end
    ActiveTicket = false
    Callback(vSERVER.isSolved(Data["id"],Data["isCallResolved"]))
end)

RegisterNUICallback("closeCallModal",function(Data,Callback)
    TransitionFromBlurred(1000)
    if not isAdmin then
        SetNuiFocus(false,false)
    end
end)

RegisterNUICallback("getRanking",function(Data,Callback)

    local Stats = {
        Answered = parseInt(TicketsInfo["Total"] / TicketsInfo["Answered"]).."%",
        Finished = parseInt(TicketsInfo["Total"] / TicketsInfo["Finished"]).."%",
        Cancelled = parseInt(TicketsInfo["Total"] / TicketsInfo["Cancelled"]).."%",
    }

    if TicketsInfo["Cancelled"] == 0 then
        Stats["Cancelled"] = "0%"
    end

    Callback({ranking = Ranking, statistics = Stats})
end)

RegisterNUICallback("close",function(Data,Callback)
    if not ActiveTicket or isAdmin then
        TransitionFromBlurred(1000)
        SetNuiFocus(false,false)
        SendNUIMessage({
            action = 'setVisible',
            data = false
        })
        TriggerServerEvent("calladmin:closeDashBoard")
        isAdmin = false
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
function SecondsToMinutes(seconds)
    local minutes = math.floor(seconds / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

RegisterCommand("opendashboard",function(source,args,rawCommand)
    Player = GetPlayerServerId(PlayerId())
    Statistics, Ranking, TicketsInfo , List = vSERVER.openDashboard()
    if Statistics then
        for i=1,#List do
            if List[i] and List[i]["Status"] ~= 0 and List[i]["Admin"] ~= Player then
                table.remove(List,i)
            end
        end
        TransitionToBlurred(1000)
        SetNuiFocus(true,true)
        SendNUIMessage({
            action = 'openDashboard',
            data = {
                ["callsList"] = List,
                ["statistics"] = Statistics
            }
        })
        isAdmin = true
    end 
    Wait(1)
    for i=1,#List do
        if List[i] and List[i]["Status"] ~= 0 and List[i]["Admin"] ~= Player then
            table.remove(List,i)
        end
    end
    SendNUIMessage({
        action = 'getRanking',
        data = {
            ["callsList"] = List,
            ["statistics"] = WeekStats
        }
    })
end)

RegisterKeyMapping("opendashboard","Abrir o painel de chamados","keyboard","F1")

RegisterCommand("call",function(source,args,rawCommand)
    openTicket()
end)

RegisterCommand("chamaradm",function(source,args,rawCommand)
    openTicket()
end)

RegisterCommand("chamar",function(source,args,rawCommand)
    openTicket()
end)

RegisterCommand("help",function(source,args,rawCommand)
    openTicket()
end)

RegisterCommand("ajuda",function(source,args,rawCommand)
    openTicket()
end)

RegisterCommand("calladm",function(source,args,rawCommand)
    openTicket()
end)

RegisterCommand("calladmin",function(source,args,rawCommand)
    openTicket()
end)

RegisterCommand("report",function(source,args,rawCommand)
    openTicket()
end)

RegisterCommand("denunciar",function(source,args,rawCommand)
    openTicket()
end)

function openTicket()
    if not ActiveTicket then
        if not isAdmin then
            SetNuiFocus(true,true)
        end
        TransitionToBlurred(1000)
        SendNUIMessage({
            action = 'getHelpItems',
            data = {
                ["items"] = FAQConfig,
            }
        })
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("calladmin:AnswerTicket")
AddEventHandler("calladmin:AnswerTicket",function(Data)
    SendNUIMessage({
        action = 'callAccepted',
        data = Data
    })
    ActiveTicket = false
end)

RegisterNetEvent("calladmin:FinishTicket")
AddEventHandler("calladmin:FinishTicket",function()
    SendNUIMessage({
        action = 'openCallModal',
        data = true
    })
    ActiveTicket = 2
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATEBAG HANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("cancelCall","Cancelar Chamado","keyboard","F7")
RegisterKeyMapping("chamaradm","Abrir Chamado","keyboard","F5")
RegisterCommand("cancelCall",function(source,args,rawCommand)
    if ActiveTicket then
        if ActiveTicket == 2 then
            TransitionFromBlurred(1000)
            if not isAdmin then
                SetNuiFocus(true,false)
            end
            SendNUIMessage({
                action = 'openFinishModal',
                data = true
            })
        else
            TransitionFromBlurred(1000)
            SetNuiFocus(true,false)
            SendNUIMessage({
                action = 'openCallModal',
                data = false
            })
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATEBAG HANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('calladmin:UpdateList')
AddEventHandler('calladmin:UpdateList',function(List)
    local Player = GetPlayerServerId(PlayerId())

    for i=1,#List do
        if List[i] and List[i]["Status"] ~= 0 and List[i]["Admin"] ~= Player then
            table.remove(List,i)
        end
    end
    Wait(100)
    SendNUIMessage({
        action = 'updateList',
        data = List
    })
end)

RegisterNetEvent('register:Open')
AddEventHandler('register:Open',function()
    SendNUIMessage({ action = "setVisible", data = false })
    SetNuiFocus(false,false)
    TriggerServerEvent("calladmin:closeDashBoard")
end)

RegisterNetEvent('calladmin:adminDrop')
AddEventHandler('calladmin:adminDrop',function()
    SendNUIMessage({ action = "CallRevert", data = true })
    ActiveTicket = true
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)