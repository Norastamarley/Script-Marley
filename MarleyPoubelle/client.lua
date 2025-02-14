ESX = exports["es_extended"]:getSharedObject()

exports.ox_target:addModel(Config.objects, {
    {
        distance = 2.5,
        name = 'interact',
        label = 'Fouiller la poubelle',
        icon = 'fas fa-hand-paper',
        onSelect = function(entity)
           -- print("Tentative de déclenchement de l'événement côté client")

            -- Vérifiez si l'entité est valide
            if DoesEntityExist(entity.entity) then
                -- Forcez la synchronisation de l'entité
                if not NetworkGetEntityIsNetworked(entity.entity) then
                    NetworkRegisterEntityAsNetworked(entity.entity)
                end

                -- Obtenez le NetID après synchronisation
                local netId = NetworkGetNetworkIdFromEntity(entity.entity)
                if netId then
                    print("NetID obtenu : " .. tostring(netId))
                    TriggerServerEvent('MarleyPoubelle:loot', netId)
                  --  print('ouverture de : '.. "trash_" .. tostring(netId))
                    exports.ox_inventory:openInventory('stash', "trash_" .. tostring(netId))
                else
                  --  print("Impossible d'obtenir un NetID pour l'entité.")
                end
            else
              --  print("Entité invalide.")
            end
        end,
        canInteract = function(entity, distance, coords)
            return true
        end,
    }
})

--[[function playAnim(entity)
  -- Animation de fouille
  local dict = "amb@prop_human_bum_bin@base"
  local anim = "base"

  -- Charger le dictionnaire d'animation
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
      Wait(100)
  end

  -- Position du joueur et de l'entité (poubelle)
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)
  local entityCoords = GetEntityCoords(entity)

  -- Calcul de la direction pour que le joueur fasse face à l'entité
  local heading = GetHeadingFromVector_2d(entityCoords.x - playerCoords.x, entityCoords.y - playerCoords.y)
  SetEntityHeading(playerPed, heading)

end

function stopAnim()
   -- Arrêter l'animation une fois terminée
   ClearPedTasks(playerPed)
end]]


-- test --
-- Fonction pour créer un item dynamique via une commande
RegisterCommand('createitem', function(source, args, rawCommand)
    -- Vérification des arguments requis
    if #args < 5 then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^1Erreur', 'Usage : /createitem [name] [description] [category] [x] [y]' }
        })
        return
    end

    -- Récupérer les arguments
    local name = args[1]
    local description = args[2]
    local category = args[3]
    local x = tonumber(args[4])
    local y = tonumber(args[5])

    -- Validation des arguments numériques
    if not x or not y then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^1Erreur', 'Les dimensions x et y doivent être des nombres.' }
        })
        return
    end

    -- Enregistrement de l'item dynamique
    exports.core_inventory:registerDynamicItem(name, {
        name = name,
        description = description,
        category = category,
        x = x,
        y = y
    }, true)

    TriggerClientEvent('chat:addMessage', source, {
        args = { '^2Succès', ('L\'item %s a été créé avec succès.'):format(name) }
    })
end, false)

----------------------------------- coroner ---------------------------------------------------------------

-- Configuration
local bodyBagModel = `xm_prop_body_bag` -- Modèle de l'objet à placer

local deadNPCs = {} -- Liste locale des PNJ morts

