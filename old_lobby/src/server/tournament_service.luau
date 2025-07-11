--[[
	TournamentService
	
	Manages tournament participation, leaderboards, rewards, and brackets.
	
	@class TournamentService
	@server
]]

local AnalyticsService = game:GetService("AnalyticsService")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TeleportService = game:GetService("TeleportService")

-- Dependencies
local Network = require("@network/server")
local Person = require("@commonserver/person")
local Signal = require("@pkgs/shingo")

-- Types
export type TournamentBracket = string -- Single letter A-Z
export type TournamentGoal = "Kills" | "Damage"
export type TournamentNumber = number

export type TournamentReward = {
	Type: "Number" | "Percent",
	Value: number,
}

export type TournamentResult = {
	Bracket: TournamentBracket,
	Kills: number,
	Damage: number,
	ClaimedRewards: boolean,
	RewardsToClaim: TournamentReward?,
}

export type TournamentData = {
	CurrentTournament: TournamentNumber?,
	Bracket: TournamentBracket,
	Kills: number,
	Damage: number,
	PreviousResults: { [TournamentNumber]: TournamentResult },
}

export type LeaderboardEntry = {
	UserId: number,
	Value: number,
}

export type TournamentInfo = {
	Number: TournamentNumber,
	Goal: TournamentGoal,
	MapName: string,
	ForcedElements: { string }?,
}

--- @class TournamentService
local TournamentService = {}
TournamentService.__index = TournamentService

-- Constants
local LEADERBOARD_CACHE_COOLDOWN = 120 -- 2 minutes
local LEADERBOARD_ENTRIES_LIMIT = 100
local PLACE_IDS = {
	[6717025335] = 127759625243990, -- Production
	[5844593548] = 87213590469285, -- Test
}

-- Registry references
local RewardLibrary = require("@commonserver/RewardLibrary")

-- Mock tournament data for now
local TournamentDataModule = {
	tournaments = {},
}

-- Mock DataAPI for now
local DataAPI = {
	GetData = function()
		return {}
	end,
	SaveData = function() end,
}

--- Creates a new TournamentService instance
--- @return TournamentService
function TournamentService.new()
	local self = setmetatable({}, TournamentService)

	-- Version tracking
	self.version = { major = 1, minor = 0, patch = 0 }

	-- Leaderboard cache
	self._cachedLeaderboardData = {}
	self._cacheLeaderboardCooldowns = {}

	-- Current tournament tracking
	self._lastTournamentNumber = nil

	-- Events
	self.tournamentStarted = Signal.new()
	self.tournamentCompleted = Signal.new()
	self.leaderboardUpdated = Signal.new()
	self.rewardClaimed = Signal.new()

	-- Network setup
	self._network = Network.new("TournamentService")
	self:_setupNetwork()

	-- Services
	self._playerService = nil
	self._notificationService = nil
	self._teleportService = nil

	return self
end

--- Initializes service dependencies
--- @private
function TournamentService:_initializeDependencies()
	repeat
		task.wait(0.1)
		self._playerService = _G.serverServices.PlayerService
		self._notificationService = _G.serverServices.NotificationService
		self._teleportService = _G.serverServices.TeleportService
	until self._playerService and self._notificationService and self._teleportService
end

--- Sets up network endpoints
--- @private
function TournamentService:_setupNetwork()
	-- Tournament start endpoint
	self._network:event("startTournament", function(person: Person.Person)
		return self:startTournament(person)
	end)

	-- Leaderboard data endpoint
	self._network:func("getLeaderboardData", function(person: Person.Person, bracket: TournamentBracket)
		return self:getLeaderboardData(bracket)
	end)

	-- Tournament rank endpoint
	self._network:func("getTournamentRank", function(person: Person.Person)
		return self:getTournamentRank(person)
	end)
end

--- Tracks engagement analytics
--- @param person Person.Person
--- @param featureName string
--- @private
function TournamentService:_trackEngagement(person: Person.Person, featureName: string)
	local player = person:getPlayer()
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

--- Generates a random tournament bracket
--- @return TournamentBracket
--- @private
function TournamentService:_getRandomBracket(): TournamentBracket
	return string.char(math.random(65, 90)) -- A-Z
end

--- Gets current tournament information
--- @return TournamentInfo?
function TournamentService:getCurrentTournament(): TournamentInfo?
	return TournamentDataModule:ReturnTournament()
end

