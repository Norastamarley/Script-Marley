ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory

local trashInventories = {}
-- Fonction pour générer plusieurs loots aléatoires
function GenerateRandomLoot(stashName)
    local itemsToAdd = {} -- Table pour stocker les items à ajouter

    for _, loot in ipairs(Config.loot) do
        -- Générer un nombre aléatoire entre 1 et 100
        local randomChance = math.random(1, 100)

        -- Vérifier si l'objet doit être ajouté selon la chance
        if randomChance <= loot.chance then
            -- Déterminer une quantité aléatoire entre 1 et le maximum configuré
            local quantity = math.random(1, loot.quantitymax)

            -- Ajouter l'objet à la table des items
            table.insert(itemsToAdd, {item = loot.item, quantity = quantity})

            -- Message de debug (optionnel)
         -- print("Préparé pour ajout : " .. loot.item .. " x" .. quantity)
        end
    end

    -- Ajouter tous les items au stash
    for _, itemData in ipairs(itemsToAdd) do
        local success,response = exports.ox_inventory:AddItem(stashName, itemData.item, itemData.quantity)
      --  print("Objet ajouté : " .. itemData.item .. " x " .. itemData.quantity .. " à " .. stashName)
        if not success then
            -- if no slots are available, the value will be "inventory_full"
            return print(response)
        end
     --   print(json.encode(response, {indent=true}))
    end
end

-- Fonction pour gérer le loot
function loot(playerid, entityId)
  --  print("Fonction 'loot' appelée pour le joueur : " .. tostring(playerid) .. " et l'entité : " .. tostring(entityId))

    -- Vérifiez si le joueur existe
    if GetPlayerName(playerid) then
    --    print("Joueur trouvé : " .. playerid)

        -- Génération d'un nom unique basé sur l'identifiant de l'entité
        local uniqueInventoryName = "trash_" .. tostring(entityId)

        -- Vérifiez si cette poubelle a déjà été ouverte
        if not trashInventories[uniqueInventoryName] then -- Nouvelle poubelle
            -- Enregistrement dans la table
            trashInventories[uniqueInventoryName] = {
                openedBy = playerid,
                timeCreated = os.time()
            }
            -- enregistrement de l'inventaire 
            exports.ox_inventory:RegisterStash(uniqueInventoryName, 'Poubelle', 50,100000, false)

            Citizen.Wait(1000)
            -- Générer plusieurs loots pour ce stash
            GenerateRandomLoot(uniqueInventoryName)
     --       print("Poubelle créée : " .. uniqueInventoryName)
        else -- ancienne poubelle
            -- chargement de l'inventaire

            -- ouverture de l'inventaire
      --      print("Cette poubelle a déjà été ouverte : " .. uniqueInventoryName)
        end
    else
   --     print("Joueur non trouvé : " .. playerid)
    end
end


RegisterServerEvent('MarleyPoubelle:loot')
AddEventHandler('MarleyPoubelle:loot', function(entityNetId)
    local _source = source
    local entityId = NetworkGetEntityFromNetworkId(entityNetId) -- Convertir le NetID en ID d'entité si nécessaire
   -- print("Événement 'MarleyPoubelle:loot' reçu du joueur : " .. tostring(_source) .. " pour l'entité réseau : " .. tostring(entityNetId))
    loot(_source, entityNetId)
end)

---------------------------------- Coroner ------------------------------------------

-- Configuration
local bodyBagModel = `xm_prop_body_bag` -- Modèle de l'objet à placer
local bodyBagItem = 'body_bag' -- Nom de l'item dans l'inventaire (à configurer dans ox_inventory)
local deadNPCsServer = {} -- Liste des PNJ morts

--[[ Fonction pour vérifier si un PNJ est déjà dans la liste
local function isDeadNPCAlreadyExists(entity)
    for _, npc in ipairs(deadNPCsServer) do
        if npc.entity == entity then
            return true
        end
    end
    return false
end]]

-- Supprimer un PNJ de la liste
RegisterNetEvent('removeDeadNPCServer', function(entity)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer and xPlayer.job.name == 'ambulance' then
        for i, npc in ipairs(deadNPCsServer) do
            if npc.entity == entity then
                table.remove(deadNPCsServer, i) -- Supprimer le PNJ de la liste
                TriggerClientEvent('updateDeadNPCList', -1, deadNPCsServer) -- Mise à jour pour tous les EMS
                break
            end
        end
    else
       -- print(('Tentative non autorisée de supprimer un PNJ par ID %s.'):format(src))
    end
end)

