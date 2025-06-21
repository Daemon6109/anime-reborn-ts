--!strict
--------------------------------------------------------------------------------
-- Challenges Constants
-- Configuration for all challenges in the game
--------------------------------------------------------------------------------

export type ChallengeData = {
	id: string,
	name: string,
	description: string,
	type: string,
	difficulty: string,
	requirements: { [string]: any },
	rewards: {
		coins: number?,
		gems: number?,
		experience: number?,
		items: { [string]: number }?,
		titles: { string }?,
	},
	isRepeatable: boolean,
}

local Challenges = {
	-- Daily challenges
	["daily_win_3_games"] = {
		id = "daily_win_3_games",
		name = "Daily Victor",
		description = "Win 3 games today",
		type = "Daily",
		difficulty = "Easy",
		requirements = {
			gamesWon = 3,
		},
		rewards = {
			coins = 200,
			experience = 100,
		},
		isRepeatable = true,
	},

	["daily_summon_10_units"] = {
		id = "daily_summon_10_units",
		name = "Daily Summoner",
		description = "Summon 10 units today",
		type = "Daily",
		difficulty = "Easy",
		requirements = {
			unitsSummoned = 10,
		},
		rewards = {
			coins = 150,
			gems = 5,
		},
		isRepeatable = true,
	},

	-- Weekly challenges
	["weekly_complete_20_stages"] = {
		id = "weekly_complete_20_stages",
		name = "Stage Master",
		description = "Complete 20 stages this week",
		type = "Weekly",
		difficulty = "Normal",
		requirements = {
			stagesCompleted = 20,
		},
		rewards = {
			coins = 1000,
			gems = 25,
			experience = 500,
		},
		isRepeatable = true,
	},

	["weekly_evolve_5_units"] = {
		id = "weekly_evolve_5_units",
		name = "Evolution Expert",
		description = "Evolve 5 units this week",
		type = "Weekly",
		difficulty = "Hard",
		requirements = {
			unitsEvolved = 5,
		},
		rewards = {
			gems = 50,
			items = {
				evolution_crystal = 3,
			},
		},
		isRepeatable = true,
	},

	-- Achievement challenges
	["first_legendary_unit"] = {
		id = "first_legendary_unit",
		name = "Legendary Collector",
		description = "Obtain your first legendary unit",
		type = "Achievement",
		difficulty = "Special",
		requirements = {
			legendaryUnitsOwned = 1,
		},
		rewards = {
			gems = 100,
			titles = { "Legendary_Collector" },
		},
		isRepeatable = false,
	},

	["win_100_games"] = {
		id = "win_100_games",
		name = "Century Victor",
		description = "Win 100 total games",
		type = "Achievement",
		difficulty = "Hard",
		requirements = {
			totalGamesWon = 100,
		},
		rewards = {
			gems = 250,
			titles = { "Century_Victor" },
			items = {
				legendary_crate = 1,
			},
		},
		isRepeatable = false,
	},

	-- Special event challenges
	["event_defeat_boss_10_times"] = {
		id = "event_defeat_boss_10_times",
		name = "Boss Hunter",
		description = "Defeat any boss 10 times during the event",
		type = "Event",
		difficulty = "Hard",
		requirements = {
			bossesDefeated = 10,
		},
		rewards = {
			gems = 150,
			items = {
				special_crate = 5,
			},
		},
		isRepeatable = false,
	},
}

return Challenges
