--------------------------------------------------------------------------------
-- crafting_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CraftingLibrary = require("@commonutils/CraftingLibrary")
local Network = require("@network/server")
local Person = require("@commonserver/person")

-- Network events
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer

--[=[
Service for handling item crafting system.

@class CraftingService
]=]
local CraftingService = {
	version = version,
}

--[=[
Attempts to craft an item for a player

@within CraftingService

@param person Person -- The person attempting to craft
@param itemName string -- The name of the item to craft

```lua
CraftingService.craftItem(person, "AdvancedSword")
```
]=]
function CraftingService.craftItem(person: Person.Person, itemName: string): ()
	-- Check if player can craft the item
	if not CraftingLibrary:CanCraftItem(person.player, itemName) then
		return
	end

	-- Attempt to craft the item
	local success = CraftingLibrary:CraftItem(person.player, itemName)

	if success then
		-- Notify player of success
		if NotifyPlayer then
			NotifyPlayer:FireClient(person.player, {
				color = "Success",
				text = "Crafting successful!",
			})
		end

		-- Update bingo progress
		if _G.serverServices and _G.serverServices.BingoService then
			_G.serverServices.BingoService:AddProgress(person.player, "Craft", 1)
		end
	end
end

--[=[
Initializes the CraftingService

@within CraftingService
]=]
function CraftingService.start(): ()
	-- Set up network handlers
	Network.registerHandler("Crafting/CraftItem", function(player: Player, itemName: string)
		local person = Person.getForPlayer(player)
		if person then
			CraftingService.craftItem(person, itemName)
		end
	end)

	print("CraftingService started")
end

return CraftingService
