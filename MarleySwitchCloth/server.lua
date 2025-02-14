ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterUsableItem('cloth_bag', function(source)
    if Config.bagChange then
        TriggerClientEvent('Marley:changeVetement', source)
    end
end)