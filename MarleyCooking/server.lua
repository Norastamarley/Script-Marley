ESX = exports["es_extended"]:getSharedObject()

local DISCORD_WEBHOOK = "https://discord.com/api/webhooks" -- Remplacez par votre URL de webhook Discord peut etre placeé dans le config
-- Envoyer un log Discord
--sendDiscordLog(xPlayer.getName(), xPlayer.getIdentifier(), spray)

-- Fonction pour envoyer un log Discord
function sendDiscordLog(playerName, playerIdentifier, spray)
    local embed = {
        {
            ["color"] = 3447003, -- Couleur de l'embed
            ["title"] = "Spray Log",
            ["description"] = "Un joueur a ajouté un spray.",
            ["fields"] = {
                { ["name"] = "Joueur", ["value"] = playerName, ["inline"] = true },
                { ["name"] = "Identifiant", ["value"] = playerIdentifier, ["inline"] = true },
                { ["name"] = "Texte du Spray", ["value"] = spray.text or "Aucun", ["inline"] = true },
                { ["name"] = "Position", ["value"] = string.format("X: %.2f, Y: %.2f, Z: %.2f", spray.location.x, spray.location.y, spray.location.z), ["inline"] = false }
            },
            ["footer"] = {
                ["text"] = os.date("%d-%m-%y %H:%M:%S")
            }
        }
    }

    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, "POST", json.encode({ username = "Spray Logs", embeds = embed }), { ["Content-Type"] = "application/json" })
end

ESX.RegisterServerCallback('cooking:getIngredientProgress', function(source, cb, ingredient)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventoryItem = xPlayer.getInventoryItem(ingredient.name)

    if inventoryItem then
        local progress = math.min(100, (inventoryItem.count / ingredient.count) * 100)
        cb(progress)
    else
        cb(0) -- Aucun ingrédient trouvé
    end
end)

function hasIngredients(playerId, ingredients)
    for _, ingredient in ipairs(ingredients) do
        -- Recherche la quantité de l'item spécifique
        local itemCount = exports.ox_inventory:Search(playerId, 'count', ingredient.name)

        if not itemCount or itemCount < ingredient.count then
            return false -- Manque un ingrédient
        end
    end

    return true -- Tous les ingrédients sont disponibles
end


function removeIngredients(playerId, ingredients)
    for _, ingredient in ipairs(ingredients) do
        -- Tente de retirer l'item, retourne `false` si la suppression échoue
        local success = exports.ox_inventory:RemoveItem(playerId, ingredient.name, ingredient.count)
        if not success then
            print('Erreur : Impossible de retirer l\'ingrédient ' .. ingredient.name)
            return false -- Arrête la suppression si un problème survient
        end
    end

    return true -- Tous les ingrédients ont été retirés
end


--[[RegisterNetEvent('cooking:startCrafting', function(data)
    local playerId = source
    local recipeName = data.recipe
    local recipe = Config.Recipes[recipeName]
  
    if not recipe then
        TriggerClientEvent('ox_lib:notify', playerId, { type = 'error', description = 'Recette invalide.', position = 'top' })
        return
    end
   
    -- Vérifie les ingrédients
    if hasIngredients(playerId, recipe.ingredients) then
    
        -- Retire les ingrédients
        if removeIngredients(playerId, recipe.ingredients) then
            -- Ajoute l'objet crafté
            local success = exports.ox_inventory:AddItem(playerId, recipe.result.name, recipe.result.count)
            if success then
                TriggerClientEvent('ox_lib:notify', playerId, { type = 'success', description = 'Vous avez cuisiné : ' .. recipe.result.label, position = 'top' })
            else
                TriggerClientEvent('ox_lib:notify', playerId, { type = 'error', description = 'Erreur lors de l\'ajout de l\'objet.', position = 'top' })
            end
        else
            TriggerClientEvent('ox_lib:notify', playerId, { type = 'error', description = 'Erreur lors du retrait des ingrédients.', position = 'top' })
        end
    else
        TriggerClientEvent('ox_lib:notify', playerId, { type = 'error', description = 'Vous n\'avez pas tous les ingrédients.', position = 'top' })
    end
end)]]
ESX = exports["es_extended"]:getSharedObject()

