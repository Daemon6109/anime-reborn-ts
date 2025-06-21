--------------------------------------------------------------------------------
-- analytics
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Person = require("@commonserver/person")

local AnalyticsService = game:GetService("AnalyticsService")

-- Analytics constants
local BATCH_SIZE = 50
local BATCH_INTERVAL = 30 -- seconds

-- Store pending events for batching
local pendingEvents: { { player: Player?, eventName: string, parameters: { [string]: any }, timestamp: number } } = {}
local sessionData: { [Player]: { joinTime: number, lastActivity: number } } = {}

--[=[
   Analytics system for tracking player behavior and game metrics.

   @class Analytics
]=]
local Analytics = {
	version = version,
}

--[=[
   Tracks when a player joins the game

   @within Analytics

   @param person Person -- The person who joined

   ```lua
   Analytics.trackPlayerJoined(person)
   ```
]=]
function Analytics.trackPlayerJoined(person: Person.Person): ()
	local player = person.player
	local joinTime = os.time()
	sessionData[player] = {
		joinTime = joinTime,
		lastActivity = joinTime,
	}

	local cache = person.dataCache()

	table.insert(pendingEvents, {
		player = player,
		eventName = "PlayerJoined",
		parameters = {
			level = cache.Level or 1,
			playtime = cache.PlayerStatistics and cache.PlayerStatistics.PlayTime or 0,
			gamesPlayed = cache.PlayerStatistics and cache.PlayerStatistics.GamesPlayed or 0,
		},
		timestamp = joinTime,
	})
end

--[=[
   Tracks when a player leaves the game

   @within Analytics

   @param player Player -- The player who left

   ```lua
   Analytics.trackPlayerLeft(player)
   ```
]=]
function Analytics.trackPlayerLeft(player: Player): ()
	local leaveTime = os.time()
	local sessionInfo = sessionData[player]

	if sessionInfo then
		local sessionDuration = leaveTime - sessionInfo.joinTime

		table.insert(pendingEvents, {
			player = player,
			eventName = "PlayerLeft",
			parameters = {
				sessionDuration = sessionDuration,
				playtime = sessionDuration,
			},
			timestamp = leaveTime,
		})

		sessionData[player] = nil
	end
end

--[=[
   Tracks when a player's character is added

   @within Analytics

   @param player Player -- The player whose character was added

   ```lua
   Analytics.trackCharacterAdded(player)
   ```
]=]
function Analytics.trackCharacterAdded(player: Player): ()
	if sessionData[player] then
		sessionData[player].lastActivity = os.time()
	end

	table.insert(pendingEvents, {
		player = player,
		eventName = "CharacterSpawned",
		parameters = {
			spawnTime = os.time(),
		},
		timestamp = os.time(),
	})
end

