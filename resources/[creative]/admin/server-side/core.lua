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
Hypex = {}
Tunnel.bindInterface("admin", Hypex)
vCLIENT = Tunnel.getInterface("admin")
vKEYBOARD = Tunnel.getInterface("keyboard")
vANIM = Tunnel.getInterface("animacoes")
vSKINSHOP = Tunnel.getInterface("skinshop")


local banimentos = "https://discord.com/api/webhooks/1147176103480393879/JUti8TdH2UN9Q9FWb5mLl_R2G3IQ69umh9CEwwimZdLQUzv4JfePc8gM4qtmn6XOTZ43"
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skinshop", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            TriggerClientEvent("skinshop:Open", source)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("announce", function(source)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            local Keyboard = vKEYBOARD.keyTertiary(source, "Mensagem:", "Cor:", "Tempo (em MS):")
            if Keyboard then
                TriggerClientEvent("Notify", -1, Keyboard[2], Keyboard[1], Keyboard[3])
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("debug", function(source)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            TriggerClientEvent("ToggleDebug", source)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODMAIL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("modmail", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) and parseInt(Message[1]) > 0 then
            local OtherPassport = parseInt(Message[1])
            local ClosestPed = vRP.Source(OtherPassport)
            if ClosestPed then
                local Keyboard = vKEYBOARD.keyTertiary(source, "Mensagem:", "Cor:", "Tempo (em MS):")
                if Keyboard then
                    TriggerClientEvent("Notify", ClosestPed, Keyboard[2], Keyboard[1], Keyboard[3])
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTARTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("restarte", function(source, Message, History)
    if source == 0 then
        GlobalState["Weather"] = "THUNDER"
        TriggerClientEvent("Notify", -1, "amarelo", "Um grande terremoto se aproxima, abriguem-se enquanto há tempo pois o terremoto chegará em" .. History:sub(9) .. " minutos.", 60000)
        print("Terremoto anunciado")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTARTEDCANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("restartecancel", function(source)
    if source == 0 then
        GlobalState["Weather"] = "EXTRASUNNY"
        TriggerClientEvent("Notify", -1, "amarelo", "Nosso sistema meteorológico detectou que o terremoto passou por agora, porém o mesmo pode voltar a qualquer momento", 60000)
        print("Terremoto cancelado")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ugroups", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport and parseInt(Message[1]) > 0 then
        local Messages = ""
        local Groups = vRP.Groups()
        local OtherPassport = Message[1]
        for Permission, _ in pairs(Groups) do
            local Data = vRP.DataGroups(Permission)
            if Data[OtherPassport] then
                Messages = Messages .. Permission .. "<br>"
            end
        end
        
        if Messages ~= "" then
            TriggerClientEvent("Notify", source, "verde", Messages, 10000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearinv", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") and parseInt(Message[1]) > 0 then
            TriggerClientEvent("Notify", source, "verde", "Limpeza concluída.", 5000)
            vRP.ClearInventory(Message[1])
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearchest", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") and Message[1] then
            local Consult = vRP.Query("chests/GetChests", {name = Message[1]})
            if Consult[1] then
                TriggerClientEvent("Notify", source, "verde", "Limpeza concluída.", 5000)
                vRP.SetSrvData("Chest:" .. Message[1], {}, true)
                
                TriggerEvent("Discord", "Admin", "**clearchest**\n\n**Passaporte:** " .. Passport .. "\n**Chest:** " .. Message[2], 3553599)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dima", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") and parseInt(Message[1]) > 0 and parseInt(Message[2]) > 0 then
            local Amount = parseInt(Message[2])
            local OtherPassport = parseInt(Message[1])
            local Identity = vRP.Identity(OtherPassport)
            if Identity then
                TriggerClientEvent("Notify", source, "verde", "Diamantes entregues.", 5000)
                vRP.Query("accounts/AddGems", {license = Identity["license"], gems = Amount})
                TriggerEvent("Discord", "Gemstone", "**Source:** " .. source .. "\n**Passaporte:** " .. Passport .. "\n**Para:** " .. OtherPassport .. "\n**Gemas:** " .. Amount .. "\n**Address:** " .. GetPlayerEndpoint(source), 3092790)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Blips = {}
RegisterCommand("blips", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            local Text = ""
            
            if not Blips[Passport] then
                Blips[Passport] = true
                Text = "Ativado"
            else
                Blips[Passport] = nil
                Text = "Desativado"
            end
            
            vRPC.BlipAdmin(source)
            
            TriggerEvent("Discord", "Admin", "**blips**\n\n**Passaporte:** " .. Passport .. "\n**Situação:** " .. Text, 3553599)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) then
            if Message[1] then
                local OtherPassport = parseInt(Message[1])
                local ClosestPed = vRP.Source(OtherPassport)
                if ClosestPed then
                    vRP.UpgradeThirst(OtherPassport, 100)
                    vRP.UpgradeHunger(OtherPassport, 100)
                    vRP.DowngradeStress(OtherPassport, 100)
                    vRP.Revive(ClosestPed, 200)
                end
            else
                vRP.Revive(source, 200, true)
                vRP.UpgradeThirst(Passport, 100)
                vRP.UpgradeHunger(Passport, 100)
                vRP.DowngradeStress(Passport, 100)
                
                TriggerClientEvent("paramedic:Reset", source)
                
                vRPC.Destroy(source)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GODA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("goda", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) then
            local Range = parseInt(Message[1])
            if Range then
                local Text = ""
                local Players = vRPC.ClosestPeds(source, Range)
                for _, v in pairs(Players) do
                    async(function()
                        local OtherPlayer = vRP.Passport(v)
                        vRP.UpgradeThirst(OtherPlayer, 100)
                        vRP.UpgradeHunger(OtherPlayer, 100)
                        vRP.DowngradeStress(OtherPlayer, 100)
                        vRP.Revive(v, 200)
                        
                        TriggerClientEvent("paramedic:Reset", v)
                        
                        if Text == "" then
                            Text = OtherPlayer
                        else
                            Text = Text .. ", " .. OtherPlayer
                        end
                    end)
                end
                
                TriggerEvent("Discord", "Admin", "**goda**\n\n**Passaporte:** " .. Passport .. "\n**Para:** " .. Text, 3553599)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            if Message[1] and Message[2] and itemBody(Message[1]) ~= nil then
                vRP.GenerateItem(Passport, Message[1], parseInt(Message[2]), true)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item2", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) and Message[3] and itemBody(Message[1]) then
            local OtherPassport = parseInt(Message[3])
            if OtherPassport > 0 then
                local Amount = parseInt(Message[2])
                local Item = itemName(Message[1])
                vRP.GenerateItem(Message[3], Message[1], Amount, true)
                TriggerClientEvent("Notify", source, "verde", "Você enviou <b>" .. Amount .. "x " .. Item .. "</b> para o passaporte <b>" .. OtherPassport .. "</b>.", 5000)
                
                TriggerEvent("Discord", "Admin", "**item2*\n\n**Passaporte:** " .. Passport .. "\n**Para:** " .. OtherPassport .. "\n**Item:** " .. Amount .. "x " .. Item, 3553599)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delete", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport and Message[1] then
        if vRP.HasGroup(Passport, "Admin", 2) then
            local OtherPassport = parseInt(Message[1])
            vRP.Query("characters/removeCharacter", {id = OtherPassport})
            TriggerClientEvent("Notify", source, "verde", "Personagem <b>" .. OtherPassport .. "</b> deletado.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
local Noclip = {}
RegisterCommand("nc", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            local Text = ""
            
            if not Noclip[Passport] then
                Noclip[Passport] = true
                Text = "Ativado"
            else
                Noclip[Passport] = nil
                Text = "Desativado"
            end
            
            vRPC.noClip(source)
            
            TriggerEvent("Discord", "Admin", "**nc**\n\n**Passaporte:** " .. Passport .. "\n**Situação:** " .. Text, 3553599)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) and parseInt(Message[1]) > 0 then
            local OtherSource = vRP.Source(Message[1])
            if OtherSource then
                TriggerClientEvent("Notify", source, "amarelo", "Passaporte <b>" .. Message[1] .. "</b> expulso.", 5000)
                vRP.Kick(OtherSource, "Expulso da cidade.")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        local Days = parseInt(Message[2])
        local OtherPassport = parseInt(Message[1])
        local Identity = vRP.Identity(OtherPassport)
        
        if vRP.HasGroup(Passport, "Admin", 2) and parseInt(Message[1]) > 0 and parseInt(Message[2]) > 0 then
            local steamid = false
            local license = false
            local discord = false
            local xbl = false
            local liveid = false
            local ip = false
            local license2 = false
            
            if vRP.Source(OtherPassport) then
                for k, v in pairs(GetPlayerIdentifiers(vRP.Source(OtherPassport))) do
                    print(v)
                    if string.sub(v, 1, string.len("steam:")) == "steam:" then
                        steamid = v
                    elseif string.sub(v, 1, string.len("license:")) == "license:" then
                        license = v
                    elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                        xbl = v
                    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                        ip = v
                    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                        discord = v
                    elseif string.sub(v, 1, string.len("live:")) == "live:" then
                        liveid = v
                    elseif string.sub(v, 1, string.len("license2:")) == "license2:" then
                        license2 = v
                    end
                end
            else
                local dadosPlayer = vRP.Query("characters/Person", {id = OtherPassport})
                if dadosPlayer[1] then
                    steamid = dadosPlayer[1]["license"]
                else
                    TriggerClientEvent("Notify", source, "vermelho", "O ID informado não existe!", 7000)
                    return false
                end
            end
            
            if Identity then
                vRP.Query("banneds/InsertBanned", {license = steamid, time = Days, fivem = license, fivem2 = license2, discord = discord, xbl = xbl, liveid = liveid, ip = ip})
                TriggerClientEvent("Notify", source, "amarelo", "Passaporte <b>" .. OtherPassport .. "</b> banido por <b>" .. Days .. "</b> dias.", 5000)
                
                local jsonData = json.encode({
                        
                        embeds = {
                            {
                                color = Color,
                                description = "Banido",
                                fields = {
                                    {name = "Servidor", value = "Interlagos RP", inline = false},
                                    {name = "Discord", value = discord, inline = false},
                                    {name = "Steam", value = steamid, inline = false},
                                    {name = "Fivem License", value = license, inline = false}
                                }
                            }
                        }
                })
                
                PerformHttpRequest(banimentos, function(err, text, headers)
                    if err == 204 then
                        print("Print Sim")-- Webhook foi enviado com sucesso
                        print(parseInt(Message[1]))
                    else
                        print("Erro: " .. err)-- Exibir erro e mensagem
                    end
                end, "POST", jsonData, {["Content-Type"] = "application/json"})
                
                local OtherSource = vRP.Source(OtherPassport)
                if OtherSource then
                    vRP.Kick(OtherSource, "Banido.")
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) and parseInt(Message[1]) > 0 then
            local OtherPassport = parseInt(Message[1])
            local Identity = vRP.Identity(OtherPassport)
            if Identity then
                vRP.Query("banneds/RemoveBanned", {license = Identity["license"]})
                TriggerClientEvent("Notify", source, "verde", "Passaporte <b>" .. OtherPassport .. "</b> desbanido.", 5000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) then
            local Keyboard = vKEYBOARD.keySingle(source, "Cordenadas:")
            if Keyboard then
                local Split = splitString(Keyboard[1], ",")
                vRP.Teleport(source, Split[1] or 0, Split[2] or 0, Split[3] or 0)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) then
            local Ped = GetPlayerPed(source)
            local Coords = GetEntityCoords(Ped)
            local heading = GetEntityHeading(Ped)
            
            vKEYBOARD.keyCopy(source, "Cordenadas:", mathLength(Coords["x"]) .. "," .. mathLength(Coords["y"]) .. "," .. mathLength(Coords["z"]) .. "," .. mathLength(heading))
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group", function(source, Message)
    local Passport = vRP.Passport(source)
    print(Passport)
    if Passport then
        --if vRP.HasGroup(Passport,"Admin") and parseInt(Message[1]) > 0 and Message[2] then
        TriggerClientEvent("Notify", source, "verde", "Adicionado <b>" .. Message[2] .. "</b> ao passaporte <b>" .. Message[1] .. "</b>.", 5000)
        vRP.SetPermission(Message[1], Message[2], Message[3])
    --end
    end