-- Ajouter une interaction globale pour les PNJ via ox_target
exports.ox_target:addGlobalPed({
    name = 'replaceNPC',
    label = 'Remplacer par un body bag',
    icon = 'fas fa-skull-crossbones',
    distance = 2.5, -- Distance d'interaction
    groups = { -- Restriction pour les groupes/métiers
        police = 0, -- Tous les grades du métier "police"
        ambulance = 0 -- Tous les grades du métier "ambulance"
    },
    onSelect = function(data) -- Capturer `data` passé par ox_target
        if lib.progressBar({
            duration = 2000, -- Temps de l'animation
            label = 'Mise en sac',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true, -- Désactiver les interactions avec les véhicules
            },
            anim = {
                dict = 'amb@medic@standing@tendtodead@idle_a', 
                clip = 'idle_a' -- Animation jouée pendant la progression
            },
        }) then 
            -- Transmettre les données au serveur
            TriggerEvent('replaceNPCServerEvent', data) 
        else 
            -- Si l'utilisateur annule
            print('Action annulée')
        end
    end,
    canInteract = function(entity, distance, coords)
        return IsEntityAPed(entity) -- Vérifie que l'entité est un PNJ
            and not IsPedAPlayer(entity) -- Vérifie que ce n'est pas un joueur
            and IsPedDeadOrDying(entity, true) -- Vérifie que le PNJ est mort
    end
})


-- Appel au serveur pour remplacer le PNJ par un body bag et le retirer de la liste
RegisterNetEvent('replaceNPCServerEvent', function(data)
    local entity = data.entity -- Récupère l'entité ciblée
    local pedCoords = GetEntityCoords(entity) -- Position du PNJ
    local pedHeading = GetEntityHeading(entity) -- Orientation du PNJ

    -- Vérification de l'existence de l'entité avant de continuer
    if DoesEntityExist(entity) and not IsPedAPlayer(entity) then
        -- Informer le serveur pour supprimer ce PNJ de la liste
        TriggerServerEvent('removeDeadNPCServer', data.npcIndex)

        -- Envoyer les données au serveur pour créer le body bag
        TriggerServerEvent('replaceNPCWithBodyBag', NetworkGetNetworkIdFromEntity(entity), pedCoords, pedHeading)

        -- Optionnel : Supprimer le PNJ du côté client (effet immédiat)
        DeleteEntity(entity)
    else
        -- Si l'entité n'existe plus ou est un joueur, afficher un message d'erreur
   --     print('Erreur : Le PNJ n\'existe plus ou est un joueur.')
    end
end)
-- Événement pour créer un body bag
RegisterNetEvent('createBodyBag', function(coords, heading)
    -- Charger le modèle côté client
    RequestModel(bodyBagModel)
    while not HasModelLoaded(bodyBagModel) do
        Wait(0)
    end

    -- Créer le body bag à la position donnée
    local bodyBag = CreateObject(bodyBagModel, coords.x, coords.y, coords.z, true, true, false)
    SetEntityHeading(bodyBag, heading) -- Orientation
    SetModelAsNoLongerNeeded(bodyBagModel) -- Libérer le modèle
end)


-- Ajouter une interaction pour le modèle bodyBagModel
exports.ox_target:addModel(bodyBagModel, {
    name = 'pickupBodyBag',
    label = 'Ramasser le body bag',
    icon = 'fas fa-box',
    event = 'pickupBodyBagClient', -- Appel côté client
    distance = 2.0, -- Distance pour interagir
    groups = { -- Restriction pour les groupes/métiers
        police = 0, -- Tous les grades du métier "police"
        ambulance = 0 -- Tous les grades du métier "ambulance"
    },
})


-- Gestion de l'événement client pour ramasser
RegisterNetEvent('pickupBodyBagClient', function(data)
    -- Récupérer les informations sur l'objet ciblé
    local entity = data.entity -- L'entité ciblée
    local coords = GetEntityCoords(entity) -- Position actuelle

    -- Vérifier si l'objet existe
    if DoesEntityExist(entity) then
        -- Supprimer l'objet côté client
        DeleteEntity(entity)

        -- Envoyer un événement au serveur pour ajouter l'objet à l'inventaire
        TriggerServerEvent('addBodyBagToInventory', coords)
    else
       -- print('Impossible de ramasser l’objet, il n’existe pas.')
    end
end)

