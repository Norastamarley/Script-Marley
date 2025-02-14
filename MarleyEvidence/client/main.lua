Config = lib.load("data.config")
local activeLoop = false

AddEventHandler("ox_inventory:currentWeapon", function(weaponData)
    local ammo = weaponData?.ammo
   
    if not ammo or activeLoop then
       
        activeLoop = false
        return
    end
    if IsPedShooting(playerPed) then
        print("le joeuur a tirer")
    end
    activeLoop = true

    while ammo and activeLoop do
        Citizen.Wait(0)--Wait(0)
       
      
         TriggerEvent("ND_Police:playerJustShot", weaponData)
        print(IsPedShooting(ped))
        if IsPedShooting(cache.ped) then 
            print("cache ped : "..cache.ped) 
            TriggerEvent("ND_Police:playerJustShot", weaponData)
        end
    end
end)

------------ barrage --------------
local radius = 50.0 -- Rayon par défaut de la zone (en mètres)
local zoneCenter = nil -- Centre de la zone (sera défini lors de l'initialisation)
local trafficBlocked = false
local markerEndTime = nil -- Temps de fin d'affichage du marqueur

-- Écoute l'événement pour définir la zone
RegisterNetEvent('traffic:setZone')
AddEventHandler('traffic:setZone', function(center, size)
    zoneCenter = center
    radius = size
end)

-- Écoute l'événement pour activer/désactiver le blocage
RegisterNetEvent('traffic:setState')
AddEventHandler('traffic:setState', function(state, size)
    trafficBlocked = state
    if state then
        -- Définit le temps de fin d'affichage du marqueur (1 minute à partir de maintenant)
        markerEndTime = GetGameTimer() + 60000 -- 60000 ms = 1 minute
    else
        -- Réinitialise le temps de fin si le barrage est désactivé
        markerEndTime = nil
    end
end)

-- Fonction pour afficher des notifications
function showNotify(state, size)
    if state then
        lib.notify({
            title = 'Barrage',
            description = ("Barrage activé avec un rayon de %s mètres."):format(size),
            type = 'success'
        })
    else
        lib.notify({
            title = 'Barrage',
            description = 'Barrage désactivé.',
            type = 'error'
        })
    end
end

-- Fonction pour vérifier si un point est dans la zone
function IsPointInZone(point, center, zoneRadius)
    return #(point - center) <= zoneRadius
end

-- Fonction pour supprimer les véhicules des PNJ dans la zone
function ClearTrafficInZone()
    local vehicles = GetGamePool('CVehicle') -- Récupère tous les véhicules dans le jeu
    for _, vehicle in ipairs(vehicles) do
        local driver = GetPedInVehicleSeat(vehicle, -1) -- Récupère le conducteur du véhicule
        if DoesEntityExist(driver) and not IsPedAPlayer(driver) then -- Vérifie si c'est un PNJ
            local vehicleCoords = GetEntityCoords(vehicle)
            if IsPointInZone(vehicleCoords, zoneCenter, radius) then
                SetEntityAsMissionEntity(vehicle, true, true) -- Marque le véhicule comme supprimable
                DeleteVehicle(vehicle) -- Supprime le véhicule
            end
        end
    end
end

-- Exemple d'utilisation de l'événement pour activer/désactiver le barrage
RegisterNetEvent('traffic:showNotify')
AddEventHandler('traffic:showNotify', function(state, radius)
    showNotify(state, radius)
end)

-- Fonction pour dessiner le marqueur
function DrawZoneMarker()
    while markerEndTime and GetGameTimer() < markerEndTime do
        Citizen.Wait(0)
        DrawMarker(1, zoneCenter.x, zoneCenter.y, zoneCenter.z - 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, 255, 0, 0, 100, false, true, 2, nil, nil, false)
    end
    markerEndTime = nil
end

-- Fonction pour gérer le trafic dans la zone
function ManageTrafficInZone()
    while true do
        Citizen.Wait(500) -- Attendre 500 ms pour éviter de surcharger le thread
        if zoneCenter and trafficBlocked then
            ClearTrafficInZone() -- Supprime les véhicules des PNJ dans la zone
        end
    end
end

-- Boucle principale
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Vérifie si le marqueur doit encore être affiché
        if markerEndTime and GetGameTimer() < markerEndTime then
            DrawZoneMarker()
        end
    end
end)

-- Lance la gestion du trafic dans une boucle séparée
Citizen.CreateThread(ManageTrafficInZone)


