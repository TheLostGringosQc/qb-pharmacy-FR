local QBCore = exports['qb-core']:GetCoreObject()
local PharmacyPed = nil
local isNearPed = false
local lastNotification = 0

-- Création du ped avec animation
Citizen.CreateThread(function()
    local pedModel = GetHashKey(Config.PharmacyPed.model)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(10)
    end

    local coords = Config.PharmacyPed.coords
    PharmacyPed = CreatePed(4, pedModel, coords.x, coords.y, coords.z - 1.0, Config.PharmacyPed.heading, false, true)
    SetPedFleeAttributes(PharmacyPed, 0, 0)
    SetPedDiesWhenInjured(PharmacyPed, false)
    SetPedCanPlayAmbientAnims(PharmacyPed, true)
    SetPedCanRagdollFromPlayerImpact(PharmacyPed, false)
    SetEntityInvincible(PharmacyPed, true)
    FreezeEntityPosition(PharmacyPed, true)

    -- Animation
    RequestAnimDict(Config.AnimDict)
    while not HasAnimDictLoaded(Config.AnimDict) do Wait(10) end
    TaskPlayAnim(PharmacyPed, Config.AnimDict, Config.Anim, 8.0, -8.0, -1, 1, 0, false, false, false)

    -- Blip
    if Config.PharmacyPed.blip.enable then
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, Config.PharmacyPed.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.PharmacyPed.blip.scale)
        SetBlipColour(blip, Config.PharmacyPed.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.PharmacyPed.blip.name)
        EndTextCommandSetBlipName(blip)
    end

    -- qb-target
    if Config.UseTarget then
        exports['qb-target']:AddTargetEntity(PharmacyPed, {
            options = {
                {
                    type = "client",
                    event = "pharmacy:openMenu",
                    icon = "fas fa-first-aid",
                    label = "Acheter des fournitures",
                },
            },
            distance = 2.5
        })
    end
end)

-- Dialog si trop proche (CORRIGÉ - évite la boucle infinie)
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        if PharmacyPed then
            local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(PharmacyPed))
            local currentTime = GetGameTimer()
            
            if dist < Config.ProximityDialog then
                if not isNearPed and (currentTime - lastNotification) > 10000 then -- 10 secondes de cooldown
                    QBCore.Functions.Notify("Pharmacien: Bonjour ! Comment puis-je vous aidé ?", "primary", 3000)
                    lastNotification = currentTime
                end
                isNearPed = true
            else
                isNearPed = false
            end
        end
    end
end)

-- Menu d'achat
RegisterNetEvent('pharmacy:openMenu', function()
    -- On demande au serveur si le ped est dispo
    QBCore.Functions.TriggerCallback("pharmacy:isBusy", function(isBusy)
        if isBusy then
            QBCore.Functions.Notify("Pharmacien: Je suis déjà avec un patient, veuillez patienter...", "error")
            return
        end

        -- On dit au serveur qu'on occupe le ped
        TriggerServerEvent("pharmacy:setBusy", true)

        local menuItems = {}
        for _, v in pairs(Config.PharmacyPed.items) do
            table.insert(menuItems, {
                header = v.label,
                txt = "Prix: $"..v.price,
                params = {
                    event = "pharmacy:buyItem",
                    args = {item = v.item, price = v.price, label = v.label}
                }
            })
        end

        -- On ajoute une option pour quitter le menu
        table.insert(menuItems, {
            header = "❌ Fermer",
            txt = "Fermer le menu",
            params = {
                event = "pharmacy:closeMenu"
            }
        })

        exports['qb-menu']:openMenu(menuItems)
    end)
end)

-- Quand on ferme le menu
RegisterNetEvent("pharmacy:closeMenu", function()
    TriggerServerEvent("pharmacy:setBusy", false)
    exports['qb-menu']:closeMenu()
end)

-- Achat (client -> server)
RegisterNetEvent('pharmacy:buyItem', function(data)
    TriggerServerEvent('pharmacy:giveItem', data.item, data.price)
    -- On ferme le menu après achat
    TriggerEvent("pharmacy:closeMenu")
end)