-- Recréer un body bag si l'inventaire est plein
RegisterNetEvent('recreateBodyBag', function(coords)
    RequestModel(bodyBagModel)
    while not HasModelLoaded(bodyBagModel) do
        Wait(0)
    end

    -- Créer un nouveau body bag à la position d'origine
    local bodyBag = CreateObject(bodyBagModel, coords.x, coords.y, coords.z, true, true, false)
    SetEntityAsMissionEntity(bodyBag, true, false)
    SetModelAsNoLongerNeeded(bodyBagModel)
end)

--[[ Détecter les PNJ tués par un joueur
AddEventHandler('gameEventTriggered', function(eventName, data)
    if eventName == 'CEventNetworkEntityDamage' then
        local victim = data[1] -- Entité victime
        local attacker = data[2] -- Entité attaquante
        local isDead = IsEntityDead(victim) -- Vérifier si la victime est morte

        if isDead and IsPedAPlayer(attacker) and IsEntityAPed(victim) then
            local pedCoords = GetEntityCoords(victim) -- Position du PNJ
            local pedModel = GetEntityModel(victim) -- Modèle du PNJ

            -- Affichage détaillé des coordonnées et du modèle
            print('Coordonnées du PNJ tué:', pedCoords)
            print('Modèle du PNJ:', pedModel)

            -- Vérification des coordonnées avant de les ajouter à la liste
            if pedCoords and pedCoords.x and pedCoords.y and pedCoords.z then
                -- Marquer le PNJ comme entité mission pour éviter la suppression
                SetEntityAsMissionEntity(victim, true, false)

                -- Ajouter aux PNJ morts
                table.insert(deadNPCs, {
                    coords = pedCoords,
                    model = pedModel,
                    time = GetGameTimer() -- Timestamp du décès
                })
                -- Informer le serveur
                TriggerServerEvent('notifyDeadNPC', pedCoords, pedModel)
            else
                print('Erreur : Les coordonnées du PNJ ne sont pas valides.')
            end
        end
    end
end)


-- Maintenir les cadavres
Citizen.CreateThread(function()
    while true do
        Wait(5000) -- Vérifier périodiquement

        for i = #deadNPCs, 1, -1 do
            local npc = deadNPCs[i]
            local elapsedTime = GetGameTimer() - npc.time

            -- Si le PNJ est mort depuis plus de 5 minutes, le retirer
            if elapsedTime > 300000 then
                -- Supprimer l'entité localement
                local entity = GetClosestPed(npc.coords.x, npc.coords.y, npc.coords.z, 1.0, true, false, false, false, -1)
                if entity and DoesEntityExist(entity) then
                    DeleteEntity(entity)
                end
                table.remove(deadNPCs, i)
            end
        end
    end
end)

RegisterNetEvent('syncDeadNPCsClient', function(deadNPCsFromServer)
    for _, npc in pairs(deadNPCsFromServer) do
        RequestModel(npc.model)
        while not HasModelLoaded(npc.model) do
            Wait(0)
        end

        -- Recréer le PNJ mort
        local ped = CreatePed(4, npc.model, npc.coords.x, npc.coords.y, npc.coords.z, 0.0, false, true)
        SetEntityAsMissionEntity(ped, true, false)
        SetPedToRagdoll(ped, 10000, 10000, 0, false, false, false)
        SetModelAsNoLongerNeeded(npc.model)
    end
end)

-- Demander la synchronisation à la connexion
Citizen.CreateThread(function()
    TriggerServerEvent('syncDeadNPCs')
end)

local activeBlips = {} -- Liste des blips actifs pour éviter les doublons

-- Ouvrir le menu avec la liste des cadavres
local function openDeadNPCMenu(deadNPCs)
    local menuOptions = {}

    for i, npc in ipairs(deadNPCs) do
        -- Vérifie si npc.coords est bien une table avec x, y, z
        if type(npc.coords) == "table" and npc.coords.x and npc.coords.y and npc.coords.z then
            table.insert(menuOptions, {
                title = 'Cadavre #' .. i,
                description = ('Position : %.2f, %.2f'):format(npc.coords.x, npc.coords.y),
                icon = 'fas fa-skull-crossbones',
                onSelect = function()
                    -- Synchroniser les coordonnées et créer un blip pour le cadavre
                    TriggerServerEvent('syncDeadNPCCoords', i)
                end
            })
        else
            print('Erreur: Coordonnées manquantes pour le cadavre #' .. i)
        end
    end

    -- Si la liste est vide, afficher un message
    if #deadNPCs == 0 then
        table.insert(menuOptions, {
            title = 'Aucun cadavre',
            description = 'Il n\'y a pas de cadavres disponibles.',
            icon = 'fas fa-ban',
            onSelect = function() end
        })
    end

    -- Afficher le menu
    lib.registerContext({
        id = 'dead_npc_menu',
        title = 'PNJ Morts',
        options = menuOptions
    })
    lib.showContext('dead_npc_menu')
end



-- Commande pour ouvrir le menu (accessible uniquement au job ambulance)
RegisterCommand('openDeadNPCMenu', function()
    TriggerServerEvent('getDeadNPCList')
end)

-- Recevoir la liste des PNJ morts depuis le serveur
RegisterNetEvent('sendDeadNPCList', function(deadNPCs)
    if #deadNPCs > 0 then
        openDeadNPCMenu(deadNPCs)
    else
        lib.notify({
            title = 'Aucun cadavre',
            description = 'Aucun PNJ mort trouvé.',
            type = 'error'
        })
    end
end)

RegisterNetEvent('notifyDeadNPC')
AddEventHandler('notifyDeadNPC', function(coords, model)
    -- Vérifier que les données sont valides
    if coords and coords.x and coords.y and coords.z then
        print('Coordonnées reçues du client:', coords)
        print('Modèle du PNJ:', model)

        -- Traitement des données (par exemple, ajouter le PNJ à la liste ou créer un blip)
        -- Ajouter le PNJ à une liste de PNJ morts sur le serveur ou effectuer une autre action
    else
        print('Erreur : Coordonnées invalides reçues du client')
    end
end)


RegisterNetEvent('sendDeadNPCCoords', function(coords)
    SetNewWaypoint(coords.x, coords.y) -- Ajouter un waypoint sur la carte
    lib.notify({
        title = 'Coordonnées reçues',
        description = ('Position ajoutée au GPS : %.2f, %.2f'):format(coords.x, coords.y),
        type = 'info'
    })
end)

-- Recevoir la liste des PNJ morts et mettre à jour l'interface
RegisterNetEvent('updateDeadNPCList', function(deadNPCs)
    -- Mettre à jour la liste des PNJ morts dans l'interface du menu
    -- Par exemple, si tu utilises un menu contextuel avec ox_lib ou un autre système :
    local menuOptions = {}
    for i, npc in ipairs(deadNPCs) do
        table.insert(menuOptions, {
            label = 'PNJ mort: ' .. npc.model .. ' - ' .. npc.coords.x .. ', ' .. npc.coords.y .. ', ' .. npc.coords.z,
            value = i -- On peut utiliser l'index du PNJ pour actions futures
        })
    end

    -- Mettre à jour l'interface utilisateur
    exports.ox_lib:showContextMenu(menuOptions) -- Adapte selon ton système de menu
end)

-- Événement déclenché lorsque le joueur met un PNJ dans un sac
RegisterNetEvent('removeDeadNPC', function(npcIndex)
    TriggerServerEvent('removeDeadNPCServer', npcIndex) -- Informer le serveur
end)

-- Recevoir la mise à jour de la liste des PNJ morts
RegisterNetEvent('updateDeadNPCList', function(deadNPCs)
    local menuOptions = {}

    -- Créer les options du menu à partir de la liste des PNJ morts
    for _, npc in ipairs(deadNPCs) do
        table.insert(menuOptions, {
            label = 'Cadavre: ' .. npc.model .. ' à ' .. string.format("%.2f, %.2f, %.2f", npc.coords.x, npc.coords.y, npc.coords.z),
            value = npc.entity -- Utilise l'identifiant de l'entité comme valeur
        })
    end

    -- Mettre à jour l'affichage du menu
   exports.ox_lib:showContextMenu(menuOptions)
end)]]

