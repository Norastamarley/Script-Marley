ESX = exports["es_extended"]:getSharedObject()

--==== Café ==== --
exports.ox_target:addModel(Config.coffe, {
    {
        distance = 2.5,
        name = 'machineCoffe',
        label = 'Utiliser la machine',
        icon = 'fas fa-hand-paper',

        onSelect = function(entity)

            local model = entity.name

            machine(model)
        end,

        canInteract = function(entity, distance, coords)
            return true
        end,
    }
})

--==== Soda ====--

exports.ox_target:addModel(Config.soda, {
    {
        distance = 2.5,
        name = 'machineSoda',
        label = 'Utiliser la machine',
        icon = 'fas fa-hand-paper',

        onSelect = function(entity)
            local model = entity.name

            machine(model)
        end,
        canInteract = function(entity, distance, coords)
            return true
        end,
    }
})

--==== snak ====-- 

exports.ox_target:addModel(Config.snak, {
    {
        distance = 2.5,
        name = 'machineSnak',
        label = 'Utiliser la machine',
        icon = 'fas fa-hand-paper',

        onSelect = function(entity)
            local model = entity.name

            machine(model)
        end,
        canInteract = function(entity, distance, coords)
            return true
        end,
    }
})

--== water ==--

exports.ox_target:addModel(Config.water, {
    {
        distance = 2.5,
        name = 'machinewater',
        label = 'Utiliser la machine',
        icon = 'fas fa-hand-paper',

        onSelect = function(entity)
            local model = entity.name

            machine(model)
        end,
        canInteract = function(entity, distance, coords)
            return true
        end,
    }
})

-- Gestion de l'événement pour acheter un item
RegisterNetEvent('buyVendingItem', function(data)
    local item = data.item
    local price = data.price
    local label = data.label

    -- Vérifie si le joueur a assez d'argent
    ESX.TriggerServerCallback('checkPlayerMoney', function(hasEnoughMoney)
        if hasEnoughMoney then
            -- Ajoute l'item dans l'inventaire du joueur
            TriggerServerEvent('giveVendingItem', item, price)
            ESX.ShowNotification("Vous avez acheté un(e) " .. label)
        else
            ESX.ShowNotification("Vous n'avez pas assez d'argent.")
        end
    end, price)
end)



function playAnim(entity)
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
end

function machine(model)

    if model then

        local machineItems = Config.objects[model]

        if machineItems then
            local options = {}

            for _, itemData in pairs(machineItems) do
                table.insert(options, {
                    title = itemData.label,
                    description = 'Prix: $' .. itemData.price,
                    icon = 'fas fa-shopping-cart',
                    image = itemData.image, -- Ajout de l'image ici
                    event = 'buyVendingItem', -- L'événement qui sera déclenché
                    args = {
                        item = itemData.item,
                        price = itemData.price,
                        label = itemData.label
                    }
                })
            end

            -- Enregistre le menu contextuel avec ox_lib
            lib.registerContext({
                id = 'vending_machine_menu',
                title = 'Distributeur',
                options = options
            })

            -- Ouvre le menu
            lib.showContext('vending_machine_menu')
        else
            ESX.ShowNotification("Cette machine n'est pas reconnue.")
        end
    else
        ESX.ShowNotification("Erreur lors de la récupération du modèle de l'entité.")
    end

end