--------------------------------------------------------------------------------
-- queue_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

-- Queue constants
local DEFAULT_WAIT_TIME = 30
local DEFAULT_MIN_PLAYERS = 1
local DEFAULT_MAX_PLAYERS = 4
local MAP_SELECTOR_TIMEOUT = 30

-- State tracking
local activeQueues: { [string]: QueueData } = {}
local playerQueues: { [Player]: string } = {}
local enterCooldowns: { [Player]: boolean } = {}

-- Create signals for queue events
local playerJoinedQueueEvent = Shingo.new() :: Shingo.Signal<Player, string>
local playerLeftQueueEvent = Shingo.new() :: Shingo.Signal<Player, string>
local queueStartedEvent = Shingo.new() :: Shingo.Signal<string, { Player }>
local queueCancelledEvent = Shingo.new() :: Shingo.Signal<string>

type QueuePlayer = {
	person: Person.Person,
	joinTime: number,
	ready: boolean,
}

type QueueConfiguration = {
	mode: string,
	mapName: string,
	difficulty: string,
	minPlayers: number,
	maxPlayers: number,
	waitTime: number,
	placeId: number?,
}

type QueueData = {
	id: string,
	config: QueueConfiguration,
	players: { QueuePlayer },
	startTime: number?,
	mapSelectorActive: boolean,
	mapSelectorTimeout: number?,
}

--[=[
   Queue management system for handling matchmaking and game sessions.

   @class QueueService
]=]
local QueueService = {
	version = version,

	-- Events
	playerJoinedQueue = playerJoinedQueueEvent,
	playerLeftQueue = playerLeftQueueEvent,
	queueStarted = queueStartedEvent,
	queueCancelled = queueCancelledEvent,
}

--[=[
   Creates a new queue with the specified configuration

   @within QueueService

   @param queueId string -- Unique identifier for the queue
   @param config QueueConfiguration -- Configuration for the queue

   @return QueueData -- The created queue data

   @error "QueueAlreadyExists" -- When a queue with the same ID already exists

   ```lua
   local queue = QueueService.createQueue("dungeon_1", {
       mode = "Dungeon",
       mapName = "TestMap",
       difficulty = "Normal",
       minPlayers = 1,
       maxPlayers = 4,
       waitTime = 30
   })
   ```
]=]
function QueueService.createQueue(queueId: string, config: QueueConfiguration): QueueData
	if activeQueues[queueId] then
		error(`Queue with ID {queueId} already exists`)
	end

	local queueData: QueueData = {
		id = queueId,
		config = config,
		players = {},
		startTime = nil,
		mapSelectorActive = false,
		mapSelectorTimeout = nil,
	}

	activeQueues[queueId] = queueData
	return queueData
end

--[=[
   Adds a player to a queue

   @within QueueService

   @param person Person -- The person joining the queue
   @param queueId string -- The queue to join

   @return boolean -- Whether the player was successfully added

   @error "QueueNotFound" -- When the queue doesn't exist
   @error "QueueFull" -- When the queue is at capacity
   @error "PlayerAlreadyQueued" -- When the player is already in a queue

   ```lua
   local success = QueueService.joinQueue(person, "dungeon_1")
   ```
]=]
function QueueService.joinQueue(person: Person.Person, queueId: string): boolean
	local queue = activeQueues[queueId]
	if not queue then
		warn(`Queue {queueId} not found`)
		return false
	end

	-- Check if player is already in a queue
	if playerQueues[person.player] then
		warn(`Player {person.player.Name} is already in queue {playerQueues[person.player]}`)
		return false
	end

	-- Check if queue is full
	if #queue.players >= queue.config.maxPlayers then
		warn(`Queue {queueId} is full`)
		return false
	end

	-- Check cooldown
	if enterCooldowns[person.player] then
		return false
	end

	-- Add player to queue
	local queuePlayer: QueuePlayer = {
		person = person,
		joinTime = os.time(),
		ready = false,
	}

	table.insert(queue.players, queuePlayer)
	playerQueues[person.player] = queueId

	-- Set cooldown
	enterCooldowns[person.player] = true
	task.delay(1, function()
		enterCooldowns[person.player] = nil
	end)

	-- Fire events
	playerJoinedQueueEvent:fire(person.player, queueId)
	Network.PlayerJoinedQueue.fire(person.player, {
		queueId = queueId,
		playerCount = #queue.players,
		maxPlayers = queue.config.maxPlayers,
	})

	-- Check if queue should start
	QueueService.checkQueueStart(queueId)

	return true
end

--[=[
   Removes a player from their current queue

   @within QueueService

   @param person Person -- The person leaving the queue

   @return boolean -- Whether the player was successfully removed

   ```lua
   local success = QueueService.leaveQueue(person)
   ```
]=]
function QueueService.leaveQueue(person: Person.Person): boolean
	local queueId = playerQueues[person.player]
	if not queueId then
		return false
	end

	local queue = activeQueues[queueId]
	if not queue then
		return false
	end

	-- Remove player from queue
	for i, queuePlayer in ipairs(queue.players) do
		if queuePlayer.person.player == person.player then
			table.remove(queue.players, i)
			break
		end
	end

	playerQueues[person.player] = nil

	-- Fire events
	playerLeftQueueEvent:fire(person.player, queueId)
	Network.PlayerLeftQueue.fire(person.player, { queueId = queueId })

	-- Check if queue should be cancelled
	if #queue.players < queue.config.minPlayers and queue.startTime then
		QueueService.cancelQueue(queueId)
	end

	return true
end

