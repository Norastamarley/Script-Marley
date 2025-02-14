
-----------------------------------------------------------------------
----------------------------- Commands --------------------------------
-----------------------------------------------------------------------
-- pièce d'identité --

RegisterCommand('idl', function(source, args, rawCommand)

	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
	  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
	end
  end)

--Permis de conduire --

RegisterCommand('dvl', function(source, args, rawCommand)
	
	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
  		TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
	end

end)

--- PPA  -----

RegisterCommand('ppal', function(source, args, rawCommand)
  
	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
  	local player, distance = ESX.Game.GetClosestPlayer()
  
  	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
  	end

end)

--- Donner une license ---

RegisterCommand('givelicense', function(source, args, rawCommand)
    if args[1] and args[2] then
        local playerId = tonumber(args[1])
        local licenseType = args[2]
		print(playerId..' '..licenseType)

        -- Appeler la fonction côté serveur pour donner le permis
		TriggerServerEvent('giveLicense', playerId, licenseType)
		
		
    else
        ESX.ShowNotification('Utilisé : /givelicense [playerId] [licenseType] / driverlicense / weapon')
    end
end, false)


-----------------------------------------------------------------------
----------------------------- Script --------------------------------
-----------------------------------------------------------------------

local open = false

-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

-- close 
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)

-------- carte d'identité ---------

RegisterNetEvent('OpenId')
AddEventHandler('OpenId', function(source, args)
    -- Appeler la fonction côté client avec les paramètres reçus
    OpenIdCard(source, args)
	
end)

-- Fonction côté client à appeler
function OpenIdCard(source, args)
	
	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
	  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
	end
end

----------- Permis de conduire ----------

RegisterNetEvent('OpenDriver')
AddEventHandler('OpenDriver', function(source, args)
    -- Appeler la fonction côté client avec les paramètres reçus
    OpenDriverCard(source, args)
	
end)

-- Fonction côté client à appeler
function OpenDriverCard(source, args)
	
	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()),'driver')
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
	  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player),'driver')
	end
end

------------- PPA ------------------

RegisterNetEvent('OpenPpa')
AddEventHandler('OpenPpa', function(source, args)
	-- Appeler la fonction côté client avec les paramètres reçus
	OpenPpaCard(source, args)
end)

-- Fonction côté client à appeler
function OpenPpaCard(source, args)

	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
	end
end


