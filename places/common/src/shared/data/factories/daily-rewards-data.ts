// Daily rewards data factory (already defined in types)
export interface DailyRewardsData {
	LastClaimedDay?: number;
	CurrentStreak: number;
	CanClaim: boolean;
	TotalClaimed: number;
}

export function createDailyRewardsData(): DailyRewardsData {
	return {
		LastClaimedDay: 0, // Changed from undefined to 0 to satisfy validation
		CurrentStreak: 0,
		CanClaim: true,
		TotalClaimed: 0,
	};
}
