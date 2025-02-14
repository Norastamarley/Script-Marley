Config = {}

---- config des machine targettable -----
Config.snak = {
    "prop_vend_snak_01",
    "prop_vend_snak_01_tu",
}

Config.soda = {
    "prop_vend_soda_01",
    "prop_vend_soda_02",
}

Config.coffe = {
    "prop_vend_coffe_01",
}

Config.water = {
    "prop_vend_water_01",
    "prop_watercooler_dark",
    "2603322528"
}

---- config des objet dans les machine -----

Config.objects = {
 
    ['machineSoda'] = {
        {
            item = 'canettecoca',      -- Nom de l'item dans l'inventaire
            label = 'canette de coca',     -- Label affiché
            price = 500,          -- prix
            image = 'https://emojis.sh/emoji/une-canette-de-coca-0xguDJYI0j'          -- Chemin de l'image
        }
    },
    ['machineWater'] = {
        {
            item = 'water',    
            label = 'Eau',     
            price = 3,
            image = 'image/water_image.png'
        }
    },
    ['machineSnak'] = {
        {
            item = 'chips',     
            label = 'Chips',    
            price = 7,
            image = ''
        }
    },
    ['machineCoffe'] = {
        {
            item = 'coffe',    
            label = 'café',
            price = 10,          
            image = 'https://files.prineside.com/gtasa_samp_model_id/white/19835_w.jpg' 
        },
        {
            item = 'coffe',    
            label = 'cappucino',
            price = 15,          
            image = 'https://files.prineside.com/gtasa_samp_model_id/white/19835_w.jpg' 
        }

    }
}
