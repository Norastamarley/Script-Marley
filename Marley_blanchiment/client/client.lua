ESX = exports["es_extended"]:getSharedObject()

-- Fonction pour vérifier si le joueur est proche des positions
local function isPlayerNearPositions()
    local playerPed = PlayerPedId()
    local plyCoords = GetEntityCoords(playerPed, false)
    local interactionDistance = 2.0 -- Distance maximale pour l'interaction

    for k, v in pairs(Config.PositionPoint) do
        local Vpos = vector3(v.x, v.y, v.z)
        local distance = #(plyCoords - Vpos)

        if distance <= interactionDistance then
            return true
        end
    end

    return false
end

exports.ox_target:addGlobalPed({

    {  
        label = 'blanchisseur',
        icon = "fa-solid fa-suitcase",

        canInteract = function()
            return isPlayerNearPositions()
        end,

        onSelect = function()
            discu()
        end

    }

})

function callpolice(callLocation,message,flashes,image)
    local playerPed = PlayerPedId()
    local playercoord = GetEntityCoords(playerPed)
    print(playercoord)

    TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
        job = { 'police', 'sheriff', 'traffic', 'patrol' },
        callLocation = vector3(playercoord.x,playercoord.y,playercoord.z),
        callCode = { code = 'Activitée suspect', snippet = '10-90' },
        message = "échange de valise pleine de billets",
        flashes = false, -- you can set to true if you need call flashing sirens...
       -- image = "URL", -- Url for image to attach to the call 
        --you can use the getSSURL export to get this url
        blip = {
            sprite = 161, --blip sprite
            scale = 5.5, -- blip scale
            colour = 1, -- blio colour
            flashes = false, -- blip flashes
            text = 'Echange d\'argent', -- blip text
            time = (20 * 1000), --blip fadeout time (1 * 60000) = 1 minute
        },
        otherData = {
    -- optional if you dont need this you can remove it and remember remove the `,` after blip end and this block
           {
               text = 'suspect non identifié', -- text of the other data item (can add more than one)
               icon = 'fas fa-user-secret', -- icon font awesome https://fontawesome.com/icons/
           }
         }
    })
end

-- création des peds

CreateThread(function()

    local Hash = GetHashKey("s_m_y_dealer_01")
    while not HasModelLoaded(Hash) do
		RequestModel(Hash)
		Wait(20)
	end

    for _, pos in ipairs(Config.PositionPoint) do
        local ped = CreatePed("PED_TYPE_CIVFEMALE", Hash, pos.x, pos.y, pos.z, pos.h, false, true)
        
        SetBlockingOfNonTemporaryEvents(ped, true)
        Citizen.Wait(5000)
        
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetEntityCoords(ped, pos.x, pos.y, pos.z,true, false, false, false)

    end

end)

-- lancement du dialogue

function discu()
    Visual.Subtitle("[~y~Vous~s~] Yo j'aurais de l'argent à faire blanchir", 3000)
    Wait(3000)
    Visual.Subtitle("[~r~Le V~s~] Ta combien à blanchir ?", 3000)
    Wait(3000)
    local input = lib.inputDialog('Combien veux tu blanchir ?', {
       
        {type = 'number', label = 'Argent sale',description = 'taux de '.. Config.Taxe.. ' %', icon = 'fa-solid fa-dollar-sign',min = 1000},
       
      })
    count = tonumber(input[1])
    
    Wait(500)
    Visual.Subtitle("[~y~Vous~s~] J'ai ~r~"..count.."$~s~ tu peut me les faires ?", 3000)
    Wait(3000)
    Visual.Subtitle("[~r~Le V~s~] Passe moi l'argent je vais compter", 300)
    TriggerServerEvent('marley:Blanchiment', count)
end

RegisterNetEvent("marley:Checked")
AddEventHandler("marley:Checked", function(amount)
    

    if lib.progressBar({
        duration = Config.TimetoProcess,
        label = 'blanchiment',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'timetable@gardener@filling_can', --- voir pour changer l'animation
            clip = 'gar_ig_5_filling_can'
        },
        prop = {
            model = `hei_prop_heist_trevor_case`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 180.0, 240.0)
        },
    }) then print('Do stuff when complete') else print('Do stuff when cancelled') end
  


    
    Visual.Subtitle("[~r~Le V~s~] Y'a bien le compte tiens ~g~"..amount.."$~s~ d'argent propre", 4000)
    Wait(4000)
    Visual.Subtitle("[~y~Vous~s~] Merci on ce revois plus tard", 3000)
    Wait(3000)
    Visual.Subtitle("[~r~Le V~s~] Vsy à plus frero", 3000)

    local policecall = GetRandomIntInRange(1,Config.ChanceCallPolice)

    if policecall == 1 and Config.PoliceCall == true then
      
        Wait(4000)
        callpolice()
    end

end)

RegisterNetEvent("marley:Unchecked")
AddEventHandler("marley:Unchecked", function()
   -- Wait(7000)
    Visual.Subtitle("[~r~Le V~s~] Tu te fou de ma geule y'a pas le compte !!", 4000)
    Wait(4000)
    Visual.Subtitle("[~r~Le V~s~] Dégage tu reviendras quand tu auras de l'argent", 4000)
    Wait(3000)
    Visual.Subtitle("[~y~Vous~s~] Okok calme", 3000)
end)



