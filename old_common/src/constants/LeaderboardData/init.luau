local RunService = game:GetService("RunService")

local module = {}

export type LeaderboardDataType = {
	Ascending : boolean;
	RankingName: string; -- Used for player statues & general visuals
	IsSeasonal: boolean?; -- Determines whether this has prizes or not, also whether to run OnSeasonChanged or not. You must have prizes prepared
	Removed: boolean?; -- Whether the leaderboard is removed or not, simply just stops player models and lists, you must manually remove the data handler for the lb
	
	CustomStatFormat: (any) -> (any)?; -- Uses this instead of FormatNumber
	OnSeasonChanged: (Player, PlayerProfile: {}) -> ()?; -- Usually used to make everything go back to 0 when ending
	
	NoSeasonRewards: boolean; -- Seasonal rewards, gave to inf castle since it alrdy has it's own rewards.
	
	IgnoreSeasons: {number}?; -- Avoids checking the lb ranking in the given ones here, incase they're new and the  wasnt active during the new lb
}

module.Metadata = {}
module.CurrentSeason = 5
module.EndsIn = 1742601600 + (86400 * 30)

module.Info = { --// i = datastore name and leaderboard name, v = LeaderboardDataType
	RobuxSpent = {
		RankingName = "MOST ROBUX SPENT";
		Ascending = false;
	};
	
	Gems = {
		RankingName = "MOST GEMS";
		Ascending = false;
	};
	
	SpiritsContributedSouls = {
		RankingName = "MOST CONTRIBUTED SPIRIT SOULS";
		Ascending = false;
	};
	
	AliensContributedSouls = {
		RankingName = "MOST CONTRIBUTED ALIEN SOULS";
		Ascending = false;
	};
	
	PlayTime = {
		RankingName = "HIGHEST PLAYTIME";
		Ascending = false;

		CustomStatFormat = function(PlayTime)
			return `{string.format("%.2f", PlayTime/60/60)} Hrs`
		end,
	};
	
	LeafVillageWaves = {
		IsSeasonal = true;
		RankingName = "HIGHEST LEAF VILLAGE INFINITE WAVES";
		Ascending = false;
		
		Removed = true;
		
		OnSeasonChanged = function(player, PlayerProfile)
			if PlayerProfile:GetField("MissionCompletionData").Infinite["Leaf Village"] then
				PlayerProfile:WriteDirectory(`MissionCompletionData/Infinite/Leaf Village/HighestWave`, 0, true)
			end
		end,
	};
	
	RedArmyHQWaves = {
		IsSeasonal = true;
		RankingName = "HIGHEST Red Army HQ INFINITE WAVES";
		Ascending = false;

		OnSeasonChanged = function(player, PlayerProfile)
			if PlayerProfile:GetField("MissionCompletionData").Infinite["Red Army HQ"] then
				PlayerProfile:WriteDirectory(`MissionCompletionData/Infinite/Red Army HQ/HighestWave`, 0, true)
			end
		end,
	};
	
	CloverKingdomWaves = {
		IsSeasonal = true;
		RankingName = "HIGHEST Clover Kingdom INFINITE WAVES";
		Ascending = false;

		OnSeasonChanged = function(player, PlayerProfile)
			if PlayerProfile:GetField("MissionCompletionData").Infinite["Clover Kingdom"] then
				PlayerProfile:WriteDirectory(`MissionCompletionData/Infinite/Clover Kingdom/HighestWave`, 0, true)
			end
		end,
	};
	
	HellTowerWaves = {
		IsSeasonal = true;
		RankingName = "HIGHEST Infinite Castle INFINITE WAVES";
		Ascending = false;
		NoSeasonRewards = true;

		OnSeasonChanged = function(player, PlayerProfile)
			PlayerProfile:WriteDirectory("HellTowerData/HighestRoom", 0, true)
			PlayerProfile:WriteDirectory("HellTowerData/ClaimData", {}, true)
			PlayerProfile:WriteDirectory("HellTowerData/RoomCompletionData", {}, true)
		end,
	};
	
	GhostTunnelWaves = {
		IsSeasonal = true;
		RankingName = "HIGHEST Ghost Tunnel INFINITE WAVES";
		Ascending = false;

		OnSeasonChanged = function(player, PlayerProfile)
			if PlayerProfile:GetField("MissionCompletionData").Infinite["Ghost Tunnel"] then
				PlayerProfile:WriteDirectory(`MissionCompletionData/Infinite/Ghost Tunnel/HighestWave`, 0, true)
			end
		end,
	};
	
	LandOfTheSkyWaves = {
		IsSeasonal = true;
		RankingName = "HIGHEST LAND OF THE SKY INFINITE WAVES";
		Ascending = false;
		
		Removed = true;
		
		OnSeasonChanged = function(player, PlayerProfile)
			if PlayerProfile:GetField("MissionCompletionData").Infinite["Land of the Sky"] then
				PlayerProfile:WriteDirectory(`MissionCompletionData/Infinite/Land of the Sky/HighestWave`, 0, true)
			end
		end,
	};
	
	FujishimaIslandWaves = {
		IsSeasonal = true;
		RankingName = "HIGHEST FUJISHIMA ISLAND INFINITE WAVES";
		Ascending = false;
		
		Removed = true;
		
		OnSeasonChanged = function(player, PlayerProfile)
			if PlayerProfile:GetField("MissionCompletionData").Infinite["Fujishima Island"] then
				PlayerProfile:WriteDirectory(`MissionCompletionData/Infinite/Fujishima Island/HighestWave`, 0, true)
			end
		end,
	};
	
	WinterMayhemWaves = {
		IsSeasonal = true;
		RankingName = "HIGHEST WINTER MAYHEM INFINITE WAVES";
		Ascending = false;
		
		Removed = true;

		OnSeasonChanged = function(player, PlayerProfile)
			if PlayerProfile:GetField("MissionCompletionData").Infinite["Winter Mayhem"] then
				PlayerProfile:WriteDirectory(`MissionCompletionData/Infinite/Winter Mayhem/HighestWave`, 0, true)
			end
		end,
	}
	
} :: {[string]: LeaderboardDataType}


--// Metadata API


--//
function module.Metadata:GetRewardsForRank(LeaderboardName: string, Rank: number): {}?
	local Prizes = self.LeaderboardSpecificRewards and self.LeaderboardSpecificRewards[LeaderboardName]  or self.Rewards 
	
	if not Prizes then return end
	
	for RankRange, Value in Prizes do
		if math.clamp(Rank, RankRange.Min, RankRange.Max) == Rank then
			return Value
		end
	end
end


--// Normal API


--//
function module:IsSeasonActive()
	local TimeNow = RunService:IsClient() and workspace:GetServerTimeNow() or DateTime.now().UnixTimestamp
	
	return TimeNow < module.EndsIn
end


--// Only uses Season/the given one if the leaderboard is a Season one
function module:GetDatastoreForLeaderboard(LeaderboardName: string, ForceSeason: number?): OrderedDataStore
	assert(RunService:IsServer(), "Attempt to call from client")
	
	local DataStoreService = game:GetService("DataStoreService")
	local Season = ForceSeason or module.CurrentSeason
	local Leaderboard = module.Info[LeaderboardName]
	
	assert(Leaderboard, `Leaderboard {LeaderboardName} is invalid.`)
	
	if not Leaderboard.IsSeasonal or Season == 0 or Season == 2 then --// Legacy, old naming convention, before this was scripted
		return DataStoreService:GetOrderedDataStore(`{LeaderboardName}2`)
	end
	
	return DataStoreService:GetOrderedDataStore(`{LeaderboardName} Season {Season}`)
end


return module
