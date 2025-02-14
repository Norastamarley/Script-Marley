ESX = exports["es_extended"]:getSharedObject()

local cooldowns = {}

exports.ox_target:addModel(Config.props, {

        {
            distance = 2.5,
            name = 'interact',
            label = 'Voler du cuivre',
            icon = 'fas fa-hand-paper',
            onSelect = function(entity)
                local playerPed = PlayerPedId()
                ESX.TriggerServerCallback('MarleyCopperCoils:hasItem', function(hasItem)

                    if hasItem then
                        VolCuivre(entity)
                    else
                        ESX.ShowNotification('Vous n\'avez pas de '.. Config.Item, 'error', 3000)  
                    end

                end, Config.Item )
                

            end,
            canInteract = function(entity,distance,coords)
                local playerData = ESX.GetPlayerData() 
                local job = playerData.job.name -- Obtient le nom du job
    
                
                -- Liste des jobs non autorisés
               -- local jobBlacklist = {"police", "sheriff", "ambulance"} -- Ajoute les jobs que tu souhaites bloquer
    
                -- Vérifie si le job du joueur est dans la liste des jobs non autorisés
                for _, jobBlacklist in ipairs(Config.jobBlacklist) do
                    if job == jobBlacklist then
                        return false -- Ne permet pas d'interagir
                    end
                end

                return not cooldowns[entity]
            end,
        }
    
   
})

function VolCuivre(entity)
    local entity = entity.entity
    local coords = GetEntityCoords(entity) 
    local playerPed = PlayerPedId()
    local entityCoords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)

    -- Placer le joueur face à l'entité
    SetEntityHeading(playerPed, heading)

    PlayAnim()

    local selectedDifficulty
    -- Vérifie le mode de difficulté
    if Config.difficultyMode == 'random' then
        -- Générer une difficulté aléatoire
        local difficulties = {"easy", "medium", "hard"}
        local randomDifficulty = difficulties[math.random(#difficulties)] -- Choisir une difficulté aléatoire
        selectedDifficulty = Config.skillCheckDifficulty[randomDifficulty]
    else
        -- Utiliser la difficulté fixée dans la configuration
        selectedDifficulty = Config.skillCheckDifficulty[Config.setDifficulty]
    end

    -- Utiliser les paramètres de la difficulté sélectionnée
    local success = lib.skillCheck({
        selectedDifficulty.difficulty,
        selectedDifficulty.difficulty,
        {areaSize = selectedDifficulty.areaSize, speedMultiplier = selectedDifficulty.speedMultiplier},
        selectedDifficulty.difficulty
    }, selectedDifficulty.keyPresses)

    local cooldownTime = Config.cooldowns

    
    if success then

        stopAnim()
       -- Envoyer la récompense au serveur
        local rewardMin = selectedDifficulty.rewardRange.min
        local rewardMax = selectedDifficulty.rewardRange.max

        TriggerServerEvent('MarleyCopperCoils:reward',rewardMin, rewardMax)

        cooldowns[entity] = true

        Citizen.SetTimeout(cooldownTime, function()
            cooldowns[entity] = nil -- Retirer l'entité du cooldown
        end)

    else
        stopAnim()
        AlertePolice(coords)      
    end
end

function AlertePolice(coords)

    local chance = Config.chanceAlert
    local randomNumber = math.random(1, 100)

    if randomNumber <= chance and Config.policeAlert then
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = { 'police', 'sheriff', 'traffic', 'patrol' },
            callLocation = vector3(coords.x,coords.y,coords.z),
            callCode = { code = 'Dégradation', snippet = '10-79' },
            message = "Dégradation de bien publique",
            flashes = false, -- you can set to true if you need call flashing sirens...
            
        
            blip = {
                sprite = 761, --blip sprite
                scale = 0.9, -- blip scale
                colour = 1, -- blio colour
                flashes = true, -- blip flashes
                text = 'Dégradation', -- blip text
                time = (20 * 1000), --blip fadeout time (1 * 60000) = 1 minute
            },
            otherData = {
                -- optional if you dont need this you can remove it and remember remove the `,` after blip end and this block
            {
                text = 'Suspect inconnu', -- text of the other data item (can add more than one)
                icon = 'fas fa-user-secret', -- icon font awesome https://fontawesome.com/icons/
            }
            }
        }) 
    end
end

function PlayAnim()
    
    local playerPed = PlayerPedId()
    local dict = "amb@world_human_welding@male@base" 
    local anim = "base"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    
    TaskPlayAnim(playerPed, dict, anim, 10.0, -8.0, -1, 1, 0, false, false, false)
end

function stopAnim()

    local playerPed = PlayerPedId() -- Récupère à nouveau l'identifiant du joueur
    ClearPedTasksImmediately(playerPed) -- Arrête immédiatement l'animation

end