-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------

-- Deixe com verdadeiro
NotifyConfig = false
-- Aqui voce pode notificar o player apos pegar seu carro inicial
NotifySuccess =
"Nossa equipe da administração está muito feliz em ter você conosco, trabalhamos incansavelmente para desenvolver o melhor ambiente para sua diversão, conte conosco e saiba que o nosso discord está aberto para <b>dúvidas</b>, <b>sugestões</b> e afins.<br><br>Tenha uma ótima estadia e um bom jogo.<br>Divirta-se!"
-- Aqui voce pode notificar o player apos não conseguir pegar o carro
NotifyFailed = "Você já resgatou o seu prêmio inicial!"


--- Maximo de veiculos
MaxVehicles = 5



---- Lista de veiculos  (OBS: A quantidade maxima de veiculos são 4 )

Vehicles = {
    {
        id = 2,
        name = "rr14",     -- Deixe o nome do carro como maiusculo quando salvar na base e poem o nome dele aqui
        subName = "RANGE ROVER",  -- Nome de destaque do carro
        photo = "rr14", -- foto que sera do carro
    },
    {
        id = 3,
        name = "r1",             -- Deixe o nome do carro como maiusculo quando salvar na base e poem o nome dele aqui
        subName = "YAMAHA R1", -- Nome de destaque do carro
        photo = "r1",            -- foto que sera do carro
    },
}
