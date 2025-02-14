-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

Config = {}

Config.checkForUpdates = false -- Check for Updates?

Config.Elevators = {
 
    casino = { -- Elevator name(Doesn't show it's just to name table)
        [1] = {
            coords = vec3(2464.7725, -279.4682, -58.4681), -- Coords, if you're new; last number is heading
            heading = 302.1483, -- Heading of how will spawn on floor
            title = 'Main hall', -- Title 
            description = 'Casino', -- Description
            target = { -- Target length/width
                width = 8,
                length = 6
            },
            item = 'casino_card',
            --  groups = {-- Job locks
            --'police',
            --'ambulance'
        --},
        },
        [2] = {
            coords = vec3(964.5359, 58.9204, 112.5530), -- Coords, if you're new; last number is heading
            heading = 53.5452, -- Heading of how will spawn on floor964.4783, 58.8351, 112.5530, 56.8957
            title = 'Rooftop', -- Title 
            description = 'Rooftop / pentahouse ', -- Description
            target = { -- Target length/width
                width = 5,
                length = 4
            },
           -- item = 'casino_card',
        --    groups = {-- Job locks
            -- 'police',
            -- 'ambulance'
        --},
        },

    },
    MissionRowLeft = { -- Elevator name(Doesn't show it's just to name table
        [1] = {
            coords = vec3(450.1654, -973.4477, 30.5262), -- Coords, if you're new; last number is heading
            heading = 20.0, -- Heading of how will spawn on floor
            title = '1', -- Title 
            description = 'Accueil', -- Description
            target = { -- Target length/width
                width = 5,
                length = 4
            },
        --  groups = {-- Job locks
            --'police',
            --'ambulance'
        --},
        },
        [2] = {
            coords = vec3(450.2259, -973.5877, 35.7979), -- Coords, if you're new; last number is heading
            heading = 20.0, -- Heading of how will spawn on floor
            title = '2', -- Title 
            description = 'Bureau/cafeteria', -- Description
            target = { -- Target length/width
                width = 5,
                length = 4
            },
        --  groups = {-- Job locks
            --'police',
            --'ambulance'
        --},
        },
        [3] = {
            coords = vec3(440.3709, -979.9277, 21.5596), -- Coords, if you're new; last number is heading
            heading = 20.0, -- Heading of how will spawn on floor
            title = '-1', -- Title 
            description = 'Cellule/Garage', -- Description
            target = { -- Target length/width
                width = 5,
                length = 4
            },
        --  groups = {-- Job locks
            --'police',
            --'ambulance'
        --},
        },   
    },
    MissionRowRight = { -- Elevator name(Doesn't show it's just to name table
    [1] = {
        coords = vec3(453.4786, -974.1015, 30.5262), -- Coords, if you're new; last number is heading
        heading = 20.0, -- Heading of how will spawn on floor
        title = '1', -- Title 
        description = 'Accueil', -- Description
        target = { -- Target length/width
            width = 5,
            length = 4
        },
    --  groups = {-- Job locks
        --'police',
        --'ambulance'
    --},
    },
    [2] = {
        coords = vec3(453.2759, -973.9297, 35.7979), -- Coords, if you're new; last number is heading
        heading = 20.0, -- Heading of how will spawn on floor
        title = '2', -- Title 
        description = 'Bureau/cafeteria', -- Description
        target = { -- Target length/width
            width = 5,
            length = 4
        },
    --  groups = {-- Job locks
        --'police',
        --'ambulance'
    --},
    },
    [3] = {
        coords = vec3(440.5933, -980.0170, 21.5596), -- Coords, if you're new; last number is heading
        heading = 20.0, -- Heading of how will spawn on floor
        title = '-1', -- Title 
        description = 'Cellule/Garage', -- Description
        target = { -- Target length/width
            width = 5,
            length = 4
        },
    --  groups = {-- Job locks
        --'police',
        --'ambulance'
    --},
    },   
},
}