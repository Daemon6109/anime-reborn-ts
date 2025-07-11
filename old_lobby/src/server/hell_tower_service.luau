--------------------------------------------------------------------------------
-- hell_tower_service
-- Manages Hell Tower progression, milestones, and seasonal rewards
-- TODO
-- Complete startTowerTeleport() implementation with actual TeleportService calls
-- Client notification system for teleport states
-- PlaceId resolution logic
-- TeleportData setup with all required fields
-- Teleport error handling and recovery
-- Integration with RewardLibrary for actual reward distribution
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Analytics = require("@commonserver/analytics")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")
local _Network = require("@network/server") -- Prefixed with _ to silence unused warning

local Players = game:GetService("Players")

-- Type definitions
export type RoomCompletionData = {
	ClearAmount: number,
	FastestTime: number,
}

export type HellTowerData = {
	HighestRoom: number,
	Season: number,
	RoomCompletionData: {
		[string]: RoomCompletionData,
	},
	ClaimData: {
		[string]: boolean,
	},
}

-- Registry structure from HellTowerData (flexible structure)
export type MilestoneReward = {
	Currencies: { [string]: number? }?,
	Items: { [string]: number? }?,
	Units: { [string]: number? }?,
}

export type RegistryMilestoneData = {
	Rewards: MilestoneReward,
	CustomText: string?,
}

export type MilestoneData = {
	Floor: number,
	Reward: MilestoneReward,
	DisplayName: string,
	CustomText: string?,
}

export type TowerResult = {
	Success: boolean,
	Message: string,
	Rewards: MilestoneReward?,
}

--[=[
	Service for managing Hell Tower progression and rewards
	
	@class HellTowerService
]=]
local HellTowerService = {}
HellTowerService.__index = HellTowerService

-- Events
local roomCompleted = Shingo.new() :: Shingo.Signal<Person.Person, number, number>
local milestoneReached = Shingo.new() :: Shingo.Signal<Person.Person, number>
local milestoneClaimed = Shingo.new() :: Shingo.Signal<Person.Person, number, MilestoneReward>
local seasonReset = Shingo.new() :: Shingo.Signal<Person.Person, number, number>

-- Internal state
local milestoneRegistry = require("@registry/HellTowerData")
local towerData: { [Player]: HellTowerData } = {}

-- Constants
local DEFAULT_SEASON = 1

--[=[
	Complete a tower room
	
	@within HellTowerService

	@param person Person.Person -- The player completing the room
	@param roomNumber number -- The room number completed
	@param completionTime number -- Time taken to complete the room in seconds

	@return TowerResult -- Result of the completion

	@error "Invalid room number" -- If room number is invalid

	```lua
	HellTowerService.completeRoom(person, 5, 120)
	```
]=]
function HellTowerService.completeRoom(person: Person.Person, roomNumber: number, completionTime: number): TowerResult
	if roomNumber <= 0 then
		return {
			Success = false,
			Message = "Invalid room number",
		}
	end

	local player = person.player
	local playerTowerData = HellTowerService._getTowerData(player)

	-- Update highest room if this is a new record
	local isNewRecord = roomNumber > playerTowerData.HighestRoom
	if isNewRecord then
		playerTowerData.HighestRoom = roomNumber
		milestoneReached:fire(person, roomNumber)
	end

	-- Update room completion data
	local roomKey = tostring(roomNumber)
	if not playerTowerData.RoomCompletionData[roomKey] then
		playerTowerData.RoomCompletionData[roomKey] = {
			ClearAmount = 0,
			FastestTime = 0,
		}
	end

	local roomData = playerTowerData.RoomCompletionData[roomKey]
	roomData.ClearAmount += 1

	-- Update fastest time if this is better
	if roomData.FastestTime == 0 or completionTime < roomData.FastestTime then
		roomData.FastestTime = completionTime
	end

	HellTowerService._saveTowerData(player, playerTowerData)

	-- Track analytics
	Analytics.trackEvent(player, "HellTower_RoomComplete", {
		RoomNumber = roomNumber,
		CompletionTime = completionTime,
	})

	roomCompleted:fire(person, roomNumber, completionTime)
	-- Check for available rewards - automatically give rewards like old handler
	HellTowerService._giveAvailableRewards(player)

	return {
		Success = true,
		Message = isNewRecord and `New record! Reached room {roomNumber}` or `Completed room {roomNumber}`,
	}
end

