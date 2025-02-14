Config = {}

-- Liste des stations de cuisine
Config.CookingStations = {
    { prop = 'prop_cooker_03', label = 'Cuisinière', stationType = 'stove' },
    { prop = 'prop_bbq_4', label = 'Barbecue', stationType = 'bbq' },
    { prop = 'prop_oven_01', label = 'Four', stationType = 'oven' },
    { prop = 'prop_blender_01', label = 'Blender', stationType = 'blender'},
    { prop = 'prop_bbq_1', label = 'Barbecue', stationType = 'bbq' },
    { prop = 'prop_bbq_5', label = 'Barbecue', stationType = 'bbq' },
    { prop = 'prop_bbq_2', label = 'Barbecue', stationType = 'bbq' },
    { prop = 'prop_bbq_4', label = 'Barbecue', stationType = 'bbq' },
    { prop = 'prop_bbq_4_l1', label = 'Barbecue', stationType = 'bbq' },
    { prop = 'v_res_ovenhobmod',  label = 'Cuisinière', stationType = 'stove' },
    { prop = 'prop_kitch_juicer', label = 'Blender', stationType = 'blender'},
    { prop = 'prop_coffee_mac_02', label = 'caftière', stationType = 'coffee'},
    { prop = 'apa_mp_h_acc_coffeemachine_01', label = 'caftière', stationType = 'coffee'},
    { prop = '1183048071 ', label = 'caftière', stationType = 'coffee'},
    { prop = '1796594030 ', label = 'Mico-onde', stationType = 'mocrowave'},
    
}

-- Recettes
Config.Recipes = {

        ['pasta_bolo'] = {
            label = 'Pâtes Bolognaises', -- Nom afficher dan sles Menu
            stationType = 'stove', -- Nécessite une cuisinière
            craftTime = 10000, -- Temps de craft en millisecondes
            prop = {
                model = 'prop_kitch_pot_lrg2', -- model de l'obejt
                pos = {x = 0.3, y = 0.6, z = 0.1}, 
                rot = {x = 0.0, y = 0.0, z = -90.0},-- Rotation de l'objet
                bone = 57,
            },
            anim = {
                dict = 'amb@prop_human_bbq@male@idle_a', -- répertoir de l'animation
                clip = 'idle_b', -- nom de l'annimation
                duration = 57005 , -- durée de lanimation005, -- Bone à attacher
            },
            ingredients = { -- egrédient que consome la recette
                { name = 'tomate', label = 'Tomate', count = 3 },
                { name = 'pasta', label = 'Pâtes', count = 1 },
                { name = 'water', label = 'Eau', count = 1 }
            },
            result = {  
                name = 'pasta_bolo', -- résulta de la recette 
                label = 'Pâtes Bolognaises', 
                count = 5 
            },
        },
       
    
        ['saucisse_griller'] = {
            label = 'Saucisse grillée',
            stationType = 'bbq', 
            craftTime = 5000,
            prop = {
                model = 'bkr_prop_coke_spatula_04', 
                pos = {x = 0.2, y = 0.0, z = 0.0},
                rot = {x = 180.0, y = 90.0, z = -90.0},
                bone = 57005,  
            },
            anim = {
                dict = 'amb@prop_human_bbq@male@idle_b', 
                clip = 'idle_d',  
                duration = 5000,  
            },
            ingredients = {
                { name = 'saucisse_cru', label = 'Saucisse crue', count = 1 },
            },
            result = {
                name = 'saucisse_griller',
                label = 'Saucisse grillée',
                count = 1,
            },
        },

        ['cold_fast_food'] = {
            label = 'Plat préparer',
            stationType = 'mocrowave', 
            craftTime = 5000,
            prop = {
                model = '', 
                pos = {x = 0.2, y = 0.0, z = 0.0},
                rot = {x = 180.0, y = 90.0, z = -90.0},
                bone = 57005,  
            },
            anim = {
                dict = '', 
                clip = '',  
                duration = 5000,  
            },
            ingredients = {
                { name = 'cold_fast_food', label = 'plat préparer froid', count = 1 },
            },
            result = {
                name = 'fast_food ',
                label = 'plat préparer',
                count = 1,
            },
        },

}

-- Associer les items à leurs modèles de props
Config.PosableProps = {
  ['camp_chair'] = { prop = "xm3_prop_xm3_folding_chair_01a", label = 'Chaise de camping'}, -- Nom de l'item : Modèle du prop
  ['camp_table'] =  { prop = "prop_ven_market_table1", label = 'Table de camping'},
  ['bbq'] = { prop = "prop_bbq_2", label = 'BBQ'},
  ['camp_chair_1'] = { prop = "hei_prop_hei_skid_chair", label = 'Chaise de camping'},
  ['camp_tent'] = { prop = "prop_skid_tent_01", label = 'toile de camping'},

}


