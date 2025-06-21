export type MissionLevel = {
	CompletedTimes: { [string]: number },
	FastestTime: { [string]: number },
	Stars: { [string]: number },
	LockData: {
		MaxCompletedTimes: number,
		CompletedTimes: number,
		Time: number,
	}?,
}

export type MissionZone = {
	[number]: MissionLevel,
}

export type StoryMissions = {
	[string]: MissionZone,
}

export type InfiniteMission = {
	HighestWave: number,
	Stars: { [string]: number },
}

export type InfiniteMissions = {
	[string]: InfiniteMission,
}

export type MissionCompletionData = {
	Story: StoryMissions,
	Infinite: InfiniteMissions,
	Legend: { [string]: any },
	Challenge: { [string]: any },
	Adventure: { [string]: any },
	Raid: StoryMissions,
	Dungeon: StoryMissions,
}

local CompletedMissionStoryTemplate = {
	["West City"] = {
		[1] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[2] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[3] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[4] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[5] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[6] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
	},
}

local CompletedMissionRaidTemplate = {
	["Ancient Dungeon"] = {
		[1] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[2] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[3] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[4] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[5] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[6] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
			LockData = {
				MaxCompletedTimes = 3,
				CompletedTimes = 0,
				Time = 0,
			},
		},
	},
}

local CompletedMissionInfiniteTemplate = {
	["West City"] = {
		HighestWave = 0,
		Stars = {
			["Infinite"] = 0,
		},
	},
}

local CompletedMissionDungeonTemplate = {
	["Dorasoza (Destroyed)"] = {
		[1] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
	},
}

local function createMissionCompletionData(): MissionCompletionData
	return {
		Story = CompletedMissionStoryTemplate,
		Infinite = CompletedMissionInfiniteTemplate,
		Legend = {},
		Challenge = {},
		Adventure = {},
		Raid = CompletedMissionRaidTemplate :: any,
		Dungeon = CompletedMissionDungeonTemplate,
	}
end

return createMissionCompletionData
