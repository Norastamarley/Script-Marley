ESX = exports["es_extended"]:getSharedObject()
missionStart = nil

function notify(title,description,type)
    lib.notify({
        id = 'notif',
        title = title,
        description = description,
        showDuration = false,
        position = 'top',
        type = type,
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            borderRadius = '8px', -- Arrondi des coins
            ['.description'] = {
              color = '#909296'
            }
        },
    })
end

RegisterNetEvent('omega:sendNotification', function(title, description, type)
    -- Appel de la fonction notify avec les paramètres fournis
    notify(title, description, type)
end)

RegisterCommand("mission", function()
    local playerPed = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)

    -- Vérifier si le joueur est dans un véhicule
    if not IsPedInAnyVehicle(playerPed, false) then
        notify('Erreur', 'Vous devez être dans un véhicule pour lancer la mission.', 'error')
        --TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Vous devez être dans un véhicule pour lancer la mission.' } })
        return
    end

    local vehicleModel = GetEntityModel(playerVehicle)

    -- Vérifier si le modèle du véhicule est dans la liste des véhicules valides
    local isValidVehicle = false
    for _, validVehicle in ipairs(Config.ValidVehicles) do
        if vehicleModel == GetHashKey(validVehicle) then
            isValidVehicle = true
            break
        end
    end

    if not isValidVehicle then
        notify('Erreur', 'Vous devez être dans un véhicule valide pour lancer la mission.', 'error')
        --TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Vous devez être dans un véhicule valide pour lancer la mission.' } })
        return
    end

    if missionStart then
        notify('Erreur', 'Vous avez déjà lancer une mission .', 'error')
        --TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Vous avez déjà lancer une mission .' } })
        return
    end
    -- Envoyer une demande au serveur pour vérifier le métier
    TriggerServerEvent('omega:checkJob')
end)

-- Recevoir l'autorisation de mission du serveur
RegisterNetEvent('omega:jobAuthorized')
AddEventHandler('omega:jobAuthorized', function(isAuthorized)
    if isAuthorized then
        -- Sélectionner une localisation de mission
        local location = GetRandomLocation()

        -- Créer le blip
        blipMission = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blipMission, 402)
        SetBlipColour(blipMission, 5)
        SetBlipAsShortRange(blipMission, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Mission Dépannage")
        EndTextCommandSetBlipName(blipMission)
        -- Active le tracé GPS pour ce blip
        SetBlipRoute(blipMission, true)
        SetBlipRouteColour(blipMission, 5) -- Changez la couleur du tracé si nécessaire
        -- Spawn un véhicule aléatoire à la zone de mission
        local vehicleToSpawn = GetRandomVehicle()
        local pedToSpawn = GetRandomPed()
 
        RequestModel(vehicleToSpawn)
        while not HasModelLoaded(vehicleToSpawn) do
            Citizen.Wait(500)
        end
 
        -- Créer le véhicule
        spawnedVehicle = CreateVehicle(vehicleToSpawn, location.x + 1, location.y + 1, location.z, GetEntityHeading(playerPed), true, false)
         
        -- Appliquer une plaque de véhicule
        plate = GenerateRandomPlate()
        SetVehicleNumberPlateText(spawnedVehicle, plate)

        -- Spawn un ped à côté
        RequestModel(pedToSpawn)
        while not HasModelLoaded(pedToSpawn) do
            Citizen.Wait(500)
        end
 
        spawnedPed = CreatePed(4, pedToSpawn, location.x + 3, location.y + 4, location.z, GetEntityHeading(playerPed), true, true)
        local randomNumber = math.random(1, 2) -- Génère un nombre aléatoire entre 1 et 2
        missionStart = true 
        if randomNumber == 1 then
            -- Ajouter la zone avec ox_target pour interagir sur le lieu de mission
            zoneId = exports.ox_target:addSphereZone({
                coords = vector3(location.x, location.y, location.z),
                radius = 5.0,
                debug = true,
                options = {
                    {
                        name = 'repair',
                        event = 'omega:repairVehicleOnSite',
                        icon = 'fas fa-wrench',
                        label = 'Réparer sur place',
                    },
               
                }
            })
            
        else
            DeleteEntity(spawnedPed)
            spawnedPed = nil
            zoneId = exports.ox_target:addSphereZone({
                coords = vector3(location.x, location.y, location.z),
                radius = 5.0,
                debug = true,
                options = {
                    {
                    name = 'tow',
                    event = 'omega:towVehicleToGarage',
                    icon = 'fas fa-truck',
                    label = 'Remorquer au garage'
                    },
                }
            })
        end
        notify('Mission démarrer', 'Rendez-vous sur le lieu de dépannage.', 'success')
       -- TriggerEvent('chat:addMessage', { args = { '^2SYSTEM', 'Mission lancée ! Rendez-vous sur le lieu de dépannage.' } })
    else
        notify('Erreur', 'Vous n\'avez pas le métier requis pour lancer une mission.', 'error')
        --TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Vous n\'avez pas le métier requis pour lancer une mission.' } })
    end
