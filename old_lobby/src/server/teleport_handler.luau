--------------------------------------------------------------------------------
-- teleport_handler
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Game configuration
local GAME_PLACES = {
	-- Production place IDs
	[6717025335] = 127759625243990, -- Production lobby -> gameplay
	-- Development place IDs
	[5844593548] = 87213590469285, -- Dev lobby -> dev gameplay
}

-- Create signals for teleport events
local teleportStartedEvent = Shingo.new() :: Shingo.Signal<Player, string, string>
local teleportFailedEvent = Shingo.new() :: Shingo.Signal<Player, string>

--[=[
   Teleport system for managing player transport between places.

   @class TeleportHandler
]=]
local TeleportHandler = {
	version = version,

	-- Events
	teleportStarted = teleportStartedEvent,
	teleportFailed = teleportFailedEvent,
}

--[=[
   Checks if a player can access a specific mission

   @within TeleportHandler

   @param person Person -- The person attempting to teleport
   @param gameType string -- The type of game (Story, Infinity, Challenge)
   @param mapName string -- The map name
   @param scenarioId number -- The scenario/chapter ID

   @return boolean -- Whether the player can access this mission

   ```lua
   local canAccess = TeleportHandler.canAccessMission(person, "Story", "Tutorial", 1)
   ```
]=]
function TeleportHandler.canAccessMission(
	person: Person.Person,
	gameType: string,
	mapName: string,
	scenarioId: number
): boolean
	local cache = person.dataCache()
	local missions = cache.MissionCompletionData or {}

	-- Always allow first scenario
	if scenarioId == 1 then
		return true
	end

	-- Check if previous scenarios are completed
	if missions[gameType] and missions[gameType][mapName] then
		return missions[gameType][mapName][scenarioId - 1] ~= nil
	end

	return false
end

--[=[
   Teleports a player to a game instance

   @within TeleportHandler

   @param person Person -- The person to teleport
   @param gameType string -- The type of game
   @param mapName string -- The map name
   @param scenarioId number -- The scenario/chapter ID
   @param difficulty string? -- The difficulty level

   ```lua
   TeleportHandler.teleportPlayer(person, "Story", "Tutorial", 1, "Normal")
   ```
]=]
function TeleportHandler.teleportPlayer(
	person: Person.Person,
	gameType: string,
	mapName: string,
	scenarioId: number,
	difficulty: string?
): ()
	local player = person.player

	-- Check if already teleporting
	if player:GetAttribute("Teleporting") then
		warn(`Player {player.Name} is already teleporting`)
		return
	end

	-- Validate access
	if not TeleportHandler.canAccessMission(person, gameType, mapName, scenarioId) then
		warn(`Player {player.Name} attempted to access unauthorized mission: {gameType}/{mapName}/{scenarioId}`)
		player:Kick("Unauthorized mission access attempt")
		return
	end

	-- Get target place ID
	local currentGameId = game.GameId
	local targetPlaceId = GAME_PLACES[currentGameId]

	if not targetPlaceId then
		warn(`No target place configured for game ID: {currentGameId}`)
		teleportFailedEvent:Fire(player, "No target place configured")
		return
	end

	-- Reserve server
	local success, accessCode = pcall(function()
		return TeleportService:ReserveServer(targetPlaceId)
	end)

	if not success then
		warn(`Failed to reserve server for player {player.Name}: {accessCode}`)
		teleportFailedEvent:Fire(player, "Failed to reserve server")
		return
	end

	-- Mark as teleporting
	player:SetAttribute("Teleporting", true)

	-- Prepare teleport data
	local teleportData = {
		MapName = mapName,
		Difficulty = difficulty or "Normal",
		GameType = gameType,
		GameScenarioId = scenarioId,
	}

	-- Fire event
	teleportStartedEvent:Fire(player, gameType, mapName)

	-- Teleport to private server
	local teleportSuccess, teleportError = pcall(function()
		TeleportService:TeleportToPrivateServer(targetPlaceId, accessCode, { player }, nil, teleportData)
	end)

	if not teleportSuccess then
		warn(`Failed to teleport player {player.Name}: {teleportError}`)
		player:SetAttribute("Teleporting", false)
		teleportFailedEvent:Fire(player, "Teleport failed")
	end
end

--[=[
   Initializes the teleport handler

   @within TeleportHandler

   ```lua
   TeleportHandler.init()
   ```
]=]
function TeleportHandler.init(): () -- Listen for teleport requests
	Network.TeleportRequest.on(function(player: Player, data: { placeId: number, data: { [string]: any }? })
		local person = Person.getForPlayer(player):Await()
		if person then
			-- Extract teleport data
			local teleportData = data.data or {}
			local placeId = data.placeId

			-- Use a simple teleport for now
			local success, err = pcall(function()
				TeleportService:Teleport(placeId, player, teleportData)
			end)

			if not success then
				warn(`Failed to teleport player {player.Name}: {err}`)
				teleportFailedEvent:Fire(player, "Teleport failed")
			else
				teleportStartedEvent:Fire(player, "Teleport", tostring(placeId))
			end
		end
	end)

	-- Clean up teleporting attribute on player leaving
	Players.PlayerRemoving:Connect(function(player: Player)
		if player:GetAttribute("Teleporting") then
			player:SetAttribute("Teleporting", false)
		end
	end)
end

return TeleportHandler