-- Gestion du craft final
RegisterNetEvent('cooking:completeCrafting', function(data)
    local playerId = source
    local recipeName = data.recipe
    local recipe = Config.Recipes[recipeName]

    if not recipe then
        TriggerClientEvent('ox_lib:notify', playerId, { type = 'error', description = 'Recette invalide.', position = 'top' })
        return
    end

    -- Vérifie les ingrédients avec ox_inventory
    local hasAllIngredients = true
    for _, ingredient in ipairs(recipe.ingredients) do
        local count = exports.ox_inventory:Search(playerId, 'count', ingredient.name)
        if count < ingredient.count then
            hasAllIngredients = false
            break
        end
    end

    if hasAllIngredients then
        -- Retirer les ingrédients
        for _, ingredient in ipairs(recipe.ingredients) do
            exports.ox_inventory:RemoveItem(playerId, ingredient.name, ingredient.count)
        end

        -- Ajouter le résultat du craft
        local success = exports.ox_inventory:AddItem(playerId, recipe.result.name, recipe.result.count)
        if success then
            TriggerClientEvent('ox_lib:notify', playerId, { type = 'success', description = 'Vous avez cuisiné : ' .. recipe.result.label, position = 'top' })
        else
            TriggerClientEvent('ox_lib:notify', playerId, { type = 'error', description = 'Erreur lors de l\'ajout de l\'objet.', position = 'top' })
        end
    else
        TriggerClientEvent('ox_lib:notify', playerId, { type = 'error', description = 'Vous n\'avez pas tous les ingrédients.', position = 'top' })
    end
end)

----------------------------------------------
----------------- PROPS ----------------------
----------------------------------------------

RegisterNetEvent('MarleyCooking:addItemToPlayer', function(itemName, count)
    local playerId = source

    -- Vérification des paramètres
    if not itemName or not count then
        print("[MarleyCooking] Erreur : itemName ou count est invalide.")
        return
    end

    -- Ajouter l'item via ox_inventory
    local success = exports.ox_inventory:AddItem(playerId, itemName, count)

    if success then
        print("[MarleyCooking] Item ajouté avec succès :", itemName, count)
        TriggerClientEvent('ox_lib:notify', playerId, {type = 'success', description = 'Vous avez récupéré ' .. count .. ' ' .. itemName})
    else
        print("[MarleyCooking] Échec de l'ajout de l'item :", itemName)
        TriggerClientEvent('ox_lib:notify', playerId, {type = 'error', description = 'Impossible d\'ajouter l\'item.'})
    end
end)


----- glaciere -----

local ox_inventory = exports.ox_inventory