--[[ Ajouter un PNJ mort à la liste
RegisterNetEvent('notifyDeadNPC', function(entity, coords, model)
    local src = source -- Identifiant du joueur

    -- Vérification si le PNJ est déjà dans la liste avant de l'ajouter
    if not isDeadNPCAlreadyExists(entity) then
        table.insert(deadNPCsServer, { entity = entity, coords = coords, model = model, time = os.time() })
        TriggerClientEvent('updateDeadNPCList', -1, deadNPCsServer) -- Mise à jour pour tous les EMS
    end
end)

-- Envoi de la liste des PNJ morts aux joueurs ambulanciers
RegisterNetEvent('getDeadNPCList', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    -- Vérification si le joueur a le job "ambulance"
    if xPlayer and xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('sendDeadNPCList', src, deadNPCsServer)
    else
        TriggerClientEvent('chat:addMessage', src, { args = { '^1Accès refusé', 'Vous devez être ambulancier pour accéder à ce menu.' } })
    end
end)]]

-- Remplacer un PNJ par un body bag
RegisterNetEvent('replaceNPCWithBodyBag', function(netId, coords, heading)
    local src = source -- Identifiant du joueur qui a déclenché l'événement

    -- Convertir l'ID réseau en entité serveur
    local entity = NetworkGetEntityFromNetworkId(netId)

    -- Vérifier que l'entité existe toujours
    if DoesEntityExist(entity) and not IsPedAPlayer(entity) then
        -- Créer le body bag à l'emplacement du PNJ
        local bodyBag = CreateObject(bodyBagModel, coords.x, coords.y, coords.z, true, true, true)
        SetEntityHeading(bodyBag, heading)

        -- Optionnel : donner des animations, effets ou sons (exemple : animation de fouille)
        -- TaskPlayAnim(entity, "dead", "corpse_lying_dead", 8.0, 8.0, -1, 49, 0, false, false, false)

        -- Retourner la confirmation au client pour qu'il mette à jour l'interface
        TriggerClientEvent('bodyBagCreated', src, bodyBag)
    end
end)


-- Ajouter un body bag dans l'inventaire
RegisterNetEvent('addBodyBagToInventory', function(coords)
    local src = source -- Identifiant du joueur
    print(src)
    -- Vérifier si l'inventaire peut contenir l'objet

    local success = exports.ox_inventory:AddItem(src, bodyBagItem, 1)
    if success then
       
    else

        -- Optionnel : recréer l'objet à l'emplacement d'origine
        TriggerClientEvent('recreateBodyBag', src, coords)
    end
end)

--[[ Synchronisation des PNJ morts pour les EMS
RegisterNetEvent('syncDeadNPCs', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local nearbyNPCs = {}

    -- Vérifier la proximité des PNJ morts
    if xPlayer and xPlayer.job.name == 'ambulance' then
        local playerCoords = GetEntityCoords(GetPlayerPed(src))
        for _, npc in ipairs(deadNPCsServer) do
            local npcCoords = vector3(npc.coords.x, npc.coords.y, npc.coords.z)
            local distance = #(playerCoords - npcCoords)

            if distance < 500.0 then -- Seuil de proximité (500m)
                table.insert(nearbyNPCs, npc)
            end
        end

        -- Synchroniser seulement les PNJ proches
        TriggerClientEvent('syncDeadNPCsClient', src, nearbyNPCs)
    end
end)


-- Nettoyage des PNJ morts après un certain temps (par exemple 10 minutes)
Citizen.CreateThread(function()
    while true do
        Wait(60000) -- Vérifier toutes les minutes

        for i = #deadNPCsServer, 1, -1 do
            local npc = deadNPCsServer[i]
            if os.time() - npc.time > 600 then -- 600 secondes = 10 minutes
                table.remove(deadNPCsServer, i) -- Suppression après 10 minutes
            end
        end
    end
end)

-- Synchroniser les coordonnées d'un cadavre avec un EMS
RegisterNetEvent('syncDeadNPCCoords', function(npcIndex)
    local src = source
    local npc = deadNPCsServer[npcIndex]

    if npc then
        TriggerClientEvent('sendDeadNPCCoords', src, npc.coords)
    end
end)]]

-- papier modifiable 
local papers = {}  -- Table pour stocker les métadonnées des papiers
local ox_inventory = exports.ox_inventory

