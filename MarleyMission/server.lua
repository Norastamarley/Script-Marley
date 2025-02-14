ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('esx_mecanojob:onNPCJobMissionCompleted')
AddEventHandler('esx_mecanojob:onNPCJobMissionCompleted', function()

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local total   = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max);

  if xPlayer.job.grade >= 3 then
    total = total * 2
  end

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
    account.addMoney(total)
  end)

  TriggerClientEvent("esx:showNotification", _source, _U('your_comp_earned').. total)

end)
--------------------------------------------------------------------------------------------
RegisterNetEvent('omega:checkJob')
AddEventHandler('omega:checkJob', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerJob = xPlayer.getJob().name

    -- Vérifier si le joueur a un métier autorisé
    local isAuthorized = false
    for _, job in ipairs(Config.AuthorizedJobs) do
        if playerJob == job then
            isAuthorized = true
            break
        end
    end

    -- Envoyer l'autorisation au client
    TriggerClientEvent('omega:jobAuthorized', source, isAuthorized)
end)

-- Arrêter la mission
RegisterNetEvent('omega:endMission')
AddEventHandler('omega:endMission', function()
    local source = source
    TriggerClientEvent('omega:stopMission', source)
end)

-- Event serveur pour payer et répartir les fonds en fonction de la société du joueur
RegisterNetEvent('omega:payPlayerAndBusiness')
AddEventHandler('omega:payPlayerAndBusiness', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Récupérer la société liée au métier du joueur
    local jobName = xPlayer.getJob().name
    local societyAccount = 'society_' .. jobName -- ex : 'society_mechanic' pour un joueur mécano

    -- Calcul du montant pour le joueur et l'entreprise
    local payoutAmount = math.random(Config.PayoutRange.min, Config.PayoutRange.max)

    -- Calculer les parts
    local playerAmount = math.floor(payoutAmount * Config.PayoutPercentage.player / 100)
    local businessAmount = math.floor(payoutAmount * Config.PayoutPercentage.business / 100)
 

    --local playerAmount = (Config.PayoutAmount * Config.PayoutPercentage.player) / 100
    --local businessAmount = (Config.PayoutAmount * Config.PayoutPercentage.business) / 100

    -- Versement au joueur
    xPlayer.addMoney(playerAmount)--<span style="color: red;">notification</span> 
    --TriggerClientEvent('chat:addMessage', source, { args = { '^2SYSTEM', 'Vous avez reçu $' .. playerAmount .. ' pour la mission.' } })
    TriggerClientEvent('omega:sendNotification', source, 'Mission réussie', 'Vous avez reçu $' .. playerAmount .. ' pour la mission.', 'success')

    -- Versement à la société du métier du joueur
    TriggerEvent('esx_addonaccount:getSharedAccount', societyAccount, function(account)
        if account then
            account.addMoney(businessAmount)
            --TriggerClientEvent('chat:addMessage', source, { args = { '^2SYSTEM', 'La société a reçu $' .. businessAmount .. ' pour la mission.' } })
            --TriggerEvent('omega:sendNotification', source, 'Succès', 'La société a reçu $' .. businessAmount .. ' pour la mission.', 'success')
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Erreur : compte de société introuvable pour ' .. jobName } })
        end
    end)
end)