--[=[
   Processes pending events and sends them to AnalyticsService

   @within Analytics

   ```lua
   Analytics.processPendingEvents()
   ```
]=]
function Analytics.processPendingEvents(): ()
	if #pendingEvents == 0 then
		return
	end

	-- Process events in batches
	local batchCount = math.min(BATCH_SIZE, #pendingEvents)

	for i = 1, batchCount do
		local event = pendingEvents[i]

		-- Use pcall to handle any analytics errors gracefully
		local success, error = pcall(function()
			if event.player and event.player.Parent then
				-- Only log for players still in game
				-- AnalyticsService:LogCustomEvent expects (player, eventName, customData?)
				-- where customData is optional number, so we'll log without parameters for now
				AnalyticsService:LogCustomEvent(event.player, event.eventName)
			end
		end)

		if not success then
			warn("Analytics error:", error)
		end
	end

	-- Remove processed events
	for i = batchCount, 1, -1 do
		table.remove(pendingEvents, i)
	end
end

--[=[
   Tracks a custom event

   @within Analytics

   @param player Player? -- The player associated with the event (optional)
   @param eventName string -- The name of the event
   @param parameters { [string]: any } -- Additional parameters for the event

   ```lua
   Analytics.trackEvent(player, "CustomEventName", { key1 = "value1", key2 = "value2" })
   ```
]=]
function Analytics.trackEvent(player: Player?, eventName: string, parameters: { [string]: any }): ()
	table.insert(pendingEvents, {
		player = player,
		eventName = eventName,
		parameters = parameters,
		timestamp = os.time(),
	})
end

--[=[
   Tracks an error event

   @within Analytics

   @param errorMessage string -- The error message
   @param errorType string -- The type of error (e.g., "Network", "Server", etc.)

   ```lua
   Analytics.trackError("An error occurred", "Network")
   ```
]=]
function Analytics.trackError(errorMessage: string, errorType: string): ()
	local parameters = {
		errorMessage = errorMessage,
		errorType = errorType,
		timestamp = os.time(),
	}

	-- Create event without player since it's a system error
	table.insert(pendingEvents, {
		player = nil,
		eventName = "SystemError",
		parameters = parameters,
		timestamp = os.time(),
	})
end

--[=[
   Tracks player performance metrics

   @within Analytics

   @param person Person -- The person to track performance for

   ```lua
   Analytics.trackPerformance(person)
   ```
]=]
function Analytics.trackPerformance(person: Person.Person): ()
	local player = person.player
	local sessionInfo = sessionData[player]
	if not sessionInfo then
		return
	end

	local currentTime = os.time()
	local sessionDuration = currentTime - sessionInfo.joinTime
	local cache = person.dataCache()

	table.insert(pendingEvents, {
		player = player,
		eventName = "PerformanceMetrics",
		parameters = {
			sessionDuration = sessionDuration,
			level = cache.Level or 1,
			playtime = sessionDuration,
		},
		timestamp = currentTime,
	})
end

--[=[
   Gets session data for a player

   @param player Player -- The player to get session data for

   @return { joinTime: number?, lastActivity: number?, sessionDuration: number? }?

   ```lua
   local sessionData = Analytics.getSessionData(player)
   if sessionData then
	   print("Join Time:", sessionData.joinTime)
	   print("Last Activity:", sessionData.lastActivity)
	   print("Session Duration:", sessionData.sessionDuration)
   end
   ```
]=]
function Analytics.getSessionData(
	player: Player
): { joinTime: number?, lastActivity: number?, sessionDuration: number? }?
	local info = sessionData[player]
	if info then
		return {
			joinTime = info.joinTime,
			lastActivity = info.lastActivity,
			sessionDuration = os.time() - info.joinTime,
		}
	end
	return nil
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   analytics.start()
   ```
]=]
local function start(): ()
	-- Analytics doesn't need remote events, but we'll process any pending events
	Analytics.processPendingEvents()

	-- Set up final event processing when the server shuts down
	game:BindToClose(function(): ...any
		Analytics.processPendingEvents()
	end)
end

--[=[
   This function is used for initialization. It should be called before `start()` to set up the provider.

   ```lua
   analytics.init()
   ```
]=]
local function init(): ()
	-- Track player connections
	Person.personAdded:connect(function(person: Person.Person): ()
		Analytics.trackPlayerJoined(person)

		-- Track character spawns
		person.player.CharacterAdded:Connect(function()
			Analytics.trackCharacterAdded(person.player)
		end)
	end)

	Person.personRemoved:connect(function(person: Person.Person): ()
		Analytics.trackPlayerLeft(person.player)
	end)

	-- Set up periodic event processing
	task.spawn(function()
		while true do
			task.wait(BATCH_INTERVAL)
			Analytics.processPendingEvents()
		end
	end)

	-- Set up periodic performance tracking (every 5 minutes)
	task.spawn(function()
		while true do
			task.wait(300) -- 5 minutes
			for player, _ in pairs(sessionData) do
				if player.Parent then
					-- Get person for player to avoid yielding
					local personFuture = Person.getForPlayer(player)
					if personFuture then
						local person = personFuture:Await()
						if person then
							Analytics.trackPerformance(person)
						end
					end
				end
			end
		end
	end)
end

return {
	version = version,
	order = 5, -- Initialize early for tracking
	-- Functions
	init = init,
	start = start,
	trackPlayerJoined = Analytics.trackPlayerJoined,
	trackPlayerLeft = Analytics.trackPlayerLeft,
	trackCharacterAdded = Analytics.trackCharacterAdded,
	trackEvent = Analytics.trackEvent,
	trackError = Analytics.trackError,
	trackPerformance = Analytics.trackPerformance,
	getSessionData = Analytics.getSessionData,
	processPendingEvents = Analytics.processPendingEvents,
}