--[=[
	Claim a milestone reward

	@within HellTowerService

	@param person Person.Person -- The player claiming the reward
	@param floor number -- The milestone floor to claim

	@return TowerResult -- Result of the claim attempt

	@error "Milestone not available" -- If milestone cannot be claimed

	```lua
	HellTowerService.claimMilestone(person, 10)
	```
]=]
function HellTowerService.claimMilestone(person: Person.Person, floor: number): TowerResult
	local player = person.player
	local playerTowerData = HellTowerService._getTowerData(player)

	-- Check if player has reached this floor
	if playerTowerData.HighestRoom < floor then
		return {
			Success = false,
			Message = `You must reach room {floor} before claiming this reward`,
		}
	end

	-- Check if already claimed
	local floorKey = tostring(floor)
	if playerTowerData.ClaimData[floorKey] then
		return {
			Success = false,
			Message = "This milestone reward has already been claimed",
		}
	end
	-- Check if milestone exists
	local milestone = HellTowerService._getMilestone(floor)
	if not milestone then
		return {
			Success = false,
			Message = "This milestone does not exist",
		}
	end

	-- Mark as claimed
	playerTowerData.ClaimData[floorKey] = true
	HellTowerService._saveTowerData(player, playerTowerData)

	-- Give rewards
	HellTowerService._giveRewards(player, milestone)

	milestoneClaimed:fire(person, floor, milestone)

	return {
		Success = true,
		Message = `Claimed milestone reward for room {floor}!`,
		Rewards = milestone,
	}
end

--[=[
	Get player's tower data

	@within HellTowerService

	@param person Person.Person -- The player

	@return HellTowerData -- The player's tower data

	```lua
	local towerData = HellTowerService.getTowerData(person)
	```
]=]

function HellTowerService.getTowerData(person: Person.Person): HellTowerData
	return table.clone(HellTowerService._getTowerData(person.player))
end

--[=[
	Get player's highest room reached

	@within HellTowerService

	@param person Person.Person -- The player

	@return number -- Highest room reached

	```lua
	local highestRoom = HellTowerService.getHighestRoom(person)
	```
]=]
function HellTowerService.getHighestRoom(person: Person.Person): number
	local playerTowerData = HellTowerService._getTowerData(person.player)
	return playerTowerData.HighestRoom
end

--[=[
	Get available milestone rewards for player

	@within HellTowerService

	@param person Person.Person -- The player

	@return { MilestoneData } -- Array of available milestones

	```lua
	local milestones = HellTowerService.getAvailableMilestones(person)
	```
]=]
function HellTowerService.getAvailableMilestones(person: Person.Person): { MilestoneData }
	local player = person.player
	local playerTowerData = HellTowerService._getTowerData(player)
	local available = {}

	if milestoneRegistry.MilestoneRewards then
		for floor, rewardData in milestoneRegistry.MilestoneRewards do
			local floorKey = tostring(floor)
			if playerTowerData.HighestRoom >= floor and not playerTowerData.ClaimData[floorKey] then
				table.insert(available, {
					Floor = floor,
					Reward = rewardData.Rewards,
					DisplayName = rewardData.CustomText or `Room {floor} Milestone`,
					CustomText = rewardData.CustomText,
				})
			end
		end
	end

	-- Handle repeating rewards for floors beyond 100 (like old handler)
	if playerTowerData.HighestRoom >= 100 then
		local amount = math.floor((playerTowerData.HighestRoom - 100) / 10)
		for i = 1, amount do
			local newFloor = 100 + (10 * i)
			local floorKey = tostring(newFloor)
			if not playerTowerData.ClaimData[floorKey] and playerTowerData.HighestRoom >= newFloor then
				table.insert(available, {
					Floor = newFloor,
					Reward = {
						Currencies = {},
						Items = {
							["TraitCrystal"] = 10,
							["GoldenMarble"] = 1,
						},
						Units = {},
					},
					DisplayName = `Room {newFloor} Milestone`,
				})
			end
		end
	end

	return available
end

--[=[
	Get all claimed milestones for player

	@within HellTowerService

	@param person Person.Person -- The player

	@return { number } -- Array of claimed milestone floors

	```lua
	local claimedMilestones = HellTowerService.getClaimedMilestones(person)
	```
]=]
function HellTowerService.getClaimedMilestones(person: Person.Person): { number }
	local playerTowerData = HellTowerService._getTowerData(person.player)
	local claimed = {}

	for floorKey, isClaimed in playerTowerData.ClaimData do
		if isClaimed then
			local floorNumber = tonumber(floorKey)
			if floorNumber then
				table.insert(claimed, floorNumber)
			end
		end
	end

	return claimed
