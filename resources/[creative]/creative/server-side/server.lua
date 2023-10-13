-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hypex = {}
Tunnel.bindInterface("creative",Hypex)

function Hypex.checkPerm(group) 
	local source = source
	local Passport = vRP.Passport(source)
	if vRP.hasGroup(Passport, "Admin") or vRP.hasGroup(Passport, group) then
		return true
	end
	return false
end

function Hypex.Passport() 
	local source = source
	return vRP.Passport(source)
end