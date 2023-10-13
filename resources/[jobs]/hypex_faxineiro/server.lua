local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

SERVER_TUNNEL = {}
Tunnel.bindInterface(GetCurrentResourceName(),SERVER_TUNNEL)

local Delay = {}

function SERVER_TUNNEL.CheckHouseDelay(Number)
    local source = source
    if not Delay[Number] or Delay[Number] <= os.time() then
        Delay[Number] = os.time() + (15 * 60) --15 minutos 
        return true
    else
        TriggerClientEvent("Notify", source, "amarelo", "Aguarde "..CompleteTimers(tonumber(Delay[Number]) - tonumber(os.time()))..".", 5000)
        return false
    end
end

function SERVER_TUNNEL.FinishHouseService(WorkingAtHome, ServicesDone)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Completed = true
        for k,v in pairs(ServicesDone) do
            if not v then
                Completed = false
                break
            end
        end
        if Completed then
            vRP.GiveItem(Passport, "dollars", #ServicesDone * math.random(30, 60), true)
        end
    end
end