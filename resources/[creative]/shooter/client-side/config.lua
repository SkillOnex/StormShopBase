Config = {}

Config.PolyZones = {
    ["Favela01-1"] = {
        Poly = PolyZone:Create({
                vector2(1681.36, -76.29),
                vector2(1692.72, -51.38),
                vector2(1763.06, -80.7),
                vector2(1771.73, -95.44),
                vector2(1749.91, -113.52),
                vector2(1733.5, -120.31),
                vector2(1716.24, -111.82),
                vector2(1703.91, -92.3),
                vector2(1679.35, -81.89),
            }, {
            name="Favela01-1",
            debugGrid=false,
        }),
        Coords = {
            vec4(1685.82, -69.82, 175.24, 104.89),
        },
        Models = {
            "g_m_y_mexgoon_01",
        },
        Weapons = {
            "WEAPON_ASSAULTRIFLE_MK2",
        },
        Center = {
            Coords = vec4(1687.47, -73.17, 175.46, 36.86),
            Dist = 50.0
        },
    },
    ["Favela01-2"] = {
        Poly = PolyZone:Create({
                vector2(2236.65, 163.18),
                vector2(2264.89, 110.95),
                vector2(2240.83, 100.28),
                vector2(2189.74, 140.83),
            }, {
            name="Favela01-2",
            debugGrid=false,
        }),
        Coords = {
            vec4(2228.13, 151.75, 224.27, 257.96),
        },
        Models = {
            "g_m_y_mexgoon_01",
            "g_m_y_mexgoon_02",
            "g_m_y_mexgoon_03",
        },
        Weapons = {
            "WEAPON_ASSAULTRIFLE_MK2",
        },
        Center = {
            Coords = vec4(2232.41, 150.31, 223.61, 252.29),
            Dist = 50.0
        }
    },
}