ESX = exports["es_extended"]:getSharedObject()

for _, station in pairs(Config.CookingStations) do
    exports.ox_target:addModel(station.prop, {
        {
            name = 'cooking_station_' .. station.prop,
            event = 'cooking:startCrafting',
            icon = 'fa-solid fa-utensils',
            label = 'Utiliser' .. station.label,
            args = { stationType = station.stationType }, -- Passe le type de station
            canInteract = function(entity, distance, coords, name)
                return distance <= 2.0 -- Vérifie la proximité
            end
        }
    })
end

RegisterNetEvent('cooking:startCrafting', function(data)
    local stationType = data.args.stationType
    local options = {}

   -- print(json.encode(data, {indent=true})) 

    for recipeName, recipe in pairs(Config.Recipes) do
        --print(recipe.stationType ..' == '.. stationType)
        if recipe.stationType == stationType then
            -- Construction des métadonnées
            local metadata = {}
            for _, ingredient in ipairs(recipe.ingredients) do
                table.insert(metadata, {
                    label = ingredient.label, -- Nom de l'ingrédient
                    value = 'x' .. ingredient.count, -- Quantité requise
                   -- progress = math.random(20, 80) -- Exemple : pourcentage fictif (à personnaliser)
                })
            end
        
            table.insert(options, {
                title = recipe.label,
                metadata = metadata, -- Ajout des métadonnées
                icon = 'fa-solid fa-utensils',
              --  Servervent = 'cooking:startCrafting',
                args = { recipe = recipeName },
                onSelect = function(args)
                    TriggerServerEvent('cooking:startCrafting', args)
                end,
               
            })
        end
    end

    if #options == 0 then
        TriggerEvent('ox_lib:notify', { type = 'error', description = 'Aucune recette disponible ici.', position = 'top' })
        return
    end

    lib.registerContext({
        id = 'cooking_menu_' .. stationType,
        title = 'Station de cuisine : ' .. stationType,
        options = options,
        
    })

    lib.showContext('cooking_menu_' .. stationType)
end)

ESX = exports["es_extended"]:getSharedObject()

-- Ajouter les stations de cuisine avec ox_target
for _, station in pairs(Config.CookingStations) do
    exports.ox_target:addModel(station.prop, {
        {
            name = 'cooking_station_' .. station.prop,
            event = 'cooking:startCrafting',
            icon = 'fa-solid fa-utensils',
            label = 'Utiliser ' .. station.label,
            args = { stationType = station.stationType },
            canInteract = function(entity, distance, coords, name)
                
                return distance <= 2.0 -- Vérifie la proximité
            end
        }
    })
end

-- Menu contextuel pour choisir une recette
RegisterNetEvent('cooking:startCrafting', function(data)
    local stationType = data.args.stationType
    local options = {}

    for recipeName, recipe in pairs(Config.Recipes) do
        if recipe.stationType == stationType then
            -- Métadonnées pour afficher les ingrédients
            local metadata = {}
            for _, ingredient in ipairs(recipe.ingredients) do
                table.insert(metadata, {
                    label = ingredient.label,
                    value = 'x' .. ingredient.count
                })
            end

            -- Ajouter l'option pour cette recette
            table.insert(options, {
                title = recipe.label,
                metadata = metadata,
                icon = 'fa-solid fa-utensils',
                event = 'cooking:selectRecipe',
                args = { recipe = recipeName }
            })
        end
    end

    -- Si aucune recette disponible
    if #options == 0 then
        TriggerEvent('ox_lib:notify', { type = 'error', description = 'Aucune recette disponible ici.', position = 'top' })
        return
    end

    -- Enregistrer et afficher le menu
    lib.registerContext({
        id = 'cooking_menu_' .. stationType,
        title = 'Station de cuisine : ' .. stationType,
        options = options,
    })

    lib.showContext('cooking_menu_' .. stationType)
end)

