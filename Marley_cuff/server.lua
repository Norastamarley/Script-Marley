ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('checkPlayerItem', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Vérifie si l'item existe dans l'inventaire
    local item = xPlayer.getInventoryItem(Config.item)

    

    if item then
        if item.count >= 1 then
            --print(item.name .. ' count : ' .. item.count)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end

end)

local cuffStatus = {} -- Stockage des statuts des joueurs

RegisterServerEvent('omega:Servercuff')
AddEventHandler('omega:Servercuff', function(target)
    print('Événement serveur déclenché')
    
    local sourcePlayer = source -- Joueur qui déclenche l'événement
    local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
   
  
    if not target then
        print("Cible invalide")
        return
    end
    print(cuffStatus[target])
    -- Inverse l'état des menottes pour le joueur cible
    cuffStatus[target] = not cuffStatus[target]
    if cuffStatus[target] == true then
        --print('remove item')
        xPlayer.removeInventoryItem(Config.item, 1)

    else 
        xPlayer.addInventoryItem(Config.item, 1)
        --print('add item')
    end
    TriggerClientEvent('receiveCuffedStatus', target, cuffStatus[target])
    --if cuffcuffStatus 
    -- Envoie l'événement au client cible
    TriggerClientEvent('anim:cuff', target)
end)

-- == fouille == --

RegisterNetEvent('getCuffStatus')
AddEventHandler('getCuffStatus', function(targetId)
    local sourcePlayer = source
    local status = cuffStatus[targetId] or false
    -- Renvoie au client qui a demandé la requête
    TriggerClientEvent('receiveCuffedStatus', sourcePlayer, status)
end)