------- hover elico --------

local hoverMode = {}

RegisterCommand("hover", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 and GetVehicleClass(vehicle) == 15 then -- Vérifie si c'est un hélicoptère
        if not IsVehicleEngineOn(vehicle) then
            TriggerEvent("chat:addMessage", { args = { "Erreur", "Le moteur de l'hélicoptère est éteint." }, color = { 255, 0, 0 } })
            return
        end
        
        if hoverMode[vehicle] then
            hoverMode[vehicle] = false

            SetEntityVelocity(vehicle, GetEntityVelocity(vehicle)) -- Réactiver le mouvement
            TriggerEvent("chat:addMessage", { args = { "Info", "Mode stationnaire désactivé." }, color = { 255, 255, 0 } })
        else
            hoverMode[vehicle] = true
            TriggerEvent("chat:addMessage", { args = { "Info", "Mode stationnaire activé." }, color = { 0, 255, 0 } })
            Citizen.CreateThread(function()
                while hoverMode[vehicle] and DoesEntityExist(vehicle) do
                    Citizen.Wait(0)
                    SetHeliBladesFullSpeed(vehicle) -- Mettre les pales à pleine vitesse
                    SetEntityVelocity(vehicle, 0.0, 0.0, 0.0) -- Bloquer la vitesse
                end
            end)
        end
    else
        TriggerEvent("chat:addMessage", { args = { "Erreur", "Vous devez être dans un hélicoptère pour utiliser cette commande." }, color = { 255, 0, 0 } })
    end
end, false)

