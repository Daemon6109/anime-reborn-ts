--------------------------------------------------------------------------------
-- shops
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server").common
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local Players = game:GetService("Players")

-- Shop constants
local SHOP_TYPES = {
	"DungeonShop",
	"EventShop",
	"RaidShop",
}

-- Shop configurations
local shopConfigs: { [string]: any } = {}

-- Create signals for shop events
local itemPurchasedEvent = Shingo.new() :: Shingo.Signal<any>

--[=[
   Shop system for managing different types of shops.

   @class Shops
]=]
local Shops = {
	version = version,

	-- Events
	itemPurchased = itemPurchasedEvent,
}

--[=[
   Loads default shop configurations

   @within Shops

   ```lua
   Shops.loadDefaultShopConfigs()
   ```
]=]
function Shops.loadDefaultShopConfigs(): ()
	-- Basic shop configs - in a real implementation this would come from external data
	shopConfigs["DungeonShop"] = {
		items = {
			["Health Potion"] = { cost = { Gold = 100 }, stock = -1 }, -- -1 = unlimited
			["Mana Potion"] = { cost = { Gold = 150 }, stock = -1 },
			["Rare Gem"] = { cost = { Gold = 1000 }, stock = 5 },
		},
		resetType = "daily", -- daily, weekly, never
	}

	shopConfigs["EventShop"] = {
		items = {
			["Event Token"] = { cost = { Gems = 50 }, stock = 10 },
			["Special Mount"] = { cost = { Gems = 500 }, stock = 1 },
		},
		resetType = "weekly",
	}

	shopConfigs["RaidShop"] = {
		items = {
			["Raid Key"] = { cost = { Gold = 500 }, stock = 3 },
			["Epic Equipment"] = { cost = { Gold = 2000 }, stock = 1 },
		},
		resetType = "weekly",
	}
end

--[=[
   Initializes shop data for a person

   @within Shops

   @param person Person -- The person for whom to initialize shop data
   @param shopType string -- The type of shop to initialize data for

   ```lua
   Shops.initializeShopData(person, "DungeonShop")
   ```
]=]
function Shops.initializeShopData(person: Person.Person, shopType: string): ()
	if not shopConfigs[shopType] then
		return
	end

	person.dataCache(function(cache)
		local newCache = table.clone(cache)

		-- Ensure shop data exists
		local shopDataKey = shopType .. "Data"
		if not newCache[shopDataKey] then
			newCache[shopDataKey] = {}
		end

		local shopData = newCache[shopDataKey]

		-- Initialize stock for items that have limited stock
		local config = shopConfigs[shopType]
		for itemId, itemConfig in pairs(config.items) do
			if itemConfig.stock > 0 and not shopData[itemId] then
				shopData[itemId] = { stock = itemConfig.stock }
			end
		end

		return newCache
	end)
end

--[=[
   Checks for shop resets (daily/weekly)
   This function should be called periodically (e.g., every hour) to check if any shops need to be reset.

   @within Shops

   ```lua
   Shops.checkShopResets()
   ```
]=]
function Shops.checkShopResets(): ()
	local currentTime = os.time()
	local _currentDay = math.floor(currentTime / 86400)
	local _currentWeek = math.floor(currentTime / (86400 * 7))

	for shopType, config in pairs(shopConfigs) do
		local shouldReset = false
		if config.resetType == "daily" then
			-- Check if it's a new day - placeholder logic
			local daysSinceEpoch = math.floor(currentTime / 86400)
			shouldReset = daysSinceEpoch > 0
		elseif config.resetType == "weekly" then
			-- Check if it's a new week - placeholder logic
			local weeksSinceEpoch = math.floor(currentTime / (86400 * 7))
			shouldReset = weeksSinceEpoch > 0
		end

		if shouldReset then
			Shops.resetShop(shopType)
		end
	end
end

