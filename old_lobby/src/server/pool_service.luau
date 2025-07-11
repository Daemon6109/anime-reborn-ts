--------------------------------------------------------------------------------
-- pool_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")
local UnitManager = require("./unit_manager")
local _RewardLibrary = require("@commoncomposables/reward_library")

local deepCopy = require("@data/utils/deepCopy")
local loadModules = require("@commonutils/loadModules")
local weightedRNG = require("@commonutils/weightedRNG")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PoolRegistry = loadModules:fromChildren(ReplicatedStorage.Registry.Pools)

-- Cache for loaded pools
local cachedPools = {}

--------------------------------------------------------------------------------
-- Utility functions

--[=[
   Merges two reward tables, summing amounts for matching items.

   @param targetRewards { [string]: { [string]: number } } -- The target rewards table
   @param sourceRewards { [string]: { [string]: number } } -- The source rewards table

  ```lua
   PoolService.mergeRewards(targetRewards, sourceRewards)
  ```
]=]
local function mergeRewards(
	targetRewards: { [string]: { [string]: number } },
	sourceRewards: { [string]: { [string]: number } }
): ()
	for category, items in pairs(sourceRewards) do
		if targetRewards[category] then
			for item, amount in pairs(items) do
				if targetRewards[category][item] then
					targetRewards[category][item] = targetRewards[category][item] + amount
				else
					targetRewards[category][item] = amount
				end
			end
		else
			targetRewards[category] = {}
			for item, amount in pairs(items) do
				targetRewards[category][item] = amount
			end
		end
	end
end

--[=[
   Calculates the sell cost for a unit based on its rarity and level.

   @param rarity string -- The rarity of the unit (e.g., "Common", "Rare", etc.)
   @param level number -- The level of the unit
   @param isEvent boolean? -- Whether the unit is from an event

   @return number -- The calculated sell cost

   ```lua
   local cost = PoolService.calculateSellCost("Common", 5, false)
   ```
]=]
local function calculateSellCost(rarity: string, level: number, isEvent: boolean?): number
	local baseCosts = {
		Common = 5,
		Uncommon = 10,
		Rare = 25,
		Epic = 75,
		Legendary = 250,
		Mythical = 1000,
		Secret = 5000,
		Exclusive = 2500,
	}

	local baseCost = baseCosts[rarity] or 5
	local levelMultiplier = level or 1
	local eventMultiplier = if isEvent then 1.5 else 1.0

	return math.floor(baseCost * levelMultiplier * eventMultiplier)
end

--[=[
   Calculates shiny chance for a player based on level and products.

   @param person Person -- The person to calculate shiny chance for
   @return number -- The shiny chance percentage

   ```lua
   local chance = calculateShinyChance(person)
   ```
]=]
local function calculateShinyChance(person: Person.Person): number
	local cache = person.dataCache()
	local level = cache.Level or 1

	local baseChance = 0.1 -- 0.1% base chance

	-- Increase chance based on level (after level 10)
	if level >= 10 then
		baseChance = baseChance + (level - 10) * 0.01
	end

	-- TODO: Add VIP product bonus when product system is available
	-- if has VIP product then baseChance = baseChance * 2

	-- Cap at reasonable maximum
	return math.min(baseChance, 5.0) -- Max 5% chance
end

--------------------------------------------------------------------------------

-- Create signals for pool events
local poolOpenedEvent = Shingo.new() :: any
local unitRewardedEvent = Shingo.new() :: any

--[=[
   Pool service for managing gacha/reward pools and summons.

   @class PoolService
]=]
local PoolService = {
	version = version,

	-- Events
	poolOpened = poolOpenedEvent,
	unitRewarded = unitRewardedEvent,

	-- Utility functions
	mergeRewards = mergeRewards,
	calculateSellCost = calculateSellCost,
	calculateShinyChance = calculateShinyChance,
}