end)

-- Fonction pour générer une plaque aléatoire
function GenerateRandomPlate()
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local plate = ''
    for i = 1, 8 do -- Longueur de la plaque (8 caractères)
        plate = plate .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return plate
end

-- Fonction pour obtenir un véhicule aléatoire
function GetRandomVehicle()
    return Config.Vehicles[math.random(#Config.Vehicles)]
end

-- Fonction pour obtenir un ped aléatoire
function GetRandomPed()
    return Config.Peds[math.random(#Config.Peds)]
end

-- Fonction pour obtenir une localisation de mission aléatoire sans répétition immédiate
local lastLocationIndex = nil
function GetRandomLocation()
    local newIndex
    repeat
        newIndex = math.random(#Config.MissionLocations)
    until newIndex ~= lastLocationIndex
    lastLocationIndex = newIndex
    return Config.MissionLocations[newIndex]
end

-- Fonction pour dessiner le marqueur
function DrawDepositMarker()
    local depositCoords = Config.TowDestination
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - depositCoords)

    if distance < 100.0 then -- Seulement dessiner le marqueur si le joueur est à moins de 100 unités de distance
        local markerType = 1 -- Type de marqueur (1 = cylindre)
        local markerColor = { r = 255, g = 0, b = 0, a = 100 } -- Couleur du marqueur (rouge avec transparence)
        local markerScale = { x = 5.0, y = 5.0, z = 1.0 } -- Échelle du marqueur

        -- Dessiner le marqueur
        DrawMarker(markerType, depositCoords.x, depositCoords.y, depositCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerScale.x, markerScale.y, markerScale.z, markerColor.r, markerColor.g, markerColor.b, markerColor.a, false, true, 2, false, nil, nil, false, false)
    end
end

-- Action : Réparer sur place
RegisterNetEvent('omega:repairVehicleOnSite')
AddEventHandler('omega:repairVehicleOnSite', function()
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    Citizen.Wait(5000) -- Temps d'animation de réparation

    ClearPedTasksImmediately(playerPed)

   -- TriggerEvent('chat:addMessage', { args = { '^2SYSTEM', 'Le véhicule a été réparé sur place avec succès !' } })
    --notify('Mission démarrer', 'Mission réussie vous toucher votre salaire et l\'entreprise une partie des revenue.', 'success')
    TriggerServerEvent('omega:endMission')
    TriggerServerEvent('omega:payPlayerAndBusiness')


    Citizen.CreateThread(function()

        -- Faire entrer le PNJ dans le véhicule
        TaskEnterVehicle(spawnedPed, spawnedVehicle, -1, -1, 1.0, 1, 0)

        while not IsPedInVehicle(spawnedPed, spawnedVehicle, false) do
            Wait(1)
        end

        -- Faire conduire le PNJ aléatoirement
        TaskVehicleDriveWander(spawnedPed, spawnedVehicle, 20.0, 786603)
     

        local spawnCoords = GetEntityCoords(spawnedVehicle)
        local startTime = GetGameTimer()
        local maxTime = 10000 -- 1 minute (60 secondes) en millisecondes
        while DoesEntityExist(spawnedVehicle) and DoesEntityExist(spawnedPed) do
            Citizen.Wait(1000)
            local currentCoords = GetEntityCoords(spawnedVehicle)
           
            local distance = #(currentCoords - spawnCoords)
           -- print(distance)

            -- Si le véhicule ou le PNJ se bloque, réinitialiser la commande de conduite
            if GetVehicleEngineHealth(spawnedVehicle) < 10 or not IsPedInVehicle(spawnedPed, spawnedVehicle, false) then
                TaskEnterVehicle(spawnedPed, spawnedVehicle, -1, 0, 1.0, 1, false)
                TaskVehicleDriveWander(spawnedPed, spawnedVehicle, 20.0, 786603)
            end

      
            -- Supprimer le PNJ et le véhicule si la distance est supérieure à 10
           -- if distance > 150 then
             --   DeleteEntity(spawnedPed)
               -- DeleteVehicle(spawnedVehicle)
                --spawnedPed = nil
                --spawnedVehicle = nil
                --TriggerEvent('chat:addMessage', { args = { '^2SYSTEM', 'Le PNJ et le véhicule ont été déspawnés car ils sont trop loin.' } })
                --missionStart = false
                --break
            --end
            -- Calcul du temps écoulé
            local currentTime = GetGameTimer()
            local elapsedTime = currentTime - startTime
           -- print("Temps écoulé :", elapsedTime)

            -- Vérification de la distance ou du délai maximal
            if distance > 150 or elapsedTime >= maxTime then
                -- Supprimer le PNJ et le véhicule
                DeleteEntity(spawnedPed)
                DeleteVehicle(spawnedVehicle)
                spawnedPed = nil
                spawnedVehicle = nil
                --TriggerEvent('chat:addMessage', { args = { '^2SYSTEM', 'Le PNJ et le véhicule ont été déspawnés.' } })
                missionStart = false
                break
            end
          
        end
    end)
 
end)


-- Action : Remorquer au garage
-- Fonction pour vérifier la livraison du véhicule
function CheckVehicleDelivery(playerPed, targetVehicle, targetPlate)
    local playerCoords = GetEntityCoords(playerPed)
    local destination = Config.TowDestination
    local playerVehicle = GetVehiclePedIsIn(playerPed)
    DrawDepositMarker()
    if Vdist(playerCoords, destination) < 2.0 then -- Vérifie si le joueur est proche de la destination
        local plate = GetVehicleNumberPlateText(targetVehicle)
        

        if targetPlate == plate then -- Vérifie si la plaque du véhicule correspond
           -- TriggerEvent('chat:addMessage', { args = { '^2SYSTEM', 'Vous avez livré le véhicule avec succès !' } })
            notify('Mission réussi', 'Vous avez livré le véhicule avec succès !', 'success')
            -- Détacher le véhicule
            DetachVehicleFromTowTruck(playerVehicle, spawnedVehicle)

           
         
            DeleteVehicle(spawnedVehicle)
            spawnedVehicle = nil

            TriggerServerEvent('omega:endMission')
            TriggerServerEvent('omega:payPlayerAndBusiness')
        
            missionStart = false
            return true -- Indique que la mission est terminée
        else
            --TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Ce n\'est pas le bon véhicule à remorquer !' } })
        end
    end

    return false -- Indique que la mission n'est pas terminée
end

RegisterNetEvent('omega:towVehicleToGarage')
AddEventHandler('omega:towVehicleToGarage', function()
        
        local playerPed = PlayerPedId()
        local targetPlate = GetVehicleNumberPlateText(spawnedVehicle)
        
        -- Créer le blip
        blipTow = AddBlipForCoord(Config.TowDestination.x, Config.TowDestination.y, Config.TowDestination.z)
        SetBlipSprite(blipTow, 402)
        SetBlipColour(blipTow, 1)
        SetBlipAsShortRange(blipTow, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Mission remorquage")
        EndTextCommandSetBlipName(blipTow)
        -- Active le tracé GPS pour ce blip
        SetBlipRoute(blipTow, true)
        SetBlipRouteColour(blipTow, 1) -- Changez la couleur du tracé si nécessaire
        notify('Mission démarrer', 'Remorquer le véhicule à la fourrière.', 'success')
        Citizen.CreateThread(function()
     
            while true do
                Citizen.Wait(500) -- Attendre 1 seconde avant de vérifier à nouveau
                
                if CheckVehicleDelivery(playerPed, spawnedVehicle, targetPlate) then
                    break -- Sortir de la boucle une fois la mission terminée
                end
            end
        end)
        Citizen.CreateThread(function()
            while blipTow do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = #(playerCoords - Config.TowDestination)
        
                if distance < 50.0 then
                    Citizen.Wait(1) -- Rafraîchissement rapide lorsque le joueur est proche
                elseif distance < 100.0 then
                    Citizen.Wait(50) -- Rafraîchissement moyen lorsque le joueur est à une distance moyenne
                else
                    Citizen.Wait(1000) -- Rafraîchissement lent lorsque le joueur est loin
                end
        
                DrawDepositMarker()
                if CheckVehicleDelivery(playerPed, spawnedVehicle, targetPlate) then
                   missionStart = false
                   --notify('Mission démarrer', 'Mission réussie vous toucher votre salaire et l\'entreprise une partie des revenue.', 'success')
                    break -- Sortir de la boucle une fois la mission terminée
                end
            end
        end)
       
end)

-- Arrêter la mission et supprimer le blip et les zones
RegisterNetEvent('omega:stopMission')
AddEventHandler('omega:stopMission', function()
    if blipMission then
        RemoveBlip(blipMission)
        blipMission = nil
        
    end
    if blipTow then
        RemoveBlip(blipTow)
        blipTow = nil
       
    end   
    exports.ox_target:removeZone(zoneId)    
    --notify('Mission arreter', 'Mission arrêtée.', 'warning')
    --TriggerEvent('chat:addMessage', { args = { '^2SYSTEM', 'Mission arrêtée.' } })
end)

-- Commande pour arrêter la mission
RegisterCommand("mission_stop", function()
    missionStart = false
    DeleteEntity(spawnedPed)
    DeleteVehicle(spawnedVehicle)
    spawnedPed = nil
    spawnedVehicle = nil
    TriggerServerEvent('omega:endMission')
end)