--[=[
   Resets a shop's stock

   @within Shops

   @param shopType string -- The type of shop to reset

   ```lua
   Shops.resetShop("DungeonShop")
   ```
]=]
function Shops.resetShop(shopType: string): ()
	if not shopConfigs[shopType] then
		return
	end

	-- Reset for all players
	for _, player in pairs(Players:GetPlayers()) do
		local personFuture = Person.getForPlayer(player)
		if personFuture then
			local person = personFuture:Await()
			if person then
				Shops.resetShopForPlayer(person, shopType)
			end
		end
	end
end

--[=[
   Resets shop stock for a specific player

   @within Shops

   @param person Person -- The person whose shop stock to reset
   @param shopType string -- The type of shop to reset for the player

   ```lua
   Shops.resetShopForPlayer(person, "DungeonShop")
   ```
]=]
function Shops.resetShopForPlayer(person: Person.Person, shopType: string): ()
	if not shopConfigs[shopType] then
		return
	end

	person.dataCache(function(cache)
		local newCache = table.clone(cache)
		local shopDataKey = shopType .. "Data"
		local shopData = newCache[shopDataKey] or {}

		local config = shopConfigs[shopType]
		for itemId, itemConfig in pairs(config.items) do
			if itemConfig.stock > 0 then
				shopData[itemId] = { stock = itemConfig.stock }
			end
		end

		newCache[shopDataKey] = shopData
		return newCache
	end)
end

--[=[
   Purchases an item from a shop

   @within Shops

   @param person Person -- The person making the purchase
   @param shopType string -- The type of shop to purchase from
   @param itemId string -- The ID of the item to purchase
   @param amount number -- The amount of the item to purchase

   @return boolean -- Returns true if the purchase was successful, false otherwise

   ```lua
   local success = Shops.purchaseShopItem(person, "DungeonShop", "Health Potion", 2)
   if success then
	   print("Purchase successful!")
   else
	   print("Purchase failed.")
   end
   ```
]=]
function Shops.purchaseShopItem(person: Person.Person, shopType: string, itemId: string, amount: number): boolean
	if not shopConfigs[shopType] then
		return false
	end

	local config = shopConfigs[shopType]
	local itemConfig = config.items[itemId]

	if not itemConfig then
		return false
	end

	local cache = person.dataCache()
	local shopDataKey = shopType .. "Data"
	local shopData = cache[shopDataKey] or {}

	-- Check stock
	if itemConfig.stock > 0 then
		local currentStock = shopData[itemId] and shopData[itemId].stock or itemConfig.stock
		if currentStock < amount then
			return false
		end
	end

	-- Check if player can afford the item
	local totalCost = {}
	for currency, cost in pairs(itemConfig.cost) do
		totalCost[currency] = cost * amount
	end

	local currencies = cache.Currencies
	for currency, cost in pairs(totalCost) do
		if (currencies[currency] or 0) < cost then
			return false
		end
	end -- Process the purchase
	person.dataCache(function(oldCache)
		local newCache = table.clone(oldCache)

		-- Deduct cost
		for currency, cost in pairs(totalCost) do
			newCache.Currencies[currency] = (newCache.Currencies[currency] or 0) - cost
		end

		-- Add item to inventory - find next available index
		local inventory = newCache.Inventory.Items
		local itemIndex = nil

		-- Find existing item or get next index
		for index, item in pairs(inventory) do
			if item.Name == itemId then
				itemIndex = index
				break
			end
		end

		if itemIndex then
			-- Item exists, increase count
			inventory[itemIndex].Count = inventory[itemIndex].Count + amount
		else
			-- Item doesn't exist, add new entry
			local nextIndex = #inventory + 1
			inventory[nextIndex] = {
				Name = itemId,
				Count = amount,
			}
		end

		-- Update shop stock
		local shopDataKeyUpdate = shopType .. "Data"
		if not newCache[shopDataKeyUpdate] then
			newCache[shopDataKeyUpdate] = {}
		end

		local shopDataUpdate = newCache[shopDataKeyUpdate]
		if itemConfig.stock > 0 then
			if not shopDataUpdate[itemId] then
				shopDataUpdate[itemId] = { stock = itemConfig.stock }
			end
			shopDataUpdate[itemId].stock = shopDataUpdate[itemId].stock - amount
		end

		return newCache
	end)

	-- Fire event
	itemPurchasedEvent:fire({
		player = person.player,
		shopType = shopType,
		itemId = itemId,
		amount = amount,
		cost = totalCost,
	})

	return true
