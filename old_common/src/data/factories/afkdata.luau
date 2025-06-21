export type AFKData = {
	GemTimeSpent: number,
	RerollTimeSpent: number,
	UnitTimeSpent: number,
	SessionData: {
		GemsGained: number,
		TraitRerollsGained: number,
		ObtainedUnits: { [number]: any },
		Uptime: number,
	},
}

local function createAFKData(): AFKData
	return {
		GemTimeSpent = 0,
		RerollTimeSpent = 0,
		UnitTimeSpent = 0,
		SessionData = {
			GemsGained = 0,
			TraitRerollsGained = 0,
			ObtainedUnits = {},
			Uptime = 0,
		},
	}
end

return createAFKData
