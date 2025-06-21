// Daily rewards data factory (already defined in types)
export interface DailyRewardsData {
	LastClaimedDay?: number;
	CurrentStreak: number;
	CanClaim: boolean;
	TotalClaimed: number;
}

export function createDailyRewardsData(): DailyRewardsData {
	return {
		LastClaimedDay: undefined,
		CurrentStreak: 0,
		CanClaim: true,
		TotalClaimed: 0,
	};
}
