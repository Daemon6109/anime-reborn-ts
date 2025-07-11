--------------------------------------------------------------------------------
-- gifting_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require("@network/server")
local Person = require("@commonserver/person")

-- Network events
local UiCommunication = ReplicatedStorage.Events.UiCommunication

-- Constants
local COOLDOWN_DURATION = 3

--[=[
Service for handling player-to-player gifting system.

@class GiftingService
]=]
local GiftingService = {
	version = version,
}

-- Track players on gift cooldown
local giftCooldowns: { [Player]: boolean } = {}

--[=[
Attempts to gift a product to another player

@within GiftingService

@param person Person -- The person sending the gift
@param giftedPlayerId number -- The user ID of the player receiving the gift
@param productId (number | string) -- The product ID to gift

```lua
GiftingService.giftPlayer(person, 123456789, 1932432089)
```
]=]
function GiftingService.giftPlayer(person: Person.Person, giftedPlayerId: number, productId: number | string): ()
	local player = person.player

	-- Check cooldown
	if giftCooldowns[player] then
		return
	end

	-- Basic validation
	if player.UserId == giftedPlayerId or giftedPlayerId <= 0 then
		return
	end

	-- Set cooldown
	giftCooldowns[player] = true

	-- Attempt the gift through monetization handler
	local success = false
	if _G.serverServices and _G.serverServices.MonetizationHandler then
		success = _G.serverServices.MonetizationHandler:AttemptGiftPlayer(player, giftedPlayerId, productId)
	end

	if success then
		-- Hide the gifting UI on success
		if UiCommunication then
			UiCommunication:FireClient(player, "Gifting/HideUI")
		end
	end

	-- Reset cooldown after delay
	task.spawn(function()
		task.wait(COOLDOWN_DURATION)
		if player.Parent then
			giftCooldowns[player] = nil
		end
	end)
end

--[=[
Removes stored gift data for a player

@within GiftingService

@param person Person -- The person to remove gift data for

```lua
GiftingService.removeGiftData(person)
```
]=]
function GiftingService.removeGiftData(person: Person.Person): ()
	if _G.serverServices and _G.serverServices.MonetizationHandler then
		_G.serverServices.MonetizationHandler.StoredGiftData[person.player] = nil
	end
end

--[=[
Initializes the GiftingService

@within GiftingService
]=]
function GiftingService.start(): ()
	-- Set up network handlers
	Network.registerHandler(
		"Gifting/GiftPlayer",
		function(player: Player, giftedPlayerId: number, productId: number | string)
			local person = Person.getForPlayer(player)
			if person then
				GiftingService.giftPlayer(person, giftedPlayerId, productId)
			end
		end
	)

	Network.registerHandler("Gifting/RemoveGiftData", function(player: Player)
		local person = Person.getForPlayer(player)
		if person then
			GiftingService.removeGiftData(person)
		end
	end)

	-- Clean up cooldowns when players leave
	Players.PlayerRemoving:Connect(function(player)
		giftCooldowns[player] = nil
	end)

	print("GiftingService started")
end

return GiftingService
