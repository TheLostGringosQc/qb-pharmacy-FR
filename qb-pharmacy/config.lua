Config = {}

Config.PharmacyPed = {
    model = "s_m_m_doctor_01", -- modèle du ped
    coords = vector4(327.45, -572.98, 43.3, 325.21),
    heading = 325.21,
    job = "ambulance", -- job requis (optionnel, non utilisé actuellement)
    items = {
        {label = "Bandage", item = "bandage", price = 150},
        {label = "Kit de premiers secours", item = "firstaid", price = 500},
        {label = "Morphine", item = "morphine", price = 300},
        {label = "Pilules antidouleur", item = "painkillers", price = 100},
    },
    blip = {
        enable = true,
        sprite = 153, -- Icône pharmacie
        color = 2, -- Vert
        scale = 0.7,
        name = "Pharmacien"
    }
}

Config.UseTarget = true -- Utiliser qb-target (recommandé)
Config.ProximityDialog = 3.0 -- Distance pour le message de proximité
Config.AnimDict = "amb@world_human_clipboard@male@idle_a"
Config.Anim = "idle_a"

-- Nouveaux paramètres
Config.NotificationCooldown = 10000 -- Cooldown entre les notifications de proximité (ms)
Config.Debug = false -- Activer les messages de debug