end

--[=[
	Get completion stats for a specific room

	@within HellTowerService

	@param person Person.Person -- The player
	@param roomNumber number -- The room number to get stats for

	@return RoomCompletionData? -- Room completion data or nil if never completed

	```lua
	local roomStats = HellTowerService.getRoomStats(person, 5)
	```
]=]
function HellTowerService.getRoomStats(person: Person.Person, roomNumber: number): RoomCompletionData?
	local playerTowerData = HellTowerService._getTowerData(person.player)
	local roomKey = tostring(roomNumber)

	return playerTowerData.RoomCompletionData[roomKey]
end

--[=[
	Check if a milestone can be claimed

	@within HellTowerService

	@param person Person.Person -- The player
	@param floor number -- The milestone floor to check

	@return boolean -- True if milestone can be claimed

	```lua
	local canClaim = HellTowerService.canClaimMilestone(person, 10)
	```
]=]
function HellTowerService.canClaimMilestone(person: Person.Person, floor: number): boolean
	local player = person.player
	local playerTowerData = HellTowerService._getTowerData(player)
	local floorKey = tostring(floor)

	return playerTowerData.HighestRoom >= floor
		and not playerTowerData.ClaimData[floorKey]
		and HellTowerService._getMilestone(floor) ~= nil
end

--[=[
	Get the current tower season

	@within HellTowerService

	@return number -- Current season number

	```lua
	local currentSeason = HellTowerService.getCurrentSeason()
	```
]=]
function HellTowerService.getCurrentSeason(): number
	return milestoneRegistry.Season or DEFAULT_SEASON
end

--[=[
	Reset player's tower data for a new season

	@within HellTowerService

	@param person Person.Person -- The player to reset

	@return HellTowerData -- New tower data after reset

	```lua
	local newTowerData = HellTowerService.resetForNewSeason(person)
	```
]=]
function HellTowerService.resetForNewSeason(person: Person.Person): HellTowerData
	local player = person.player
	local oldData = HellTowerService._getTowerData(player)
	local oldSeason = oldData.Season
	local newSeason = HellTowerService.getCurrentSeason()

	local newData: HellTowerData = {
		HighestRoom = 0,
		Season = newSeason,
		RoomCompletionData = {
			["1"] = {
				ClearAmount = 0,
				FastestTime = 0,
			},
		},
		ClaimData = {},
	}

	HellTowerService._saveTowerData(player, newData)

	-- Safe Person retrieval
	local personResult = Person.getForPlayer(player):Await()
	if personResult then
		seasonReset:fire(personResult, oldSeason, newSeason)
	end

	return newData
end

--[=[
	Get the tower data for a player, initializing if necessary

	@private

	@within HellTowerService

	@param player Player -- The player to get data for

	@return HellTowerData -- The player's tower data

	```lua
	local towerData = HellTowerService._getTowerData(player)
	```
]=]
function HellTowerService._getTowerData(player: Player): HellTowerData
	if not towerData[player] then
		-- Load from data store or create default
		towerData[player] = {
			HighestRoom = 0,
			Season = HellTowerService.getCurrentSeason(),
			RoomCompletionData = {
				["1"] = {
					ClearAmount = 0,
					FastestTime = 0,
				},
			},
			ClaimData = {},
		}
	end

	return towerData[player]
end

--[=[
	Save tower data for a player

	@private

	@within HellTowerService

	@param player Player -- The player to save data for
	@param data HellTowerData -- The tower data to save

	```lua
	HellTowerService._saveTowerData(player, towerData)
	```
]=]
function HellTowerService._saveTowerData(player: Player, data: HellTowerData): ()
	towerData[player] = data
	-- In production, this would save to DataStore
end

--[=[
	Setup player's tower data when they join

	@private

	@within HellTowerService

	@param player Player -- The player to setup

	```lua
	HellTowerService._setupPlayerTower(player)
	```
]=]
function HellTowerService._setupPlayerTower(player: Player): ()
	local playerTowerData = HellTowerService._getTowerData(player)
	local currentSeason = HellTowerService.getCurrentSeason() -- Check for season reset
	if playerTowerData.Season ~= currentSeason then
		local personResult = Person.getForPlayer(player):Await()
		if personResult then
			HellTowerService.resetForNewSeason(personResult)
		end
	else
		-- Give available rewards for existing progress
		HellTowerService._giveAvailableRewards(player)
	end
