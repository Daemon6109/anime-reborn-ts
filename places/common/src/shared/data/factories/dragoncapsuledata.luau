export type DragonCapsuleData = {
	MythicalPity: number,
	LegendaryPity: number,
	GohanEventPity: number,
}

local function createDragonCapsuleData(): DragonCapsuleData
	return {
		MythicalPity = 0,
		LegendaryPity = 0,
		GohanEventPity = 0,
	}
end

return createDragonCapsuleData