--- Calculates tournament rewards based on performance
--- @param person Person.Person
--- @param bracket TournamentBracket
--- @param tournamentNumber TournamentNumber
--- @param stats { Kills: number, Damage: number }
--- @return TournamentReward?
function TournamentService:calculateRewards(
	person: Person.Person,
	bracket: TournamentBracket,
	tournamentNumber: TournamentNumber,
	stats: { Kills: number, Damage: number }
): TournamentReward?
	local dsName = `TournamentScore{bracket} Season {tournamentNumber}`
	local dataStore = DataStoreService:GetOrderedDataStore(dsName)
	local tournamentData = TournamentDataModule:ReturnTournament(tournamentNumber)

	if not tournamentData then
		return nil
	end

	local success, dataPages = pcall(function()
		return dataStore:GetSortedAsync(false, 15)
	end)

	if not success then
		return nil
	end

	local currentPage = dataPages:GetCurrentPage()
	local player = person:getPlayer()
	local leaderboardHighestScore = 0

	-- Check for top 15 placement
	for rank, playerData in currentPage do
		if rank <= 15 then
			local userId = tonumber(playerData.key)
			local value = playerData.value

			if userId and userId > 0 then
				if rank == 1 then
					leaderboardHighestScore = value
				end

				if userId == player.UserId then
					return {
						Type = "Number",
						Value = rank,
					}
				end
			end
		end
	end

	-- Calculate percentage-based reward
	if tournamentData.Goal and leaderboardHighestScore > 0 then
		local playerValue = tournamentData.Goal == "Kills" and stats.Kills or stats.Damage
		local achievementPercent = playerValue / leaderboardHighestScore * 100

		return {
			Type = "Percent",
			Value = achievementPercent,
		}
	end

	return nil
end

--- Updates player tournament data
--- @param person Person.Person
function TournamentService:updatePlayerData(person: Person.Person)
	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local tournamentData = PlayerProfileClass:GetField("TournamentsData")

	-- Initialize tournament data if needed
	if not tournamentData then
		tournamentData = {
			CurrentTournament = nil,
			Bracket = self:_getRandomBracket(),
			Kills = 0,
			Damage = 0,
			PreviousResults = {},
		}
	end

	task.spawn(function()
		local currentTournamentData = self:getCurrentTournament()

		-- Wait for tournament data if not available
		if not currentTournamentData then
			local tries = 0
			local maxTries = 10
			repeat
				task.wait(1)
				currentTournamentData = self:getCurrentTournament()
				tries += 1
			until currentTournamentData or tries >= maxTries
		end

		if not currentTournamentData then
			return
		end

		-- Initialize current tournament
		if not tournamentData.CurrentTournament then
			tournamentData.CurrentTournament = currentTournamentData.Number
		end

		-- Handle tournament change
		if tournamentData.CurrentTournament ~= currentTournamentData.Number then
			task.spawn(function()
				-- Store previous tournament data
				local previousData: TournamentResult = {
					Bracket = tournamentData.Bracket,
					Kills = tournamentData.Kills,
					Damage = tournamentData.Damage,
					ClaimedRewards = false,
				}

				tournamentData.PreviousResults[tournamentData.CurrentTournament] = previousData

				-- Calculate rewards for previous tournament
				local success, rewards = pcall(function()
					return self:calculateRewards(person, tournamentData.Bracket, tournamentData.CurrentTournament, {
						Kills = tournamentData.Kills,
						Damage = tournamentData.Damage,
					})
				end)

				if success and rewards then
					tournamentData.PreviousResults[tournamentData.CurrentTournament].RewardsToClaim = rewards
				end
			end)

			-- Reset for new tournament
			tournamentData.Bracket = self:_getRandomBracket()
			tournamentData.Damage = 0
			tournamentData.Kills = 0
			tournamentData.CurrentTournament = currentTournamentData.Number

			self.tournamentCompleted:fire(person, tournamentData.CurrentTournament)
		end

		-- Calculate missing rewards for previous tournaments
		for oldTournamentNumber, oldTournamentData in tournamentData.PreviousResults do
			if not oldTournamentData.RewardsToClaim then
				task.spawn(function()
					local success, rewards = pcall(function()
						return self:calculateRewards(person, oldTournamentData.Bracket, oldTournamentNumber, {
							Kills = oldTournamentData.Kills,
							Damage = oldTournamentData.Damage,
						})
					end)

					if success and rewards then
						tournamentData.PreviousResults[oldTournamentNumber].RewardsToClaim = rewards
					end
				end)
			end
		end
	end)

	-- Ensure valid bracket
	if not tournamentData.Bracket or string.len(tournamentData.Bracket) > 1 then
		tournamentData.Bracket = self:_getRandomBracket()
	end

	-- Save and update leaderboard
	PlayerProfileClass:WriteField("TournamentsData", tournamentData, true)
	self:updatePlayerLeaderboard(person, tournamentData)
