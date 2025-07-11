local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local LevelData = require(ReplicatedStorage.Registry.LevelData)
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)

local DataAPI = DataAccess:GetAPI()

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local LevelRewards = {
	ClaimReward = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local ClaimedRewards = PlayerProfile:GetField("ClaimedLevelRewards")
		local level

		if player:GetAttribute("ClaimingLevelPrizes") then
			return
		end

		-- Technically, the length of the claimed levels + 1 should work, but this is future proofing
		for i = 1, PlayerProfile:GetField("Level") do
			if not table.find(ClaimedRewards, i) then
				level = i
				break
			end
		end

		if not level or PlayerProfile:GetField("Level") < level then
			return
		end

		local RewardData = LevelData:GetRewardsForLevel(level)

		if not RewardData then
			return
		end

		table.insert(ClaimedRewards, level)

		trackEngagement(player, "ClaimLeveReward")

		PlayerProfile:WriteField("ClaimedLevelRewards", ClaimedRewards, true)
		RewardLibrary:RewardPlayer(player, RewardData)
	end,

	ClaimEverything = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		if player:GetAttribute("ClaimingLevelPrizes") then
			return
		end

		player:SetAttribute("ClaimingLevelPrizes", true)

		for level = 1, PlayerProfile:GetField("Level") do
			local ClaimedRewards = PlayerProfile:GetField("ClaimedLevelRewards")

			if table.find(ClaimedRewards, level) then
				continue
			end

			local RewardData = LevelData:GetRewardsForLevel(level)

			if RewardData then
				table.insert(ClaimedRewards, level)

				PlayerProfile:WriteField("ClaimedLevelRewards", ClaimedRewards)
				RewardLibrary:RewardPlayer(player, RewardData)
			end
		end

		PlayerProfile:ReplicateField("ClaimedLevelRewards")

		player:SetAttribute("ClaimingLevelPrizes", nil)
	end,
}

return LevelRewards
