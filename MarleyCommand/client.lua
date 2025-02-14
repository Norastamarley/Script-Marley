ESX = exports["es_extended"]:getSharedObject()
RegisterCommand('momeg', function()
    lib.showContext('cmd')
end)


lib.registerContext({
  id = 'cmd',
  title = '📋 Menu Aide',
  options = {
    {
        title = '🕴️ Personnage',
        description = 'Options liées au personnage',
        arrow = true,
        menu = 'personnage',
    },
      {
          title = '💰 Boutique Oméga',
          description = 'La boutique du serveur',
          arrow = true,
          menu = 'boutique',
      },
      {
          title = '🏋️‍♂️ Sport',
          description = 'Gestion du sport',
          arrow = true,
          menu = 'sport',
      },
      {
          title = '⌨️ Touche',
          description = 'Voir les raccourcis du serveur',
          arrow = true,
          menu = 'touche',
      },
      {
        title = '❓  Information',
        description = 'Informations utiles sur le serveur',
        arrow = true,
        menu = 'information',
    },
   --[[  {
          title = '🐾 Gestion animal',
          description = 'Gestion de ton animal de compagnie',
          arrow = true,
          menu = 'animal',
      }, ]]
  },
})

lib.registerContext({
  id = 'sport',
  title = '🏋️ Menu Sport',
  menu = 'cmd',
  options = {
      {
          title = '📊 Stat',
          description = 'Statistiques personnelles',
          onSelect = function()
              ExecuteCommand('physique')
          end,
      },
      {
          title = '💪 Pompes',
          description = 'Faire des pompes',
          onSelect = function()
              ExecuteCommand('pompe')
          end,
      },
      {
          title = '🛠️ Abdos',
          description = 'Faire des abdos',
          onSelect = function()
              ExecuteCommand('abdos')
          end,
      },
      {
          title = '🧘 Yoga',
          description = 'Faire du yoga',
          onSelect = function()
              ExecuteCommand('yoga')
          end,
      },
  },
})


  lib.registerContext({
    id = 'touche',
    title = 'Raccourcis',
    menu = 'cmd',
   
    options = {
        {
            title = 'Régulateur de vitesse',
           -- description = 'Example button description',
            icon = 'circle',
            readOnly = true,
        
            metadata = {
                {label = 'Monter le Régulateur ', value = 'flèche du haut'},
                {label = 'Monter le Régulateur ', value = 'flèche du haut'},
                {label = 'Allumer le Régulateur ', value = 'K'},
            },
        },
        {
            title = 'Téléphone',
            description = 'Touche F1',
            icon = 'circle',
            readOnly = true,
        
            
        },
        {
            title = 'Menu animation',
            description = 'Touche F2',
            icon = 'circle',
            readOnly = true,

            
            metadata = {
                {label = 'Lever les mains', value = 'X'},
                {label = 'Pointer du doigt', value = 'B'},
                {label = 'Ragdoll', value = 'W'},
                {label = 'Annuler L\'animation', value = 'X'},
            },
        },
        {
            title = 'Ouvrir/Fermer véhicule',
            description = 'Touche U',
            icon = 'circle',
            readOnly = true,
            
            metadata = {
                {label = 'Menu clé voiture', value = 'presse 2 fois pour ouvrir les option de la clée'},
            },
        },
        {
            title = 'allumer/éteindre moteur',
            description = 'Touche G',
            icon = 'circle',
            readOnly = true,
            
        },
        {
            title = 'ceinture sécurité',
            description = 'Touche B',
            icon = 'circle',
            readOnly = true,
            
        },
        {
            title = 'Ouvrir le menu facture',
            description = 'Touche F7',
            icon = 'circle',
            readOnly = true,
         
        },
        {
            title = 'Ouvrir le menu job',
            description = 'Touche F6',
            icon = 'circle',
            readOnly = true,
         
        },
        {
            title = 'Ouvrir le menu Illégal',
            description = 'Touche F9',
            icon = 'circle',
            readOnly = true,
         
        },
    }
  })


  lib.registerContext({
    id = 'information',
    title = '❓ Informations du serveur',
    menu = 'cmd',
    options = {
      {
          title = '🚗 Voitures persistantes',
          description = "Elles ne disparaissent pas à votre déconnexion ou tempête. Pensez à bien les garer.",
          icon = 'car',
          readOnly = true,
      },
      {
          title = '📡 Radar',
          description = "Des radars existent en ville. Ils informent la police et vous retirent de l'argent en cas d'infraction (icône sur la carte).",
          icon = 'radar',
          readOnly = true,
      },
      {
          title = '🏋️ Physique',
          description = "Améliorez votre physique pour augmenter votre rapidité, force au combat, etc.",
          icon = 'dumbbell',
          readOnly = true,
      },
      {
          title = '💰 Braquages',
          description = "Il est interdit de se faire braquer ou de braquer en ville ou dans les lieux publics.",
          icon = 'ban',
          readOnly = true,
      },
      {
          title = '🎭 RP',
          description = "Merci de garder un RP correct. Pensez au massRP et au fearRP. Une arme peut entraîner la suppression de votre personnage.",
          icon = 'book',
          readOnly = true,
      },
      {
          title = '🎉 Amusez-vous',
          description = "Nous avons plein d'activités sur le serveur. Éclatez-vous !",
          icon = 'smile',
          readOnly = true,
      },
      {
          title = '👥 Parrainage',
          description = "Pensez à utiliser le code parrainage si vous invitez des joueurs. Commande : /parrain.",
          icon = 'user-friends',
          readOnly = true,
      },
      {
          title = '❓ Questions',
          description = "Si vous avez des questions, merci d'utiliser le Discord. Notre staff est disponible pour vous.",
          icon = 'question-circle',
          readOnly = true,
      },
    },
  })
  


  lib.registerContext({
    id = 'personnage',
    title = '🕴️ Menu Personnage',
    menu = 'cmd',
    options = {
        {
            title = '🎒 Inventaire',
            description = 'Ouvrez votre inventaire',
            onSelect = function()
                ExecuteCommand('inventory')
            end,
        },
        {
            title = '🎭 Animations',
            description = 'Ouvrez le menu des animations',
            onSelect = function()
                ExecuteCommand('emote')
            end,
        },
        {
            title = '👕 Vêtement',
            description = 'Ouvrez le menu vêtement',
            onSelect = function()
                ExecuteCommand('vetement')
            end,
        },
        {
            title = '🖥️ Modification HUD',
            description = 'Personnalisez votre interface HUD',
            onSelect = function()
                ExecuteCommand('hud')
            end,
        },
        {
            title = '🎮 Menu Fun',
            description = 'Amusez-vous avec des mini-jeux',
            arrow = true,
            menu = 'fun',
        },
        
    }
  })