end

--- Updates player's position on tournament leaderboard
--- @param person Person.Person
--- @param tournamentData TournamentData?
function TournamentService:updatePlayerLeaderboard(person: Person.Person, tournamentData: TournamentData?)
	local player = person:getPlayer()

	if not tournamentData then
		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
		tournamentData = PlayerProfileClass:GetField("TournamentsData")
	end

	local currentTournamentData = self:getCurrentTournament()

	if
		currentTournamentData
		and currentTournamentData.Goal
		and currentTournamentData.Number
		and tournamentData.Bracket
	then
		local success, error = pcall(function()
			local dsName = `TournamentScore{tournamentData.Bracket} Season {currentTournamentData.Number}`
			local dataStore = DataStoreService:GetOrderedDataStore(dsName)

			local value = currentTournamentData.Goal == "Kills" and tournamentData.Kills or tournamentData.Damage

			dataStore:SetAsync(player.UserId, value)
		end)

		if not success then
			warn("Failed to update tournament leaderboard: " .. tostring(error))
		else
			self.leaderboardUpdated:fire(person, tournamentData.Bracket, currentTournamentData.Number)
		end
	end
end

--- Updates cached leaderboard data for a bracket
--- @param bracket TournamentBracket
function TournamentService:updateCachedLeaderboard(bracket: TournamentBracket)
	local currentTournamentData = self:getCurrentTournament()

	if not currentTournamentData then
		return
	end

	-- Check cooldown
	if self._cacheLeaderboardCooldowns[bracket] then
		return
	end

	-- Set cooldown
	self._cacheLeaderboardCooldowns[bracket] = true
	task.delay(LEADERBOARD_CACHE_COOLDOWN, function()
		self._cacheLeaderboardCooldowns[bracket] = nil
	end)

	task.spawn(function()
		local success, error = pcall(function()
			local dsName = `TournamentScore{bracket} Season {currentTournamentData.Number}`
			local dataStore = DataStoreService:GetOrderedDataStore(dsName)

			self._cachedLeaderboardData[bracket] = {}

			local dataPages = dataStore:GetSortedAsync(false, LEADERBOARD_ENTRIES_LIMIT)
			local currentPage = dataPages:GetCurrentPage()

			for rank, playerData in currentPage do
				local userId = tonumber(playerData.key)
				local value = playerData.value

				if userId and userId > 0 then
					self._cachedLeaderboardData[bracket][rank] = {
						UserId = userId,
						Value = value,
					}
				end
			end
		end)

		if not success then
			warn("Failed to update cached leaderboard: " .. tostring(error))
		end
	end)
end

--- Gets leaderboard data for a bracket
--- @param bracket TournamentBracket
--- @return { LeaderboardEntry }
function TournamentService:getLeaderboardData(bracket: TournamentBracket): { LeaderboardEntry }
	if self._cachedLeaderboardData[bracket] then
		return self._cachedLeaderboardData[bracket]
	else
		self:updateCachedLeaderboard(bracket)
		return {}
	end
end

--- Gets tournament rank for a player
--- @param person Person.Person
--- @return { Rank: number, Value: number } | string
function TournamentService:getTournamentRank(person: Person.Person): { Rank: number, Value: number } | string
	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local tournamentData = PlayerProfileClass:GetField("TournamentsData")

	if not tournamentData or not tournamentData.Bracket then
		return "<100"
	end

	local leaderboardData = self._cachedLeaderboardData[tournamentData.Bracket]

	if leaderboardData then
		for rank, data in leaderboardData do
			if data.UserId == player.UserId then
				return {
					Rank = rank,
					Value = data.Value,
				}
			end
		end
		return "<100"
	else
		-- Update cache if not available
		self:updateCachedLeaderboard(tournamentData.Bracket)
		return "<100"
	end
end

