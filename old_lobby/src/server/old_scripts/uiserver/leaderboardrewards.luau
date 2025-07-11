local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)
local LeaderboardSeasons = _G.Registry.registry.LeaderboardSeasons

local DataAPI = DataAccess:GetAPI()

local module = {
	ClaimPrize = function(player, id)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local PlayerPrizes = PlayerProfile:GetField("LeaderboardData").PendingRewards
		local Prize = PlayerPrizes[id]
		if player:GetAttribute("ClaimLeaderboardPrizeCooldown") or not Prize then
			return
		end

		player:SetAttribute("ClaimLeaderboardPrizeCooldown", true)

		local Rank, LeaderboardName, Season = Prize.Rank, Prize.LeaderboardName, Prize.Season

		local Folder = LeaderboardSeasons.Default
		if LeaderboardSeasons:FindFirstChild(tostring(Season)) then
			Folder = LeaderboardSeasons[tostring(Season)]
		end

		local PrizesToGive = Folder:GetRewardsForRank(LeaderboardName, Rank)
		PlayerPrizes[id] = nil
		PlayerProfile:WriteDirectory("LeaderboardData/PendingRewards", PlayerPrizes, true)
		RewardLibrary:RewardPlayer(player, PrizesToGive)

		task.wait(1.5)

		if player.Parent then
			player:SetAttribute("ClaimLeaderboardPrizeCooldown", nil)
		end
	end,
}

return module
