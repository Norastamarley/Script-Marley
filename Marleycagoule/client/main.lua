
ESX = exports["es_extended"]:getSharedObject()
local isHooded = false

local Keys = {
		["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
		["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
		["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
		["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
		["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
		["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
		["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
		["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
		["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


-- Enregistrer la commande personnalisée
RegisterCommand('cagoule', function(source, args, rawCommand)
	if isHooded then
		RemoveHood()
	else
		PutHood()
	end
end, false)

function PutHood()
	SendNUIMessage({action = "put"})
	isHooded = true
end

function RemoveHood()
	SendNUIMessage({action = "remove"})
	isHooded = false
end


function usedatCagoule()

	local player ,distance = ESX.Game.GetClosestPlayer()

	 if distance ~= -1 and distance <= 3.0 then
	 	
	 	 
	    TriggerServerEvent('setCagoule', GetPlayerServerId(player))
	   
	    
	    
	 else
	  ESX.ShowNotification('Pas de joueur proche')
	 end
end


RegisterNetEvent('useCagoule')
AddEventHandler('useCagoule', function()
	usedatCagoule()
end)

RegisterNetEvent('returnSetCagoule')
AddEventHandler('returnSetCagoule', function(bool)
	if bool then
		PutHood()
	else
		 ESX.ShowNotification('Le joueur est déjà cagoulé')
    end
end)


RegisterNetEvent('returnRemoveCagoule')
AddEventHandler('returnRemoveCagoule', function (bool)
	if bool then
		RemoveHood()
	else
		ESX.ShowNotification('Le joueur n\'est pas cagoulé')
	end
end)

-- Configurer une interaction via ox_target
exports['ox_target']:addGlobalPlayer({
    name = 'remove_cagoule',                 -- Nom de l'action
    label = 'Retirer la cagoule',            -- Ce que voit le joueur
    icon = 'fas fa-hat-wizard',              -- Icône (facultatif)
    distance = 3.0,                          -- Distance maximale pour l'action
    onSelect = function(data)                -- Que se passe-t-il quand un joueur est sélectionné
		local player, distance = ESX.Game.GetClosestPlayer()

		if distance ~= -1 and distance <= 3.0 then
			 TriggerServerEvent('removeCagoule', GetPlayerServerId(player))
			 
		else
			 ESX.ShowNotification('Pas de joueur proche')
		end
    end
})


Citizen.CreateThread(function()

	while true do
		Wait(0)
		if IsControlJustReleased(0, Keys['DELETE']) then
			local player, distance = ESX.Game.GetClosestPlayer()

	 		if distance ~= -1 and distance <= 3.0 then
	  			TriggerServerEvent('removeCagoule', GetPlayerServerId(player))
	  			
	 		else
	  			ESX.ShowNotification('Pas de joueur proche')
	 		end
		end
	end
end)