---===== Boutique Menu =====---
lib.registerContext({
  id = 'boutique',
  title = '💰 Boutique Oméga',
  menu = 'cmd',
  options = {
      {
          title = '🔓 Battlepass',
          description = 'Ouvrez le battle pass de Oméga Rp',
          onSelect = function()
              ExecuteCommand('battlepass')
          end,
      },
      {
          title = '🎁 Caisse',
          description = 'Ouvrez le menu caisse de Oméga Rp',
          onSelect = function()
              ExecuteCommand('caisse')
          end,
      },
   --[[ {
        title = '🎁 Vote serveur',
        description = 'Votez pour le serveur et gagner des récompense',
        onSelect = function()
            openExternalWebsite()
        end,
    },]]
   
  }
})
--[[
---======== pet menu ========---
lib.registerContext({
  id = 'animal',
  title = '🐾 Gestion animal',
  menu = 'cmd',
  options = {
      {
          title = '🦴 Menu animal',
          description = 'Ouvrez le menu gestion de l\'animal',
          onSelect = function()
              ExecuteCommand('petmenu')
          end,
      },
      {
          title = '👗 Garde robe',
          description = 'Ouvrez la garde robe de votre animal',
          onSelect = function()
              ExecuteCommand('petwardrobe')
          end,
      },
      {
          title = '🤝 Interaction animal',
          description = 'Menu interaction de votre animal',
          onSelect = function()
              ExecuteCommand('petemote')
          end,
      },
  }
})
]]

---===== Menu Fun =====---
lib.registerContext({
    id = 'fun',
    title = '🎮 Menu Fun',
    menu = 'cmd',
    options = {
        {
            title = '✊ Pierre-Feuille-Ciseaux',
            description = 'Jouez une partie contre un adversaire',
            onSelect = function()
                ExecuteCommand('pfc')
            end,
        },
        {
            title = '🎲 Lancer de dé',
            description = 'Lancer un dé à 6 faces',
            onSelect = function()
                ExecuteCommand('roll')
            end,
        },
    }
  })
  


