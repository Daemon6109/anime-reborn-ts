local module = {}

local Maid = require(game.ReplicatedStorage.Maid).new()
local RewardLibrary = require(game.ReplicatedStorage.Libs.RewardLibrary)

local DataStoreService = game:GetService("DataStoreService")
local HTTP = game:GetService("HttpService")

local Events = game.ReplicatedStorage.Events
local TeleportingToggle_RE = game.ReplicatedStorage.Events.TeleportingToggle
local NotifyPlayer = game.ReplicatedStorage.Events.NotifyPlayer
local GameVariables = game.ReplicatedStorage.GameVariables

local Registry = _G.Registry.registry
local MapOrder = Registry.MapOrder
local MapRegistry = Registry.Maps
local TournamentDataModule = require(game.ReplicatedStorage.Registry.TournamentData)

local AnalyticsService = game:GetService("AnalyticsService")
local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local CachedLeaderboardData = {}
local CacheLBCooldowns = {}

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

function module:ReturnReward(player, Bracket, Number, Statss)
	local DSName = `TournamentScore{Bracket} Season {Number}`
	local CurrentDataStore = DataStoreService:GetOrderedDataStore(DSName)

	local TournamentData = TournamentDataModule:ReturnTournament(Number)

	local DataPages = CurrentDataStore:GetSortedAsync(false, 15)
	local CurrentPage = DataPages:GetCurrentPage()

	local Rewards = {}
	local LeaderboardHighestScore

	for Rank, PlayerData in CurrentPage do
		if Rank <= 15 then
			local UserId = PlayerData.key
			local Value = PlayerData.value

			UserId = tonumber(UserId)

			if UserId <= 0 then
				continue
			end

			if Rank == 1 then
				LeaderboardHighestScore = Value
			end

			if UserId == player.UserId then
				Rewards = {
					Type = "Number",
					Value = Rank,
				}
			end
		end
	end

	if
		not Rewards
		and TournamentData
		and TournamentData.Goal
		and LeaderboardHighestScore
		and LeaderboardHighestScore > 0
	then
		local playerValue = TournamentData.Goal == "Kills" and Statss.Kills or Statss.Damage
		local achievementPercent = playerValue / LeaderboardHighestScore * 100

		local Percent = achievementPercent
		print(Percent)

		if Percent then
			Rewards = {
				Type = "Percent",
				Value = Percent,
			}
		end
	end

	return Rewards
end

local function getRandomBracket()
	local firstLetter = string.char(math.random(65, 90))
	--local secondLetter = string.char(math.random(65, 90))
	return firstLetter -- .. secondLetter
end