end

--[=[
	Get a specific milestone reward by floor number
	
	@private

	@within HellTowerService

	@param floor number -- The milestone floor to get

	@return MilestoneReward? -- The reward for the milestone or nil if not found

	```lua
	local reward = HellTowerService._getMilestone(10)
	```
]=]
function HellTowerService._getMilestone(floor: number): MilestoneReward?
	if milestoneRegistry.MilestoneRewards and milestoneRegistry.MilestoneRewards[floor] then
		return milestoneRegistry.MilestoneRewards[floor].Rewards
	end
	return nil
end

--[=[
	Give all available rewards to the player (auto-claiming like old handler)

	@private

	@within HellTowerService

	@param player Player -- The player to check rewards for

	```lua
	HellTowerService._giveAvailableRewards(player)
	```
]=]
function HellTowerService._giveAvailableRewards(player: Player): ()
	local playerTowerData = HellTowerService._getTowerData(player)
	local rewardsToGive = {}

	-- Check milestone rewards
	if milestoneRegistry.MilestoneRewards then
		for floor, milestoneData in milestoneRegistry.MilestoneRewards do
			local floorKey = tostring(floor)
			if not playerTowerData.ClaimData[floorKey] and playerTowerData.HighestRoom >= floor then
				playerTowerData.ClaimData[floorKey] = true
				table.insert(rewardsToGive, milestoneData.Rewards)
			end
		end
	end

	-- Check repeating rewards beyond floor 100 (like old handler)
	if playerTowerData.HighestRoom >= 100 then
		local amount = math.floor((playerTowerData.HighestRoom - 100) / 10)
		for i = 1, amount do
			local newFloor = 100 + (10 * i)
			local floorKey = tostring(newFloor)
			if not playerTowerData.ClaimData[floorKey] and playerTowerData.HighestRoom >= newFloor then
				playerTowerData.ClaimData[floorKey] = true
				table.insert(
					rewardsToGive,
					{
						Currencies = {},
						Items = {
							["TraitCrystal"] = 10,
							["GoldenMarble"] = 1,
						},
						Units = {},
					} :: any
				)
			end
		end
	end

	HellTowerService._saveTowerData(player, playerTowerData)

	-- Give all rewards using RewardLibrary
	for _, reward in rewardsToGive do
		HellTowerService._giveRewards(player, reward)
	end
end

--[=[
	Start Hell Tower teleport for a player (like old handler)

	@within HellTowerService

	@param person Person.Person -- The player
	@param floor number -- The floor to teleport to
	@param difficulty string -- The difficulty ("Normal" or "Nightmare")

	@return TowerResult -- Result of the teleport attempt

	```lua
	HellTowerService.startTowerTeleport(person, 5, "Normal")
	```
]=]
function HellTowerService.startTowerTeleport(person: Person.Person, floor: number, difficulty: string): TowerResult
	if difficulty ~= "Normal" and difficulty ~= "Nightmare" then
		return {
			Success = false,
			Message = "Invalid difficulty. Must be 'Normal' or 'Nightmare'",
		}
	end

	local player = person.player
	local playerTowerData = HellTowerService._getTowerData(player)

	-- Check if player can access this floor
	if floor > playerTowerData.HighestRoom + 1 then
		return {
			Success = false,
			Message = `You must reach room {playerTowerData.HighestRoom + 1} first`,
		}
	end
	-- Generate floor data using our own function
	local floorData = HellTowerService._generateFloor(floor)
	if not floorData then
		return {
			Success = false,
			Message = "Error generating floor data",
		}
	end

	-- This would handle teleportation logic in the real implementation
	-- Similar to the old handler's teleport code

	return {
		Success = true,
		Message = `Starting teleport to floor {floor} ({difficulty})`,
	}
end

