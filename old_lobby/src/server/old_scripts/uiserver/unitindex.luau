local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local IndexRegistry = require(ReplicatedStorage.Registry.IndexData)
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)

local DataAPI = DataAccess:GetAPI()

local UnitIndex = {
	ClaimAllPrizes = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local IndexData = PlayerProfile:GetField("IndexData")
		local IndexLevel = IndexData.IndexLevel

		if player:GetAttribute("ClaimingIndexPrizes") then
			return
		end

		player:SetAttribute("ClaimingIndexPrizes", true)

		for i = 1, IndexLevel do
			local ClaimedRewards = PlayerProfile:GetField("IndexData").ClaimedLevelRewards

			if not table.find(ClaimedRewards, i) then
				local RewardData = IndexRegistry:GetRewardsForLevel(i)

				if RewardData then
					table.insert(ClaimedRewards, i)

					PlayerProfile:WriteDirectory("IndexData/ClaimedLevelRewards", ClaimedRewards, true)
					RewardLibrary:RewardPlayer(player, RewardData)
				end
			end
		end

		player:SetAttribute("ClaimingIndexPrizes", nil)
	end,
}

return UnitIndex