function module:UpdatePlayerData(player)
	local HostClass = DataAPI:GetActivePlayerProfileClass(player)
	local TournamentData = HostClass:GetField("TournamentsData")

	local CurrentTournamentData = TournamentDataModule:ReturnTournament()

	task.spawn(function()
		if not CurrentTournamentData then
			local Tries = 0
			local MaxTries = 10
			repeat
				task.wait(1)
				CurrentTournamentData = TournamentDataModule:ReturnTournament()
				Tries += 1
			until CurrentTournamentData or Tries >= MaxTries
		end

		if CurrentTournamentData then
			if not TournamentData.CurrentTournament then
				TournamentData.CurrentTournament = CurrentTournamentData.Number
			end

			print("DEBUGGING ", {
				["TournamentData"] = TournamentData,
				["CurrentTournamentData"] = CurrentTournamentData,
			})

			if TournamentData.CurrentTournament ~= CurrentTournamentData.Number then
				task.spawn(function()
					local PreviousData = {
						Bracket = TournamentData.Bracket,
						Kills = TournamentData.Kills,
						Damage = TournamentData.Damage,
						ClaimedRewards = false,
					}

					TournamentData.PreviousResults[TournamentData.CurrentTournament] = PreviousData

					local Success, Error = pcall(function()
						local Rewards =
							module:ReturnReward(player, TournamentData.Bracket, TournamentData.CurrentTournament, {
								Kills = TournamentData.Kills,
								Damage = TournamentData.Damage,
							})
						if Rewards then
							TournamentData.PreviousResults[TournamentData.CurrentTournament].RewardsToClaim = Rewards
						end
					end)

					if not Success then
						warn(Error)
					end
				end)

				TournamentData.Bracket = getRandomBracket()
				TournamentData.Damage = 0
				TournamentData.Kills = 0
				TournamentData.CurrentTournament = CurrentTournamentData.Number
			end

			for OldTournamentNumber, OldTournamentData in TournamentData.PreviousResults do
				if not OldTournamentData.RewardsToClaim then
					task.spawn(function()
						local Success, Error = pcall(function()
							local Rewards =
								module:ReturnReward(player, OldTournamentData.Bracket, OldTournamentNumber, {
									Kills = OldTournamentData.Kills,
									Damage = OldTournamentData.Damage,
								})

							if Rewards then
								TournamentData.PreviousResults[OldTournamentNumber].RewardsToClaim = Rewards
							end
						end)

						if not Success then
							warn(Error)
						end
					end)
				end
			end
		end
	end)

	if not TournamentData.Bracket or string.len(TournamentData.Bracket) > 1 then
		TournamentData.Bracket = getRandomBracket()
	end

	HostClass:WriteField("TournamentsData", TournamentData, true)
	module:UpdatePlayerLeaderboard(player, TournamentData)
end

function module:UpdatePlayerLeaderboard(Player, TournamentsData)
	if not TournamentsData then
		local HostClass = DataAPI:GetActivePlayerProfileClass(Player)
		TournamentsData = HostClass:GetField("TournamentsData")
	end

	local CurrentTournamentData = TournamentDataModule:ReturnTournament()

	if
		CurrentTournamentData
		and CurrentTournamentData.Goal
		and CurrentTournamentData.Number
		and TournamentsData.Bracket
	then
		local Success, Error = pcall(function()
			local CurrentDataStore = DataStoreService:GetOrderedDataStore(
				`TournamentScore{TournamentsData.Bracket} Season {CurrentTournamentData.Number}`
			)

			CurrentDataStore:SetAsync(
				Player.UserId,
				CurrentTournamentData.Goal == "Kills" and TournamentsData.Kills or TournamentsData.Damage
			)
		end)

		if not Success then
			warn(Error)
		end
	end
end

function module:UpdateCachedLeaderboard(Bracket)
	local CurrentTournamentData = TournamentDataModule:ReturnTournament()

	if CurrentTournamentData then
		if Bracket then
			if not CacheLBCooldowns[Bracket] then
				CacheLBCooldowns[Bracket] = true
				task.delay(120, function()
					CacheLBCooldowns[Bracket] = nil
				end)
			else
				return
			end

			task.spawn(function()
				local Success, Error = pcall(function()
					local DSName = `TournamentScore{Bracket} Season {CurrentTournamentData.Number}`
					local CurrentDataStore = DataStoreService:GetOrderedDataStore(DSName)

					CachedLeaderboardData[Bracket] = {}

					local DataPages = CurrentDataStore:GetSortedAsync(false, 100)
					local CurrentPage = DataPages:GetCurrentPage()

					for Rank, PlayerData in CurrentPage do
						local UserId = PlayerData.key
						local Value = PlayerData.value

						UserId = tonumber(UserId)

						if UserId <= 0 then
							continue
						end

						CachedLeaderboardData[Bracket][tonumber(Rank)] = {
							UserId = UserId,
							Value = Value,
						}
					end
				end)

				if not Success then
					warn(Error)
				end
			end)
		end
	end
end

function module:ReturnLeaderboardData(Bracket)
	if CachedLeaderboardData and CachedLeaderboardData[Bracket] then
		return CachedLeaderboardData[Bracket]
	else
		module:UpdateCachedLeaderboard(Bracket)
	end
	return {}
