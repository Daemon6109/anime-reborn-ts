export type IndexData = {
	UnlockedUnits: { [number]: any },
	ClaimedLevelRewards: { [number]: any },
	IndexLevel: number,
	IndexXP: number,
}

local function createIndexData(): IndexData
	return {
		UnlockedUnits = {},
		ClaimedLevelRewards = {},
		IndexLevel = 0,
		IndexXP = 0,
	}
end

return createIndexData