local hookId = exports.ox_inventory:registerHook('swapItems', function(payload)
    print(json.encode(payload, { indent = true })) -- Debug payload

    if payload.action == 'move' or payload.action == 'stack' or payload.action == 'swap' then
        local fromSlot = payload.fromSlot
        local toSlot = payload.toSlot
        local toInv = payload.toInventory
        local toType = payload.toType
        local itemName = payload.fromSlot.name
        local fromInv = payload.fromInventory
        -- Vérifier si le type d'inventaire cible est un conteneur
        if toType == 'container' then
         
            --print(itemName)

            --local inv = exports.ox_inventory:GetInventoryItems(toInv, false)
            local item = exports.ox_inventory:GetSlotWithItem(toInv, itemName, metadata, false)--exports.ox_inventory:GetSlot(toInv, toSlot)--exports.ox_inventory:GetSlotWithItem(toInv, itemName, metadata, strict) --
            --local baseinfo = ox_inventory:GetItem(toInv, itemName, nil, false)
            print(json.encode(item, {indent=true}))
		    

            item.metadata.degrade = 0
        
          
            -- Appliquer les changements
            exports.ox_inventory:SetMetadata(toInv, item.slot, item.metadata)
    
            refreshMetadata(toInv, 0)
        elseif toType == 'player' then
           
           --local inv = exports.ox_inventory:GetInventoryItems(toInv, false)
           local item = exports.ox_inventory:GetSlotWithItem(toInv, itemName, metadata, false)--exports.ox_inventory:GetSlot(toInv, toSlot)--exports.ox_inventory:GetSlotWithItem(toInv, itemName, metadata, strict) --
           --local allItems = exports.ox_inventory:GetInventoryItems(toInv, false)
           --local metadata = { degrade = 0 }
           --print(json.encode(allItems, {indent=true}))
           print(json.encode(item, {indent=true}))
           
           item.metadata.degrade = 380
         
           -- Appliquer les changements
           exports.ox_inventory:SetMetadata(toInv, item.slot, item.metadata)
           refreshMetadata(toInv, 380)
           
        end
        
    end
    refreshMetadata(toInv, 0)
    return true -- Autoriser l'action
end, {
    print = true, -- Activer les logs
    itemFilter = {
        fish = true -- Filtrer uniquement les items de type "fish"
    },
    inventoryFilter = {
        '^[%w]+', -- Inclure tous les inventaires
    }
})

local function refreshMetadata(inventory,metadata)
    local items = exports.ox_inventory:GetInventoryItems(inventory, false) -- Récupérer tous les items
    if items then
        for _, item in pairs(items) do
            if item.metadata then
                -- Modifier les métadonnées (exemple : "degrade" à 0)
                item.metadata.degrade =  metadata

                -- Appliquer la modification
                exports.ox_inventory:SetMetadata(inventory, item.slot, item.metadata)
                print(('Métadonnée rafraîchie : Item [%s], Slot [%s], Nouvelle valeur "degrade" [%s]')
                    :format(item.name, item.slot, item.metadata.degrade))
            end
        end
    else
        print(('Aucun item trouvé pour l\'inventaire [%s]'):format(inventory))  
    end
end


--[[local hookId = exports.ox_inventory:registerHook('swapItems', function(payload)
    print(json.encode(payload, { indent = true })) -- Debug payload

    if payload.action == 'move' or payload.action == 'stack' or payload.action == 'swap' then
        local fromInv = payload.fromInventory
        local toInv = payload.toInventory
        local toType = payload.toType

        -- Fonction pour rafraîchir les métadonnées d'un inventaire
        local function refreshMetadata(inventory)
            local items = exports.ox_inventory:GetInventoryItems(inventory, false) -- Récupérer tous les items
            if items then
                for _, item in pairs(items) do
                    if item.metadata then
                        -- Modifier les métadonnées (exemple : "degrade" à 0)
                        item.metadata.degrade = 0

                        -- Appliquer la modification
                        exports.ox_inventory:SetMetadata(inventory, item.slot, item.metadata)
                        print(('Métadonnée rafraîchie : Item [%s], Slot [%s], Nouvelle valeur "degrade" [%s]')
                            :format(item.name, item.slot, item.metadata.degrade))
                    end
                end
            else
                print(('Aucun item trouvé pour l\'inventaire [%s]'):format(inventory))
            end
        end

        -- Rafraîchir les métadonnées de l'inventaire source et cible
        if fromInv then
            print(('Rafraîchissement des métadonnées pour l\'inventaire source [%s]'):format(fromInv))
            refreshMetadata(fromInv)
        end
        if toInv then
            print(('Rafraîchissement des métadonnées pour l\'inventaire cible [%s]'):format(toInv))
            refreshMetadata(toInv)
        end
    end

    return true -- Autoriser l'action
end, {
    print = true, -- Activer les logs
    itemFilter = {
        fish = true -- Filtrer uniquement les items de type "fish"
    },
    inventoryFilter = {
        '^[%w]+', -- Inclure tous les inventaires
    }
})]]