--[=[
   Processes unit rewards from a pool, handling shiny calculation, auto-sell, and statistics

   @within PoolService

   @param person Person -- The person receiving units
   @param rewardTable table -- The reward table containing units
   @param amount number -- The number of summons

   @return { string } -- Array of unit UUIDs

   ```lua
   local uuids = PoolService.processUnitRewards(person, rewards, 1)
   ```
]=]
function PoolService.processUnitRewards(
	person: Person.Person,
	rewardTable: { [string]: { [string]: number } },
	amount: number
): { string }
	local player = person.player
	local uuids = {}
	local _hasRareUnit = false
	local goldEarned = 0
	-- Get player data
	local cache = person.dataCache()
	local level = cache.Level or 1
	local _statistics = cache.PlayerStatistics or {}

	-- Convert units to array for processing
	local units = {}
	for unitId, quantity in pairs(rewardTable.Units or {}) do
		for i = 1, quantity do
			table.insert(units, unitId)
		end
	end

	-- Process each unit
	for _, unitId in ipairs(units) do
		-- Check for rare units
		local unitConfig = UnitManager.registry[unitId]
		if unitConfig and unitConfig.configuration then
			local rarity = unitConfig.configuration.Rarity
			if rarity == "Secret" or rarity == "Mythical" or rarity == "Exclusive" then
				_hasRareUnit = true
			end

			-- Calculate shiny chance
			local isShiny = false
			if not table.find({ "Epic", "Rare" }, rarity) then
				if level >= 10 then
					local rolledShinyOdd = math.random(1, 1000) -- Use 1000 for better precision
					local shinyChanceThreshold = calculateShinyChance(person) * 10 -- Convert to per-1000
					isShiny = rolledShinyOdd <= shinyChanceThreshold

					if isShiny then
						-- Update shiny statistics
						person.dataCache(function(dataCache)
							dataCache.PlayerStatistics.SummonedShinies = dataCache.PlayerStatistics.SummonedShinies + 1
							return dataCache
						end)
					end
				end
			end -- Check auto-sell (convert boolean values to array lookup)
			local autoSellArray = {}
			if cache.Settings and cache.Settings.AutoSell then
				for rarityName, enabled in pairs(cache.Settings.AutoSell) do
					if enabled then
						table.insert(autoSellArray, rarityName)
					end
				end
			end

			if not isShiny and table.find(autoSellArray, rarity) then
				-- Calculate sell value and add to gold
				local cost = calculateSellCost(rarity, 1, false) -- TODO: Check for event units
				goldEarned = goldEarned + cost
				table.insert(uuids, unitId) -- Store unit ID instead of UUID for auto-sold units				continue
			end

			-- Give unit to player
			local additionalData = if isShiny then { Shiny = true } else nil
			local unitInstance = UnitManager.addUnit(person, unitId, 1, additionalData)
			if unitInstance then
				local uuid = unitInstance.id
				table.insert(uuids, uuid)
			end

			-- Update unit statistics (simplified to avoid type issues)
			if rarity == "Secret" then
				person.dataCache(function(dataCache)
					dataCache.PlayerStatistics.SummonedSecrets = dataCache.PlayerStatistics.SummonedSecrets + 1
					return dataCache
				end)
			elseif rarity == "Mythical" then
				person.dataCache(function(dataCache)
					dataCache.PlayerStatistics.SummonedMythicals = dataCache.PlayerStatistics.SummonedMythicals + 1
					return dataCache
				end)
			end

			-- TODO: Add chat announcement for rare units when chat system is available
		end
	end

	-- Give gold for auto-sold units
	if goldEarned > 0 then
		person.dataCache(function(dataCache)
			dataCache.Currencies.Gold = dataCache.Currencies.Gold + goldEarned
			return dataCache
		end)
	end

	-- Update total summons statistic
	person.dataCache(function(dataCache)
		dataCache.PlayerStatistics.TotalSummons = dataCache.PlayerStatistics.TotalSummons + amount
		return dataCache
	end)

	-- TODO: Request save if rare unit was obtained when save method is available
	-- if hasRareUnit then
	-- 	person.save()
	-- end

	-- Fire event
	unitRewardedEvent:fire(player, uuids)

	return uuids
end

