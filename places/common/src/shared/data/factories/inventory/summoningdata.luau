export type SummoningData = {
	FeaturedMythicalPity: number,
	MythicalPity: number,
	LegendaryPity: number,
	SecretPity: number,
	LastBannerSeed: number,
}

local function createSummoningData(): SummoningData
	return {
		FeaturedMythicalPity = 0,
		MythicalPity = 0,
		LegendaryPity = 0,
		SecretPity = 0,
		LastBannerSeed = 0,
	}
end

return createSummoningData
