--------------------------------------------------------------------------------
-- person_class
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local Data = require("../data/init")
local Leaderboard = require("@commoncomposables/leaderboard")
local Shingo = require("@pkgs/shingo")
local Trove = require("@pkgs/trove")

export type Person = {
	-- Properties
	player: Player,
	sessionData: SessionData,
	dataCache: Atom<DataTemplate>,

	-- Methods
	Dispose: (self: Person) -> (),
}

type PersonInternal = {
	-- Properties
	player: Player,
	sessionData: SessionData,
	dataCache: Atom<DataTemplate>,
	_trove: Trove.Trove,

	-- Methods
	Dispose: (self: Person) -> (),
}

type DataTemplate = typeof(Data.template)
type Signal<T> = Shingo.Signal<T>
type Trove = Trove.Trove

--[=[
	An atom is a reactive value that can be subscribed to.

	@within Person
	@external Atom https://www.npmjs.com/package/@rbxts/charm?activeTab=readme#-reference
	@type Atom<T> Atom
]=]

type Atom<T> = Charm.Atom<T>

--[=[
	@within Person
	@interface SessionDataEntry
	.Value Atom<T> -- The value of the stat.
	.Leaderboard boolean -- Whether or not this stat should be on the leaderboard.
	.Name string -- The name of the stat.
]=]
type SessionDataEntry<T> = {
	Value: Atom<T>,
	Leaderboard: boolean,
	Name: string,
}

--[=[
	@within Person
	@interface SessionData
	.Kills SessionDataEntry<number> -- The number of kills the player has.
]=]
type SessionData = {
	Kills: SessionDataEntry<number>,
}

--[=[
	@within Person
	@interface PersonProps
	.player Player
]=]
type PersonProps = {
	player: Player,
}

--[[
	The Person class represents a player in the game, encapsulating all player data and functionality.
	It provides a clean interface for interacting with player data, characters, and events.

	@class Person
]]
local Person = {}
Person.__index = Person

local atom = Charm.atom
local subscribe = Charm.subscribe

--[=[
	Creates a new Person instance for a player.
	
	@param player Player -- The player to create a Person for
	@return Person -- The created Person instance

	```lua
	local person_class = Person.new({
		player = player,
	})
	```
]=]
function Person.new(props: PersonProps): Person
	local self = setmetatable({}, Person)

	self.player = props.player

	local dataCache = Data.getCache(self.player)
	assert(dataCache, "DataCache not found")

	self.dataCache = atom(dataCache)
	self._trove = Trove.new()

	self.sessionData = {
		Kills = {
			Value = atom(0),
			Leaderboard = true,
			Name = "Kills 🗡️",
		},
	}

	for _, sesData in pairs(self.sessionData or {}) do
		if sesData.Leaderboard then
			subscribe(sesData.Value, function(newValue: Atom<any>)
				Leaderboard.setStat(self.player, sesData.Name, newValue())
			end)
			Leaderboard.setStat(self.player, sesData.Name, sesData.Value())
		end
	end
	return (self :: any) :: Person
end

--[=[
	Cleans up resources associated with this person instance.
	
	```lua
	person:Dispose()
	```
]=]
function Person.Dispose(self: PersonInternal): ()
	print("Disposing Person for", self.player.Name)
	Data.setCache(self.player, self.dataCache())
	Data.closeDocument(self.player)
	self._trove:Destroy()
end

return Person
