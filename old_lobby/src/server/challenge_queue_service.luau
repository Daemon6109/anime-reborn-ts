--[[
	ChallengeQueueService
	
	Manages challenge queue zones, map selection, and teleportation to challenge games.
	
	@class ChallengeQueueService
	@server
]]

local version = { major = 1, minor = 0, patch = 0 }

local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

-- Dependencies
local Network = require("@network/server")
local Person = require("@commonserver/person")
local Signal = require("@pkgs/shingo")

-- Types
export type ChallengeZoneData = {
	Instance: Model,
	Type: string,
	WaitTime: number,
	MinimumPlayers: number,
	MaximumPlayers: number,
	Players: { Player },
	PlayerConnections: { [Player]: RBXScriptConnection },
	CanPlayersEnter: boolean,
	Active: boolean,
	IsTeleporting: boolean?,
	MapSelector: Player?,
	PassedSelectorTime: number?,
	PassedTime: number,
	Map: string?,
	Challenge: string?,
	Challenges: { [string]: boolean }?,
	ChallengeDisplayName: string?,
	DisplayName: string?,
	Icon: string?,
	BossName: string?,
	ActRewards: ChallengeRewards?,
	RewardPoolSeed: number?,
	RandomSeed: number?,
	PoolType: string?,
	ResetTime: number?,
	Number: number?,
}

export type ChallengeRewards = {
	Set: RewardCategory,
	FirstClear: RewardCategory,
	Random: RewardCategory,
}

export type RewardCategory = {
	Currencies: { [string]: RewardData }?,
	Items: { [string]: RewardData }?,
	Units: { [string]: RewardData }?,
}

export type RewardData = {
	Amount: NumberRange | number,
	Chance: number,
	RNG: NumberRange,
}

export type ChallengeData = {
	GameType: string,
	MapName: string,
	GameScenarioID: string | number,
	Difficulty: string,
	Challenges: { [string]: boolean }?,
	RewardPoolSeed: number?,
	RandomSeed: number?,
	PoolType: string?,
	FriendsOnly: boolean?,
	is24H: boolean?,
}

export type TeleportResult = {
	success: boolean,
	error: string?,
}

--- @class ChallengeQueueService
local ChallengeQueueService = {}
ChallengeQueueService.__index = ChallengeQueueService

-- Constants
local MAP_SELECTOR_TIMEOUT = 30
local DEFAULT_WAIT_TIME = 10
local DEFAULT_MINIMUM_PLAYERS = 1
local DEFAULT_MAXIMUM_PLAYERS = 4
local UPDATE_INTERVAL = 1 / 60 -- 60 FPS updates

local PLACE_IDS = {
	[6717025335] = 127759625243990, -- Production
	[5844593548] = 87213590469285, -- Test
}

local DIFFICULTY_ICONS = {
	Easy = "rbxassetid://18621359625",
	Normal = "rbxassetid://18621367494",
	Hard = "rbxassetid://18621367494",
}

-- Events
local playerJoinedQueue = Signal.new() :: Signal.Signal<Person.Person, ChallengeZoneData>
local playerLeftQueue = Signal.new() :: Signal.Signal<Person.Person, ChallengeZoneData>
local challengeStarted = Signal.new() :: Signal.Signal<ChallengeZoneData, { Player }>
local queueUpdated = Signal.new() :: Signal.Signal<ChallengeZoneData>

