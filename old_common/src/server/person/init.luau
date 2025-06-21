--------------------------------------------------------------------------------
-- person
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Future = require("@pkgs/future")
local Shingo = require("@pkgs/shingo")

local person_class = require("@self/person_class")

local safePlayerAdded = require("@commonutils/safePlayerAdded")

local Players = game:GetService("Players")

type Signal<T> = Shingo.Signal<T>
export type Person = person_class.Person

-- Store all active Person instances
local activePeople = {}

-- Create signals for person events
local personAddedEvent = Shingo.new() :: Signal<Person>
local personRemovedEvent = Shingo.new() :: Signal<Person>

local threadsPendingPersonLoad = {} :: { [Player]: { thread } }

local function isLoading(player: Player): boolean
	if activePeople[player.UserId] then
		return false
	else
		return true
	end
end

local function waitForPersonLoadAsync(player: Player): ()
	if not isLoading(player) then -- If the data is already loaded,
		return
	end
	threadsPendingPersonLoad[player] = threadsPendingPersonLoad[player] or {}

	-- We'll store the thread and resume it in _resumeThreadsPendingLoad when the data loads
	table.insert(threadsPendingPersonLoad[player], coroutine.running())

	coroutine.yield()
end

local function resumeThreadsPendingLoad(player: Player): ()
	if threadsPendingPersonLoad[player] then
		for _, thread in ipairs(threadsPendingPersonLoad[player]) do
			task.spawn(thread)
		end
	end

	threadsPendingPersonLoad[player] = nil
end

local function cancelThreadsPendingLoad(player: Player): ()
	if threadsPendingPersonLoad[player] then
		for _, thread in ipairs(threadsPendingPersonLoad[player]) do
			coroutine.resume(thread, nil) -- Resume the thread with nil to indicate cancellation
		end
	end

	threadsPendingPersonLoad[player] = nil
end

--[=[
   Creates a new Person instance for a player
   
   @param player Player -- The player to create a Person for
   @return Person -- The created Person instance
   
   ```lua
   local person = person.createForPlayer(somePlayer)
   ```
]=]
local function createForPlayer(player: Player): Person
	if activePeople[player.UserId] then
		return activePeople[player.UserId]
	end

	local person = person_class.new({ player = player })
	activePeople[player.UserId] = person

	resumeThreadsPendingLoad(player)

	-- Fire the person added event
	personAddedEvent:fire(person)

	return person
end

--[=[
   Removes a Person instance for a player
   
   @param player Player -- The player to remove the Person for
   
   ```lua
   person.removeForPlayer(somePlayer)
   ```
]=]
local function removeForPlayer(player: Player): ()
	local person = activePeople[player.UserId]

	if person then
		-- Fire the person removed event
		personRemovedEvent:fire(person)

		task.defer(function()
			person:Dispose()
			activePeople[player.UserId] = nil
			player:Destroy()
		end)
	else
		task.defer(player.Destroy, player)
	end

	cancelThreadsPendingLoad(player)
end

local function getForPlayer(_player: Player, _yield: boolean?): Future.Future<Person?>
	local future_person = Future.new(function(player: Player, yield: boolean?): Person?
		yield = if yield == nil then true else yield
		if yield then
			waitForPersonLoadAsync(player)
		end

		-- Return nil if timeout or player left
		return activePeople[player.UserId]
	end, _player, _yield)

	return future_person
end

--[=[
   This function is used for initialization. It should be called before `start()` to set up the provider.

   ```lua
   person.init()
   ```
]=]
local function init()
	-- Set up player joining/leaving events
	safePlayerAdded(createForPlayer)
	Players.PlayerRemoving:Connect(removeForPlayer)
end

return {
	version = version,
	order = 1,

	-- Functions
	init = init,
	isLoading = isLoading,
	waitForPersonLoadAsync = waitForPersonLoadAsync,
	getForPlayer = getForPlayer,
	createForPlayer = createForPlayer,
	removeForPlayer = removeForPlayer,

	-- Events
	personAdded = personAddedEvent,
	personRemoved = personRemovedEvent,
}
