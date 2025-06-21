--------------------------------------------------------------------------------
-- HellTowerData
-- Configuration data for Hell Tower system
-- Contains milestone rewards, seasons, and other static configuration
--------------------------------------------------------------------------------

-- Type definitions
export type CurrencyReward = {
	Gold: number?,
	Gems: number?,
}

export type ItemReward = {
	[string]: number,
}

export type UnitReward = {
	[string]: number,
}

export type MilestoneReward = {
	Currencies: CurrencyReward,
	Items: ItemReward,
	Units: UnitReward,
}

export type MilestoneEntry = {
	Rewards: MilestoneReward,
	CustomText: string?,
}

export type ElementRange = {
	Min: number,
	Max: number,
}

export type FloorData = {
	Map: string,
	Act: number,
	Elements: { [string]: ElementRange }?,
}

export type HellTowerConfig = {
	Season: number,
	MilestoneRewards: { [number]: MilestoneEntry },
	RanksData: { [number]: string },
	RandomSeed: number,
	RoomElementsStartFrom: number,
	ElementsTable: { string },
	ElementsRange: NumberRange,
}

-- Configuration data
local config: HellTowerConfig = {
	Season = 2, -- Change forward to reset HellTower

	MilestoneRewards = {
		[5] = {
			Rewards = {
				Currencies = {},
				Items = {
					TraitCrystal = 5,
				},
				Units = {},
			},
		},

		[10] = {
			Rewards = {
				Currencies = {
					Gold = 15_000,
				},
				Items = {},
				Units = {},
			},
		},

		[15] = {
			Rewards = {
				Currencies = {
					Gems = 250,
				},
				Items = {
					PotentialKey = 10,
				},
				Units = {},
			},
		},

		[20] = {
			Rewards = {
				Currencies = {},
				Items = {
					FrostKey = 5,
				},
				Units = {},
			},
		},

		[25] = {
			Rewards = {
				Currencies = {},
				Items = {
					TraitCrystal = 10,
				},
				Units = {},
			},
		},

		[30] = {
			Rewards = {
				Currencies = {
					Gold = 20_000,
				},
				Items = {
					FrostKey = 5,
				},
				Units = {},
			},
		},

		[35] = {
			Rewards = {
				Currencies = {
					Gems = 500,
				},
				Items = {
					PotentialKey = 15,
				},
				Units = {},
			},
		},

		[40] = {
			Rewards = {
				Currencies = {},
				Items = {
					FrostKey = 10,
				},
				Units = {},
			},
		},

		[45] = {
			Rewards = {
				Currencies = {
					Gold = 25_000,
					Gems = 250,
				},
				Items = {
					PotentialKey = 5,
				},
				Units = {},
			},
		},

		[50] = {
			Rewards = {
				Currencies = {},
				Items = {
					RainbowStar = 2,
					RedStar = 2,
					GreenStar = 2,
					BlueStar = 2,
					OrangeStar = 2,
					PurpleStar = 2,
				},
				Units = {},
			},
			CustomText = "2x All Stars!",
		},

		[55] = {
			Rewards = {
				Currencies = {},
				Items = {
					TraitCrystal = 20,
				},
				Units = {},
			},
		},

		[60] = {
			Rewards = {
				Currencies = {},
				Items = {
					FrostKey = 20,
				},
				Units = {},
			},
		},

		[65] = {
			Rewards = {
				Currencies = {
					Gold = 30_000,
				},
				Items = {
					TraitCrystal = 5,
				},
				Units = {},
			},
		},

		[70] = {
			Rewards = {
				Currencies = {
					Gems = 300,
				},
				Items = {
					PotentialKey = 20,
				},
				Units = {},
			},
		},

		[75] = {
			Rewards = {
				Currencies = {},
				Items = {
					TraitCrystal = 25,
				},
				Units = {},
			},
		},

		[80] = {
			Rewards = {
				Currencies = {
					Gold = 50_000,
				},
				Items = {
					RainbowStar = 5,
				},
				Units = {},
			},
		},

		[85] = {
			Rewards = {
				Currencies = {
					Gems = 375,
				},
				Items = {
					PotentialKey = 30,
				},
				Units = {},
			},
		},

		[90] = {
			Rewards = {
				Currencies = {},
				Items = {
					TraitCrystal = 40,
				},
				Units = {},
			},
		},

		[95] = {
			Rewards = {
				Currencies = {},
				Items = {
					FrostKey = 25,
				},
				Units = {},
			},
		},

		[100] = {
			Rewards = {
				Currencies = {},
				Items = {
					TraitCrystal = 50,
				},
				Units = {
					Caulifla = 1,
				},
			},
		},
	},

	RanksData = {
		[0] = "Noobie",
		[10] = "Novice",
		[25] = "Apprentice",
		[50] = "Skilled",
		[100] = "Master",
		[250] = "Grandmaster",
		[500] = "Apex",
		[1000] = "Legend",
		[10000] = "???",
	},

	RandomSeed = 1740942376,
	RoomElementsStartFrom = 75,
	ElementsTable = {
		"Fierce",
		"Dark",
		"Fire",
		"Ice",
		"Light",
		"Water",
		"Wind",
	},
	ElementsRange = NumberRange.new(-125, -125),
}

-- Map rotation for floor generation
local MAP_ROTATION = {
	"Leaf Village",
	"West City",
	"Land of the Sky",
	"Red Army HQ",
	"Fujishima Island",
	"Ghost Tunnel",
	"Clover Kingdom",
}

-- Factory functions
local function createMilestoneReward(
	currencies: CurrencyReward?,
	items: ItemReward?,
	units: UnitReward?
): MilestoneReward
	return {
		Currencies = currencies or {},
		Items = items or {},
		Units = units or {},
	}
end

local function createMilestoneEntry(reward: MilestoneReward, customText: string?): MilestoneEntry
	return {
		Rewards = reward,
		CustomText = customText,
	}
end

local function createFloorData(map: string, act: number, elements: { [string]: ElementRange }?): FloorData
	return {
		Map = map,
		Act = act,
		Elements = elements,
	}
end

-- Generate floor data for a given floor number (moved from old registry)
local function generateFloor(floor: number): FloorData
	-- Calculate map index based on floor
	local mapIndex = ((floor - 1) % #MAP_ROTATION) + 1
	local map = MAP_ROTATION[mapIndex]

	-- Calculate act based on floor progression
	local act = math.max(1, math.floor((floor - 1) / 10) + 1)

	-- Generate elements for higher floors (after RoomElementsStartFrom)
	local elements = nil
	if floor >= config.RoomElementsStartFrom then
		elements = {}

		-- Add random elements based on floor difficulty
		for _, element in ipairs(config.ElementsTable) do
			elements[element] = {
				Min = config.ElementsRange.Min,
				Max = config.ElementsRange.Max,
			}
		end
	end

	return createFloorData(map, act, elements)
end

-- Export the configuration and factory functions
return {
	-- Configuration
	Season = config.Season,
	MilestoneRewards = config.MilestoneRewards,
	RanksData = config.RanksData,
	RandomSeed = config.RandomSeed,
	RoomElementsStartFrom = config.RoomElementsStartFrom,
	ElementsTable = config.ElementsTable,
	ElementsRange = config.ElementsRange,

	-- Constants
	MAP_ROTATION = MAP_ROTATION,
	-- Factory functions
	createMilestoneReward = createMilestoneReward,
	createMilestoneEntry = createMilestoneEntry,
	createFloorData = createFloorData,
	generateFloor = generateFloor,

	-- Types
	Config = config,
}