end

--[=[
   Gets available items for a shop type

   @within Shops

   @param shopType string -- The type of shop to get items for

   @return { [string]: any }? -- Returns a table of items if the shop type exists, nil otherwise

   ```lua
   local items = Shops.getShopItems("DungeonShop")
   if items then
	   for itemId, itemConfig in pairs(items) do
		   print(itemId, itemConfig.cost, itemConfig.stock)
	   end
   else
	   print("Shop type not found.")
   end
   ```
]=]
function Shops.getShopItems(shopType: string): { [string]: any }?
	return shopConfigs[shopType] and shopConfigs[shopType].items
end

--[=[
   Gets shop stock for a person

   @within Shops

   @param person Person -- The person whose shop stock to get
   @param shopType string -- The type of shop to get stock for

   @return { [string]: number } -- Returns a table of item IDs and their stock counts

   ```lua
   local stock = Shops.getShopStock(person, "DungeonShop")
   for itemId, stockCount in pairs(stock) do
	   print(itemId, stockCount)
   end
   ```
]=]
function Shops.getShopStock(person: Person.Person, shopType: string): { [string]: number }
	local cache = person.dataCache()
	local shopDataKey = shopType .. "Data"
	local shopData = cache[shopDataKey] or {}

	local stock = {}
	local config = shopConfigs[shopType]
	if config then
		for itemId, itemConfig in pairs(config.items) do
			if itemConfig.stock > 0 then
				stock[itemId] = shopData[itemId] and shopData[itemId].stock or itemConfig.stock
			else
				stock[itemId] = -1 -- Unlimited
			end
		end
	end

	return stock
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   shops.start()
   ```
]=]
local function start(): ()
	-- Set up Blink network event handling
	-- Purchase shop item event
	Network.PurchaseShopItem.on(function(player, data)
		local personFuture = Person.getForPlayer(player)
		if not personFuture then
			return
		end

		local person = personFuture:Await()
		if not person then
			return
		end

		Shops.purchaseShopItem(person, data.shopType, data.itemId, data.amount)
	end)
end

--[=[
   This function is used for initialization. It should be called before `start()` to set up the provider.

   ```lua
   shops.init()
   ```
]=]
local function init(): ()
	-- Load shop configurations
	Shops.loadDefaultShopConfigs()

	-- Initialize shop data for new players
	Person.personAdded:connect(function(person: Person.Person): ()
		task.wait(1) -- Wait for data to load
		for _, shopType in ipairs(SHOP_TYPES) do
			Shops.initializeShopData(person, shopType)
		end
	end)

	-- Set up periodic shop reset checks (every hour)
	task.spawn(function()
		while true do
			task.wait(3600) -- Check every hour
			Shops.checkShopResets()
		end
	end)
end

return {
	version = version,

	-- Functions
	start = start,
	init = init,
	loadDefaultShopConfigs = Shops.loadDefaultShopConfigs,
	initializeShopData = Shops.initializeShopData,
	checkShopResets = Shops.checkShopResets,
	resetShop = Shops.resetShop,
	resetShopForPlayer = Shops.resetShopForPlayer,
	purchaseShopItem = Shops.purchaseShopItem,
	getShopItems = Shops.getShopItems,
	getShopStock = Shops.getShopStock,

	-- Events
	itemPurchased = Shops.itemPurchased,
}
