--------------------------------------------------------------------------------
-- unit_inventory_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")

-- Constants
local STORAGE_UPGRADE_AMOUNT = 50
local GOLD_UPGRADE_COST = 50000
local GEMS_UPGRADE_COST = 7500

--[=[
Service for managing unit inventory storage upgrades.

@class UnitInventoryService
]=]
local UnitInventoryService = {
	version = version,
}

--[=[
Upgrades unit storage using gold

@within UnitInventoryService

@param person Person -- The person upgrading storage

```lua
UnitInventoryService.upgradeStorageWithGold(person)
```
]=]
function UnitInventoryService.upgradeStorageWithGold(person: Person.Person): ()
	local dataCache = person.dataCache()
	local currencies = dataCache.Currencies

	-- Check if player has enough gold
	if currencies.Gold < GOLD_UPGRADE_COST then
		return
	end

	-- Deduct gold and increase storage
	local newCache = table.clone(dataCache)
	newCache.Currencies.Gold = currencies.Gold - GOLD_UPGRADE_COST
	newCache.Inventory.MaxUnitStorage = dataCache.Inventory.MaxUnitStorage + STORAGE_UPGRADE_AMOUNT

	-- Update data cache
	person.dataCache(newCache)

	-- Legacy service call for compatibility
	if _G.serverServices and _G.serverServices.PlayerService then
		_G.serverServices.PlayerService:GiveCurrency(person.player, "Gold", -GOLD_UPGRADE_COST)
	end
end

--[=[
Upgrades unit storage using gems

@within UnitInventoryService

@param person Person -- The person upgrading storage

```lua
UnitInventoryService.upgradeStorageWithGems(person)
```
]=]
function UnitInventoryService.upgradeStorageWithGems(person: Person.Person): ()
	local dataCache = person.dataCache()
	local currencies = dataCache.Currencies

	-- Check if player has enough gems
	if currencies.Gems < GEMS_UPGRADE_COST then
		return
	end

	-- Deduct gems and increase storage
	local newCache = table.clone(dataCache)
	newCache.Currencies.Gems = currencies.Gems - GEMS_UPGRADE_COST
	newCache.Inventory.MaxUnitStorage = dataCache.Inventory.MaxUnitStorage + STORAGE_UPGRADE_AMOUNT

	-- Update data cache
	person.dataCache(newCache)

	-- Legacy service call for compatibility
	if _G.serverServices and _G.serverServices.PlayerService then
		_G.serverServices.PlayerService:GiveCurrency(person.player, "Gems", -GEMS_UPGRADE_COST)
	end
end

--[=[
Initializes the UnitInventoryService

@within UnitInventoryService
]=]
function UnitInventoryService.start(): ()
	-- Set up network handlers
	Network.registerHandler("UnitInventory/UpgradeWithGold", function(player: Player)
		local person = Person.getForPlayer(player)
		if person then
			UnitInventoryService.upgradeStorageWithGold(person)
		end
	end)

	Network.registerHandler("UnitInventory/UpgradeWithGems", function(player: Player)
		local person = Person.getForPlayer(player)
		if person then
			UnitInventoryService.upgradeStorageWithGems(person)
		end
	end)

	print("UnitInventoryService started")
end

return UnitInventoryService
