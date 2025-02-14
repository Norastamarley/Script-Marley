ESX = exports["es_extended"]:getSharedObject()

exports.ox_target:addGlobalVehicle({
    name = 'switchCloth',
    icon = 'fa-solid fa-shirt',
    label = 'Changer de vêtement',
    iconColor = '#EAC100',
    distance = 2.5,
    onSelect = function(entity)
        ChangeVetement()
    end,
    canInteract = function(entity, distance, coords, name, bone)
        local netId = NetworkGetNetworkIdFromEntity(entity)
        local properties = lib.getVehicleProperties(entity)
        local vehicleProps = lib.getVehicleProperties(entity)
        local plate = vehicleProps.plate
        print('Entity:', entity)
        print('Properties:', properties)

        --print(plate)
        if(exports["vehicles_keys"]:doesPlayerOwnPlate(plate)) and Config.carChange then
           -- print("I own this vehicle plate")
           print('true')
            return true
            
        end
        print('true')
        return false
    end,
})

function ChangeVetement()
    TriggerEvent('rcore_clothing:openChangingRoom')
end

-- Enregistrement de l'événement côté client
RegisterNetEvent('Marley:changeVetement', function()
    ChangeVetement()
end)
