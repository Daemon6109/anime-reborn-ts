// Player statistics data factory
export interface PlayerStatisticsData {
	Kills: number;
	TotalDamage: number;
	GamesPlayed: number;
	PlayTime: number;
	TotalSummons: number;
	SummonedShinies: number;
	SummonedMythicals: number;
	SummonedSecrets: number;
}

export function createPlayerStatisticsData(): PlayerStatisticsData {
	return {
		Kills: 0,
		TotalDamage: 0,
		GamesPlayed: 0,
		PlayTime: 0,
		TotalSummons: 0,
		SummonedShinies: 0,
		SummonedMythicals: 0,
		SummonedSecrets: 0,
	};
}
