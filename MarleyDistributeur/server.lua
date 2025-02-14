ESX = exports["es_extended"]:getSharedObject()

-- Callback pour vérifier si le joueur a assez d'argent
ESX.RegisterServerCallback('checkPlayerMoney', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= amount then
        cb(true) -- Le joueur a assez d'argent
    else
        cb(false) -- Le joueur n'a pas assez d'argent
    end
end)

-- Événement pour donner l'item au joueur
RegisterServerEvent('giveVendingItem')
AddEventHandler('giveVendingItem', function(item, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Vérifie si l'item existe dans l'inventaire
    if xPlayer then
        xPlayer.addInventoryItem(item, 1) -- Ajoute l'item à l'inventaire du joueur
        xPlayer.removeInventoryItem('cash', price)
    end
end)
