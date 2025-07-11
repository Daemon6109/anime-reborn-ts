--------------------------------------------------------------------------------
-- unit_index_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local AnalyticsService = game:GetService("AnalyticsService")

local IndexRegistry = require("@registry/IndexData")
local Network = require("@network/server")
local Person = require("@commonserver/person")
local RewardLibrary = require("@commonserver/RewardLibrary")

--[=[
Service for managing unit index functionality and rewards.

@class UnitIndexService
]=]
local UnitIndexService = {
	version = version,
}

--[=[
Claims all available index prizes for a player.

@param player Player -- The player claiming rewards
]=]
function UnitIndexService.claimAllPrizes(player: Player)
	local person = Person.new(player)
	local indexData = person.dataCache().IndexData
	local indexLevel = indexData.IndexLevel

	if player:GetAttribute("ClaimingIndexPrizes") then
		return
	end

	player:SetAttribute("ClaimingIndexPrizes", true)

	local claimedCount = 0
	for level = 1, indexLevel do
		local claimedRewards = indexData.ClaimedLevelRewards or {}

		if not table.find(claimedRewards, level) then
			local rewardData = IndexRegistry:GetRewardsForLevel(level)

			if rewardData then
				table.insert(claimedRewards, level)
				indexData.ClaimedLevelRewards = claimedRewards

				RewardLibrary:RewardPlayer(player, rewardData)
				claimedCount += 1

				-- Analytics tracking
				AnalyticsService:LogCustomEvent(player, "IndexRewardClaimed", {
					level = level,
					indexLevel = indexLevel,
				})
			end
		end
	end

	player:SetAttribute("ClaimingIndexPrizes", nil)

	-- Analytics for bulk claim
	if claimedCount > 0 then
		AnalyticsService:LogCustomEvent(player, "IndexBulkRewardClaim", {
			rewardsClaimed = claimedCount,
			currentIndexLevel = indexLevel,
		})
	end
end

--[=[
Claims a specific index level reward.

@param player Player -- The player claiming the reward
@param level number -- The index level to claim
]=]
function UnitIndexService.claimLevelReward(player: Player, level: number)
	local person = Person.new(player)
	local indexData = person.dataCache().IndexData
	local indexLevel = indexData.IndexLevel

	-- Validate level
	if level < 1 or level > indexLevel then
		return
	end

	local claimedRewards = indexData.ClaimedLevelRewards or {}

	-- Check if already claimed
	if table.find(claimedRewards, level) then
		return
	end

	local rewardData = IndexRegistry:GetRewardsForLevel(level)
	if not rewardData then
		return
	end

	-- Claim the reward
	table.insert(claimedRewards, level)
	indexData.ClaimedLevelRewards = claimedRewards

	RewardLibrary:RewardPlayer(player, rewardData)

	-- Analytics tracking
	AnalyticsService:LogCustomEvent(player, "IndexRewardClaimed", {
		level = level,
		indexLevel = indexLevel,
	})
end

--[=[
Gets the player's current index progress.

@param player Player -- The player to check
@return table -- Index progress data
]=]
function UnitIndexService.getIndexProgress(player: Player): table
	local person = Person.new(player)
	local indexData = person.dataCache().IndexData

	return {
		IndexLevel = indexData.IndexLevel or 0,
		ClaimedLevelRewards = indexData.ClaimedLevelRewards or {},
		TotalLevels = IndexRegistry:GetMaxLevel() or 100,
	}
end

-- Register network handlers
Network.registerHandler("ClaimAllIndexPrizes", UnitIndexService.claimAllPrizes)
Network.registerHandler("ClaimIndexLevelReward", UnitIndexService.claimLevelReward)
Network.registerHandler("GetIndexProgress", UnitIndexService.getIndexProgress)

return UnitIndexService
