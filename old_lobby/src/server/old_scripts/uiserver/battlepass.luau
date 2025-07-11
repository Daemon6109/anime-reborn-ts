local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScripts = game:GetService("ServerScriptService")
local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local IndexRegistry = require(ReplicatedStorage.Registry.IndexData)
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)

local bpData = require(game.ReplicatedStorage.Registry.BattlePassData)

local function Length(dict: table)
	local counter = 0
	for _ in dict do
		counter += 1
	end
	return counter
end

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local DataAPI = DataAccess:GetAPI()
local unreleased = true
local UnitIndex = {
	ClaimRewards = function(player: Player)
		--// Player Cooldown
		if player:GetAttribute("ClaimingBattlepass") then
			return
		end
		player:SetAttribute("ClaimingBattlepass", true)

		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
		local BattlePassData = PlayerProfileClass:GetField("BattlepassData")
		if
			(
				not BattlePassData.HasPremium
				or BattlePassData.HasPremium and BattlePassData.ClaimedPremium >= BattlePassData.Level
			) and BattlePassData.ClaimedFree >= BattlePassData.Level
		then
			return
		end
		-- There is something to claim
		--warn('Claiming yoyo')

		--

		local PremiumLevel = BattlePassData.ClaimedPremium
		local FreeLevel = BattlePassData.ClaimedFree

		if BattlePassData.HasPremium then
			PlayerProfileClass:WriteDirectory("BattlepassData/ClaimedPremium", BattlePassData.Level, true)
		end -- Update claimed tiers for premium
		PlayerProfileClass:WriteDirectory("BattlepassData/ClaimedFree", BattlePassData.Level, true) -- Update claimed tiers for free players

		local function counter(root)
			local count = 0

			for i, v in root do
				count += v
			end

			return count
		end

		task.spawn(function()
			--// Reward Regular
			local Claimed
			for level = FreeLevel + 1, BattlePassData.Level do
				local RewardDataTable = bpData.LevelData[level]
				if not RewardDataTable then
					continue
				end

				local RewardData = RewardDataTable["Regular"]
				if not RewardData then
					continue
				end

				local UnitRewardCount = RewardData.Units and counter(RewardData.Units) or 0
				local ShinyUnitRewardCount = RewardData.ShinyUnits and counter(RewardData.ShinyUnits) or 0

				print(RewardData)
				warn(UnitRewardCount, ShinyUnitRewardCount)

				local UnitCount = Length(PlayerProfileClass:GetField("Inventory").Units)
				if
					UnitRewardCount + ShinyUnitRewardCount
					> PlayerProfileClass:GetField("Inventory").MaxUnitStorage - UnitCount
				then
					game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
						player,
						"Error",
						"Your unit storage is full!"
					)
					PlayerProfileClass:WriteDirectory("BattlepassData/ClaimedFree", level - 1, true)
					player:SetAttribute("ClaimingBattlepass", false)
					return
				end
				Claimed = true
				trackEngagement(player, "RegularPass")
				RewardLibrary:RewardPlayer(player, RewardData)
			end
			if Claimed then
				game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(player, "Success", "Claimed free pass rewards!")
			end
		end)

		task.spawn(function()
			--// Reward Premium
			local Claimed
			if BattlePassData.HasPremium then
				for level = PremiumLevel + 1, BattlePassData.Level do
					local RewardDataTable = bpData.LevelData[level]
					if not RewardDataTable then
						continue
					end

					local RewardData = RewardDataTable["Premium"]
					if not RewardData then
						continue
					end

					local UnitRewardCount = RewardData.Units and counter(RewardData.Units) or 0
					local ShinyUnitRewardCount = RewardData.ShinyUnits and counter(RewardData.ShinyUnits) or 0

					warn("Claiming Premium", RewardData)
					warn("Claiming Premium", UnitRewardCount, ShinyUnitRewardCount)

					local UnitCount = Length(PlayerProfileClass:GetField("Inventory").Units)
					if
						UnitRewardCount + ShinyUnitRewardCount
						> PlayerProfileClass:GetField("Inventory").MaxUnitStorage - UnitCount
					then
						game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
							player,
							"Error",
							"Your unit storage is full!"
						)
						PlayerProfileClass:WriteDirectory("BattlepassData/ClaimedPremium", level - 1, true)
						player:SetAttribute("ClaimingBattlepass", false)
						return
					end
					trackEngagement(player, "PremiumPass")
					Claimed = true
					RewardLibrary:RewardPlayer(player, RewardData)
				end

				if Claimed then
					game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
						player,
						"Success",
						"Claimed free pass rewards!"
					)
				end
			end
		end)

		--PlayerProfileClass:ReplicateField("BattlepassData")

		warn("BattlePassData Updated", BattlePassData)
		task.wait(1)
		player:SetAttribute("ClaimingBattlepass", false)
	end,
}

return UnitIndex
