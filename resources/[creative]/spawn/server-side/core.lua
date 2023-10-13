
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("spawn",Creative)

local first = {}
local Global = {}
local horas = {}
local minutos = {}

vRP.Prepare("Hypex/setHour","UPDATE characters SET minutos = @minutos, horas = @horas WHERE id = @id")

function Creative.updateTime()
  local source = source
  local user_id = vRP.Passport(source)
  if user_id then
    if minutos[user_id] == 59 then
      minutos[user_id] = 0
      horas[user_id] = horas[user_id] + 1
    elseif minutos[user_id] then
      minutos[user_id] = minutos[user_id] + 1
    elseif minutos[user_id] >= 60 then
      minutos[user_id] = 0
      horas[user_id] = horas[user_id] + 1
    else
      minutos[user_id] = 0
    end
    vRP.Query("Hypex/setHour", { minutos = minutos[user_id], horas = horas[user_id], id = user_id})
  end
end

function Creative.Characters()
  local source = source
  local license = vRP.Identities(source)
  local account = vRP.Account(license)
  local query = vRP.Query("characters/Characters", { license = license })
  if query and query[1] then
    local values = {}
    for k, v in pairs(query) do
      if horas[v.id] == nil and minutos[v.id] == nil then
        horas[v.id] = v.horas
        minutos[v.id] = v.minutos
      end
      values[#values + 1] = { id = v.id, Skin = vRP.UserData(v.id, "Datatable").Skin, horas = v.horas, minutos = v.minutos, name = v.name.." "..v.name2, sexo = v.sex, Blood = Sanguine(v.blood), Clothes = vRP.UserData(v.id, "Clothings"), Barber = vRP.UserData(v.id, "Barbershop"), Tattoos = vRP.UserData(v.id, "Tatuagens"), Banco = v.bank }
    end
    local character = {}
    for i = 1, 3 do
      if values[i] then
        character[i] = true
      elseif account.chars >= i then
        character[i] = { slot = true, true }
      else
        character[i] = { slot = false, false }
      end
     -- character[]
    end
    if first[license] == nil then
      first[license] = true
    end
    return values, character, first[license] --{ [1] = { slot = true, false}, [2] = { slot = true, false}, [3] = { slot = true, false}}
  end
  return {}
end

function Creative.CharacterChosen(user_id, coords)
  local source = source
  local license = vRP.Identities(source)
  local query = vRP.Query("characters/UserLicense", { id = user_id, license = license})
  if query and query[1] then
    first[license] = false
  --  TriggerClientEvent("spawn:justSpawn", source, true, false)
    vRP.CharacterChosen(source, user_id)
    return true
  else
    DropPlayer(source, "Conectando em personagem irregular.")
  end
  return false
end

function Creative.getPos()
  local source = source
	local Passport = vRP.Passport(source)
	local Datatable = vRP.Datatable(Passport)
  if Datatable then
    return Datatable.Pos
  end
end


function Creative.NewCharacter(name, name2, sex)
  local source = source
  if not Global[source] then
    Global[source] = true
    local license = vRP.Identities(source)
    local account = vRP.Account(license)
    local query = vRP.Query("characters/countPersons", { license = license })
    local AmountCharactersPremium = parseInt(account["chars"])
    if vRP.LicensePremium(License) then
			AmountCharactersPremium = AmountCharactersPremium + 2
		end

    if parseInt(account.chars + AmountCharactersPremium) <= parseInt(query[1].qtd) then
      TriggerClientEvent("Notify", source, "amarelo", "Limite de personagem atingido.", 3000)
      Global[source] = nil
      return false
    end

    local sexo = "F"
		if sex == "mp_m_freemode_01" then
			sexo = "M"
		end

    vRP.Query("characters/newCharacter", { license = license, name = name, sex = sexo, name2 = name2, phone = vRP.GeneratePhone(), blood = math.random(4) })
    local id = vRP.Query("characters/lastCharacters", { license = license })
    if id[1] then
      vRP.CharacterChosen(source, id[1].id, sex)
    end
    --TriggerClientEvent("spawn:JustSpawn", source, false, true)
    first[license] = false
    Global[source] = nil
    return true
  end
end