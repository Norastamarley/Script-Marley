Ox_inventory = exports.ox_inventory
ESX = exports["es_extended"]:getSharedObject()
local glm = require 'glm'
local config = lib.load("data.config")

RegisterServerEvent('ND_Police:deploySpikestrip', function(data)
    local count = Ox_inventory:Search(source, 'count', 'spikestrip')

    if count < data.size then return end

    Ox_inventory:RemoveItem(source, 'spikestrip', data.size)

    local dir = glm.direction(data.segment[1], data.segment[2])

    for i = data.size, 1, -1 do
        local coords = glm.segment.getPoint(data.segment[1], data.segment[2], (i * 2 - 1) / (data.size * 2))
        local object = CreateObject(`p_ld_stinger_s`, coords.x, coords.y, coords.z, true, true, true)

        while not DoesEntityExist(object) do
            Wait(0)
        end

        SetEntityRotation(object, math.deg(-math.sin(dir.z)), 0.0, math.deg(math.atan(dir.y, dir.x)) + 90, 2, false)
        Entity(object).state:set('inScope', true, true)
        Wait(800)
    end
end)

RegisterServerEvent('ND_Police:retrieveSpikestrip', function(netId)
    local ped = GetPlayerPed(source)

    if GetVehiclePedIsIn(ped, false) ~= 0 then return end

    local pedPos = GetEntityCoords(ped)
    local spike = NetworkGetEntityFromNetworkId(netId)
    local spikePos = GetEntityCoords(spike)

    if #(pedPos - spikePos) > 5 then return end

    if not Ox_inventory:CanCarryItem(source, 'spikestrip', 1) then return end

    DeleteEntity(spike)

    Ox_inventory:AddItem(source, 'spikestrip', 1)
end)

RegisterNetEvent('ND_Police:gsrTest', function(target)
	local src = source
	local state = Player(target).state

    if state.shot then
        return Bridge.notify(src, {
            type = 'success',
            description = 'Test comes back POSITIVE (Has Shot)'
        })
    end

    Bridge.notify(src, {
        type = 'error',
        description = 'Test comes back NEGATIVE (Has Not Shot)'
    })
end)

---------- barrage -----------

local trafficBlocked = false
local zoneCenter = nil
local radius = 50.0 -- Rayon par défaut de la zone (en mètres)

-- Vérifie si le joueur est un agent de police
function IsPlayerPolice(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId) -- Récupère le joueur
    return xPlayer and xPlayer.job and xPlayer.job.name == 'police' -- Vérifie si le métier est 'police'
end

-- Commande pour gérer le barrage
RegisterCommand("barrage", function(source, args, rawCommand)
    local playerId = source
    if not IsPlayerPolice(playerId) then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Barrage',
            description = "Vous n'êtes pas autorisé à utiliser cette commande.",
            type = 'error'
        })
        return
    end

    -- Récupère la taille de la zone (si fournie)
    local size = tonumber(args[1])
    if size and size > 0 then
        radius = size
    end

    -- Définit la zone autour du joueur
    local playerPed = GetPlayerPed(source)
    if playerPed then
        local playerCoords = GetEntityCoords(playerPed)
        zoneCenter = playerCoords

        -- Active ou désactive le blocage
        trafficBlocked = not trafficBlocked
        TriggerClientEvent('traffic:setZone', -1, zoneCenter, radius)
        TriggerClientEvent('traffic:setState', -1, trafficBlocked, radius)
        TriggerClientEvent('traffic:showNotify', source, trafficBlocked, radius)

    end
end, false) -- false = tout le monde peut voir la commande, mais elle est restreinte par la fonction IsPlayerPolice