-- Gestion de la sélection d'une recette
RegisterNetEvent('cooking:selectRecipe', function(data)
    print(json.encode(data, {indent=true})) 
    local recipeName = data.recipe
    local recipe = Config.Recipes[recipeName]

    if not recipe then
        TriggerEvent('ox_lib:notify', { type = 'error', description = 'Recette invalide.', position = 'top' })
        return
    end
    print(json.encode(recipe, {indent=true})) 

    -- Afficher une barre de progression avec un prop
    local success = lib.progressBar({
        duration = recipe.craftTime or 5000,  -- Temps en millisecondes
        label = 'Préparation en cours : ' .. recipe.label,
        useWhileDead = false,
        canCancel = true,  -- L'utilisateur peut annuler l'action
        disable = { move = true, combat = true, car = true },  -- Désactiver certaines actions
        anim = recipe.anim and recipe.anim.dict and recipe.anim.clip and { 
            dict = recipe.anim.dict, 
            clip = recipe.anim.clip 
        } or nil,  -- Vérifier si l'animation est définie avant de l'utiliser
        prop = recipe.prop and recipe.prop.model and {
            model = recipe.prop.model,
            pos = recipe.prop.pos and { 
                x = recipe.prop.pos.x, 
                y = recipe.prop.pos.y, 
                z = recipe.prop.pos.z 
            } or nil,  -- Vérifier si la position est définie correctement
            rot = recipe.prop.rot and { 
                x = recipe.prop.rot.x, 
                y = recipe.prop.rot.y, 
                z = recipe.prop.rot.z 
            } or nil,  -- Vérifier si la rotation est définie correctement
            bone = recipe.prop.bone
        } or nil,  -- Vérifier si le prop est défini avant de l'utiliser
    })


    

    if success then
       
        -- Si craft réussi, envoyer au serveur
        TriggerServerEvent('cooking:completeCrafting', { recipe = recipeName })
    else
        -- Si craft annulé
        TriggerEvent('ox_lib:notify', { type = 'error', description = 'Cuisine annulée.', position = 'top' })
    end
end)

