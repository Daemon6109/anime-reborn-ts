export type LeaderboardData = {
	PendingRewards: { [number]: any },
	CheckedSeasons: { [number]: any },
	LastSeasonUpdate: number,
}

local function createLeaderboardData(): LeaderboardData
	return {
		PendingRewards = {},
		CheckedSeasons = {},
		LastSeasonUpdate = 0,
	}
end

return createLeaderboardData
