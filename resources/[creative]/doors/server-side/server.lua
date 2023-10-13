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
Tunnel.bindInterface("doors",Hypex)
vTASKBAR = Tunnel.getInterface("taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Doors"] = {
	-- Policia-1
	[1] = { x = -952.54, y = -2049.71, z = 6.1, hash = -806761221, lock = true, text = true, distance = 5, press = 2, perm = "Policia" },
	[2] = { x = -953.05, y = -2051.72, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "Policia" },
	[3] = { x = -955.99, y = -2049.01, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "Policia" },
	[4] = { x = -959.65, y = -2052.67, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "Policia" },
	[5] = { x = -925.98, y = -2035.20, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Policia", other = 32 },
	[6] = { x = -926.82, y = -2034.42, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Policia", other = 31 },
	[7] = { x = -953.81, y = -2044.32, z = 9.7, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Policia" },
	[8] = { x = -954.02, y = -2058.36, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Policia", other = 35 },
	[9] = { x = -954.78, y = -2057.61, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Policia", other = 34 },
	[10] = { x = -912.94, y = -2033.33, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Policia", other = 37 },
	[11] = { x = -913.69, y = -2032.55, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Policia", other = 36 },
	-- Policia-2
	[12] = { x = 816.78, y = -1321.01, z = 26.22, hash = -1372582968, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[13] = { x = 858.11, y = -1320.39, z = 28.24, hash = -1339729155, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[14] = { x = 830.43, y = -1310.36, z = 28.26, hash = -1246730733, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[15] = { x = 846.98, y = -1309.93, z = 28.24, hash = 272264766, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[16] = { x = 834.65, y = -1296.69, z = 28.24, hash = 1162089799, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	-- Policia-3
	[17] = { x = 1846.049, y = 2604.733, z = 45.579, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "Emergency" },
	[18] = { x = 1819.475, y = 2604.743, z = 45.577, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "Emergency" },
	[19] = { x = 1836.71, y = 2590.32, z = 46.20, hash = 539686410, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[20] = { x = 1769.52, y = 2498.92, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[21] = { x = 1766.34, y = 2497.09, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[22] = { x = 1763.20, y = 2495.26, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[23] = { x = 1756.89, y = 2491.66, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[24] = { x = 1753.75, y = 2489.85, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[25] = { x = 1750.61, y = 2488.02, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[26] = { x = 1757.14, y = 2474.87, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[27] = { x = 1760.26, y = 2476.71, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[28] = { x = 1763.44, y = 2478.50, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[29] = { x = 1766.54, y = 2480.33, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[30] = { x = 1769.73, y = 2482.13, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[31] = { x = 1772.83, y = 2483.97, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[32] = { x = 1776.00, y = 2485.77, z = 46.00, hash = 913760512, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	-- Policia-4
	[33] = { x = 1849.02, y = 3693.30, z = 34.37, hash = -1491332605, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[34] = { x = 1851.94, y = 3694.98, z = 34.37, hash = -1491332605, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[35] = { x = 1856.33, y = 3696.54, z = 34.37, hash = -1491332605, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[36] = { x = 1853.76, y = 3699.85, z = 34.37, hash = -2002725619, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[37] = { x = 1847.24, y = 3688.46, z = 34.37, hash = -2002725619, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	-- Policia-5
	[38] = { x = -444.45, y = 6007.71, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[39] = { x = -442.98, y = 6011.80, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[40] = { x = -445.12, y = 6012.14, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[41] = { x = -448.08, y = 6015.12, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[42] = { x = -445.60, y = 6017.56, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	[43] = { x = -442.63, y = 6014.60, z = 27.75, hash = -594854737, lock = true, text = true, distance = 10, press = 2, perm = "Policia" },
	-- Chiliad
	[49] = { x = 2196.82, y = 5570.79, z = 53.9, hash = 819505495, lock = true, text = true, distance = 10, press = 2, perm = "Chiliad" },
	-- Families
	[50] = { x = -151.55, y = -1622.2, z = 33.65, hash = 1381046002, lock = true, text = true, distance = 10, press = 2, perm = "Families" },
	-- Highways
	[51] = { x = 1431.64, y = 6338.15, z = 23.86, hash = 1471868433, lock = true, text = true, distance = 10, press = 2, perm = "Highways" },
	-- Vagos
	[52] = { x = 325.11, y = -1990.69, z = 24.2, hash = 2118614536, lock = true, text = true, distance = 10, press = 2, perm = "Vagos" },
	[53] = { x = 336.45, y = -1992.27, z = 24.2, hash = 2118614536, lock = true, text = true, distance = 10, press = 2, perm = "Vagos" },
	-- Madrazzo
	[54] = { x = 1390.46, y = 1162.32, z = 114.33, hash = -52575179, lock = true, text = true, distance = 10, press = 2, perm = "Madrazzo", other = 55 },
	[55] = { x = 1390.46, y = 1162.32, z = 114.33, hash = -1032171637, lock = true, text = true, distance = 10, press = 2, perm = "Madrazzo", other = 54 },
	[56] = { x = 1406.95, y = 1128.27, z = 114.33, hash = 262671971, lock = true, text = true, distance = 10, press = 2, perm = "Madrazzo" },
	-- Playboy
	[57] = { x = -1470.84, y = 68.46, z = 53.3, hash = -2125423493, lock = true, text = true, distance = 10, press = 2, perm = "Playboy" },
	-- TheSouth
	[58] = { x = 982.29, y = -125.23, z = 74.05, hash = -930593859, lock = true, text = true, distance = 10, press = 2, perm = "Municao" },
	[59] = { x = 959.98, y = -140.16, z = 74.49, hash = -197537718, lock = true, text = true, distance = 10, press = 2, perm = "Municao" },
	[60] = { x = 981.62, y = -102.6, z = 74.85, hash = 190770132, lock = true, text = true, distance = 10, press = 2, perm = "Municao" },
	-- Vineyard
	[61] = { x = -1864.15, y = 2060.52, z = 141.13, hash = -1141522158, lock = true, text = true, distance = 10, press = 2, perm = "Vineyard", other = 62 },
	[62] = { x = 1390.46, y = 1162.32, z = 114.33, hash = 988364535, lock = true, text = true, distance = 10, press = 2, perm = "Vineyard", other = 61 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSSTATISTICS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.doorsStatistics(doorNumber,doorStatus)
	local Doors = GlobalState["Doors"]

	Doors[doorNumber]["lock"] = doorStatus

	if Doors[doorNumber]["other"] ~= nil then
		local doorSecond = Doors[doorNumber]["other"]
		Doors[doorSecond]["lock"] = doorStatus
	end

	GlobalState["Doors"] = Doors
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.doorsPermission(doorNumber)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if GlobalState["Doors"][doorNumber]["perm"] ~= nil then
			if vRP.HasGroup(Passport,GlobalState["Doors"][doorNumber]["perm"]) then
				return true
			end
		end
	end

	return false
end