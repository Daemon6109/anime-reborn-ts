--------------------------------------------------------------------------------
-- teleport_handler_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local MapRegistry = require("@registry/Maps")
local Network = require("@network/server")
local Person = require("@commonserver/person")

--[=[
Service for handling player teleportation to game servers.

@class TeleportHandlerService
]=]
local TeleportHandlerService = {
	version = version,
}

-- Constants
local DEBUG = false -- Set to true for development

-- Place IDs for different environments
local PLACE_IDS = {
	[6717025335] = 127759625243990, -- Production
	[5844593548] = 87213590469285, -- Development
}

--[=[
Teleports a player to a game server.

@param player Player -- The player to teleport
@param data table -- Teleport data containing game info
]=]
function TeleportHandlerService.teleport(
	player: Player,
	data: {
		GameType: string,
		MapName: string,
		GameScenarioID: number,
		Difficulty: string?,
	}
)
	-- Prevent multiple teleports
	if player:GetAttribute("Teleporting") then
		return
	end

	local person = Person.new(player)
	local missions = person.dataCache().MissionCompletionData
	local gameType = data.GameType
	local mapName = data.MapName
	local gameScenarioID = data.GameScenarioID
	local difficulty = data.Difficulty

	-- Validate mission progress (unless in debug mode)
	local hasAccess = DEBUG
		or (
			missions[gameType]
			and missions[gameType][mapName]
			and (gameScenarioID == 1 or missions[gameType][mapName][gameScenarioID - 1])
		)

	if not hasAccess then
		player:Kick("Invalid teleport request - mission not unlocked")
		return
	end

	-- Get the appropriate place ID
	local placeId = PLACE_IDS[game.GameId]
	if not placeId then
		warn("TeleportHandlerService: No place ID configured for game ID", game.GameId)
		return
	end

	-- Reserve a server
	local success, accessCode, privateServerId = pcall(function()
		return TeleportService:ReserveServer(placeId)
	end)

	if not success then
		warn("TeleportHandlerService: Failed to reserve server -", accessCode)
		return
	end

	-- Mark player as teleporting
	player:SetAttribute("Teleporting", true)

	-- Prepare teleport data
	local teleportData = {
		MapName = mapName,
		Difficulty = difficulty,
		GameType = gameType,
		GameScenarioId = gameScenarioID,
	}

	-- Teleport to the private server
	local teleportSuccess, teleportError = pcall(function()
		TeleportService:TeleportToPrivateServer(placeId, accessCode, { player }, nil, teleportData)
	end)

	if not teleportSuccess then
		warn("TeleportHandlerService: Failed to teleport player -", teleportError)
		player:SetAttribute("Teleporting", false)
	end
end

--[=[
Teleports multiple players together to a game server.

@param players table<Player> -- Array of players to teleport
@param data table -- Teleport data containing game info
]=]
function TeleportHandlerService.teleportGroup(
	players: { Player },
	data: {
		GameType: string,
		MapName: string,
		GameScenarioID: number,
		Difficulty: string?,
	}
)
	if #players == 0 then
		return
	end

	-- Check if any players are already teleporting
	for _, player in players do
		if player:GetAttribute("Teleporting") then
			return
		end
	end

	-- Use the first player's mission data for validation
	local leadPlayer = players[1]
	local person = Person.new(leadPlayer)
	local missions = person.dataCache().MissionCompletionData
	local gameType = data.GameType
	local mapName = data.MapName
	local gameScenarioID = data.GameScenarioID
	local difficulty = data.Difficulty

	-- Validate mission progress
	local hasAccess = DEBUG
		or (
			missions[gameType]
			and missions[gameType][mapName]
			and (gameScenarioID == 1 or missions[gameType][mapName][gameScenarioID - 1])
		)

	if not hasAccess then
		return
	end

	-- Get the appropriate place ID
	local placeId = PLACE_IDS[game.GameId]
	if not placeId then
		warn("TeleportHandlerService: No place ID configured for game ID", game.GameId)
		return
	end

	-- Reserve a server
	local success, accessCode, privateServerId = pcall(function()
		return TeleportService:ReserveServer(placeId)
	end)

	if not success then
		warn("TeleportHandlerService: Failed to reserve server -", accessCode)
		return
	end

	-- Mark all players as teleporting
	for _, player in players do
		player:SetAttribute("Teleporting", true)
	end

	-- Prepare teleport data
	local teleportData = {
		MapName = mapName,
		Difficulty = difficulty,
		GameType = gameType,
		GameScenarioId = gameScenarioID,
	}

	-- Teleport to the private server
	local teleportSuccess, teleportError = pcall(function()
		TeleportService:TeleportToPrivateServer(placeId, accessCode, players, nil, teleportData)
	end)

	if not teleportSuccess then
		warn("TeleportHandlerService: Failed to teleport group -", teleportError)
		for _, player in players do
			player:SetAttribute("Teleporting", false)
		end
	end
end

--[=[
Gets available maps for a player based on their progression.

@param player Player -- The player to check
@return table -- Available maps data
]=]
function TeleportHandlerService.getAvailableMaps(player: Player): table
	local person = Person.new(player)
	local missions = person.dataCache().MissionCompletionData
	local availableMaps = {}

	for mapName, mapData in MapRegistry do
		if mapData.configuration then
			local isAvailable = DEBUG
				or (missions[mapData.configuration.GameType] and missions[mapData.configuration.GameType][mapName])

			if isAvailable then
				availableMaps[mapName] = mapData
			end
		end
	end

	return availableMaps
end

-- Register network handlers
Network.registerHandler("Teleport", TeleportHandlerService.teleport)
Network.registerHandler("TeleportGroup", TeleportHandlerService.teleportGroup)
Network.registerHandler("GetAvailableMaps", TeleportHandlerService.getAvailableMaps)

return TeleportHandlerService
