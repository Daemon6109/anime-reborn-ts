// Summoning data factory
export interface SummoningData {
	FeaturedMythicalPity: number;
	MythicalPity: number;
	LegendaryPity: number;
	SecretPity: number;
	LastBannerSeed: number;
}

export function createSummoningData(): SummoningData {
	return {
		FeaturedMythicalPity: 0,
		MythicalPity: 0,
		LegendaryPity: 0,
		SecretPity: 0,
		LastBannerSeed: 0,
	};
}