-- Registry references
local DataAccess = require(game:GetService("ServerScriptService").ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

-- State
local createdZones: { [Model]: ChallengeZoneData } = {}
local enterCooldowns: { [Player]: boolean } = {}
local currentPoolNumbers: { [string]: { [string]: number } } = {}
local possibleMaps: { string } = {}
local queueCount = 0

function ChallengeQueueService.new()
	local self = setmetatable({}, ChallengeQueueService)

	-- Version tracking
	self.version = version

	-- Network setup
	self._network = Network.new("ChallengeQueueService")
	self:_setupNetwork()

	-- Services
	self._queueLibrary = nil
	self._messagingHandler = nil

	-- State
	self.tick = os.time()
	self.layoutOrders = nil

	return self
end

--- Initializes service dependencies
--- @private
function ChallengeQueueService:_initializeDependencies()
	repeat
		task.wait(0.1)
		self._queueLibrary = _G.Registry and _G.Registry.QueueLibrary
		self._messagingHandler = _G.serverServices.MessagingHandler
	until self._queueLibrary and self._messagingHandler
end

--- Sets up network endpoints
--- @private
function ChallengeQueueService:_setupNetwork()
	-- Queue exit endpoint
	self._network:event("exitQueue", function(person: Person.Person)
		return self:kickPlayer(person)
	end)

	-- Queue status endpoint
	self._network:func("getQueueStatus", function(person: Person.Person)
		local zone = self:getPlayerZone(person)
		return zone
				and {
					mapName = zone.Map,
					challenge = zone.ChallengeDisplayName,
					playersCount = #zone.Players,
					maxPlayers = zone.MaximumPlayers,
					timeLeft = zone.PassedSelectorTime or zone.PassedTime,
				}
			or nil
	end)
end

--- Tracks engagement analytics
--- @param player Player
--- @param featureName string
--- @private
function ChallengeQueueService:_trackEngagement(player: Player, featureName: string)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

--- Creates a new challenge zone
--- @param instance Model -- The zone instance
--- @return ChallengeZoneData
--- @private
function ChallengeQueueService:_createZone(instance: Model): ChallengeZoneData
	if createdZones[instance] then
		return createdZones[instance]
	end

	local zoneType = instance:GetAttribute("ZoneType")

	local zoneData: ChallengeZoneData = {
		Instance = instance,
		Type = "Challenge",
		WaitTime = DEFAULT_WAIT_TIME,
		MinimumPlayers = DEFAULT_MINIMUM_PLAYERS,
		MaximumPlayers = DEFAULT_MAXIMUM_PLAYERS,
		Players = {},
		PlayerConnections = {},
		CanPlayersEnter = true,
		Active = false,
		PassedTime = DEFAULT_WAIT_TIME,
	}

	-- Apply custom zone data if available
	if zoneType and _G.Registry and _G.Registry.CustomData and _G.Registry.CustomData[zoneType] then
		local customData = _G.Registry.CustomData[zoneType]
		for key, value in pairs(customData) do
			zoneData[key] = value
		end
	end

	createdZones[instance] = zoneData
	return zoneData
end

--- Handles player entering a challenge zone
--- @param zoneData ChallengeZoneData
--- @param player Player
--- @private
function ChallengeQueueService:_onEnter(zoneData: ChallengeZoneData, player: Player)
	local character = player.Character
	if not character then
		return
	end

	local enterPosition = zoneData.Instance:FindFirstChild("EnterPosition")
	if not enterPosition then
		return
	end

	-- Position player
	character.HumanoidRootPart.Anchored = true
	character:PivotTo(enterPosition.CFrame)
	character.HumanoidRootPart.Anchored = false

	-- Add to zone
	table.insert(zoneData.Players, player)

	-- Setup cleanup connection
	zoneData.PlayerConnections[player] = character.AncestryChanged:Connect(function()
		if not character.Parent then
			self:kickPlayer(Person.fromPlayer(player))
		end
	end)

	-- Disable windows
	player:SetAttribute("WindowsDisabled", true)

	-- Assign map selector if needed
	if not zoneData.MapSelector then
		zoneData.PassedSelectorTime = MAP_SELECTOR_TIMEOUT
		zoneData.MapSelector = player
		zoneData.CanPlayersEnter = true
	end

	-- Update GUI
	self:_updateZoneGui(zoneData)

	-- Fire event
	playerJoinedQueue:fire(Person.fromPlayer(player), zoneData)
end

--- Removes a player from their queue
--- @param person Person.Person -- The player to remove
function ChallengeQueueService:kickPlayer(person: Person.Person)
	local player = person:getPlayer()
	local zone = self:getPlayerZone(person)

	if not zone then
		return
	end

	local character = player.Character
	local exitPosition = zone.Instance:FindFirstChild("ExitPosition")

	-- Position player at exit
	if character and exitPosition then
		character:PivotTo(exitPosition.CFrame)
	end

	-- Remove from zone
	local index = table.find(zone.Players, player)
	if index then
		table.remove(zone.Players, index)
	end

	-- Cleanup connections
	if zone.PlayerConnections[player] then
		zone.PlayerConnections[player]:Disconnect()
		zone.PlayerConnections[player] = nil
	end

	-- Handle map selector change
	if zone.MapSelector == player then
		zone.MapSelector = nil
		zone.Active = false

		-- Assign new map selector
		for _, otherPlayer in zone.Players do
			zone.MapSelector = otherPlayer
			break
		end

		zone.CanPlayersEnter = true
	end

	-- Re-enable windows
	player:SetAttribute("WindowsDisabled", false)

	-- Update GUI
	self:_updateZoneGui(zone)

	-- Fire event
	playerLeftQueue:fire(person, zone)
end

--- Gets the challenge zone a player is in
--- @param person Person.Person -- The player
--- @return ChallengeZoneData? -- The zone data or nil
function ChallengeQueueService:getPlayerZone(person: Person.Person): ChallengeZoneData?
	local player = person:getPlayer()

	for _, zoneData in createdZones do
		if table.find(zoneData.Players, player) then
			return zoneData
		end
	end

	return nil
end

--- Updates the GUI for a challenge zone
--- @param zoneData ChallengeZoneData
--- @private
function ChallengeQueueService:_updateZoneGui(zoneData: ChallengeZoneData)
	local surfaceGui = zoneData.Instance:FindFirstChild("GuiContainer")
	if not surfaceGui then
		return
	end

	surfaceGui = surfaceGui:FindFirstChildWhichIsA("SurfaceGui")
	if not surfaceGui then
		return
	end

	local container = surfaceGui:FindFirstChild("Container")
	if not container then
		return
	end

	local mapData = container:FindFirstChild("MapData")
	if mapData and zoneData.Map then
		if mapData:FindFirstChild("MapName") then
			mapData.MapName.Text = zoneData.DisplayName or zoneData.Map
		end
		if mapData:FindFirstChild("ActName") then
			mapData.ActName.Text = "Challenge Mode"
		end
		if mapData:FindFirstChild("Challenge") and mapData.Challenge:FindFirstChild("TextLabel") then
			mapData.Challenge.TextLabel.Text = zoneData.ChallengeDisplayName or ""
		end
		if mapData:FindFirstChild("Image") and zoneData.Icon then
			mapData.Image.Image = zoneData.Icon
		end
	end

	-- Update player count displays, timers, etc.
	queueUpdated:fire(zoneData)
end

--- Teleports players to the challenge game
--- @param zoneData ChallengeZoneData
--- @return boolean -- Success
--- @private
function ChallengeQueueService:_teleportPlayers(zoneData: ChallengeZoneData): boolean
	local challengeData: ChallengeData = {
		GameType = "Challenge",
		MapName = zoneData.Map or "",
		GameScenarioID = "1",
		Difficulty = "Nightmare",
		Challenges = zoneData.Challenges,
		RewardPoolSeed = zoneData.RewardPoolSeed,
		RandomSeed = zoneData.RandomSeed,
		PoolType = zoneData.PoolType,
		is24H = zoneData.Instance:GetAttribute("24h"),
	}

	-- Get place ID
	local placeId = PLACE_IDS[game.GameId]
	if not placeId then
		warn("[ChallengeQueueService] Invalid game environment")
		return false
	end

	-- Reserve server
	local success, server, serverId = pcall(function()
		return TeleportService:ReserveServer(placeId)
	end)

	if not success then
		warn("[ChallengeQueueService] Failed to reserve server:", server)
		return false
	end

	-- Handle Studio testing
	if RunService:IsStudio() then
		for _, player in zoneData.Players do
			player:Kick("Studio teleport simulation")
		end
		return true
	end

	-- Setup teleport options
	local teleportOptions = Instance.new("TeleportOptions")
	teleportOptions.ShouldReserveServer = true
	teleportOptions:SetTeleportData({
		MapName = challengeData.MapName,
		Difficulty = challengeData.Difficulty,
		GameType = challengeData.GameType,
		GameScenarioId = challengeData.GameScenarioID,
		PlaceId = placeId,
		PrivateServerId = serverId,
		Challenges = challengeData.Challenges,
		RewardPoolSeed = challengeData.RewardPoolSeed,
		RandomSeed = challengeData.RandomSeed,
		PoolType = challengeData.PoolType,
		Host = zoneData.MapSelector and zoneData.MapSelector.UserId,
		BossName = zoneData.BossName,
		is24H = challengeData.is24H,
	})

	-- Track engagement
	local engagementType = challengeData.is24H and "DailyChallenge" or "Challenge"
	for _, player in zoneData.Players do
		self:_trackEngagement(player, engagementType)
	end

	-- Perform teleport
	local teleportSuccess, teleportResult = pcall(function()
		return TeleportService:TeleportAsync(placeId, zoneData.Players, teleportOptions)
	end)

	if not teleportSuccess then
		warn("[ChallengeQueueService] Teleport failed:", teleportResult)
		return false
	end

	-- Mark players as teleporting
	for _, player in zoneData.Players do
		player:SetAttribute("Teleporting", true)
	end

	return true
end

--- Starts a challenge game for a zone
--- @param zoneData ChallengeZoneData
function ChallengeQueueService:startGame(zoneData: ChallengeZoneData)
	if zoneData.IsTeleporting then
		return
	end

	zoneData.PassedTime = 0
	zoneData.CanPlayersEnter = false
	zoneData.IsTeleporting = true

	-- Attempt teleport
	if not self:_teleportPlayers(zoneData) then
		-- Reset on failure
		zoneData.IsTeleporting = false
		zoneData.CanPlayersEnter = true
		zoneData.PassedTime = 5 -- Cooldown to prevent spam
		return
	end

	-- Fire event
	challengeStarted:fire(zoneData, table.clone(zoneData.Players))

	-- Cleanup zone
	for _, connection in zoneData.PlayerConnections do
		connection:Disconnect()
	end

	zoneData.Active = false
	zoneData.Players = {}
	zoneData.PlayerConnections = {}
	zoneData.MapSelector = nil
	zoneData.PassedSelectorTime = nil

	-- Reset zone after delay
	task.wait(5)
	zoneData.CanPlayersEnter = true
	zoneData.IsTeleporting = false
end

--- Validates challenge requirements for a player
--- @param person Person.Person -- The player
--- @param challengeData ChallengeData -- The challenge data
--- @return boolean -- Whether requirements are met
--- @private
function ChallengeQueueService:_validateRequirements(person: Person.Person, challengeData: ChallengeData): boolean
	local player = person:getPlayer()

	-- Check if queue library is available
	if not self._queueLibrary then
		return false
	end

	-- Use queue library to check requirements
	return self._queueLibrary:CheckRequirements(player, challengeData) == true
end

--- Generates hourly/daily challenge rotations
--- @param zoneData ChallengeZoneData
--- @private
function ChallengeQueueService:_generateChallengeRotation(zoneData: ChallengeZoneData)
	local is24h = zoneData.Instance:GetAttribute("24h")
	local currentTime = os.time()
	local date = os.date("!*t", currentTime)

	-- Determine reset time
	local resetTime: number
	if is24h then
		-- Daily reset at midnight UTC
		resetTime = os.time({
			year = date.year,
			month = date.month,
			day = date.day + 1,
			hour = 0,
			min = 0,
			sec = 0,
		})
	else
		-- Hourly reset
		resetTime = os.time({
			year = date.year,
			month = date.month,
			day = date.day,
			hour = date.hour + 1,
			min = 0,
			sec = 0,
		})
	end

	zoneData.ResetTime = resetTime

	-- Generate zone number if needed
	if not zoneData.Number then
		queueCount += 1
		zoneData.Number = queueCount
	end

	-- Generate seeds
	local randomSeed = is24h and tonumber(date.yday) * zoneData.Number
		or tonumber(date.yday .. date.hour) * zoneData.Number

	zoneData.RewardPoolSeed = randomSeed

	local rng = Random.new(randomSeed)

	-- Select random map
	if #possibleMaps <= 0 then
		self:_refreshMapPool()
	end

	if #possibleMaps > 0 then
		local chosenMap = possibleMaps[rng:NextInteger(1, #possibleMaps)]
		table.remove(possibleMaps, table.find(possibleMaps, chosenMap))
		zoneData.Map = chosenMap

		-- Set display info
		local mapRegistry = _G.Registry and _G.Registry.registry and _G.Registry.registry.Maps
		if mapRegistry and mapRegistry[chosenMap] then
			local mapData = mapRegistry[chosenMap]
			zoneData.DisplayName = mapData.DisplayName
			zoneData.Icon = mapData.Icon
		end
	end

	-- Select random challenge
	local challengeRegistry = _G.Registry and _G.Registry.registry and _G.Registry.registry.Challenges
	if challengeRegistry then
		local possibleChallenges = {}
		for challengeName, _ in challengeRegistry do
			if challengeName ~= "Traits Disabled" then
				table.insert(possibleChallenges, challengeName)
			end
		end

		if #possibleChallenges > 0 then
			local chosenChallenge = possibleChallenges[rng:NextInteger(1, #possibleChallenges)]
			zoneData.Challenge = chosenChallenge
			zoneData.Challenges = { [chosenChallenge] = true }
			zoneData.ChallengeDisplayName = challengeRegistry[chosenChallenge].DisplayName
		end
	end

	-- Generate rewards and pool type
	self:_generateRewards(zoneData, rng)
end

--- Refreshes the available map pool
--- @private
function ChallengeQueueService:_refreshMapPool()
	possibleMaps = {}

	local mapRegistry = _G.Registry and _G.Registry.registry and _G.Registry.registry.Maps
	if not mapRegistry then
		return
	end

	for mapName, mapData in mapRegistry do
		if
			mapData.raw
			and mapData.raw.Released
			and mapData.raw.Released.Value
			and mapData.raw:FindFirstChild("Challenge")
		then
			table.insert(possibleMaps, mapName)
		end
	end
end

--- Generates challenge rewards for a zone
--- @param zoneData ChallengeZoneData
--- @param rng Random
--- @private
function ChallengeQueueService:_generateRewards(zoneData: ChallengeZoneData, rng: Random)
	-- This would implement the complex reward generation logic
	-- For now, we'll create a basic structure

	zoneData.ActRewards = {
		Set = {
			Currencies = {},
			Items = {},
			Units = {},
		},
		FirstClear = {
			Currencies = {},
			Items = {},
			Units = {},
		},
		Random = {
			Currencies = {},
			Items = {},
			Units = {},
		},
	}

	-- Add basic rewards based on challenge type
	local is24h = zoneData.Instance:GetAttribute("24h")
	if is24h then
		-- Daily challenge rewards
		zoneData.ActRewards.Random.Currencies = {
			Gold = { Amount = 1000, Chance = 1, RNG = NumberRange.new(1, 1) },
			Gems = { Amount = 1000, Chance = 1, RNG = NumberRange.new(1, 1) },
		}
		zoneData.ActRewards.Set.Items = {
			TraitCrystal = 20,
			PotentialKey = 10,
			FrostKey = 10,
			bloodexpvile = 1,
		}
	else
		-- Regular challenge rewards
		zoneData.ActRewards.Random.Currencies = {
			Gold = { Amount = NumberRange.new(40, 60), Chance = 1, RNG = NumberRange.new(1, 1) },
			Gems = { Amount = NumberRange.new(40, 60), Chance = 1, RNG = NumberRange.new(1, 1) },
		}
	end
end

--- Initializes all challenge zones
function ChallengeQueueService:start()
	self:_initializeDependencies()

	-- Find and setup challenge zones
	local challengeZones = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("QueueChallengeZones")
	if not challengeZones then
		warn("[ChallengeQueueService] No challenge zones found")
		return
	end

	-- Setup each zone
	for _, zone in challengeZones:GetChildren() do
		local hitbox = zone:FindFirstChild("Hitbox")
		local exitPosition = zone:FindFirstChild("ExitPosition")
		local enterPosition = zone:FindFirstChild("EnterPosition")

		if not (hitbox and exitPosition and enterPosition) then
			warn(`[ChallengeQueueService] Zone {zone.Name} missing required parts`)
			continue
		end

		local zoneData = self:_createZone(zone)

		-- Setup touch detection
		hitbox.Touched:Connect(function(hit)
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if not player or enterCooldowns[player] or player:GetAttribute("Teleporting") then
				return
			end

			enterCooldowns[player] = true
			task.delay(1, function()
				enterCooldowns[player] = nil
			end)

			-- Check if zone is available
			if not zoneData.CanPlayersEnter or zoneData.IsTeleporting then
				return
			end

			if #zoneData.Players >= zoneData.MaximumPlayers or self:getPlayerZone(Person.fromPlayer(player)) then
				return
			end

			-- Validate player requirements
			local person = Person.fromPlayer(player)
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)

			-- Check if player has units equipped
			local slotbar = PlayerProfileClass:GetField("Slotbar")
			local hasUnits = false

			for _, slot in slotbar do
				if slot and slot.UnitName and slot.UnitName ~= "" then
					hasUnits = true
					break
				end
			end

			if not hasUnits then
				-- Notify player - would use notification service in production
				return
			end

			-- Check daily challenge cooldown
			if zone:GetAttribute("24h") then
				local lastPlayed = PlayerProfileClass:GetField("DailyChallenge")
				if lastPlayed then
					local now = os.time()
					local nextReset = self:_getNextResetTime(lastPlayed)

					if now < nextReset then
						-- Notify player - would use notification service in production
						return
					end
				end
			end

			self:_onEnter(zoneData, player)
		end)

		-- Generate initial challenge rotation
		self:_generateChallengeRotation(zoneData)
	end

	-- Start update loop
	self:_startUpdateLoop()

	return "ChallengeQueueService loaded"
end

--- Gets next reset time for daily challenges
--- @param timestamp number
--- @return number
--- @private
function ChallengeQueueService:_getNextResetTime(timestamp: number): number
	local utcDate = os.date("!*t", timestamp)
	return os.time({
		year = utcDate.year,
		month = utcDate.month,
		day = utcDate.day + 1,
		hour = 0,
		min = 0,
		sec = 0,
	})
end

--- Starts the main update loop
--- @private
function ChallengeQueueService:_startUpdateLoop()
	RunService.PostSimulation:Connect(function(deltaTime)
		for _, zoneData in createdZones do
			self:_updateZone(zoneData, deltaTime)
		end

		-- Update timers every second
		if os.time() - self.tick >= 1 then
			self.tick = os.time()
			self:_updateTimers()
		end
	end)
end

--- Updates a single zone's state
--- @param zoneData ChallengeZoneData
--- @param deltaTime number
--- @private
function ChallengeQueueService:_updateZone(zoneData: ChallengeZoneData, deltaTime: number)
	local playerCount = #zoneData.Players

	-- Handle map selector timeout
	if not zoneData.ChosenData and zoneData.MapSelector then
		if zoneData.PassedSelectorTime and zoneData.PassedSelectorTime <= 0 then
			if not zoneData.IsTeleporting then
				self:startGame(zoneData)
			end
		elseif zoneData.PassedSelectorTime then
			zoneData.PassedSelectorTime -= deltaTime
		end
	end

	-- Handle queue timer
	if playerCount >= zoneData.MinimumPlayers and playerCount <= zoneData.MaximumPlayers then
		if zoneData.Active then
			if zoneData.PassedTime > 0 then
				zoneData.PassedTime -= deltaTime
			elseif not zoneData.IsTeleporting then
				self:startGame(zoneData)
			end
		end
	else
		zoneData.Active = false
		zoneData.PassedTime = zoneData.WaitTime
	end
end

--- Updates zone timers and rotations
--- @private
function ChallengeQueueService:_updateTimers()
	for _, zoneData in createdZones do
		-- Check for challenge rotation
		if not zoneData.ResetTime or os.time() >= zoneData.ResetTime then
			self:_generateChallengeRotation(zoneData)
			self:_updateZoneGui(zoneData)
		end
	end
end

-- Events
ChallengeQueueService.playerJoinedQueue = playerJoinedQueue
ChallengeQueueService.playerLeftQueue = playerLeftQueue
ChallengeQueueService.challengeStarted = challengeStarted
ChallengeQueueService.queueUpdated = queueUpdated

-- Version
ChallengeQueueService.version = version

return ChallengeQueueService.new()