--[=[
   Opens a pool and returns rewards

   @within PoolService

   @param person Person -- The person opening the pool
   @param poolName string -- The name of the pool
   @param generateOnly boolean? -- Whether to only generate rewards without giving them

   @return { [string]: { [string]: number } } -- The reward table

   ```lua
   local rewards = PoolService.openPool(person, "StandardSummon", false)
   ```
]=]
function PoolService.openPool(
	person: Person.Person,
	poolName: string,
	generateOnly: boolean?
): { [string]: { [string]: number } }
	-- Load the pool if not cached
	if not cachedPools[poolName] then
		local poolModule = PoolRegistry[poolName]
		if not poolModule then
			warn(`PoolService: Pool '{poolName}' not found`)
			return {}
		end
		cachedPools[poolName] = poolModule
	end

	local poolData = cachedPools[poolName].Get()

	-- Convert pool data to RNG table
	local rngTable = {}
	local infoTable = {}
	local totalChance = 0
	local randomRewards = {}

	-- Process all pool categories except Guaranteed
	for categoryType, categoryData in pairs(poolData) do
		if categoryType == "Guaranteed" then
			continue
		end

		for itemName, itemData in pairs(categoryData) do
			-- Handle nested random rewards
			if itemData.Rewards then
				randomRewards[itemName] = {
					Rewards = itemData.Rewards,
					Type = categoryType,
				}
			end

			rngTable[itemName] = itemData.Chance
			totalChance = totalChance + itemData.Chance
			infoTable[itemName] = itemData
			infoTable[itemName].Type = categoryType
		end
	end

	-- Add "Nothing" option if total chance < 100
	if totalChance < 100 then
		rngTable["Nothing"] = 100 - totalChance
	end

	-- Select item using weighted RNG
	local selectedItem = weightedRNG(rngTable)

	-- Handle nested random rewards
	if randomRewards[selectedItem] then -- Clear tables and rebuild for sub-rewards
		local newRngTable = {}
		totalChance = 0
		infoTable = {}

		for itemName, itemData in pairs(randomRewards[selectedItem].Rewards) do
			newRngTable[itemName] = itemData.Chance
			totalChance = totalChance + itemData.Chance
			infoTable[itemName] = itemData
			infoTable[itemName].Type = randomRewards[selectedItem].Type
		end

		selectedItem = weightedRNG(newRngTable)
	end

	-- Handle guaranteed rewards
	local guaranteedRewards = nil
	if poolData.Guaranteed then
		guaranteedRewards = deepCopy(poolData.Guaranteed)
	end

	-- Return only guaranteed if "Nothing" was selected
	if selectedItem == "Nothing" then
		return guaranteedRewards or {}
	end

	-- Build reward table
	local itemInfo = infoTable[selectedItem]
	local rewardTable = {
		[itemInfo.Type] = {
			[selectedItem] = itemInfo.Quantity,
		},
	}

	-- Merge guaranteed rewards
	if guaranteedRewards then
		mergeRewards(rewardTable, guaranteedRewards)
	end

	-- If only generating, return the table
	if generateOnly then
		return rewardTable
	end -- Process unit rewards
	local originalUnits = nil
	if rewardTable.Units then
		originalUnits = deepCopy(rewardTable.Units)
		local _uuids = PoolService.processUnitRewards(person, rewardTable, 1)
		-- Remove units from reward table since they've been processed
		rewardTable.Units = nil
	end

	-- TODO: Give other rewards using RewardLibrary when type issues are resolved
	-- if next(rewardTable) then
	-- 	RewardLibrary.ProcessReward(person.player, rewardTable)
	-- end

	-- Fire event
	poolOpenedEvent:fire(person.player, poolName, rewardTable)

	-- Prepare return value with original units
	local returnTable = deepCopy(rewardTable) :: { [string]: { [string]: number } }
	if originalUnits then
		returnTable.Units = originalUnits
	else
		returnTable.Units = {}
	end

	return returnTable
end

--[=[
   Initializes the pool service

   @within PoolService

   ```lua
   PoolService.init()
   ```
]=]
function PoolService.init(): () -- Listen for pool opening requests
	Network.OpenPool.on(function(player: Player, data: { poolName: string, amount: number? })
		local person = Person.getForPlayer(player):Await()
		if person then
			for i = 1, data.amount or 1 do
				PoolService.openPool(person, data.poolName, false)
			end
		end
	end)
end

return PoolService