end)

RegisterCommand("setpica", function(source, Message)
    if source == 0 then
        vRP.SetPermission(Message[1], "Admin", 1)
        print('PASSAPORTE ' .. Message[1] .. " RECEBEU PICA.")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") and parseInt(Message[1]) > 0 and Message[2] then
            TriggerClientEvent("Notify", source, "verde", "Removido <b>" .. Message[2] .. "</b> ao passaporte <b>" .. Message[1] .. "</b>.", 5000)
            vRP.RemovePermission(Message[1], Message[2])
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) and parseInt(Message[1]) > 0 then
            local ClosestPed = vRP.Source(Message[1])
            if ClosestPed then
                local Ped = GetPlayerPed(source)
                local Coords = GetEntityCoords(Ped)
                
                vRP.Teleport(ClosestPed, Coords["x"], Coords["y"], Coords["z"])
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) and parseInt(Message[1]) > 0 then
            local ClosestPed = vRP.Source(Message[1])
            if ClosestPed then
                local Ped = GetPlayerPed(ClosestPed)
                local Coords = GetEntityCoords(Ped)
                vRP.Teleport(source, Coords["x"], Coords["y"], Coords["z"])
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) then
            vCLIENT.teleportWay(source)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo", function(source)
    local Passport = vRP.Passport(source)
    if Passport and vRP.GetHealth(source) <= 100 then
        vCLIENT.teleportLimbo(source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            local vehicle = vRPC.VehicleHash(source)
            if vehicle then
                vKEYBOARD.keyCopy(source, "Hash do veículo:", Vehicle)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            TriggerClientEvent("admin:vehicleTuning", source)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            local Vehicle, Network, Plate = vRPC.VehicleList(source, 10)
            if Vehicle then
                TriggerClientEvent("inventory:repairAdmin", source, Network, Plate)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparea", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            local Ped = GetPlayerPed(source)
            local Coords = GetEntityCoords(Ped)
            TriggerClientEvent("syncarea", source, Coords["x"], Coords["y"], Coords["z"], 100)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players", function(source)
    if source ~= 0 then
        local Passport = vRP.Passport(source)
        if not vRP.HasGroup(Passport, "Admin", 2) then
            return
        end
    end
    
    if source ~= 0 then
        TriggerClientEvent("Notify", source, "azul", "<b>Jogadores Conectados:</b> " .. GetNumPlayerIndices() .. ".", 5000)
    else
        print("^2Jogadores Conectados:^7 " .. GetNumPlayerIndices())
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ids", function(source)
    if source ~= 0 then
        local Passport = vRP.Passport(source)
        if not vRP.HasGroup(Passport, "Admin", 2) then
            return
        end
    end
    
    local Text = ""
    local List = vRP.Players()
    
    for OtherPlayer, _ in pairs(List) do
        if Text == "" then
            Text = OtherPlayer
        else
            Text = Text .. ", " .. OtherPlayer
        end
    end
    
    if source ~= 0 then
        TriggerClientEvent("Notify", source, "azul", "<b>IDs Conectados:</b> " .. Text .. ".", 20000)
    else
        print("^2IDs Conectados:^7 " .. Text)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAM
-----------------------------------------------------------------------------------------------------------------------------------------
local FreeHook = ""
RegisterCommand("cam", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasPermission(Passport, "Premium") then
        TriggerClientEvent("freecam:Active", source)
        exports["megazord"]:Discord("**Passaporte:** " .. Passport .. "\n**Coords:** " .. vRP.GetEntityCoords(source), source, FreeHook)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("id", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") and parseInt(Message[1]) > 0 then
            local Identity = vRP.Identity(Message[1])
            if Identity then
                TriggerClientEvent("Notify", source, "azul", "<b>Passaporte:</b> " .. Message[1] .. "<br><b>Nome:</b> " .. Identity["name"] .. " " .. Identity["name2"] .. "<br><b>Telefone:</b> " .. Identity["phone"] .. "<br><b>Banco:</b> $" .. parseFormat(Identity["bank"]), 5000)
                TriggerEvent("Discord", "Admin", "**id**\n\n**Passaporte:** " .. Passport .. "\n**Para:** " .. Message[1], 3553599)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("source", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        local Source = parseInt(Message[1])
        if vRP.HasGroup(Passport, "Admin") and Source > 0 then
            local OtherPassport = vRP.Passport(Source)
            if OtherPassport then
                TriggerClientEvent("Notify", source, "azul", "<b>Source:</b> " .. Source .. "<br><b>Passaporte:</b> " .. OtherPassport, 5000)
                TriggerEvent("Discord", "Admin", "**source**\n\n**Passaporte:** " .. Passport .. "\n**Para:** " .. OtherPassport, 3553599)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:Coords")
AddEventHandler("admin:Coords", function(Coords)
    vRP.Archive("coordenadas.txt", mathLength(Coords["x"]) .. "," .. mathLength(Coords["y"]) .. "," .. mathLength(Coords["z"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.buttonTxt()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            local Ped = GetPlayerPed(source)
            local Coords = GetEntityCoords(Ped)
            local heading = GetEntityHeading(Ped)
            
            vRP.Archive(Passport .. ".txt", mathLength(Coords["x"]) .. "," .. mathLength(Coords["y"]) .. "," .. mathLength(Coords["z"]) .. "," .. mathLength(heading))
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSOLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("console", function(source, Message, History)
    if source == 0 then
        TriggerClientEvent("Notify", -1, "amarelo", History:sub(9), 10000)
        print("Anuncio")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall", function(source)
    if source ~= 0 then
        local Passport = vRP.Passport(source)
        if not vRP.HasGroup(Passport, "Admin") then
            return
        end
    end
    
    local List = vRP.Players()
    for _, Sources in pairs(List) do
        vRP.Kick(Sources, "Desconectado, a cidade reiniciou.")
        Wait(100)
    end
    
    TriggerEvent("SaveServer", false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("save", function(source)
    if source ~= 0 then
        local Passport = vRP.Passport(source)
        if not vRP.HasGroup(Passport, "Admin") then
            return
        end
    end
    
    TriggerEvent("SaveServer", false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemall", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            local List = vRP.Players()
            for OtherPlayer, _ in pairs(List) do
                async(function()
                    vRP.GenerateItem(OtherPlayer, Message[1], Message[2], true)
                end)
            end
            
            TriggerClientEvent("Notify", source, "verde", "Envio concluído.", 10000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("bucket", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) and Message[1] then
            local Route = parseInt(Message[1])
            if Message[2] then
                local OtherPassport = parseInt(Message[2])
                local OtherSource = vRP.Source(OtherPassport)
                if OtherSource then
                    if Route > 0 then
                        TriggerEvent("vRP:BucketServer", OtherSource, "Enter", Route)
                    else
                        TriggerEvent("vRP:BucketServer", OtherSource, "Exit")
                    end
                end
            else
                if Route > 0 then
                    TriggerEvent("vRP:BucketServer", source, "Enter", Route)
                else
                    TriggerEvent("vRP:BucketServer", source, "Exit")
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dm", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 2) and Message[1] then
            local OtherSource = vRP.Source(Message[1])
            if OtherSource then
                local Keyboard = vKEYBOARD.keySingle(source, "Mensagem:")
                if Keyboard then
                    TriggerClientEvent("chat:ClientMessage", OtherSource, "Prefeitura", Keyboard[1], "DM")
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("services", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasGroup(Passport, "Admin", 2) then
        local Text = ""
        local Groups = vRP.Groups()
        
        if Message[1] then
            if Groups[Message[1]] then
                local Data = vRP.DataGroups(Message[1])
                
                for Passport, Level in pairsKeys(Data) do
                    if Text == "" then
                        Text = "<b>" .. Passport .. ":</b> " .. Level
                    else
                        Text = Text .. "<br><b>" .. Passport .. ":</b> " .. Level
                    end
                end
            end
        else
            for Permission, _ in pairsKeys(Groups) do
                local _, Total = vRP.NumPermission(Permission)
                
                if Text == "" then
                    Text = "<b>" .. Permission .. ":</b> " .. Total
                else
                    Text = Text .. "<br><b>" .. Permission .. ":</b> " .. Total
                end
            end
        end
        
        if Text ~= "" then
            TriggerClientEvent("Notify", source, "azul", Text, 20000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("generate", function(source, Message)
    if source ~= 0 then
        local Passport = vRP.Passport(source)
        if not vRP.HasGroup(Passport, "Admin") then
            return
        end
    end
    
    local List = {}
    if Message[1] == "item" then
        List = itemList()
    elseif Message[1] == "car" then
        List = VehicleGlobal()
    elseif Message[1] == "anim" then
        if source == 0 then
            local Players = vRP.Players()
            if #Players <= 0 then
                return
            end
            
            for _, OtherSource in pairs(Players) do
                source = OtherSource
                break
            end
        end
        
        List = vANIM.AnimList(source)
    end
    
    if List then
        local Text = "**" .. Message[1] .. "**"
        
        for Index, v in pairsKeys(List) do
            if Message[1] == "car" then
                if v["Mode"] == "rental" then
                    Text = Text .. "\n" .. Index
                end
            else
                Text = Text .. "\n" .. Index
            end
        end
        
        Text = Text .. "\n"
        
        vRP.Archive("generate.txt", Text)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOM
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
    [1] = "hat",
    [2] = "pants",
    [3] = "vest",
    [4] = "bracelet",
    [5] = "backpack",
    [6] = "decals",
    [7] = "mask",
    [8] = "shoes",
    [9] = "tshirt",
    [10] = "torso",
    [11] = "accessory",
    [12] = "watch",
    [13] = "arms",
    [14] = "glass",
    [15] = "ear"
}

RegisterCommand("custom", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            local Custom = vSKINSHOP.Customization(source)
            if Custom then
                local Text = ""
                local Count = 1
                
                repeat
                    if Text == "" then
                        Text = '["' .. List[Count] .. '"] = { item = ' .. Custom[List[Count]]["item"] .. ', texture = ' .. Custom[List[Count]]["texture"] .. ' }'
                    else
                        Text = Text .. ',\n["' .. List[Count] .. '"] = { item = ' .. Custom[List[Count]]["item"] .. ', texture = ' .. Custom[List[Count]]["texture"] .. ' }'
                    end
                    
                    Count = Count + 1
                until Count == #List + 1
                
                Text = Text .. "\n"
                
                vRP.Archive("custom.txt", Text)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACECOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Checkpoint = 0
function Hypex.raceCoords(vehCoords, leftCoords, rightCoords)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        Checkpoint = Checkpoint + 1
        
        vRP.Archive("races.txt", "[" .. Checkpoint .. "] = {")
        
        vRP.Archive("races.txt", "{ " .. mathLength(vehCoords["x"]) .. "," .. mathLength(vehCoords["y"]) .. "," .. mathLength(vehCoords["z"]) .. " },")
        vRP.Archive("races.txt", "{ " .. mathLength(leftCoords["x"]) .. "," .. mathLength(leftCoords["y"]) .. "," .. mathLength(leftCoords["z"]) .. " },")
        vRP.Archive("races.txt", "{ " .. mathLength(rightCoords["x"]) .. "," .. mathLength(rightCoords["y"]) .. "," .. mathLength(rightCoords["z"]) .. " }")
        
        vRP.Archive("races.txt", "},")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = {}
RegisterCommand("spectate", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin") then
            if Spectate[Passport] then
                local Ped = GetPlayerPed(Spectate[Passport])
                if DoesEntityExist(Ped) then
                    SetEntityDistanceCullingRadius(Ped, 0.0)
                end
                
                TriggerClientEvent("admin:resetSpectate", source)
                Spectate[Passport] = nil
            else
                local nsource = vRP.Source(Message[1])
                if nsource then
                    local Ped = GetPlayerPed(nsource)
                    if DoesEntityExist(Ped) then
                        SetEntityDistanceCullingRadius(Ped, 999999999.0)
                        Wait(1000)
                        TriggerClientEvent("admin:initSpectate", source, nsource)
                        Spectate[Passport] = nsource
                    end
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENAME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rename", function(source)
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasGroup(Passport, "Admin", 2) then
        local Keyboard = vKEYBOARD.Tertiary(source, "Passaporte", "Nome", "Sobrenome")
        if Keyboard then
            vRP.UpgradeNames(Keyboard[1], Keyboard[2], Keyboard[3])
            TriggerClientEvent("Notify", source, "verde", "Nome atualizado.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
    if Spectate[Passport] then
        Spectate[Passport] = nil
    end
end)
