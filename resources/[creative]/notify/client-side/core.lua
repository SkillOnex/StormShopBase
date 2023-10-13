-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
Player = GetPlayerServerId(PlayerId())

local ValidNotify = {
    ["azul"] = true,
    ["vermelho"] = true,
    ["verde"] = true,
    ["amarelo"] = true,
    ["sangramento"] = true,
    ["compras"] = true,
    ["fome"] = true,
    ["sede"] = true,
    ["police"] = true,
    ["paramedic"] = true,
    ["admin"] = true,
    ["dica"] = true,
    ["amor"] = true,
    ["airdrop"] = true,
}

RegisterNetEvent("Notify")
AddEventHandler("Notify",function(Css,Message,Timer,Title)
    if ValidNotify[Css] then
        SendNUIMessage({ Action = "Notify", Css = Css, Message = Message, Timer = Timer or 5000, Title = Title })
    else
        SendNUIMessage({ Action = "Notify", Css = "vermelho", Message = Message, Title = Title, Timer = Timer or 5000 })
    end
end)

RegisterNetEvent("Notify:Text")
AddEventHandler("Notify:Text",function(Text)
    SendNUIMessage({ Action = "Text", Message = Text})
end)

RegisterNetEvent("Announce")
AddEventHandler("Announce",function(Css,Message,Timer,Title)
    if ValidNotify[Css] then
        SendNUIMessage({ Action = "Announce", Css = Css, Message = Message, Timer = Timer or 5000, Title = Title })
    else
        SendNUIMessage({ Action = "Announce", Css = "Admin", Message = Message, Title = Title, Timer = Timer or 5000 })
    end
end)

local infoHelp = false
function openCloseShortCuts()
    TriggerEvent("help:open")
    infoHelp = not infoHelp
    SendNUIMessage({ Action = "Tutorial", Status = infoHelp})
end

RegisterCommand("help2",openCloseShortCuts)
RegisterKeyMapping("help2","Open/Close HELP","keyboard","EQUALS") 

RegisterNetEvent("notify:Tutorial")
AddEventHandler("notify:Tutorial",function()
    openCloseShortCuts()
end)


local HelpNotify = {
    "Trabalho de Pescador, Minerador e Agricultor estão bufados! [Procure no Mapa]",
    "Você pode fazer TestDrive gratuitamente de carros vips diretamente na concessionária da cidade!",
    "Você pode denúnciar um jogador que deslogou em meio a uma ação através do comando /report [Advertência Automática]",
    "Você ganha XP por tempo online, so Aperta J para acessar o seu painel de XP!",
    "Você sabia que hoje mais de 40 colaboradores trabalham full-time no Artico Roleplay?",
    "Você sabia que carros vip além de te dar mais respeito com os amigos correm mais que os demais carros da cidade?",
    "Você sabia que Anti-RP não são bem vindos aqui? E que você pode denúnciar um mau jogador? Com o /report",
    "Você sabia que existe um FAQ de Dúvidas Frequentes na cidade?",
    "Você sabia que pode abrir a loja vip da cidade a qualquer momento através do ESC",
    "Você sabia que pode avaliar um Staff como positivo ou negativo da prefeitura?",
    "Recrutamentos para a polícia são feitos diariamente! [Procure um Responsavel]",
    "Jogadores ganham benefícios por recrutar iniciantes para Polícia, Hospital e Facções!",
    "A Praça é o Ponto Central da Cidade e onde os moradores se socializam!",
    "Você ganha benefícios gratuitamente por estar online através do BattlePass! [Aperte J]",
    "Os produtos mais vendidos na loja vip atualmente são o Vip Ouro e o Nissagtr R34!",
    "Seu personagem morre de fome e sede enquanto você estiver AFK!", 
    "Você sabia que o BattlePass é renovado todo dia 01 de cada mês?",
    "Você sabia que Médico é uma profissão legal que paga muito bem?",
    "Você sabia que pode salvar sua o preset da sua roupa atual e voltar facilmente pra ela depois? [F9/Roupas/Guardar]"
}

local HelpDone = {}

AddStateBagChangeHandler('Active',('player:%s'):format(Player) , function(_, _, Value)
    local Ped = PlayerPedId()
    if Value then
        CreateThread(function()
            Wait(2500)
            while true do
                -- if not LocalPlayer["state"]["Newbie"] then
                --     return
                -- end
                ::Another::
                if #HelpDone == #HelpNotify then
                    HelpDone = {}
                end
                local Random = math.random(1,#HelpNotify)
                if HelpDone[Random] then
                    goto Another
                end
                HelpDone[Random] = true
                TriggerEvent("Notify","dica",HelpNotify[Random],30000,"Dicas")
                Wait(1000*60*5)
            end
        end)
    end 
end)