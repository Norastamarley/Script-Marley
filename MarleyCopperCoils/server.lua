ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('MarleyCopperCoils:hasItem', function(source, cb, itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local item = xPlayer.getInventoryItem(Config.Item)
        if item and item.count > 0 then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

-- Fonction pour donner une récompense aléatoire
function GiveRandomReward(playerId,rewardMin,rewardMax)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    for _, reward in ipairs(Config.rewards) do
        local quantity = math.random(rewardMin, rewardMax)
    
        xPlayer.addInventoryItem(reward.item, quantity)
        TriggerClientEvent('esx:showNotification', playerId, 'Vous avez reçu ' .. quantity .. ' ' .. reward.item)
        -- Log de la récompense sur Discord avec embed
        SendToDiscord(playerId, quantity, reward.item)

    end
end

-- Exemple d'utilisation de la fonction
RegisterServerEvent('MarleyCopperCoils:reward')
AddEventHandler('MarleyCopperCoils:reward', function(rewardMin,rewardMax)
    GiveRandomReward(source,rewardMin,rewardMax)
end)

local webhookUrl = "https://discord.com/api/webhooks/1295573150398152714/mt_xf5mPXhCwC-ypRMq3L-CRmjDBA5W2z74bEPJVhNzfZIVK5FqlFcr-n0rlJVsviYLJ" -- Remplace par ton URL de webhook

-- Fonction pour envoyer un message au webhook Discord
function SendToDiscord(playerId, quantity, item)
    local playerName = GetPlayerName(playerId)
    local playerIdentifier = GetPlayerIdentifiers(playerId)[1] -- Récupérer le premier identifiant du joueur

    local embed = {
        {
            ["color"] = 3447003, -- Couleur de l'embed (Hexadecimal)
            ["title"] = "VOL DE CUIVRE",
            ["description"] = "**" .. playerName .. "** a volé du cuivre.",
            ["fields"] = {
                {
                    ["name"] = "Identifiant",
                    ["value"] = playerIdentifier,
                    ["inline"] = true
                },
                {
                    ["name"] = "Item",
                    ["value"] = quantity .. " " .. item,
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Marley Copper Coils", -- Texte de pied de page
            }
        }
    }

    -- Envoie l'embed au webhook
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end