---------------------------------------------------
------------------- PROPS -------------------------
---------------------------------------------------
--[[
-- Table pour stocker les objets posés et leur association à des items
local placedProps = {}

-- Ajouter des cibles interactives pour chaque prop dans Config
for itemName, prop in pairs(Config.PosableProps) do
    exports.ox_target:addModel(prop.prop, {
        {
            name = itemName, -- Nom unique basé sur l'item
            event = 'MarleyCooking:removeprop',
            icon = 'fa-solid fa-utensils',
            label = 'Ramasser ' .. (prop.label or 'Objet'),
            args = {itemName = itemName, prop = prop}, -- Passer les infos nécessaires

            canInteract = function(entity, distance, coords, name)
                return distance <= 2.0 -- Vérifie la proximité
            end,
        }
    })
end

-- Événement pour poser un objet
RegisterNetEvent('MarleyCooking:useItem', function(args)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local itemName = args.client.args -- Nom de l'item
    local itemData = Config.PosableProps[itemName]

    if not itemData then
        ESX.ShowNotification("Erreur : l'item n'est pas défini.")
        return
    end

    -- Calcul de la position devant le joueur
    local forwardVector = GetEntityForwardVector(playerPed)
    local spawnPos = vector3(
        playerCoords.x + forwardVector.x * 1.0,
        playerCoords.y + forwardVector.y * 1.0,
        playerCoords.z
    )

    -- Charger et créer le modèle
    local ItemHash = GetHashKey(itemData.prop)
    RequestModel(ItemHash)
    while not HasModelLoaded(ItemHash) do
        Wait(0)
    end

    local Object = CreateObject(ItemHash, spawnPos.x, spawnPos.y, spawnPos.z, true, false, true)
    PlaceObjectOnGroundProperly(Object)
    SetEntityHeading(Object, GetEntityHeading(playerPed))
    SetModelAsNoLongerNeeded(ItemHash)

    -- Stocker l'objet posé
    placedProps[Object] = itemName

    -- Notifier le joueur et retirer l'item de l'inventaire
    ESX.ShowNotification('Vous avez posé ' .. (itemData.label or 'Objet'))
    TriggerServerEvent('ox_inventory:removeItem', itemName, 1)
end)

-- Événement pour ramasser un objet
RegisterNetEvent('MarleyCooking:removeprop', function(data)
    print(json.encode(data, {indent=true})) 
    local entity = data.entity -- L'entité sélectionnée
    local itemName = data.name -- Récupérer l'item associé

    if not itemName then
        ESX.ShowNotification("Erreur : cet objet n'est pas enregistré.")
        return
    end

    local itemData = Config.PosableProps[data.name]

    -- Supprimer l'objet et retirer du tableau
    DeleteObject(entity)
    placedProps[entity] = nil

    -- Notifier le joueur et ajouter l'item à l'inventaire
    ESX.ShowNotification('Vous avez ramassé ' .. (itemData.label or 'Objet'))
    print(itemName)
    TriggerServerEvent('MarleyCooking:addItemToPlayer', itemName, 1)
end)

-- Table pour suivre les particules associées aux entités
local EntityParticles = {}

-- Table pour stocker les objets posés et leur association à des items
local placedProps = {}

-- Ajouter des cibles interactives pour chaque prop dans Config
for itemName, prop in pairs(Config.PosableProps) do
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local uniqueId = "cooking_station_prop_" .. prop.prop .. "_" .. math.floor(playerCoords.x) .. "_" .. math.floor(playerCoords.y) .. "_" .. math.floor(playerCoords.z)
    exports.ox_target:addModel(prop.prop, {
        {
            name = itemName,
            event = 'MarleyCooking:removeprop',
            icon = 'fa-solid fa-utensils',
            label = 'Ramasser ' .. (prop.label or 'Objet'),
            args = {itemName = itemName, prop = prop},

            canInteract = function(entity, distance, coords, name)
                return distance <= 2.0 -- Vérifie la proximité
            end,
        }
    })
end

-- Événement pour poser un objet
RegisterNetEvent('MarleyCooking:useItem', function(args)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local itemName = args.client.args
    local itemData = Config.PosableProps[itemName]

    if not itemData then
        ESX.ShowNotification("Erreur : l'item n'est pas défini.")
        return
    end

    -- Calcul de la position devant le joueur
    local forwardVector = GetEntityForwardVector(playerPed)
    local spawnPos = vector3(
        playerCoords.x + forwardVector.x * 1.0,
        playerCoords.y + forwardVector.y * 1.0,
        playerCoords.z
    )

    -- Charger et créer le modèle
    local ItemHash = GetHashKey(itemData.prop)
    RequestModel(ItemHash)
    while not HasModelLoaded(ItemHash) do
        Wait(0)
    end

    local Object = CreateObject(ItemHash, spawnPos.x, spawnPos.y, spawnPos.z, true, false, true)
    PlaceObjectOnGroundProperly(Object)
    SetEntityHeading(Object, GetEntityHeading(playerPed))
    SetModelAsNoLongerNeeded(ItemHash)

    -- Ajouter une flamme si c'est un BBQ
    if itemName == "bbq" then
        StartBBQFire(Object)
    end

    -- Stocker l'objet posé
    placedProps[Object] = itemName

    -- Notifier le joueur
   -- ESX.ShowNotification('Vous avez posé ' .. (itemData.label or 'Objet'))

    -- Retirer l'item de l'inventaire
    TriggerServerEvent('ox_inventory:removeItem', itemName, 1)
end)

-- Fonction pour démarrer la flamme (version simple avec effet étincelle)
function StartBBQFire(entity)
    
    local particleDict = "core"  -- Dictionnaire de particules
    local particleName = "ent_amb_barrel_fire"  -- Utilisation de l'effet de flamme standard
    local fireOffset = vector3(0.0, 0.0, 0.0)   -- Décalage de la flamme sur le BBQ

    -- Récupère la position de l'objet
    local objectPos = GetEntityCoords(entity)

    -- Charger les particules
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(0)
    end

    -- Utiliser les particules à la position de l'objet
    UseParticleFxAssetNextCall(particleDict)

    -- Ajouter l'effet de particule à la position de l'objet
    local particle = StartParticleFxLoopedAtCoord(
        particleName,            -- Nom de l'effet
        objectPos.x, objectPos.y, objectPos.z + fireOffset.z, -- Position avec décalage
        0.0, 0.0, 0.0,           -- Rotation (Pitch, Roll, Yaw)
        0.5,                     -- Échelle de l'effet
        false, false, false, false -- Options d'affichage
    )

    -- Sauvegarder la particule pour pouvoir la supprimer plus tard si nécessaire
    EntityParticles[entity] = particle
end

-- remove prop
RegisterNetEvent('MarleyCooking:removeprop', function(data)
    print(json.encode(data, {indent=true}))
    local entity = data.entity  -- L'entité sélectionnée

    -- Vérifier si des particules sont attachées à cette entité
    if EntityParticles[entity] then
        RemoveParticleFx(EntityParticles[entity], true)
        EntityParticles[entity] = nil
    end

    -- Supprimer l'objet du monde
    DeleteObject(entity)

    -- Notifier le joueur
   -- ESX.ShowNotification('Vous avez ramassé ' .. (data.args.prop.label or 'Objet'))

    -- Ajouter l'item à l'inventaire
    TriggerServerEvent('MarleyCooking:addItemToPlayer', data.args.itemName, 1)
end)]]
