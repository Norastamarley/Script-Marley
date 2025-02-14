ESX = exports["es_extended"]:getSharedObject()


RegisterServerEvent('marley:Blanchiment')
AddEventHandler('marley:Blanchiment', function(amount)
    
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local taxe = Config.Taxe
    local valeurARetirer = amount * (taxe / 100)
    local nouvelleQuantite = amount - valeurARetirer
    
    

    if amount > 0 and xPlayer.getInventoryItem('black_money').count >= amount then
        

        xPlayer.removeInventoryItem('black_money', amount)
       

        TriggerClientEvent("marley:Checked", _src, nouvelleQuantite)
        Citizen.Wait(7000)
        xPlayer.addInventoryItem('cash', nouvelleQuantite)
        playeriden = xPlayer.getIdentifier(_src)
        playerName = xPlayer.getName(_src)
        date = os.date("!%Y-%m-%dT%H:%M:%SZ")

       -- local message = 'Argent donné : ' .. amount .. ' Argent lavé : ' .. nouvelleQuantite .. 'Player identifier : ' .. playeriden .. 'Nom du joueur : ' .. playerName
       local message = 'Argent donné : ' .. amount .. '\n' ..
                'Argent lavé : ' .. nouvelleQuantite .. '\n' ..
                'Player identifier : ' .. playeriden .. '\n' ..
                'Nom du joueur : ' .. playerName

        sendToDiscordWithSpecialURL(_src, message, 16711680, 'https://discord.com/api/webhooks/1283367893962195014/yToQ922YGx3FPyG5AFhNqwUd1lKi5SQbw9iO1qI0KnLp2cWSm67gSSHaPDM5Hc7s_wad') -- 16711680 est la couleur rouge en hexadécimal

    else
        TriggerClientEvent("marley:Unchecked", _src)
        TriggerClientEvent('esx:showNotification', source, 'pas deal','error')
    end
end)

function sendToDiscordWithSpecialURL(source, message, color, url)
    local playerName = GetPlayerName(source)
    local embeds = {
        
            {
                ["title"] = "Informations sur la transaction",
                ["type"] = "rich",
                ["color"] = color,
                ["description"] = message,
                ["footer"] = {
                    ["text"] = "/Blanchiment by Marley",
                    ["timestamp"] = date
                },
            }
        
       --[[ {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
            ["text"] = "/Blanchiment by Marley",
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            },
        }]]
    }

    if message == nil or message == '' then return false end

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({ username = playerName, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