-- papier modifiable -- 

local ox_inventory = exports.ox_inventory

-- Fonction pour éditer le papier
local function editPaper(slot)
    print('Slot reçu dans editPaper :', slot)  -- Afficher le slot dans les logs
    local input = lib.inputDialog('Éditer le papier', {
        { type = 'textarea', label = 'Contenu', placeholder = 'Écrivez quelque chose...', required = true }
    })

    if input then
        local content = input[1]
        TriggerServerEvent('editable_paper:updatePaper', slot, content)  -- Passer le slot au serveur
    end
end

-- Fonction pour lire le papier
local function readPaper(content)
    print(content)
    lib.alertDialog({
        header = 'Contenu du papier',
        content = content,
        centered = true,
        size = 'xl'
    })
end


-- Événement pour ouvrir le menu du papier
RegisterNetEvent('editable_paper:openMenu', function()
    local options = {
        { 
            title  = 'Écrire sur le papier', 
            icon = 'pencil', 
            onSelect = function(slot)
                print('on seaect : '.. tostring(json.encode(slot, {indent=true})))
                local slot = exports.ox_inventory:Search('slots', 'papier')
                editPaper(slot) 
            end
        },
        { 
            title  = 'Lire le papier', 
            icon = 'book', 
            onSelect = function()
                local slot = exports.ox_inventory:Search('slots', 'papier')
                TriggerServerEvent('editable_paper:requestPaperContent',slot)
            end 
        },
       --[[ { 
            label = 'Donner le papier', 
        --    icon = 'handshake', 
            onSelect = function()
                local players = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 3.0, false)
                if #players > 0 then
                    local options = {}
                    for i = 1, #players do
                        options[#options + 1] = {
                            label = GetPlayerName(players[i].id),
                            args = { target = GetPlayerServerId(players[i].id), slot = slot }
                        }
                    end

                    lib.registerContext({
                        id = 'give_paper_menu',
                        title = 'Donner le papier',
                        options = options
                    })
                    lib.showContext('give_paper_menu')
                else
                    lib.notify({ type = 'error', description = 'Aucun joueur à proximité.' })
                end
            end 
        }]]
    }
    
    lib.registerContext({
        id = 'paper_menu',
        title = 'Papier',
        options = options
    })

    lib.showContext('paper_menu')
