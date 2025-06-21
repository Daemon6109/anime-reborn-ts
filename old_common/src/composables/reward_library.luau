--------------------------------------------------------------------------------
-- RewardLibrary
-- Handles player rewards for various game systems
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Person = require("@commonserver/person")

export type RewardData = {
	Units: { [string]: number }?, -- Index = UnitName, value = amount of units to give
	ShinyUnits: { [string]: number }?,

	Items: { [string]: number }?, -- Index = ItemName, value = amount of items to give

	Titles: { string }?,

	Currencies: {
		Gold: number,
		Gems: number,
	}?,

	Callback: (player: Player) -> ()?,

	BattlepassExp: number?,
	XP: number?,
	Level: number?,
}

export type ProcessedRewards = {
	Currencies: {
		Gold: number,
		Gems: number,
	},
	Items: { [string]: number },
	Units: { [string]: number },
	Titles: { string },
	XP: number,
}

--[=[
	Library for processing and giving rewards to players

	@class RewardLibrary
]=]
local RewardLibrary = {
	version = version,
}

--[=[
	Processes and gives rewards to a player

	@within RewardLibrary

	@param player Player -- The player to reward
	@param rewardData RewardData -- The rewards to give

	@return ProcessedRewards -- The processed rewards

	```lua
	-- Example usage
	local player = game.Players:GetPlayerByUserId(123456789)
	local rewardData = {
		Currencies = { Gold = 1000, Gems = 500 },
		Items = { HealthPotion = 3, ManaPotion = 2 },
		Units = { Warrior = 1, Archer = 2 },
		Titles = { "Hero of the Realm" },
		XP = 250,
	}
	return RewardLibrary.ProcessReward(player, rewardData)
	```
]=]
function RewardLibrary.ProcessReward(player: Player, rewardData: RewardData): ProcessedRewards
	local processedRewards = {
		Currencies = {
			Gold = 0,
			Gems = 0,
		},
		Items = {},
		Units = {},
		Titles = {},
		XP = 0,
	} :: ProcessedRewards

	if not player or not rewardData then
		return processedRewards
	end

	local person = Person.getForPlayer(player):Await()
	if not person then
		warn(`RewardLibrary. Could not get person for player {player.Name}`)
		return processedRewards
	end

	-- Process each reward type
	if rewardData.Currencies and rewardData.Currencies.Gems > 0 then
		person.dataCache(function(dataCache)
			dataCache.Currencies.Gems = (dataCache.Currencies.Gems or 0) + rewardData.Currencies.Gems
			return dataCache
		end)
		processedRewards.Currencies.Gems = rewardData.Currencies.Gems
	end

	if rewardData.Currencies and rewardData.Currencies.Gold > 0 then
		person.dataCache(function(dataCache)
			dataCache.Currencies.Gold = (dataCache.Currencies.Gold or 0) + rewardData.Currencies.Gold
			return dataCache
		end)
		processedRewards.Currencies.Gold = rewardData.Currencies.Gold
	end

	if rewardData.XP and rewardData.XP > 0 then
		person.dataCache(function(dataCache)
			dataCache.XP = (dataCache.XP or 0) + rewardData.XP
			return dataCache
		end)
		processedRewards.XP = rewardData.XP
	end

	if rewardData.Items then
		person.dataCache(function(dataCache)
			for itemId, quantity in pairs(rewardData.Items) do
				if not dataCache.Inventory.Items[itemId] then
					dataCache.Inventory.Items[itemId] = {
						Cost = 0,
						Quantity = quantity,
					}
				else
					dataCache.Inventory.Items[itemId].Quantity = (dataCache.Inventory.Items[itemId].Quantity or 0)
						+ quantity
				end
			end
			return dataCache
		end)
		processedRewards.Items = rewardData.Items
	end

	if rewardData.Units then
		person.dataCache(function(dataCache)
			for _, unitId in pairs(rewardData.Units) do
				table.insert(dataCache.Inventory.Units, unitId)
			end
			return dataCache
		end)
		processedRewards.Units = rewardData.Units
	end

	if rewardData.Titles then
		person.dataCache(function(dataCache)
			for _, titleId in pairs(rewardData.Titles) do
				if not table.find(dataCache.Inventory.Titles, titleId) then
					table.insert(dataCache.Inventory.Titles, titleId)
				end
			end
			return dataCache
		end)
		processedRewards.Titles = rewardData.Titles
	end

	return processedRewards
end

return RewardLibrary
