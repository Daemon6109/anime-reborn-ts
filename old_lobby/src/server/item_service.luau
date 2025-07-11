--------------------------------------------------------------------------------
-- item_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local HttpService = game:GetService("HttpService")

local Analytics = require("@commonserver/analytics")
local BundleUsages = require("@registry/BundleUsages")
local ChallengeRegistry = require("@registry/Challenges")
local ItemRegistry = require("@registry/Items")
local MapRegistry = require("@registry/Maps")
local ModifierRegistry = require("@registry/ElementalModifiers")
local Network = require("@network/server")
local Person = require("@commonserver/person")
local PotionRegistry = require("@registry/Potions")
local deepCopy = require("@data/utils/deepCopy")

export type ItemData = {
	Name: string,
	Count: number,
	ExtraData: { [string]: any }?,
}

export type ItemConfig = {
	DisplayName: string,
	NotStackable: boolean?,
	Limit: (number | "inf")?,
	RequestAmountOnUsage: boolean?,
	Sort: { string },
	RedeemItem: string?,
	RedeemItemType: string?,
	ProductId: number?,
	GetCustomData: (() -> { [string]: any })?,
}

--[=[
Service for managing player items, inventory operations, and item usage.

@class ItemService
]=]
local ItemService = {
	version = version,
}

-- Template for new items
local ITEM_TEMPLATE: ItemData = {
	Name = "",
	Count = 0,
}

-- Usable item modules (would be loaded from child modules in real implementation)
local usableItemModules: { [string]: any } = {}