--[=[
	Generate floor data for teleportation

	@private

	@within HellTowerService

	@param floor number -- The floor number to generate data for

	@return FloorData? -- Generated floor data or nil if error

	```lua
	local floorData = HellTowerService._generateFloor(25)
	```
]=]
function HellTowerService._generateFloor(floor: number): any?
	-- Use the MAP_ROTATION and configuration from registry
	local mapRotation = {
		"Leaf Village",
		"West City",
		"Land of the Sky",
		"Red Army HQ",
		"Fujishima Island",
		"Ghost Tunnel",
		"Clover Kingdom",
	}

	-- Calculate map index based on floor
	local mapIndex = ((floor - 1) % #mapRotation) + 1
	local map = mapRotation[mapIndex]

	-- Calculate act based on floor progression
	local act = math.max(1, math.floor((floor - 1) / 10) + 1)

	-- Generate elements for higher floors (after RoomElementsStartFrom)
	local elements = nil
	if floor >= (milestoneRegistry.RoomElementsStartFrom or 75) then
		elements = {}
		local elementsTable = milestoneRegistry.ElementsTable
			or {
				"Fierce",
				"Dark",
				"Fire",
				"Ice",
				"Light",
				"Water",
				"Wind",
			}

		-- Add random elements based on floor difficulty
		for _, element in ipairs(elementsTable) do
			elements[element] = {
				Min = -125,
				Max = -125,
			}
		end
	end

	return {
		Map = map,
		Act = act,
		Elements = elements,
	}
end

--[=[
	Give specific rewards to a player

	@private

	@within HellTowerService

	@param player Player -- The player to give rewards to
	@param rewards MilestoneReward -- The rewards to give

	```lua
	HellTowerService._giveRewards(player, { Items = { ["Sword"] = 1 }, Gems = 100 })
	```
]=]
function HellTowerService._giveRewards(player: Player, rewards: MilestoneReward): ()
	-- In a real implementation, this would use RewardLibrary or similar
	-- to give items, gems, gold, etc.
	-- Example:
	-- local RewardLibrary = require(game.ReplicatedStorage.Libs.RewardLibrary)
	-- RewardLibrary:RewardPlayer(player, rewards)
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   hell_tower_service.start()
   ```
]=]
local function start(): () -- Setup network handlers (commented out until added to blink configuration)
	-- _Network.completeRoom:connect(
	-- 	function(person: Person.Person, roomNumber: number, completionTime: number)
	-- 		return HellTowerService.completeRoom(person, roomNumber, completionTime)
	-- 	end
	-- )

	-- _Network.claimMilestone:connect(function(person: Person.Person, floor: number)
	-- 	return HellTowerService.claimMilestone(person, floor)
	-- end)

	-- _Network.getTowerData:connect(function(person: Person.Person)
	-- 	return HellTowerService.getTowerData(person)
	-- end)

	-- _Network.getAvailableMilestones:connect(function(person: Person.Person)
	-- 	return HellTowerService.getAvailableMilestones(person)
	-- end)

	-- _Network.startTowerTeleport:connect(function(person: Person.Person, floor: number, difficulty: string)
	-- 	return HellTowerService.startTowerTeleport(person, floor, difficulty)
	-- end)

	-- _Network.canClaimMilestone:connect(function(person: Person.Person, floor: number)
	-- 	return HellTowerService.canClaimMilestone(person, floor)
	-- end)

	-- _Network.getRoomStats:connect(function(person: Person.Person, roomNumber: number)
	-- 	return HellTowerService.getRoomStats(person, roomNumber)
	-- end)

	-- _Network.getHighestRoom:connect(function(person: Person.Person)
	-- 	return HellTowerService.getHighestRoom(person)
	-- end)

	-- _Network.getClaimedMilestones:connect(function(person: Person.Person)
	-- 	return HellTowerService.getClaimedMilestones(person)
	-- end)

	-- Handle player connections
	Players.PlayerAdded:Connect(function(player)
		HellTowerService._setupPlayerTower(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		towerData[player] = nil
	end)
end

return {
	version = version,

	-- Public API
	completeRoom = HellTowerService.completeRoom,
	claimMilestone = HellTowerService.claimMilestone,
	getTowerData = HellTowerService.getTowerData,
	getHighestRoom = HellTowerService.getHighestRoom,
	getAvailableMilestones = HellTowerService.getAvailableMilestones,
	getClaimedMilestones = HellTowerService.getClaimedMilestones,
	getRoomStats = HellTowerService.getRoomStats,
	canClaimMilestone = HellTowerService.canClaimMilestone,
	getCurrentSeason = HellTowerService.getCurrentSeason,
	resetForNewSeason = HellTowerService.resetForNewSeason,
	startTowerTeleport = HellTowerService.startTowerTeleport,

	-- Events
	roomCompleted = roomCompleted,
	milestoneReached = milestoneReached,
	milestoneClaimed = milestoneClaimed,
	seasonReset = seasonReset,

	-- Functions
	start = start,
}
