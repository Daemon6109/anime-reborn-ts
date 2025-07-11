--------------------------------------------------------------------------------
-- battlepass_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BattlePassData = require("@registry/BattlePassData")
local Network = require("@network/server")
local Person = require("@commonserver/person")
local RewardLibrary = require("@commonutils/RewardLibrary")
local deepCopy = require("@data/utils/deepCopy")

-- Network events
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer_2

export type BattlePassRewardData = {
	Units: { [string]: number }?,
	ShinyUnits: { [string]: number }?,
	Currencies: { [string]: number }?,
	Items: { [string]: number }?,
}

export type BattlePassLevelData = {
	Regular: BattlePassRewardData?,
	Premium: BattlePassRewardData?,
}

--[=[
Service for handling battle pass reward claiming and progression.

@class BattlePassService
]=]
local BattlePassService = {
	version = version,
}

-- Track players currently claiming to prevent spam
local claimingPlayers: { [Player]: boolean } = {}

--[=[
Tracks player engagement with analytics

@within BattlePassService

@param person Person -- The person to track
@param featureName string -- The feature being tracked

```lua
BattlePassService.trackEngagement(person, "PremiumPass")
```
]=]
function BattlePassService.trackEngagement(person: Person.Person, featureName: string): ()
	AnalyticsService:LogCustomEvent(person.player, "Engagement_" .. featureName)
end

--[=[
Counts total units in a reward table

@within BattlePassService

@param rewards { [string]: number } -- The rewards to count

@return number -- Total count of units

@private
]=]
local function countUnits(rewards: { [string]: number }?): number
	if not rewards then
		return 0
	end

	local count = 0
	for _, amount in pairs(rewards) do
		count += amount
	end
	return count
end

--[=[
Checks if player has enough storage space for unit rewards

@within BattlePassService

@param person Person -- The person to check storage for
@param rewardData BattlePassRewardData -- The reward data to check

@return boolean -- Whether the player has enough storage space

@private
]=]
local function hasEnoughStorage(person: Person.Person, rewardData: BattlePassRewardData): boolean
	local dataCache = person.dataCache()
	local inventory = dataCache.Inventory

	local unitCount = 0
	for _ in pairs(inventory.Units) do
		unitCount += 1
	end

	local unitRewardCount = countUnits(rewardData.Units)
	local shinyUnitRewardCount = countUnits(rewardData.ShinyUnits)
	local totalNewUnits = unitRewardCount + shinyUnitRewardCount

	return totalNewUnits <= (inventory.MaxUnitStorage - unitCount)
end

--[=[
Claims rewards for a specific battle pass level

@within BattlePassService

@param person Person -- The person claiming rewards
@param level number -- The battle pass level
@param isPremium boolean -- Whether this is premium pass

@return boolean -- Whether rewards were successfully claimed

@private
]=]
local function claimLevelRewards(person: Person.Person, level: number, isPremium: boolean): boolean
	local levelData: BattlePassLevelData? = BattlePassData.LevelData[level]
	if not levelData then
		return true -- Skip levels without data
	end

	local rewardData = isPremium and levelData.Premium or levelData.Regular
	if not rewardData then
		return true -- Skip if no rewards for this type
	end

	-- Check storage space for units
	if not hasEnoughStorage(person, rewardData) then
		if NotifyPlayer then
			NotifyPlayer:FireClient(person.player, "Error", "Your unit storage is full!")
		end
		return false
	end

	-- Give rewards using the reward library
	local success = pcall(function()
		RewardLibrary:RewardPlayer(person.player, rewardData)
	end)

	if success then
		-- Track engagement
		local engagementType = isPremium and "PremiumPass" or "RegularPass"
		BattlePassService.trackEngagement(person, engagementType)
		return true
	else
		warn(`Failed to give rewards for battle pass level {level}`)
		return false
	end
end

--[=[
Claims all available battle pass rewards for a player

@within BattlePassService

@param person Person -- The person claiming rewards

```lua
BattlePassService.claimRewards(person)
```
]=]
function BattlePassService.claimRewards(person: Person.Person): ()
	local player = person.player

	-- Prevent spam claiming
	if claimingPlayers[player] then
		return
	end
	claimingPlayers[player] = true

	local success = pcall(function()
		local dataCache = person.dataCache()
		local battlePassData = dataCache.BattlepassData

		-- Check if there's anything to claim
		local hasFreeToClaim = battlePassData.ClaimedFree < battlePassData.Level
		local hasPremiumToClaim = battlePassData.HasPremium and battlePassData.ClaimedPremium < battlePassData.Level

		if not hasFreeToClaim and not hasPremiumToClaim then
			return -- Nothing to claim
		end

		local newCache = table.clone(dataCache)
		local newBattlePassData = table.clone(battlePassData)

		local claimedFreeRewards = false
		local claimedPremiumRewards = false

		-- Claim free rewards
		for level = battlePassData.ClaimedFree + 1, battlePassData.Level do
			if claimLevelRewards(person, level, false) then
				newBattlePassData.ClaimedFree = level
				claimedFreeRewards = true
			else
				-- Storage full, stop claiming
				break
			end
		end

		-- Claim premium rewards if player has premium
		if battlePassData.HasPremium then
			for level = battlePassData.ClaimedPremium + 1, battlePassData.Level do
				if claimLevelRewards(person, level, true) then
					newBattlePassData.ClaimedPremium = level
					claimedPremiumRewards = true
				else
					-- Storage full, stop claiming
					break
				end
			end
		end

		-- Update battle pass data
		newCache.BattlepassData = newBattlePassData
		person.dataCache(newCache)

		-- Notify player of success
		if claimedFreeRewards or claimedPremiumRewards then
			if NotifyPlayer then
				local message = claimedPremiumRewards and "Claimed premium pass rewards!"
					or "Claimed free pass rewards!"
				NotifyPlayer:FireClient(player, "Success", message)
			end
		end
	end)

	if not success then
		warn(`Error claiming battle pass rewards for player {player.Name}`)
	end

	-- Remove from claiming list after a delay
	task.wait(1)
	claimingPlayers[player] = nil
end

--[=[
Initializes the BattlePassService

@within BattlePassService
]=]
function BattlePassService.start(): ()
	-- Set up network handlers
	Network.registerHandler("BattlePass/ClaimRewards", function(player: Player)
		local person = Person.getForPlayer(player)
		if person then
			BattlePassService.claimRewards(person)
		end
	end)

	-- Clean up claiming players when they leave
	game.Players.PlayerRemoving:Connect(function(player)
		claimingPlayers[player] = nil
	end)

	print("BattlePassService started")
end

return BattlePassService
