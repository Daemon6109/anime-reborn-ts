local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)

local TournamentRewards = game.ReplicatedStorage.Registry.TournamentRewards

local DataAPI = DataAccess:GetAPI()

local module = {
	ClaimPrize = function(player, tournamentNumber)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local PreviousResults = PlayerProfile:GetField("TournamentsData").PreviousResults
		local CurrentResult = PreviousResults[tournamentNumber]

		if
			player:GetAttribute("ClaimTournamentRewardsCD")
			or not CurrentResult
			or CurrentResult.ClaimedRewards
			or not CurrentResult.RewardsToClaim
		then
			return
		end

		local Mod = TournamentRewards:FindFirstChild(tostring(tournamentNumber))
			or TournamentRewards:FindFirstChild("Default")

		if Mod then
			local CurrentModule = require(Mod)

			local RewardsToClaim = CurrentResult.RewardsToClaim

			local RewardsTable = CurrentModule[RewardsToClaim.Type]

			if RewardsTable then
				local PrizeList = nil

				for _, entry in pairs(RewardsTable) do
					local req = entry.Requirement
					if RewardsToClaim.Type == "Number" then
						if RewardsToClaim.Value <= req.Max then
							PrizeList = entry
							break
						end
					elseif RewardsToClaim.Type == "Percent" then
						if RewardsToClaim.Value >= req.Min and RewardsToClaim.Value <= req.Max then
							PrizeList = entry
							break
						end
					end
				end

				if PrizeList and PrizeList.Rewards then
					PrizeList = PrizeList.Rewards

					PreviousResults[tournamentNumber].ClaimedRewards = true
					PlayerProfile:WriteDirectory("TournamentsData/PreviousResults", PreviousResults, true)

					RewardLibrary:RewardPlayer(player, PrizeList)
				end
			end
		end

		player:SetAttribute("ClaimTournamentRewardsCD", true)

		task.wait(1.5)

		if player.Parent then
			player:SetAttribute("ClaimTournamentRewardsCD", nil)
		end
	end,
}

return module
