local createPool = require("./factory")

return createPool({
	Items = {
		["PotentialKey"] = { Quantity = 1, Chance = 45 },
		["BasicLuckPotion"] = { Quantity = 1, Chance = 5 },
	},
	Currencies = {
		["Candy Cane"] = { Quantity = math.random(200, 300), Chance = 5 },
		["Gems"] = { Quantity = math.random(50, 100), Chance = 45 },
	},
})
