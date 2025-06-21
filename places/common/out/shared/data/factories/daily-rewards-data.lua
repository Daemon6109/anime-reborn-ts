-- Compiled with roblox-ts v2.3.0
-- Daily rewards data factory (already defined in types)
local function createDailyRewardsData()
	return {
		LastClaimedDay = nil,
		CurrentStreak = 0,
		CanClaim = true,
		TotalClaimed = 0,
	}
end
return {
	createDailyRewardsData = createDailyRewardsData,
}
