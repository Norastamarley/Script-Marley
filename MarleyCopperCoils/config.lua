Config = {}

Config.props = {

    "prop_elecbox_01a",
    "prop_elecbox_01b",
    "prop_elecbox_02a",
    "prop_elecbox_02b",
    "prop_elecbox_04a",
    "prop_elecbox_05a",
    "prop_elecbox_07a",
    "prop_elecbox_09",
    "prop_elecbox_10",
    "prop_elecbox_11",

}

Config.Item = "drill"

Config.rewards = {
    { item = 'filcuivre'}, 
    
}

Config.policeAlert = true
Config.chanceAlert = 5 -- 5/100 chance 
Config.cooldowns = 300000  --ms = 5 minutes

-- Mode de difficulté (set ou random)
Config.difficultyMode = 'random' -- Changez à 'set' pour une difficulté fixe
Config.setDifficulty = 'medium' -- Difficulté fixe si le mode est 'set'

-- Configuration des niveaux de difficulté
Config.skillCheckDifficulty = {
    easy = {
        difficulty = 'easy',
        areaSize = 40,
        speedMultiplier = 1.5,
        keyPresses = {'q', 'd'},
        rewardRange = {min = 1, max = 2} -- Récompense pour la difficulté facile
    },
    medium = {
        difficulty = 'medium',
        areaSize = 30,
        speedMultiplier = 1.25,
        keyPresses = {'e', 'f'},
        rewardRange = {min = 1, max = 4} -- Récompense pour la difficulté moyenne
    },
    hard = {
        difficulty = 'hard',
        areaSize = 20,
        speedMultiplier = 1,
        keyPresses = {'r', 't'},
        rewardRange = {min = 4, max = 10} -- Récompense pour la difficulté difficile
    }
}

Config.jobBlacklist = {"police", "sheriff", "ambulance"}

