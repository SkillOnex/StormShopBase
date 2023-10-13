-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS -- Emergency 1
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
    -- Groups
		["Emergency"] = {
			["Parent"] = {
				["Policia"] = true,
				["Civil"] = true,
				["Paramedico"] = true
			},
			["Hierarchy"] = { "Chefe" },
			["Service"] = {}
		},
		["Restaurants"] = {
			["Parent"] = {
				["Pearls"] = true
			},
			["Hierarchy"] = { "Chefe" },
			["Service"] = {}
		},
    -- Framework
		["Admin"] = {
			["Parent"] = {
				["Admin"] = true
			},
			["Hierarchy"] = { "Administrador","Moderador","Suporte" },
			["Service"] = {}
		},
		["Premium"] = {
			["Parent"] = {
				["Premium"] = true
			},
			["Hierarchy"] = { "Platina","Ouro","Prata","Bronze" },
			["Salary"] = { 2500,2250,2000,1750 },
			["Service"] = {}
		},
		["Creators"] = {
			["Parent"] = {
				["Creators"] = true
			},
			["Hierarchy"] = { "Platina","Ouro","Prata","Bronze" },
			["Salary"] = { 1500,2250,2000,1750 },
			["Service"] = {}
		},
    -- Public
		["Paramedico"] = {
			["Parent"] = {
				["Paramedico"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Salary"] = { 4500,4250,4000 },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Policia"] = {
			["Parent"] = {
				["Policia"] = true,
				["Civil"] = true
			},
			["Hierarchy"] = { "Coronel","Tenente Coronel","Major","Capitão","Primeiro Tenente","Segundo Tenente","Subtenente","Primeiro Sargento","Segundo Sargento","Terceiro Sargento","Cabo","Soldado" },
			["Salary"] = { 4500,4250,4000,4000,4000,4000,4000,4000,4000,4000,4000,4000 },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Civil"] = {
			["Parent"] = {
				["Civil"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Salary"] = { 4500,4250,4000 },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Harmony"] = {
			["Parent"] = {
				["Harmony"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Salary"] = { 3500,3250,3000 },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Mecanico"] = {
			["Parent"] = {
				["Mecanico"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Salary"] = { 3500,3250,3000 },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Bennys"] = {
			["Parent"] = {
				["Bennys"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
    -- Restaurants
		["Pearls"] = {
			["Parent"] = {
				["Pearls"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
    -- Contraband
		["Chiliad"] = {
			["Parent"] = {
				["Chiliad"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Families"] = {
			["Parent"] = {
				["Families"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Highways"] = {
			["Parent"] = {
				["Highways"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Vagos"] = {
			["Parent"] = {
				["Vagos"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
    -- Favelas
		["Barragem"] = {
			["Parent"] = {
				["Barragem"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Farol"] = {
			["Parent"] = {
				["Farol"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Parque"] = {
			["Parent"] = {
				["Parque"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Sandy"] = {
			["Parent"] = {
				["Sandy"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Petroleo"] = {
			["Parent"] = {
				["Petroleo"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Praia-1"] = {
			["Parent"] = {
				["Praia-1"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Praia-2"] = {
			["Parent"] = {
				["Praia-2"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Zancudo"] = {
			["Parent"] = {
				["Zancudo"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
    -- Mafias
		["Madrazzo"] = {
			["Parent"] = {
				["Madrazzo"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Playboy"] = {
			["Parent"] = {
				["Playboy"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Municao"] = {
			["Parent"] = {
				["Municao"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Vineyard"] = {
			["Parent"] = {
				["Vineyard"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		},
		["Lavagem"] = {
			["Parent"] = {
				["Lavagem"] = true
			},
			["Hierarchy"] = { "Chefe","Gerente","Membro" },
			["Service"] = {},
			["Type"] = "Work"
		}
}