end

function module:start()
	task.spawn(function()
		local lastLeaderboardUpdateTime = 0
		local currentTournamentData = TournamentDataModule:ReturnTournament()
		local lastTournamentNumber = currentTournamentData.Number

		while true do
			local newTournamentData = TournamentDataModule:ReturnTournament()

			if newTournamentData.Number ~= lastTournamentNumber then
				lastTournamentNumber = newTournamentData.Number
				CachedLeaderboardData = {}
				for _, player in ipairs(game.Players:GetPlayers()) do
					module:UpdatePlayerData(player)
				end
			end

			task.wait(1)
		end
	end)

	Events.StartTournament.OnServerEvent:Connect(function(Player)
		local HostClass = DataAPI:GetActivePlayerProfileClass(Player)
		local TournamentsData = HostClass:GetField("TournamentsData")

		local CurrentTournamentData = TournamentDataModule:ReturnTournament()
		if not CurrentTournamentData then
			return
		end
		if CurrentTournamentData.Number ~= TournamentsData.CurrentTournament then
			module:UpdatePlayerData(Player)
			return
		end

		local GameType = "Tournament"
		local MapName = CurrentTournamentData.MapName
		local Difficulty = "Nightmare"
		local GameScenarioID = 1

		local PlaceId = (game.GameId == 6717025335 and 127759625243990)
			or (game.GameId == 5844593548 and 87213590469285)

		local PlayerList = { Player }

		TeleportingToggle_RE:FireClient(Player, true, {
			GameType = GameType,
			MapName = MapName,
			GameScenarioID = GameScenarioID,
			Difficulty = Difficulty,
		})

		local TeleportOptions = Instance.new("TeleportOptions")
		TeleportOptions.ShouldReserveServer = true
		TeleportOptions:SetTeleportData({
			MapName = MapName,
			Difficulty = Difficulty,
			GameType = GameType,
			GameScenarioId = GameScenarioID,
			Host = Player.UserId,
			ForcedElements = CurrentTournamentData.ForcedElements,
		})

		local Success, TeleportResult = pcall(function()
			return game["Teleport Service"]:TeleportAsync(PlaceId, PlayerList, TeleportOptions)
		end)

		if not Success then
			for _, Player in PlayerList do
				TeleportingToggle_RE:FireClient(Player, false, {
					GameType = GameType,
					MapName = MapName,
					GameScenarioID = GameScenarioID,
					Difficulty = Difficulty,
				})

				NotifyPlayer:FireClient(Player, {
					color = "Error",
					text = "Error occurred when teleporting",
				})
			end

			return
		end

		trackEngagement(Player, "Tournaments")
	end)

	Events.GetCachedLeaderboardData.OnServerInvoke = function(Player, Bracket)
		if Bracket and type(Bracket) == "string" then
			return module:ReturnLeaderboardData(Bracket)
		else
			return {}
		end
	end

	Events.RequestTournamentRank.OnServerInvoke = function(Player)
		local HostClass = DataAPI:GetActivePlayerProfileClass(Player)
		local TournamentsData = HostClass:GetField("TournamentsData")

		if
			TournamentsData
			and TournamentsData.Bracket
			and CachedLeaderboardData
			and CachedLeaderboardData[TournamentsData.Bracket]
		then
			for Rank, Data in CachedLeaderboardData[TournamentsData.Bracket] do
				if Data.UserId == Player.UserId then
					return {
						Rank = Rank,
						Value = Data.Value,
					}
				end
			end

			return "<100"
		end

		if TournamentsData and TournamentsData.Bracket and not CachedLeaderboardData[TournamentsData.Bracket] then
			module:UpdateCachedLeaderboard(TournamentsData.Bracket)
		end
	end
end

function module:playerLoaded(player)
	module:UpdatePlayerData(player)
end

return module