--[=[
   Checks if a queue should start based on current conditions

   @within QueueService

   @param queueId string -- The queue to check

   ```lua
   QueueService.checkQueueStart("dungeon_1")
   ```
]=]
function QueueService.checkQueueStart(queueId: string): ()
	local queue = activeQueues[queueId]
	if not queue or queue.startTime then
		return
	end

	-- Check if minimum players reached
	if #queue.players >= queue.config.minPlayers then
		queue.startTime = os.time()

		-- Start countdown
		task.spawn(function()
			task.wait(queue.config.waitTime)
			QueueService.startQueue(queueId)
		end)

		-- Notify players
		for _, queuePlayer in ipairs(queue.players) do
			Network.QueueCountdownStarted.fire(queuePlayer.person.player, {
				queueId = queueId,
				waitTime = queue.config.waitTime,
			})
		end
	end
end

--[=[
   Starts a queue and teleports players to the game

   @within QueueService

   @param queueId string -- The queue to start

   @error "QueueNotFound" -- When the queue doesn't exist

   ```lua
   QueueService.startQueue("dungeon_1")
   ```
]=]
function QueueService.startQueue(queueId: string): ()
	local queue = activeQueues[queueId]
	if not queue then
		warn(`Queue {queueId} not found`)
		return
	end

	-- Validate we have enough players
	if #queue.players < queue.config.minPlayers then
		QueueService.cancelQueue(queueId)
		return
	end

	-- Get target place ID (would come from configuration)
	local targetPlaceId = queue.config.placeId or 127759625243990 -- Default to gameplay place

	-- Reserve server
	local success, accessCode = pcall(function()
		return TeleportService:ReserveServer(targetPlaceId)
	end)

	if not success then
		warn(`Failed to reserve server for queue {queueId}: {accessCode}`)
		QueueService.cancelQueue(queueId)
		return
	end

	-- Prepare teleport data
	local teleportData = {
		QueueId = queueId,
		Mode = queue.config.mode,
		MapName = queue.config.mapName,
		Difficulty = queue.config.difficulty,
		Players = {},
	}

	-- Collect players
	local playersToTeleport = {}
	for _, queuePlayer in ipairs(queue.players) do
		table.insert(playersToTeleport, queuePlayer.person.player)
		table.insert(teleportData.Players, {
			UserId = queuePlayer.person.player.UserId,
			Name = queuePlayer.person.player.Name,
		})
	end

	-- Fire events
	queueStartedEvent:fire(queueId, playersToTeleport)

	-- Teleport players
	local teleportSuccess, teleportError = pcall(function()
		TeleportService:TeleportToPrivateServer(targetPlaceId, accessCode, playersToTeleport, nil, teleportData)
	end)

	if not teleportSuccess then
		warn(`Failed to teleport players from queue {queueId}: {teleportError}`)
		QueueService.cancelQueue(queueId)
		return
	end

	-- Clean up queue
	QueueService.destroyQueue(queueId)
end

--[=[
   Cancels a queue and notifies all players

   @within QueueService

   @param queueId string -- The queue to cancel

   ```lua
   QueueService.cancelQueue("dungeon_1")
   ```
]=]
function QueueService.cancelQueue(queueId: string): ()
	local queue = activeQueues[queueId]
	if not queue then
		return
	end

	-- Notify players
	for _, queuePlayer in ipairs(queue.players) do
		playerQueues[queuePlayer.person.player] = nil
		Network.QueueCancelled.fire(queuePlayer.person.player, { queueId = queueId })
	end

	-- Fire events
	queueCancelledEvent:fire(queueId)

	-- Clean up
	QueueService.destroyQueue(queueId)
end

--[=[
   Destroys a queue and cleans up resources

   @within QueueService

   @param queueId string -- The queue to destroy

   ```lua
   QueueService.destroyQueue("dungeon_1")
   ```
]=]
function QueueService.destroyQueue(queueId: string): ()
	local queue = activeQueues[queueId]
	if not queue then
		return
	end

	-- Clean up player tracking
	for _, queuePlayer in ipairs(queue.players) do
		playerQueues[queuePlayer.person.player] = nil
	end

	-- Remove queue
	activeQueues[queueId] = nil
end

--[=[
   Gets the current queue state for a player

   @within QueueService

   @param person Person -- The person to get queue info for

   @return QueueData? -- The queue data if the player is in a queue

   ```lua
   local queueData = QueueService.getPlayerQueue(person)
   ```
]=]
function QueueService.getPlayerQueue(person: Person.Person): QueueData?
	local queueId = playerQueues[person.player]
	if queueId then
		return activeQueues[queueId]
	end
	return nil
end

--[=[
   Initializes the queue service

   @within QueueService

   ```lua
   QueueService.init()
   ```
]=]
function QueueService.init(): ()
	-- Clean up when players leave
	Players.PlayerRemoving:Connect(function(player: Player)
		local queueId = playerQueues[player]
		if queueId then
			-- Create a temporary person object for cleanup
			local tempPerson = { player = player }
			QueueService.leaveQueue(tempPerson :: any)
		end
	end)

	-- Listen for network events when they're added
	Network.JoinQueue.on(function(player: Player, data: { queueId: string }): ()
		local person = Person.getForPlayer(player):Await()
		if person then
			QueueService.joinQueue(person, data.queueId)
		end
	end)

	Network.LeaveQueue.on(function(player: Player): ()
		local person = Person.getForPlayer(player):Await()
		if person then
			QueueService.leaveQueue(person)
		end
	end)
end

return QueueService
