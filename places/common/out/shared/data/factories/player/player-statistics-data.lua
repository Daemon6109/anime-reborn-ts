-- Compiled with roblox-ts v2.3.0
-- Player statistics data factory
local function createPlayerStatisticsData()
	return {
		Kills = 0,
		TotalDamage = 0,
		GamesPlayed = 0,
		PlayTime = 0,
		TotalSummons = 0,
		SummonedShinies = 0,
		SummonedMythicals = 0,
		SummonedSecrets = 0,
	}
end
return {
	createPlayerStatisticsData = createPlayerStatisticsData,
}
