local createPool = require("./factory")

return createPool({
	Skins = {
		["Metal (Mad)"] = { Quantity = 1, Chance = 50 },
		["Igres (Mad)"] = { Quantity = 1, Chance = 35 },
		["Igres (Dark)"] = { Quantity = 1, Chance = 20 },
		["Kargalgan (Mad)"] = { Quantity = 1, Chance = 5 },
		["Baek (Elite)"] = { Quantity = 1, Chance = 2.5 },
		["Igres (Revealed)"] = { Quantity = 1, Chance = 0.5 },
	},
	Items = {
		TraitCrystal = { Quantity = math.random(1, 3), Chance = 10 },
		PotentialKey = { Quantity = math.random(1, 3), Chance = 10 },
		RandomStar = {
			Quantity = 1,
			Rewards = {
				OrangeStar = { Quantity = math.random(2, 4), Chance = 25 },
				BlueStar = { Quantity = math.random(2, 4), Chance = 50 },
				GreenStar = { Quantity = math.random(2, 4), Chance = 50 },
				PurpleStar = { Quantity = math.random(2, 4), Chance = 50 },
				RedStar = { Quantity = math.random(2, 4), Chance = 50 },
				RainbowStar = { Quantity = math.random(1, 2), Chance = 5 },
			},
			Chance = 10,
		},
	},
})
