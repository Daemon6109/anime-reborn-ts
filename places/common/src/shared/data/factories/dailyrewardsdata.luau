export type DailyRewardsData = {
	LastClaimedDay: number?,
	CurrentStreak: number,
	CanClaim: boolean,
	TotalClaimed: number,
}

local function createDailyRewardsData(): DailyRewardsData
	return {
		LastClaimedDay = nil,
		CurrentStreak = 0,
		CanClaim = true,
		TotalClaimed = 0,
	}
end

return createDailyRewardsData
