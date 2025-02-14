ESX = exports["es_extended"]:getSharedObject()

HoodedPlayers = {}


function isHooded (target)
local bool = false
local targetposition = nil

	if HoodedPlayers[1] ~= nil then
		for i=1, #HoodedPlayers, 1 do
			if target == HoodedPlayers[i] then
				bool = true
				targetposition = i
			end
		end
	end

	return bool, targetposition


end

function returnPutHood(hood, target, source)
	if hood then
		TriggerClientEvent('returnSetCagoule', source, false)
	else
		TriggerClientEvent('returnSetCagoule', target, true)
		local xPlayer = ESX.GetPlayerFromId(source)

		xPlayer.removeInventoryItem('cagoule', 1)

		table.insert(HoodedPlayers, target)
	end
end

function returnRemoveHood(hood, target, source, targetposit)
	if hood then
		TriggerClientEvent('returnRemoveCagoule', target, true)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.addInventoryItem('cagoule', 1)

		table.remove(HoodedPlayers, targetposit)
	else
		TriggerClientEvent('returnRemoveCagoule', source, false)
	end
end


ESX.RegisterUsableItem('cagoule', function(source)

	TriggerClientEvent('useCagoule',source)
end)


RegisterServerEvent('setCagoule')
AddEventHandler('setCagoule', function(target)
local test,targetpos = isHooded(target)
returnPutHood(test, target, source) 

end)

RegisterServerEvent('removeCagoule')
AddEventHandler('removeCagoule', function(target)
local test, targetpos = isHooded(target)
returnRemoveHood(test, target, source, targetpos)

	
end)