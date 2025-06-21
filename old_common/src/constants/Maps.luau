--!strict
--------------------------------------------------------------------------------
-- Maps Constants
-- Configuration for all maps in the game
--------------------------------------------------------------------------------

export type MapData = {
	id: string,
	name: string,
	difficulty: string,
	waves: number,
	rewards: {
		coins: number,
		experience: number,
		gems: number?,
	},
	unlockLevel: number,
}

local Maps = {
	-- Tutorial maps
	["training_grounds"] = {
		id = "training_grounds",
		name = "Training Grounds",
		difficulty = "Tutorial",
		waves = 5,
		rewards = {
			coins = 50,
			experience = 25,
		},
		unlockLevel = 1,
	},

	-- Easy maps
	["grasslands"] = {
		id = "grasslands",
		name = "Peaceful Grasslands",
		difficulty = "Easy",
		waves = 10,
		rewards = {
			coins = 100,
			experience = 50,
			gems = 1,
		},
		unlockLevel = 3,
	},

	["forest_path"] = {
		id = "forest_path",
		name = "Forest Path",
		difficulty = "Easy",
		waves = 12,
		rewards = {
			coins = 120,
			experience = 60,
			gems = 2,
		},
		unlockLevel = 5,
	},

	-- Normal maps
	["rocky_canyon"] = {
		id = "rocky_canyon",
		name = "Rocky Canyon",
		difficulty = "Normal",
		waves = 15,
		rewards = {
			coins = 200,
			experience = 100,
			gems = 3,
		},
		unlockLevel = 10,
	},

	["desert_oasis"] = {
		id = "desert_oasis",
		name = "Desert Oasis",
		difficulty = "Normal",
		waves = 18,
		rewards = {
			coins = 250,
			experience = 125,
			gems = 4,
		},
		unlockLevel = 15,
	},

	-- Hard maps
	["volcanic_peaks"] = {
		id = "volcanic_peaks",
		name = "Volcanic Peaks",
		difficulty = "Hard",
		waves = 25,
		rewards = {
			coins = 400,
			experience = 200,
			gems = 8,
		},
		unlockLevel = 25,
	},

	-- Expert maps
	["celestial_realm"] = {
		id = "celestial_realm",
		name = "Celestial Realm",
		difficulty = "Expert",
		waves = 30,
		rewards = {
			coins = 800,
			experience = 400,
			gems = 15,
		},
		unlockLevel = 40,
	},
}

return Maps