--[=[
Generates random portal data for portal items

@within ItemService

@return { [string]: any } -- Portal configuration data

@private
]=]
local function generateRandomPortalData(): { [string]: any }
	-- Get available maps
	local allMaps = {}
	for mapName, order in pairs(_G.Registry.registry.MapOrder.Info) do
		if mapName ~= "raw" then
			allMaps[order] = mapName
		end
	end

	-- Get available challenges
	local allChallenges = {}
	for challengeName in pairs(ChallengeRegistry) do
		if challengeName ~= "Traits Disabled" then
			table.insert(allChallenges, challengeName)
		end
	end

	-- Get available modifiers
	local allModifiers = {}
	for modifierName in pairs(ModifierRegistry) do
		table.insert(allModifiers, modifierName)
	end

	-- Select random values
	local challenge = allChallenges[math.random(1, #allChallenges)]
	local map = allMaps[math.random(1, #allMaps)]

	-- Ensure the map has a portal
	while not MapRegistry[map].Root:FindFirstChild("Portal") do
		table.remove(allMaps, table.find(allMaps, map))
		map = allMaps[math.random(1, #allMaps)]
	end

	local portalFolder = MapRegistry[map].Root:FindFirstChild("Portal")
	local allActs = #portalFolder:GetChildren()
	local act = math.random(1, allActs)

	-- Select buff and debuff
	local debuff = allModifiers[math.random(1, #allModifiers)]
	table.remove(allModifiers, table.find(allModifiers, debuff))
	local buff = allModifiers[math.random(1, #allModifiers)]

	return {
		Map = map,
		Act = act,
		Challenge = challenge,
		Buff = buff,
		Debuff = debuff,
		ForcedElements = {
			[buff] = {
				Min = 0,
				Max = 25,
			},
			[debuff] = {
				Min = -50,
				Max = 0,
			},
		},
	}
end

--[=[
Checks if a player has a specific item in sufficient quantity

@within ItemService

@param person Person -- The person to check
@param itemName string -- The name of the item
@param count number? -- The required count (default: 1)

@return boolean -- Whether the player has enough of the item

```lua
local hasEnough = ItemService.hasItem(person, "TraitCrystal", 5)
```
]=]
function ItemService.hasItem(person: Person.Person, itemName: string, count: number?): boolean
	count = count or 1

	if not ItemRegistry[itemName] then
		return false
	end

	local dataCache = person.dataCache()
	local inventory = dataCache.Inventory.Items

	-- Handle non-stackable items
	if ItemRegistry[itemName].NotStackable then
		count = 1
	end

	-- Check for item by name
	for itemId, itemData in pairs(inventory) do
		if itemData.Name == itemName and itemData.Count >= count then
			return true
		end
	end

	return false
end

--[=[
Gets the count of a specific item a player has

@within ItemService

@param person Person -- The person to check
@param itemName string -- The name of the item

@return number -- The count of the item

```lua
local crystalCount = ItemService.getItemCount(person, "TraitCrystal")
```
]=]
function ItemService.getItemCount(person: Person.Person, itemName: string): number
	if not ItemRegistry[itemName] then
		return 0
	end

	local dataCache = person.dataCache()
	local inventory = dataCache.Inventory.Items

	for itemId, itemData in pairs(inventory) do
		if itemData.Name == itemName then
			return itemData.Count
		end
	end

	return 0
end

--[=[
Gives items to a player (can be negative to remove items)

@within ItemService

@param person Person -- The person to give items to
@param items { [string]: number } -- Table of item names and amounts
@param visualsDisabled boolean? -- Whether to disable visual notifications
@param extraData { [string]: any }? -- Extra data for non-stackable items

```lua
ItemService.giveItems(person, {
	TraitCrystal = 10,
	Gems = -500 -- Remove 500 gems
})
```
]=]
function ItemService.giveItems(
	person: Person.Person,
	items: { [string]: number },
	visualsDisabled: boolean?,
	extraData: { [string]: any }?
): ()
	local dataCache = person.dataCache()
	local newCache = table.clone(dataCache)
	local inventory = newCache.Inventory.Items
	local itemsCopy = deepCopy(items)
	local visualData = {}

	for itemName, count in pairs(itemsCopy) do
		if count == 0 then
			continue
		end

		count = count or 1
		local itemConfig = ItemRegistry[itemName]

		-- Handle items that exist in inventory but not in registry
		if not itemConfig and inventory[itemName] then
			itemConfig = ItemRegistry[inventory[itemName].Name]
			if not itemConfig then
				continue
			end
		end

		-- Track quest progress for item acquisition
		if _G.serverServices and _G.serverServices.QuestHandler then
			_G.serverServices.QuestHandler:GivePointsByPointType(person.player, `GetItem{itemName}`, count)
		end

		-- Handle non-stackable items
		if itemConfig and itemConfig.NotStackable then
			if count < 0 then
				-- Remove non-stackable items
				local removeCount = math.abs(count)
				local removed = 0

				for itemId, itemData in pairs(inventory) do
					if removed >= removeCount then
						break
					end
					if itemData.Name == itemName then
						inventory[itemId] = nil
						removed += 1
						visualData[itemData.Name] = (visualData[itemData.Name] or 0) - 1
					end
				end
			elseif count > 0 then
				-- Add non-stackable items
				local limit = (itemConfig.Limit == "inf" and math.huge) or (itemConfig.Limit or 100)
				local totalItems = 0

				-- Count existing items
				for _, itemData in pairs(inventory) do
					if itemData.Name == itemName then
						totalItems += 1
					end
				end

				if totalItems >= limit then
					continue
				end

				-- Add new items
				for i = 1, math.min(count, limit - totalItems) do
					local itemExtraData = extraData
					if not itemExtraData and itemConfig.GetCustomData then
						itemExtraData = itemConfig.GetCustomData()
					elseif not itemExtraData and table.find(itemConfig.Sort, "Portal") then
						itemExtraData = generateRandomPortalData()
					elseif not itemExtraData and table.find(itemConfig.Sort, "Relic") then
						-- Would call relic service here
						if _G.serverServices and _G.serverServices.RelicsServer then
							itemExtraData = _G.serverServices.RelicsServer:GetNewRelicData(person.player, itemName)
						end
					end

					local itemId = HttpService:GenerateGUID(false)
					inventory[itemId] = {
						Name = itemName,
						Count = 1,
						ExtraData = itemExtraData or {},
					}
				end

				visualData[itemName] = (visualData[itemName] or 0) + count
			end
		else
			-- Handle stackable items
			if inventory[itemName] then
				local itemLimit = (itemConfig and itemConfig.Limit == "inf" and math.huge)
					or (itemConfig and itemConfig.Limit)
					or 100

				if inventory[itemName].Count + count > itemLimit then
					local originalCount = count
					count = itemLimit - inventory[itemName].Count
					itemsCopy[itemName] = count ~= 0 and count or nil

					if NotifyPlayer and itemConfig then
						NotifyPlayer:FireClient(
							person.player,
							"Error",
							`You have already exceeded the limit for {itemConfig.DisplayName}. (MAX {itemLimit})`
						)
					end
				end

				if count == 0 then
					continue
				end

				if inventory[itemName].Count + count > 0 then
					inventory[itemName].Count += count
				else
					inventory[itemName] = nil
				end
			elseif count > 0 then
				-- Create new stackable item
				local finalCount = count
				if itemConfig and itemConfig.Limit ~= "inf" then
					finalCount = math.min(count, itemConfig.Limit or 100)
				end

				inventory[itemName] = {
					Name = itemName,
					Count = finalCount,
				}

				itemsCopy[itemName] = finalCount
			end

			if count ~= 0 then
				visualData[itemName] = (visualData[itemName] or 0) + count
			end
		end
	end

	-- Update data cache
	newCache.Inventory.Items = inventory
	person.dataCache(newCache)

	-- Send visual notification
	if not visualsDisabled and ItemReceivedEvent then
		ItemReceivedEvent:FireClient(person.player, visualData)
	end
end

--[=[
Handles item usage logic

@within ItemService

@param person Person -- The person using the item
@param itemName string -- The name of the item to use
@param useAmount number? -- The amount to use

```lua
ItemService.useItem(person, "HealthPotion", 1)
```
]=]
function ItemService.useItem(person: Person.Person, itemName: string, useAmount: number?): ()
	local dataCache = person.dataCache()
	local inventory = dataCache.Inventory.Items
	local itemConfig = ItemRegistry[itemName]
	local itemId: string?

	-- Handle case where itemName is actually an ID for non-stackable items
	if not itemConfig then
		local itemData = inventory[itemName]
		if itemData then
			itemConfig = ItemRegistry[itemData.Name]
			itemId = itemName
			itemName = itemData.Name
		end
	end

	if not itemConfig then
		return
	end

	local usableModule = usableItemModules[itemName]
	local potionInfo = PotionRegistry[itemName]

	-- Determine use amount
	if not itemConfig.RequestAmountOnUsage or not useAmount then
		useAmount = 1
	end

	useAmount = math.floor(math.abs(useAmount or 1))
	useAmount = math.clamp(useAmount, 1, math.huge)

	-- Check if player has enough items
	if not ItemService.hasItem(person, itemName, useAmount) then
		return
	end

	-- Handle different item types
	if table.find(itemConfig.Sort, "Potions") and potionInfo then
		-- Apply potion effect
		if _G.serverServices and _G.serverServices.EffectService then
			_G.serverServices.EffectService:ApplyEffect(
				person.player,
				potionInfo.configuration.ApplyEffect,
				potionInfo.configuration.Duration
			)
		end
		ItemService.giveItems(person, { [itemName] = -1 })
	elseif table.find(itemConfig.Sort, "Redeemable") then
		-- Handle redeemable items
		if not itemConfig.RedeemItem or not itemConfig.RedeemItemType then
			warn(`No RedeemItem or RedeemItemType for item {itemName}`)
			return
		end

		-- Check if item can be redeemed (e.g., bundle usage limits)
		if itemConfig.RedeemItemType == "Bundle" then
			-- Check bundle usage limits here if needed
		end

		-- Remove the item
		ItemService.giveItems(person, { [itemName] = -useAmount })

		-- Give the redeemed reward
		if itemConfig.RedeemItemType == "Mount" then
			if _G.serverServices and _G.serverServices.MountsManager then
				_G.serverServices.MountsManager:GiveMount(person.player, itemConfig.RedeemItem, useAmount)
			end
		elseif itemConfig.RedeemItemType == "Bundle" then
			-- Handle bundle redemption
			if _G.serverServices and _G.serverServices.MonetizationHandler then
				_G.serverServices.MonetizationHandler:GiveProduct(person.player, itemConfig.RedeemItem)
			end
		end
	elseif usableModule then
		-- Handle custom item modules
		if usableModule.Check and not usableModule.Check(person.player, useAmount) then
			return
		end

		ItemService.giveItems(person, { [itemName] = -useAmount })
		usableModule.Callback(person.player, useAmount)
	end

	-- Track engagement
	local engagement = `Item:{itemName};UseAmount:{useAmount}`
	ItemService.trackEngagement(person, engagement)
end

--[=[
Deletes a specific amount of an item from player inventory

@within ItemService

@param person Person -- The person to delete items from
@param itemName string -- The name of the item
@param count number -- The amount to delete

```lua
ItemService.deleteItem(person, "TraitCrystal", 5)
```
]=]
function ItemService.deleteItem(person: Person.Person, itemName: string, count: number): ()
	local dataCache = person.dataCache()
	local inventory = dataCache.Inventory.Items
	count = math.floor(math.abs(count))

	if inventory[itemName] and inventory[itemName].Count >= count then
		ItemService.giveItems(person, { [itemName] = -count })
	end
end

--[=[
Deletes multiple items from player inventory

@within ItemService

@param person Person -- The person to delete items from
@param itemNames { string } -- Array of item names to delete

```lua
ItemService.deleteMultipleItems(person, {"OldItem1", "OldItem2"})
```
]=]
function ItemService.deleteMultipleItems(person: Person.Person, itemNames: { string }): ()
	local dataCache = person.dataCache()
	local inventory = dataCache.Inventory.Items
	local itemsToRemove = {}

	for _, itemName in ipairs(itemNames) do
		if inventory[itemName] and inventory[itemName].Count then
			itemsToRemove[itemName] = -inventory[itemName].Count
		end
	end

	if next(itemsToRemove) then
		ItemService.giveItems(person, itemsToRemove)
	end
end

--[=[
Handles when a player is loaded

@within ItemService

@param person Person -- The person who was loaded
]=]
function ItemService.playerLoaded(person: Person.Person): ()
	-- Set up relic validation (remove equipped relics that no longer exist in inventory)
	local dataCache = person.dataCache()
	local inventory = dataCache.Inventory.Items
	local units = dataCache.Inventory.Units

	for unitId, unitData in pairs(units) do
		if unitData.Relic ~= "" and not inventory[unitData.Relic] then
			if _G.serverServices and _G.serverServices.RelicsServer then
				_G.serverServices.RelicsServer:UnequipRelic(person.player, unitId)
			end
		end
	end
end

--[=[
	Initializes the ItemService

	@within ItemService
]=]
function ItemService.start(): ()
	-- Set up network handlers
	Network.registerHandler("Item/Use", function(player: Player, itemName: string, useAmount: number?)
		local person = Person.getForPlayer(player)
		if person then
			ItemService.useItem(person, itemName, useAmount)
		end
	end)

	Network.registerHandler("Item/Delete", function(player: Player, itemName: string, count: number)
		local person = Person.getForPlayer(player)
		if person then
			ItemService.deleteItem(person, itemName, count)
		end
	end)

	Network.registerHandler("Item/DeleteMultiple", function(player: Player, itemNames: { string })
		local person = Person.getForPlayer(player)
		if person then
			ItemService.deleteMultipleItems(person, itemNames)
		end
	end)

	-- Legacy event support
	if ItemUseEvent then
		ItemUseEvent.OnServerEvent:Connect(function(player: Player, itemName: string, useAmount: number?)
			local person = Person.getForPlayer(player)
			if person then
				ItemService.useItem(person, itemName, useAmount)
			end
		end)
	end

	if ItemActionEvent then
		ItemActionEvent.OnServerEvent:Connect(function(player: Player, action: string, ...)
			local person = Person.getForPlayer(player)
			if not person then
				return
			end

			if action == "Delete" then
				local itemName, count = ...
				ItemService.deleteItem(person, itemName, count)
			elseif action == "MultiDelete" then
				local itemNames = ...
				ItemService.deleteMultipleItems(person, itemNames)
			end
		end)
	end

	print("ItemService started")
end

return ItemService
