ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('roll:notifyNearby')
AddEventHandler('roll:notifyNearby', function(diceResult)
    local playerId = source 
    TriggerClientEvent('roll:showDiceResult', -1, playerId, diceResult)
end)

--------------- Weazel news ----------------------
NewsJob = "weazel_news" -- Nom du job
NewsGrade = "patron" -- Grade requis pour envoyer la news

function notification(msg)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
    ESX.ShowAdvancedNotification('title', 'subject', 'msg', mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end

RegisterCommand("breakingnews", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer and xPlayer.job.name == NewsJob and xPlayer.job.grade_name == NewsGrade then
        TriggerClientEvent("breakingNews:openDialog", source)
    else
        TriggerClientEvent("chat:addMessage", source, { args = { "Erreur", "Vous n'avez pas la permission d'utiliser cette commande." }, color = { 255, 0, 0 } })
    end
end, false)
-- server.lua (Ajout de l'événement serveur pour envoyer la news)
RegisterNetEvent("breakingNews:send")
AddEventHandler("breakingNews:send", function(title, message, position, duration)
    TriggerClientEvent("breakingNews:notify", -1, title, message, position, duration)
end)
