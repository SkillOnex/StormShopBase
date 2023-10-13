-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local Hypex = {}
Tunnel.bindInterface("calladmin", Hypex)
vCLIENT = Tunnel.getInterface("calladmin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Prepares
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("calladmin/GetRanking", "SELECT * FROM calladminranking ORDER BY Passport")
vRP.Prepare("calladmin/CheckPassport", "SELECT Passport FROM CallAdminRanking WHERE Passport = @Passport")
vRP.Prepare("calladmin/AddToRanking",
    "INSERT INTO CallAdminRanking(Passport, Name,Rating, TotalTicket) VALUES (@Passport, @Name, @Rating, @TotalTicket)")
vRP.Prepare("calladmin/IncrementTicket",
    "UPDATE CallAdminRanking SET TotalTicket = TotalTicket + 1 WHERE Passport = @Passport")
vRP.Prepare("calladmin/ResetAll", "DELETE FROM CallAdminRanking")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------------------------------------------------------------------
local Tickets = {}
local Ranking = {}
local Statistics = {
    ['attendedToday'] = 0,
    ['finalizedCalls'] = 0,
    ['canceledCalls'] = 0,
}
local TicketsInfo = {
    ["Total"]     = 0,
    ["Answered"]  = 0,
    ["Finished"]  = 0,
    ["Cancelled"] = 0
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------------------------------------------------------
function isPassportInRanking(Passport)
    local result = vRP.Query("calladmin/CheckPassport", { Passport = Passport })
    if result[1] then
        return true
    end
    return false
end

function addToRanking(Passport)
    local identity = vRP.Identity(Passport)
    local Name = identity["name"] .. " " .. identity["name2"] .. " (" .. Passport .. ")"
    local Rating = 0
    local TotalTicket = 0
    vRP.Query("calladmin/AddToRanking", {
        Passport = Passport,
        Name = Name,
        Rating = Rating,
        TotalTicket = TotalTicket,
    })
end

function notifyAdministrator(ticketId)
    local Passport = Tickets[ticketId].Passport
    local Coords = GetEntityCoords(GetPlayerPed(vRP.Source(Passport)))
    local Identity = vRP.Identity(Passport)
    local playerName = Identity["name"] .. " " .. Identity["name2"] .. " (" .. Passport .. ")"
    for Passports, Sources in pairs(vRP.Players()) do
        if vRP.HasGroup(Passports, "Admin") then
            async(function()
                vRPC.PlaySound(Sources, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
                TriggerClientEvent("Notify", Sources, "verde", playerName .. "<br> " .. Tickets[ticketId].Description,
                    "Aviso", 60000)
                TriggerClientEvent("NotifyPush", Sources,
                    {
                        code = 20,
                        title = "Ajuda (Administração)",
                        text = Tickets[ticketId].Description,
                        x = Coords["x"],
                        y = Coords["y"],
                        z = Coords["z"],
                        name = playerName,
                        time = "Recebido às " .. os.date("%H:%M"),
                        blipColor = 25
                    })
            end)
        end
    end
end

function Hypex.openDashboard()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            if not isPassportInRanking(Passport) then
                addToRanking(Passport)
            end
            Ranking = vRP.Query("calladmin/GetRanking")
            table.sort(Ranking, function(a, b)
                return a.Passport < b.Passport
            end)
            return Statistics, Ranking, TicketsInfo, Tickets
        end
    end
    return false
end

function Hypex.CreateTicket(type, text)
    local source = source
    local Passport = vRP.Passport(source)
    local identity = vRP.Identity(Passport)
    local Name = identity["name"] .. " " .. identity["name2"] .. " (" .. Passport .. ")"
    local id = #Tickets + 1

    Tickets[id] = {
        ['id'] = id,
        ['Type'] = type,
        ['Description'] = text,
        ['Passport'] = Passport,
        ['Status'] = 0,
        ['Admin'] = 0,
        ['Time'] = os.date("%H:%M:%S", os.time()),
        ['Player'] = Name
    }
    notifyAdministrator(id)
    TicketsInfo.Total = TicketsInfo.Total + 1
    return id
end

function Hypex.CancellTicket(ticketId)
    local source = source
    if Tickets[ticketId] then
        Tickets[ticketId] = nil
        Statistics.canceledCalls = Statistics.canceledCalls + 1
        TicketsInfo.Cancelled = TicketsInfo.Cancelled + 1
        TriggerClientEvent("calladmin:FinishTicket", source)
        return true
    end
    return false
end

function Hypex.AnswerTicket(ticketId)
    local source = source
    local Passport = vRP.Passport(source)
    if Tickets[ticketId] then
        Tickets[ticketId]['Status'] = 1
        Tickets[ticketId]['Admin'] = source
        Tickets[ticketId]['AnswerTime'] = os.time()
        Statistics.attendedToday = Statistics.attendedToday + 1
        TicketsInfo.Answered = TicketsInfo.Answered + 1
        local PlayerSource = vRP.Source(Tickets[ticketId]['Passport'])
        local Coords = GetEntityCoords(GetPlayerPed(PlayerSource))
        TriggerClientEvent("calladmin:AnswerTicket", PlayerSource)
        vRP.Teleport(source, Coords["x"], Coords["y"], Coords["z"])
        return true
    end
    return false
end

function Hypex.FinishTicket(ticketId)
    local source = source
    local Passport = vRP.Passport(source)
    if Tickets[ticketId] then
        Statistics.finalizedCalls = Statistics.finalizedCalls + 1
        TicketsInfo.Finished = TicketsInfo.Finished + 1
        vRP.Query("calladmin/IncrementTicket", { Passport = vRP.Passport(Tickets[ticketId]['Admin']) })
        local nSource = vRP.Source(parseInt(Tickets[ticketId]['Passport']))
        Tickets[ticketId] = nil
        TriggerClientEvent("calladmin:FinishTicket", nSource)
        return true
    end
    return false
end

function Hypex.isSolved(ticketId, isResolved)

end

GlobalState["AnswerTime"] = 0
CreateThread(function()
    while true do
        local totalResponseTime = 0
        local numRespondedTickets = 0
        for k, v in pairs(Tickets) do
            if v['Status'] == 1 and v['AnswerTime'] then
                if v['AnswerTime'] and v['Time'] then
                    totalResponseTime = totalResponseTime + (tonumber(v['AnswerTime']) - tonumber(v['Time']))
                end
                numRespondedTickets = numRespondedTickets + 1
            end
        end
        if numRespondedTickets > 0 then
            local averageResponseTime = totalResponseTime / numRespondedTickets
            GlobalState["AnswerTime"] = averageResponseTime
        end
        Wait(1000 * 60 * 1)
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        local time = os.date('*t')
        if time.wday == 2 and time.hour == 0 then
            vRP.Query("calladmin/ResetAll")
            Wait(3600000)
        end
    end
end)