end)

RegisterNetEvent('editable_paper:receivePaperContent', function(content)
    -- Afficher le contenu dans les logs pour débogage
    print("Contenu du papier reçu :", content)

    -- Afficher le contenu dans une boîte de dialogue
    lib.alertDialog({
        header = 'Contenu du papier',
        content = content,
        centered = true,
        size = 'xl'
    })
end)

-- Événement pour recevoir le contenu du papier
RegisterNetEvent('editable_paper:receivePaperContent', function(content)
    readPaper(content)
end)

-- Commande pour utiliser le papier
RegisterCommand('papier', function()
    lib.showContext('paper_menu')
end, false)


--------------- id card ------

RegisterNetEvent('showDocument')
AddEventHandler('showDocument', function(data)
    local type = data.type

    ESX.TriggerServerCallback('generateDocument', function(documentData)
        if type == 'id_card' then
            -- Afficher la carte d'identité
            SendNUIMessage({
                action = 'showDocument',
                type = 'id_card',
                data = documentData
            })
        elseif type == 'driver_license' then
            -- Afficher le permis de conduire
            SendNUIMessage({
                action = 'showDocument',
                type = 'driver_license',
                data = documentData
            })
        end
    end, type)
end)

--- photo suspect ---

function PrendrePhoto()
    -- Créer une nouvelle caméra
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    DisplayRadar(false)
    -- Définir la position de la caméra (exemple ici, tu peux ajuster les coordonnées)
    local camPosition = vector3(478.01, -984.9162, 22.2596)  -- Remplace par les coordonnées de ta position désirée
    SetCamCoord(cam, camPosition.x, camPosition.y, camPosition.z)

    -- Définir la direction vers laquelle la caméra va regarder (exemple ici, tu peux ajuster les coordonnées)
    local lookAtPosition = vector3(-800.0, -950.0, -100.0)  -- Remplace par les coordonnées vers lesquelles tu veux que la caméra regarde
    PointCamAtCoord(cam, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z)

    -- Activer la caméra et rendre l'interface du jeu scriptée
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)

    -- ⏳ Attendre quelques secondes pour voir l'orientation de la caméra
    Citizen.Wait(1000)  -- Temps d'attente pour voir la caméra orientée
    -- 📸 Prendre la capture d'écran du point de vue de la caméra
    exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/1338699966998380605/TsNjk6VowZjNdbpb4eK9Zu60mQQRooUXL0n61Y0cIOPTiSDEJby0Bj4E9xZOwZ90zUdz", "files[]", function(data)
        local imageURL = json.decode(data).attachments[1].url
        lib.setClipboard(imageURL) -- Copier le lien dans le presse-papier
        lib.notify({
        title = 'Mugshot enregistré',
        description = 'L\'image est disponible sur le site de la lspd',
        type = 'success'
    })
    end)
    Citizen.Wait(500)  -- Temps d'attente avant la capture d'écran
    -- Désactiver la caméra après la durée
    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(cam, false)
    DisplayRadar(true)
end

local photoCoords = vector3(482.5816, -985.4104, 21.5596) -- Coordonnées de la zone cible
local photoRotation = 56.2062 -- Rotation de la caméra pour prendre la photo

-- Créer un box dans l'espace avec ox_target
exports.ox_target:addBoxZone({
    coords = photoCoords,
    size = vector3(2.0, 2.0, 2.0),  -- Taille de la box, ajuster selon les besoins
    rotation = photoRotation,
    debug = false,
    options = {
        {
            name = 'take_photo',
            icon = 'fa-solid fa-camera', -- Icône pour l'interaction
            label = 'Prendre une photo',
            onSelect = function()
                PrendrePhoto()
            end
        },
    }
})










