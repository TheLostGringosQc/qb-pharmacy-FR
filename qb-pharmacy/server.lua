local QBCore = exports['qb-core']:GetCoreObject()

local isBusy = false -- état global du ped

-- Vérifier si occupé
QBCore.Functions.CreateCallback("pharmacy:isBusy", function(source, cb)
    cb(isBusy)
end)

-- Changer l'état du ped
RegisterNetEvent("pharmacy:setBusy", function(state)
    local src = source
    isBusy = state
    
    -- Debug pour vérifier l'état
    print("Pharmacy ped busy state changed to: " .. tostring(state) .. " by player " .. src)
end)

-- Achat d'items
RegisterNetEvent('pharmacy:giveItem', function(item, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then
        print("Error: Player not found for source " .. src)
        return
    end

    -- Vérification de l'argent
    local playerMoney = Player.Functions.GetMoney("cash")
    
    if playerMoney >= price then
        -- Enlever l'argent et donner l'item
        Player.Functions.RemoveMoney("cash", price, "pharmacy-purchase")
        Player.Functions.AddItem(item, 1)
        
        -- Notification de succès
        TriggerClientEvent('QBCore:Notify', src, "Vous avez acheté 1x " .. item .. " pour $" .. price, "success")
        
        -- Log pour debug
        print("Player " .. src .. " bought " .. item .. " for $" .. price)
    else
        -- Pas assez d'argent
        TriggerClientEvent('QBCore:Notify', src, "Vous n'avez pas assez d'argent (Requis: $" .. price .. ", Vous avez: $" .. playerMoney .. ")", "error")
        print("Player " .. src .. " tried to buy " .. item .. " but doesn't have enough money")
    end
    
    -- Libérer le ped après l'achat
    isBusy = false
end)