--- Starts a tournament for a player
--- @param person Person.Person
--- @return { success: boolean, error: string? }
function TournamentService:startTournament(person: Person.Person): { success: boolean, error: string? }
	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local tournamentData = PlayerProfileClass:GetField("TournamentsData")

	local currentTournamentData = self:getCurrentTournament()
	if not currentTournamentData then
		return { success = false, error = "No active tournament" }
	end

	-- Update player data if tournament changed
	if not tournamentData or tournamentData.CurrentTournament ~= currentTournamentData.Number then
		self:updatePlayerData(person)
		return { success = false, error = "Tournament data updated, please try again" }
	end

	-- Get place ID
	local placeId = PLACE_IDS[game.GameId]
	if not placeId then
		return { success = false, error = "Invalid game environment" }
	end

	-- Prepare teleport data
	local gameType = "Tournament"
	local mapName = currentTournamentData.MapName
	local difficulty = "Nightmare"
	local gameScenarioID = 1

	-- Notify client of teleport
	local events = ReplicatedStorage.Events
	events.TeleportingToggle:FireClient(player, true, {
		GameType = gameType,
		MapName = mapName,
		GameScenarioID = gameScenarioID,
		Difficulty = difficulty,
	})

	-- Setup teleport options
	local teleportOptions = Instance.new("TeleportOptions")
	teleportOptions.ShouldReserveServer = true
	teleportOptions:SetTeleportData({
		MapName = mapName,
		Difficulty = difficulty,
		GameType = gameType,
		GameScenarioId = gameScenarioID,
		Host = player.UserId,
		ForcedElements = currentTournamentData.ForcedElements,
	})

	-- Attempt teleport
	local success, teleportResult = pcall(function()
		return TeleportService:TeleportAsync(placeId, { player }, teleportOptions)
	end)

	if not success then
		-- Notify client of teleport failure
		events.TeleportingToggle:FireClient(player, false, {
			GameType = gameType,
			MapName = mapName,
			GameScenarioID = gameScenarioID,
			Difficulty = difficulty,
		})

		events.NotifyPlayer:FireClient(player, {
			color = "Error",
			text = "Error occurred when teleporting",
		})

		return { success = false, error = "Teleport failed" }
	end

	-- Track engagement and fire event
	self:_trackEngagement(person, "Tournaments")
	self.tournamentStarted:fire(person, currentTournamentData.Number)

	return { success = true }
end

--- Updates tournament stats for a player
--- @param person Person.Person
--- @param kills number
--- @param damage number
function TournamentService:updateStats(person: Person.Person, kills: number, damage: number)
	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local tournamentData = PlayerProfileClass:GetField("TournamentsData")

	if tournamentData then
		tournamentData.Kills = math.max(tournamentData.Kills, kills)
		tournamentData.Damage = math.max(tournamentData.Damage, damage)

		PlayerProfileClass:WriteField("TournamentsData", tournamentData, true)
		self:updatePlayerLeaderboard(person, tournamentData)
	end
end

--- Claims tournament rewards
--- @param person Person.Person
--- @param tournamentNumber TournamentNumber
--- @return { success: boolean, rewards: any?, error: string? }
function TournamentService:claimRewards(
	person: Person.Person,
	tournamentNumber: TournamentNumber
): { success: boolean, rewards: any?, error: string? }
	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local tournamentData = PlayerProfileClass:GetField("TournamentsData")

	if not tournamentData or not tournamentData.PreviousResults[tournamentNumber] then
		return { success = false, error = "Tournament result not found" }
	end

	local result = tournamentData.PreviousResults[tournamentNumber]

	if result.ClaimedRewards then
		return { success = false, error = "Rewards already claimed" }
	end

	if not result.RewardsToClaim then
		return { success = false, error = "No rewards available" }
	end

	-- Give rewards
	local rewards = RewardLibrary:ProcessReward(player, result.RewardsToClaim)

	-- Mark as claimed
	result.ClaimedRewards = true
	PlayerProfileClass:WriteField("TournamentsData", tournamentData, true)

	self.rewardClaimed:fire(person, tournamentNumber, rewards)

	return { success = true, rewards = rewards }
end

--- Starts the tournament monitoring loop
--- @private
function TournamentService:_startTournamentLoop()
	task.spawn(function()
		local currentTournamentData = self:getCurrentTournament()
		if currentTournamentData then
			self._lastTournamentNumber = currentTournamentData.Number
		end

		while true do
			local newTournamentData = self:getCurrentTournament()

			if newTournamentData and newTournamentData.Number ~= self._lastTournamentNumber then
				self._lastTournamentNumber = newTournamentData.Number

				-- Clear cached leaderboard data
				self._cachedLeaderboardData = {}

				-- Update all players' tournament data
				for _, player in Players:GetPlayers() do
					local person = Person.new(player)
					self:updatePlayerData(person)
				end
			end

			task.wait(1)
		end
	end)
end

--- Handles new player joining
--- @param person Person.Person
function TournamentService:playerJoined(person: Person.Person)
	self:updatePlayerData(person)
end

--- Initializes the service
function TournamentService:start()
	self:_initializeDependencies()
	self:_startTournamentLoop()

	-- Handle player joining
	Players.PlayerAdded:Connect(function(player)
		local person = Person.new(player)
		self:playerJoined(person)
	end)

	return "TournamentService loaded"
end

return TournamentService