-- Événement pour utiliser le papier
exports('usePaper', function(event, item, inventory, slot, data)
    local player = inventory.id  -- ID du joueur
    -- Envoyer un événement au client pour afficher le menu
    TriggerClientEvent('editable_paper:openMenu', player)
end)

-- Événement pour mettre à jour le contenu du papier

RegisterNetEvent('editable_paper:updatePaper', function(slot, content)
    local player = source
    print('Arguments reçus sur le serveur :', json.encode({ slot = slot, content = content }))  -- Afficher les arguments dans les logs

    if not slot or not content then
        print('Erreur : slot ou contenu manquant.')
        return
    end
    ox_inventory:SetMetadata(source, slot, content)
    papers[player] = papers[player] or {}  -- Initialiser la table pour le joueur
    papers[player][slot] = { content = content }  -- Stocker le contenu du papier
    lib.notify(player, { type = 'success', description = 'Contenu du papier mis à jour.' })
end)
RegisterNetEvent('editable_paper:updatePaper', function(slot, content)
    local player = source
    print('Slot reçu sur le serveur :', slot)  -- Afficher le slot dans les logs
    print('Contenu reçu sur le serveur :', content)  -- Afficher le contenu dans les logs
    ox_inventory:SetMetadata(source, slot, content)
    papers[player] = papers[player] or {}  -- Initialiser la table pour le joueur
    papers[player][slot] = { content = content }  -- Stocker le contenu du papier
    lib.notify(player, { type = 'success', description = 'Contenu du papier mis à jour.' })
end)
-- Événement pour demander le contenu du papier
RegisterNetEvent('editable_paper:requestPaperContent', function(slot)
    local player = source

   -- local metadata = papers[player] and papers[player][slot]  -- Récupérer les métadonnées du papier
  --  if metadata and metadata.content then
        TriggerClientEvent('editable_paper:receivePaperContent', player, metadata.content)
  ----  else
    --    lib.notify(player, { type = 'error', description = 'Ce papier est vide.' })
    --end
end)

--[[ Événement pour donner le papier à un autre joueur
RegisterNetEvent('editable_paper:givePaper', function(target, slot)
    local player = source
    local targetPlayer = tonumber(target)

    if papers[player] and papers[player][slot] then
        -- Transférer les métadonnées au joueur cible
        papers[targetPlayer] = papers[targetPlayer] or {}
        papers[targetPlayer][slot] = papers[player][slot]
        papers[player][slot] = nil  -- Supprimer les métadonnées du joueur actuel

        -- Transférer l'item
        exports.ox_inventory:TransferItem(player, targetPlayer, 'papier', 1, nil, slot)
        lib.notify(player, { type = 'success', description = 'Papier donné avec succès.' })
        lib.notify(targetPlayer, { type = 'info', description = 'Vous avez reçu un papier.' })
    else
        lib.notify(player, { type = 'error', description = 'Vous n\'avez pas de papier à donner.' })
    end
end)]]



-------------------- Pointeurse -------------------------
-- Fonction pour envoyer un message Discord avec une couleur spécifique et une URL spéciale
function sendToDiscordWithSpecialURL(source, message, color, url)
    local playerName = GetPlayerName(source)
    local embeds = {
        {
            ["title"] = pds,
            ["type"] = "rich",
            ["color"] = color,
            ["description"] = message,
            ["footer"] = {
                ["text"] = os.date("%d-%m-%y %H:%M:%S")
            }
        }
    }

    if message == nil or message == '' then return false end

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({ username = playerName, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end


-- Écouteur d'événement pour basculer le service
RegisterNetEvent("jobs_creator:toggleDuty")
AddEventHandler("jobs_creator:toggleDuty", function(playerId, jobName, isOnDuty)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local playeriden = xPlayer.getIdentifier()
    local playerName = xPlayer.getName()
    local date = os.date("!%d-%m-%yT%H:%M:%SZ")
    local pds = isOnDuty and 'Prise de service' or 'Fin de service'
    local message = pds .. '\n' ..
                    'Nom du joueur : ' .. playerName

    -- Récupérer l'URL du webhook en fonction du nom du métier
    local webhookUrl = Config.society[jobName]
    if webhookUrl then
        sendToDiscordWithSpecialURL(playerId, message, isOnDuty and 3066993 or 15158332, webhookUrl)
    else
        print("Erreur : Webhook non trouvé pour le métier " .. jobName)
    end
end)