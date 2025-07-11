--------------------------------------------------------------------------------
-- title_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

-- Create signals for title events
local titleEquippedEvent = Shingo.new() :: Shingo.Signal<Player, string>
local titleAwardedEvent = Shingo.new() :: Shingo.Signal<Player, string>

--[=[
   Title management system for handling player titles.

   @class TitleService
]=]
local TitleService = {
	version = version,

	-- Events
	titleEquipped = titleEquippedEvent,
	titleAwarded = titleAwardedEvent,
}

--[=[
   Equips a title for a player

   @within TitleService

   @param person Person -- The person equipping the title
   @param titleName string -- The name of the title to equip

   @return boolean -- Whether the title was equipped successfully

   @error "InvalidTitle" -- When the title doesn't exist in player's inventory

   ```lua
   local success = TitleService.equipTitle(person, "Champion")
   ```
]=]
function TitleService.equipTitle(person: Person.Person, titleName: string): boolean
	local cache = person.dataCache()
	local inventory = cache.Inventory or { Titles = {} }
	local playerTitles = inventory.Titles or {}

	-- Check if player owns the title
	if not table.find(playerTitles, titleName) then
		warn(`Player {person.player.Name} attempted to equip title they don't own: {titleName}`)
		return false
	end

	-- Equip the title
	person.dataCache(function(dataCache)
		dataCache.CurrentTitle = titleName
		return dataCache
	end)

	-- Fire events
	titleEquippedEvent:fire(person.player, titleName)
	Network.TitleEquipped.fire(person.player, { title = titleName })

	return true
end

--[=[
   Awards a title to a player

   @within TitleService

   @param person Person -- The person receiving the title
   @param titleName string -- The name of the title to award

   @return boolean -- Whether the title was awarded

   ```lua
   local awarded = TitleService.awardTitle(person, "FirstWin")
   ```
]=]
function TitleService.awardTitle(person: Person.Person, titleName: string): boolean
	local cache = person.dataCache()
	local inventory = cache.Inventory or { Titles = {} }
	local playerTitles = inventory.Titles or {}

	-- Check if player already has the title
	if table.find(playerTitles, titleName) then
		return false
	end

	-- Award the title
	person.dataCache(function(dataCache)
		dataCache.Inventory = dataCache.Inventory or { Titles = {} }
		dataCache.Inventory.Titles = dataCache.Inventory.Titles or {}
		table.insert(dataCache.Inventory.Titles, titleName)
		return dataCache
	end)

	-- Fire events
	titleAwardedEvent:fire(person.player, titleName)
	Network.TitleAwarded.fire(person.player, { title = titleName })

	return true
end

--[=[
   Unequips the current title for a player

   @within TitleService

   @param person Person -- The person unequipping their title

   ```lua
   TitleService.unequipTitle(person)
   ```
]=]
function TitleService.unequipTitle(person: Person.Person): ()
	person.dataCache(function(dataCache)
		dataCache.CurrentTitle = ""
		return dataCache
	end)

	-- Fire events
	titleEquippedEvent:fire(person.player, "")
	Network.TitleEquipped.fire(person.player, { title = "" })
end

--[=[
   Gets all titles owned by a player

   @within TitleService

   @param person Person -- The person to get titles for

   @return {string} -- Array of title names

   ```lua
   local titles = TitleService.getPlayerTitles(person)
   ```
]=]
function TitleService.getPlayerTitles(person: Person.Person): { string }
	local cache = person.dataCache()
	local inventory = cache.Inventory or { Titles = {} }
	return inventory.Titles or {}
end

--[=[
   Gets the currently equipped title for a player

   @within TitleService

   @param person Person -- The person to get the current title for

   @return string -- The current title name (empty string if none)

   ```lua
   local currentTitle = TitleService.getCurrentTitle(person)
   ```
]=]
function TitleService.getCurrentTitle(person: Person.Person): string
	local cache = person.dataCache()
	return cache.CurrentTitle or ""
end

--[=[
   Initializes the title service

   @within TitleService

   ```lua
   TitleService.init()
   ```
]=]
function TitleService.init(): ()
	-- Listen for network events when they're added
	-- Network.EquipTitle.on(function(player: Player, data: { title: string })
	--     local person = Person.getForPlayer(player):Await()
	--     if person then
	--         TitleService.equipTitle(person, data.title)
	--     end
	-- end)
end

return TitleService
