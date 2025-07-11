--------------------------------------------------------------------------------
-- leaderboard_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Leaderboard constants
local MAX_PLAYERS = 100
local UPDATE_INTERVAL = 60 -- Update every 60 seconds
local NAME_CACHE_RESET_INTERVAL = 5 -- Reset name cache every 5 updates

-- State tracking
local currentRanking: string? = nil
local updateCount = 0
local requestRankCache: { [string]: { [number]: any } } = {}
local nameCache: { [number]: string } = {}
local isUpdatingModels = false

-- Create signals for leaderboard events
local leaderboardUpdatedEvent = Shingo.new() :: Shingo.Signal<string>
local playerRankChangedEvent = Shingo.new() :: Shingo.Signal<Player, string, number>

type LeaderboardData = {
	name: string,
	displayName: string,
	dataStoreName: string,
	ascending: boolean,
	customFormat: ((number) -> string)?,
	removed: boolean?,
}

type PlayerRankInfo = {
	rank: number,
	value: number,
}

--[=[
   Leaderboard management system for handling player rankings and displays.

   @class LeaderboardService
]=]
local LeaderboardService = {
	version = version,

	-- Events
	leaderboardUpdated = leaderboardUpdatedEvent,
	playerRankChanged = playerRankChangedEvent,
}

--[=[
   Formats a number for display on leaderboards

   @within LeaderboardService

   @param value number -- The number to format

   @return string -- The formatted number string

   ```lua
   local formatted = LeaderboardService.formatNumber(1500)
   -- Returns "1.5K"
   ```
]=]
function LeaderboardService.formatNumber(value: number): string
	if value >= 1000000000 then
		return string.format("%.1fB", value / 1000000000)
	elseif value >= 1000000 then
		return string.format("%.1fM", value / 1000000)
	elseif value >= 1000 then
		return string.format("%.1fK", value / 1000)
	else
		return tostring(value)
	end
end

--[=[
   Gets a player's name from their user ID with caching

   @within LeaderboardService

   @param userId number -- The user ID to get the name for
   @param callback (string) -> () -- Callback function to call with the name

   @error "InvalidUserId" -- When the user ID is invalid

   ```lua
   LeaderboardService.getPlayerNameFromUserId(12345, function(name)
       print("Player name:", name)
   end)
   ```
]=]
function LeaderboardService.getPlayerNameFromUserId(userId: number, callback: (string) -> ()): ()
	-- Check cache first
	if nameCache[userId] then
		callback(nameCache[userId])
		return
	end

	-- Get name with retry logic
	local retryDelay = 2
	local ranOnce = false

	for i = 1, 3 do
		retryDelay *= 2

		local success, name = pcall(function()
			return Players:GetNameFromUserIdAsync(userId)
		end)

		if not ranOnce and not success then
			ranOnce = true
			callback("Loading...")
		end

		if success then
			callback(name)
			nameCache[userId] = name
			return
		end

		task.wait(retryDelay)
	end

	-- Fallback if all retries failed
	callback("Unknown")
end

--[=[
   Gets a player's rank in a specific leaderboard

   @within LeaderboardService

   @param person Person -- The person to get the rank for
   @param leaderboardName string -- The name of the leaderboard
   @param detailed boolean? -- Whether to return detailed rank info

   @return number | PlayerRankInfo | string -- The rank number, detailed info, or "<100" if not in top 100

   @error "InvalidLeaderboard" -- When the leaderboard doesn't exist

   ```lua
   local rank = LeaderboardService.getPlayerRank(person, "TotalWins", true)
   ```
]=]
function LeaderboardService.getPlayerRank(
	person: Person.Person,
	leaderboardName: string,
	detailed: boolean?
): number | PlayerRankInfo | string
	-- Check cache first
	local cachedLeaderboard = requestRankCache[leaderboardName]
	if cachedLeaderboard and cachedLeaderboard[person.player.UserId] then
		return cachedLeaderboard[person.player.UserId]
	end

	-- Get leaderboard data from registry (this would be imported from common data)
	-- For now, using a mock structure
	local leaderboardData: LeaderboardData = {
		name = leaderboardName,
		displayName = leaderboardName,
		dataStoreName = leaderboardName,
		ascending = false,
	}

	local dataStore = DataStoreService:GetOrderedDataStore(leaderboardData.dataStoreName)
	local retryDelay = 1

	for i = 1, 3 do
		retryDelay *= 2

		local success, rank = pcall(function()
			local dataPages = dataStore:GetSortedAsync(leaderboardData.ascending, MAX_PLAYERS)
			local currentPage = dataPages:GetCurrentPage()

			for currentRank, playerData in ipairs(currentPage) do
				local userId = tonumber(playerData.key)
				if userId == person.player.UserId then
					if detailed then
						return { rank = currentRank, value = playerData.value }
					else
						return currentRank
					end
				end
			end
			return nil
		end)

		if success and rank then
			-- Cache the result
			requestRankCache[leaderboardName] = requestRankCache[leaderboardName] or {}
			requestRankCache[leaderboardName][person.player.UserId] = rank
			return rank
		end

		task.wait(retryDelay)
	end

	return "<100"