RegisterKeyMapping("momeg", "Ouvrir le menu aide", "keyboard", "F5")

RegisterCommand('inventory', function()
    local playerId = GetPlayerServerId(PlayerId())
    exports.ox_inventory:openInventory('player', playerId)
end, false)

RegisterCommand('pfc', function(source, args)
    -- Vérifie si un joueur proche est sélectionné via ox_target
    local targetPlayer = args[1] -- Récupérer l'ID cible
    if not targetPlayer then
        lib.notify({
            title = "Pierre-Feuille-Ciseaux",
            description = "Sélectionnez un joueur proche avec ox_target pour jouer.",
            type = "error"
        })
        return
    end

    local choices = {"Pierre", "Feuille", "Ciseaux"}

    -- Invite le joueur cible
    TriggerServerEvent('pfc:invite', targetPlayer, choices)
end, false)

-- Gestion de l'invitation sur le serveur
RegisterNetEvent('pfc:invite', function(choices)
    local playerChoice = lib.inputDialog("Pierre-Feuille-Ciseaux", {"Choisissez : Pierre, Feuille ou Ciseaux"})
    if playerChoice then
        playerChoice = string.lower(playerChoice[1])
        if not (playerChoice == "pierre" or playerChoice == "feuille" or playerChoice == "ciseaux") then
            lib.notify({
                title = "Pierre-Feuille-Ciseaux",
                description = "Choix invalide !",
                type = "error"
            })
            return
        end

        local opponentChoice = choices[math.random(1, #choices)]
        local result
        if playerChoice == opponentChoice then
            result = "Égalité !"
        elseif (playerChoice == "pierre" and opponentChoice == "ciseaux") or
               (playerChoice == "feuille" and opponentChoice == "pierre") or
               (playerChoice == "ciseaux" and opponentChoice == "feuille") then
            result = "Vous avez gagné ! 🎉"
        else
            result = "Vous avez perdu... 😢"
        end

        lib.notify({
            title = "Pierre-Feuille-Ciseaux",
            description = string.format("Votre choix : %s\nAdversaire : %s\nRésultat : %s", playerChoice, opponentChoice, result),
            type = "info"
        })
    end
end)



RegisterCommand('roll', function()
    local diceResult = math.random(1, 6) 
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent('roll:notifyNearby', diceResult)
end, false)


RegisterNetEvent('roll:showDiceResult')
AddEventHandler('roll:showDiceResult', function(playerId, diceResult)
    if not diceResult then
        print("Erreur : diceResult est nil")
        return
    end

    local displayTime = 5
    local startTime = GetGameTimer()

    CreateThread(function()
        while GetGameTimer() - startTime < displayTime * 1000 do
            Wait(0)
            local ped = GetPlayerPed(GetPlayerFromServerId(playerId))
            if DoesEntityExist(ped) then
                local coords = GetEntityCoords(ped)
                DrawText3D(coords.x, coords.y, coords.z + 1.0, string.format("🎲 %d", diceResult))
            end
        end
    end)
end)


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
----- Open top serveur ------

function openExternalWebsite()
    local url = "https://top-serveurs.net/gta/omegaroleplay"
  

    ExecuteCommand("explorer  " .. url)
 
end

-------- Weazel news ---------

RegisterNetEvent("breakingNews:openDialog")
AddEventHandler("breakingNews:openDialog", function()
    local input = lib.inputDialog("Breaking News", {
        {type = "input", label = "Titre", placeholder = "Saisissez le titre",min = 1, max = 150},
        {type = "input", label = "Message", placeholder = "Saisissez le message",min = 1, max = 62},-- 49
        {type = "input", label = "bas", placeholder = "Saisissez le message", default = "Waezel News",min = 1, max = 136},
        {type = "number", label = "Durée (secondes)", default = 5, min = 1, max = 10}
    })
    
    if input then
        local title = input[1] or "Breaking News"
        local message = input[2] or ""
        local position = input[3] or ""
        local duration = math.min(tonumber(input[4]) or 5, 10)
        
        TriggerServerEvent("breakingNews:send", title, message, position, duration)
    end
end)

RegisterNetEvent("breakingNews:notify")
AddEventHandler("breakingNews:notify", function(title, message, position, duration)
    ESX.Scaleform.ShowBreakingNews(title, message, position, duration)
end)
