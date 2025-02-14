Config = {}

-- Liste des métiers autorisés
Config.AuthorizedJobs = { 'mecano', 'autorace', 'reaper_motors' } 

-- Liste des véhicules valides
Config.ValidVehicles = { 'towtruck', 'flatbed', 'flatbed2','flatbed3' }
-- endroit ou l'on dépose les véhicule remorquer
Config.TowDestination = vector3(401.8678, -1633.5006, 29.3778)

-- Localisations pour les missions
Config.MissionLocations = {
    { ['x'] = -2480.8720703125, ['y'] = -211.96409606934, ['z'] = 17.397672653198 },
    { ['x'] = -2723.392578125, ['y'] = 13.207388877869, ['z'] = 15.12806892395 },
    { ['x'] = -3169.6235351563, ['y'] = 976.18127441406, ['z'] = 15.038360595703 },
    { ['x'] = -3139.7568359375, ['y'] = 1078.7182617188, ['z'] = 20.189767837524 },
    { ['x'] = -1656.9357910156, ['y'] = -246.16479492188, ['z'] = 54.510955810547 },
    { ['x'] = -1586.6560058594, ['y'] = -647.56115722656, ['z'] = 29.441320419312 },
    { ['x'] = -1036.1470947266, ['y'] = -491.05856323242, ['z'] = 36.214912414551 },
    { ['x'] = -1029.1884765625, ['y'] = -475.53167724609, ['z'] = 36.416831970215 },
    { ['x'] = 75.212287902832, ['y'] = 164.8522644043, ['z'] = 104.69123077393 },
    { ['x'] = -534.60491943359, ['y'] = -756.71801757813, ['z'] = 31.599143981934 },
    { ['x'] = 487.24212646484, ['y'] = -30.827201843262, ['z'] = 88.856712341309 },
    { ['x'] = -772.20111083984, ['y'] = -1281.8114013672, ['z'] = 4.5642876625061 },
    { ['x'] = -663.84173583984, ['y'] = -1206.9936523438, ['z'] = 10.171216011047 },
    { ['x'] = 719.12451171875, ['y'] = -767.77545166016, ['z'] = 24.892364501953 },
    { ['x'] = -970.95465087891, ['y'] = -2410.4453125, ['z'] = 13.344270706177 },
    { ['x'] = -1067.5234375, ['y'] = -2571.4064941406, ['z'] = 13.211874008179 },
    { ['x'] = -619.23968505859, ['y'] = -2207.2927246094, ['z'] = 5.5659561157227 },
    { ['x'] = 1192.0831298828, ['y'] = -1336.9086914063, ['z'] = 35.106426239014 },
    { ['x'] = -432.81033325195, ['y'] = -2166.0505371094, ['z'] = 9.8885231018066 },
    { ['x'] = -451.82403564453, ['y'] = -2269.34765625, ['z'] = 7.1719741821289 },
    { ['x'] = 939.26702880859, ['y'] = -2197.5390625, ['z'] = 30.546691894531 },
    { ['x'] = -556.11486816406, ['y'] = -1794.7312011719, ['z'] = 22.043060302734 },
    { ['x'] = 591.73504638672, ['y'] = -2628.2197265625, ['z'] = 5.5735430717468 },
    { ['x'] = 1654.515625, ['y'] = -2535.8325195313, ['z'] = 74.491394042969 },
    { ['x'] = 1642.6146240234, ['y'] = -2413.3159179688, ['z'] = 93.139915466309 },
    { ['x'] = 1371.3223876953, ['y'] = -2549.525390625, ['z'] = 47.575256347656 },
    { ['x'] = 383.83779907227, ['y'] = -1652.8695068359, ['z'] = 37.278503417969 },
    { ['x'] = 27.219129562378, ['y'] = -1030.8818359375, ['z'] = 29.414621353149 },
    { ['x'] = 229.26435852051, ['y'] = -365.91101074219, ['z'] = 43.750762939453 },
    { ['x'] = -85.809432983398, ['y'] = -51.665500640869, ['z'] = 61.10591506958 },
    { ['x'] = -4.5967531204224, ['y'] = -670.27124023438, ['z'] = 31.85863494873 },
    { ['x'] = -111.89884185791, ['y'] = 91.96940612793, ['z'] = 71.080169677734 },
    { ['x'] = -314.26129150391, ['y'] = -698.23309326172, ['z'] = 32.545776367188 },
    { ['x'] = -366.90979003906, ['y'] = 115.53963470459, ['z'] = 65.575706481934 },
    { ['x'] = -592.06726074219, ['y'] = 138.20733642578, ['z'] = 60.074813842773 },
    { ['x'] = -1613.8572998047, ['y'] = 18.759860992432, ['z'] = 61.799819946289 },
    { ['x'] = -1709.7995605469, ['y'] = 55.105819702148, ['z'] = 65.706237792969 },
    { ['x'] = -521.88830566406, ['y'] = -266.7805480957, ['z'] = 34.940990447998 },
    { ['x'] = -451.08666992188, ['y'] = -333.52026367188, ['z'] = 34.021533966064 },
    { ['x'] = 322.36480712891, ['y'] = -1900.4990234375, ['z'] = 25.773607254028 },
}

  
Config.Vehicles = {
    'adder',
    'asea',
    'asterope',
    'banshee',
    'buffalo'
}

-- Liste des modèles de peds à spawn aléatoirement
Config.Peds = {
    "a_m_m_business_01", -- Remplacez par vos modèles de peds
    "a_f_m_beach_01",
    "a_m_y_skater_01"
}

Config.PayoutRange = { min = 300, max = 600 } -- Remplacez par votre plage souhaitée

--Config.PayoutAmount = 100 -- Montant total à distribuer
Config.PayoutPercentage = {
    player = 40, -- Pourcentage pour le joueur
    business = 60 -- Pourcentage pour l'entreprise
}