end

--[=[
   Updates all leaderboards with fresh data

   @within LeaderboardService

   ```lua
   LeaderboardService.updateLeaderboards()
   ```
]=]
function LeaderboardService.updateLeaderboards(): ()
	updateCount += 1

	-- This would iterate through leaderboard configurations from registry
	-- For now, using a mock example
	local leaderboards = {
		TotalWins = {
			name = "TotalWins",
			displayName = "Total Wins",
			dataStoreName = "TotalWins",
			ascending = false,
		},
	}

	for leaderboardName, data in pairs(leaderboards) do
		if data.removed then
			continue
		end

		task.spawn(function()
			local dataStore = DataStoreService:GetOrderedDataStore(data.dataStoreName)
			local success, result = pcall(function()
				local dataPages = dataStore:GetSortedAsync(data.ascending, MAX_PLAYERS)
				return dataPages:GetCurrentPage()
			end)

			if success and result then
				-- Fire update event
				leaderboardUpdatedEvent:fire(leaderboardName)

				-- Update UI leaderboards through network
				local leaderboardData = {}
				for rank, playerData in ipairs(result) do
					local userId = tonumber(playerData.key)
					if userId and userId > 0 then
						table.insert(leaderboardData, {
							rank = rank,
							userId = userId,
							value = playerData.value,
						})
					end
				end

				Network.LeaderboardUpdated.fire(Players:GetPlayers(), {
					leaderboard = leaderboardName,
					data = leaderboardData,
				})
			end
		end)
	end

	-- Clear request cache
	table.clear(requestRankCache)

	-- Reset name cache periodically
	if updateCount >= NAME_CACHE_RESET_INTERVAL then
		updateCount = 0
		table.clear(nameCache)
	end
end

--[=[
   Updates a player's stat in a leaderboard

   @within LeaderboardService

   @param person Person -- The person to update
   @param leaderboardName string -- The leaderboard to update
   @param value number -- The new value

   @error "InvalidLeaderboard" -- When the leaderboard doesn't exist

   ```lua
   LeaderboardService.updatePlayerStat(person, "TotalWins", 150)
   ```
]=]
function LeaderboardService.updatePlayerStat(person: Person.Person, leaderboardName: string, value: number): ()
	local success, error = pcall(function()
		local dataStore = DataStoreService:GetOrderedDataStore(leaderboardName)
		dataStore:SetAsync(tostring(person.player.UserId), value)
	end)

	if not success then
		warn(`Failed to update leaderboard stat for {person.player.Name}: {error}`)
		return
	end

	-- Fire rank changed event
	playerRankChangedEvent:fire(person.player, leaderboardName, value)
end

--[=[
   Initializes the leaderboard service

   @within LeaderboardService

   ```lua
   LeaderboardService.init()
   ```
]=]
function LeaderboardService.init(): ()
	-- Start periodic updates
	task.spawn(function()
		while true do
			LeaderboardService.updateLeaderboards()
			task.wait(UPDATE_INTERVAL)
		end
	end)

	-- Listen for network events
	-- Network.GetPlayerRank.on(function(player: Player, data: { leaderboard: string })
	--     local person = Person.getForPlayer(player):Await()
	--     if person then
	--         local rank = LeaderboardService.getPlayerRank(person, data.leaderboard, true)
	--         Network.PlayerRankResponse.fire(player, { rank = rank })
	--     end
	-- end)

	-- Initial update
	LeaderboardService.updateLeaderboards()
end

return LeaderboardService
