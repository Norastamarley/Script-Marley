-- ESX
local ESX = nil
ESX = exports["es_extended"]:getSharedObject()

-----------------------------------------------------------------------
----------------------------- Items --------------------------------
-----------------------------------------------------------------------

ESX.RegisterUsableItem('idcard', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	TriggerClientEvent('OpenId', playerId, args)
	
end)

ESX.RegisterUsableItem('driverlicense', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	TriggerClientEvent('OpenDriver', playerId, args)
	
end)  

ESX.RegisterUsableItem('ppa', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	TriggerClientEvent('OpenPpa', playerId, args)
end)  


-----------------------------------------------------------------------
----------------------------- Script --------------------------------
-----------------------------------------------------------------------

-- Open ID card
RegisterServerEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function(ID, targetID, type)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				if type ~= nil then
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								show = true
							end
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('jsfour-idcard:open', _source, array, type)
				else
					TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas cette license")
				end
			end)
		end
	end)
end)


-- Événement pour donner un permis à un joueur
RegisterServerEvent('giveLicense')
AddEventHandler('giveLicense', function(playerId, licenseType)
	print('serverGiveEvent')
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'admin' then
       
        GiveLicense(playerId, licenseType)	
		local item = nil
		
        print('La commande maCommande a été utilisée par l\'administrateur ' .. source)
		exports['core_inventory']:addItem(playerId, item, 1, metadata, inventoryType)
    else 
        -- Afficher un message d'erreur
        TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas la permission d\'utiliser cette commande.')
   		
	end 

end)

-- Fonction pour donner un permis à un joueur
function GiveLicense(playerId, licenseType)
    local xPlayer = ESX.GetPlayerFromId(playerId)
	print('serverAddLicence')
    if xPlayer then
        -- Appeler l'événement pour ajouter le permis
		
        
			TriggerEvent('esx_license:addLicense', playerId, licenseType, function(result)
			
			--MySQL.insert('INSERT INTO user_licenses (type, owner) VALUES (?, ?)', {licenseType, playerId}
            if result then
                -- Notifier le joueur
                TriggerClientEvent('esx:showNotification', playerId, 'Vous avez donnez' .. licenseType )
            else
                -- Notifier l'échec
                TriggerClientEvent('esx:showNotification', playerId, 'Echec du give de' .. licenseType)
            end
        end)
    else
        print('erreur de ID :'.. playerId)
    end
end

