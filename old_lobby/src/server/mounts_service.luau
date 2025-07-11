--------------------------------------------------------------------------------
-- mounts_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local AnalyticsService = game:GetService("AnalyticsService")
local Players = game:GetService("Players")

local MountsRegistry = require("@registry/Mounts")
local Network = require("@network/server")
local Person = require("@commonserver/person")

-- Constants
local TOGGLE_MOUNT_COOLDOWN = 0.5

--[=[
Service for handling mount purchasing and equipping.

@class MountsService
]=]
local MountsService = {
	version = version,
}

-- Track players on toggle cooldown
local toggleCooldowns: { [Player]: boolean } = {}

--[=[
Tracks player engagement with analytics

@within MountsService

@param person Person -- The person to track
@param featureName string -- The feature being tracked

```lua
MountsService.trackEngagement(person, "BuyMount")
```
]=]
function MountsService.trackEngagement(person: Person.Person, featureName: string): ()
	AnalyticsService:LogCustomEvent(person.player, "Engagement_" .. featureName)
end

--[=[
Purchases a mount for a player

@within MountsService

@param person Person -- The person buying the mount
@param mountName string -- The name of the mount to buy

```lua
MountsService.buyMount(person, "DragonMount")
```
]=]
function MountsService.buyMount(person: Person.Person, mountName: string): ()
	local dataCache = person.dataCache()
	local mountsInventory = dataCache.Inventory.Mounts
	local currencies = dataCache.Currencies

	-- Check if mount exists in registry
	local mountConfig = MountsRegistry[mountName]
	if not mountConfig then
		return
	end

	-- Check if player already owns the mount
	if mountsInventory[mountName] then
		return
	end

	local mountInfo = mountConfig.configuration
	local price = mountInfo.PriceInGems

	-- Check if player has enough gems
	if not price or currencies.Gems < price then
		return
	end

	-- Deduct gems and give mount
	local newCache = table.clone(dataCache)
	newCache.Currencies.Gems = currencies.Gems - price

	-- Update data cache
	person.dataCache(newCache)

	-- Track engagement
	MountsService.trackEngagement(person, "BuyMount")

	-- Give mount through MountsManager
	if _G.serverServices and _G.serverServices.MountsManager then
		_G.serverServices.MountsManager:GiveMount(person.player, mountName)
	else
		-- Fallback: add to data cache
		newCache.Inventory.Mounts[mountName] = true
		person.dataCache(newCache)
	end
end

--[=[
Toggles mount equipment for a player

@within MountsService

@param person Person -- The person toggling the mount
@param mountName string -- The name of the mount to toggle

```lua
MountsService.toggleEquip(person, "DragonMount")
```
]=]
function MountsService.toggleEquip(person: Person.Person, mountName: string): ()
	local player = person.player

	-- Check cooldown to avoid spam
	if toggleCooldowns[player] then
		return
	end

	local dataCache = person.dataCache()
	local mountsInventory = dataCache.Inventory.Mounts

	-- Check if player owns the mount
	if not mountsInventory[mountName] then
		return
	end

	-- Set cooldown
	toggleCooldowns[player] = true
	task.delay(TOGGLE_MOUNT_COOLDOWN, function()
		if player.Parent then
			toggleCooldowns[player] = nil
		end
	end)

	local currentMount = dataCache.EquippedMount

	if currentMount == mountName then
		-- Unequip current mount
		local newCache = table.clone(dataCache)
		newCache.EquippedMount = ""
		person.dataCache(newCache)

		if _G.serverServices and _G.serverServices.MountsManager then
			_G.serverServices.MountsManager:UnequipMount(player)
		end
	else
		-- Equip new mount
		local newCache = table.clone(dataCache)
		newCache.EquippedMount = mountName
		person.dataCache(newCache)

		if _G.serverServices and _G.serverServices.MountsManager then
			_G.serverServices.MountsManager:EquipMount(player, mountName)
		end
	end
end

--[=[
Initializes the MountsService

@within MountsService
]=]
function MountsService.start(): ()
	-- Set up network handlers
	Network.registerHandler("Mounts/BuyMount", function(player: Player, mountName: string)
		local person = Person.getForPlayer(player)
		if person then
			MountsService.buyMount(person, mountName)
		end
	end)

	Network.registerHandler("Mounts/ToggleEquip", function(player: Player, mountName: string)
		local person = Person.getForPlayer(player)
		if person then
			MountsService.toggleEquip(person, mountName)
		end
	end)

	-- Clean up cooldowns when players leave
	Players.PlayerRemoving:Connect(function(player)
		toggleCooldowns[player] = nil
	end)

	print("MountsService started")
end

return MountsService
