--------------------------------------------------------------------------------
-- mounts
--------------------------------------------------------------------------------

local Network = require("@network/server").common
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local loadModules = require("@commonutils/loadModules")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local version = { major = 1, minor = 0, patch = 0 }

-- Get mounts registry from constants
local MountsRegistry = loadModules:fromChildren(ReplicatedStorage.Registry.Mounts)

-- Store equipped mount data for all players
local equippedMountData: { [Player]: { Model: Model | Part | nil } } = {}

-- Events
local mountEquippedEvent: Shingo.Signal<{ player: Player, mountName: string }> = Shingo.new()
local mountUnequippedEvent: Shingo.Signal<{ player: Player }> = Shingo.new()

type Person = Person.Person

--[=[
	Mount system for managing player mounts.

	Provides functionality to give, equip, unequip, and toggle mounts for players.
	Integrates with the Person class for data storage and the Blink Network system for networking.

	@class Mounts
]=]
local Mounts = {
	version = version,
	mountEquipped = mountEquippedEvent,
	mountUnequipped = mountUnequippedEvent,
}

--[=[
	Gives a mount to a player.

	@within Mounts
	
	@param person Person -- The person to give the mount to
	@param mountName string -- The name of the mount
	@param amount number? -- The amount to give (defaults to 1)
	
	```lua
	Mounts.giveMount(person, "DragonMount", 1)
	```
]=]
function Mounts.giveMount(person: Person, mountName: string, amount: number?): ()
	if not MountsRegistry[mountName] then
		warn(`Invalid Mount {mountName}`)
		return
	end
	amount = amount or 1
	person.dataCache(function(dataCache)
		-- Add mount to inventory
		local currentCount = dataCache.Inventory.Mounts[mountName] and dataCache.Inventory.Mounts[mountName].Count or 0
		dataCache.Inventory.Mounts[mountName] = {
			Count = currentCount + amount,
		}
		return dataCache
	end)
end

--[=[
	Equips a mount for a player.

	@within Mounts
	
	@param person Person -- The person to equip the mount for
	@param mountName string -- The name of the mount to equip
	
	@return boolean -- Whether the mount was successfully equipped
	
	```lua
	local success = Mounts.equipMount(person, "DragonMount")
	```
]=]
function Mounts.equipMount(person: Person, mountName: string): boolean
	-- Check if mount exists in registry
	local mountConfig = MountsRegistry[mountName]
	if not mountConfig then
		warn(`Mount {mountName} not found in registry`)
		return false
	end
	local player = person.player
	local character = player.Character
	if not character then
		return false
	end
	-- Check if player owns this mount
	local cache = person.dataCache()
	local inventory = cache.Inventory
	local mounts = inventory.Mounts
	if not mounts[mountName] or not mounts[mountName].Count or mounts[mountName].Count <= 0 then
		return false
	end
	-- Unequip current mount first
	Mounts.unequipMount(person)
	-- Get mount model
	local mountModel = mountConfig.GetModel and mountConfig:GetModel()
	if mountModel then
		local newModel = mountModel:Clone()
		equippedMountData[player] = { Model = newModel }
		-- Attach mount to character
		for _, descendant in pairs(newModel:GetDescendants()) do
			local motor = descendant :: Motor6D
			if not motor:IsA("Motor6D") or not character:FindFirstChild(motor.Name) then
				continue
			end
			local limb = character:FindFirstChild(motor.Name) :: BasePart
			if not motor.Part0 then
				motor.Part0 = limb
			elseif not motor.Part1 then
				motor.Part1 = limb
			end
		end
		newModel.Parent = character -- Create mount object reference in character
		local mountObject = character:FindFirstChild("MountObject") :: ObjectValue?
		if not mountObject then
			local newMountObject = Instance.new("ObjectValue")
			newMountObject.Name = "MountObject"
			newMountObject.Parent = character
			mountObject = newMountObject
		end
		if mountObject then
			mountObject.Value = newModel
		end
	else
		warn(`Mount {mountName} does not have a valid model`)
		return false
	end
	-- Update data cache
	person.dataCache(function(dataCache)
		dataCache.EquippedMount = mountName
		return dataCache
	end)
	-- Fire event
	mountEquippedEvent:fire({ player = player, mountName = mountName })
	return true
end

--[=[
	Unequips the currently equipped mount for a player.

	@within Mounts
	
	@param person Person -- The person to unequip the mount for
	
	```lua
	Mounts.unequipMount(person)
	```
]=]
function Mounts.unequipMount(person: Person): ()
	local player = person.player
	if equippedMountData[player] then
		local mountModel = equippedMountData[player].Model
		if mountModel then
			mountModel:Destroy()
		end
		equippedMountData[player] = nil
	end
	-- Update data cache
	person.dataCache(function(dataCache)
		dataCache.EquippedMount = "" -- Clear equipped mount (This will save as nil in the data since its the default value)
		return dataCache
	end)
	-- Fire event
	mountUnequippedEvent:fire({ player = player })
end

--[=[
	Equips the mount that's saved in the player's data.
	
	@private

	@param person Person -- The person to equip the mount for
]=]
function Mounts.equipMountFromData(person: Person): ()
	local cache = person.dataCache()
	local equippedMount = cache.EquippedMount

	if equippedMount and equippedMount ~= "" then
		Mounts.equipMount(person, equippedMount)
	end
end

--[=[
	Handles when a character is added - equips their saved mount.
	
	@private

	@param person Person -- The person whose character was added

	```lua
	Mounts._handleCharacterAdded(person)
	```
]=]
local function _handleCharacterAdded(person: Person): ()
	person.player.CharacterAppearanceLoaded:Wait() -- Wait for character to load
	Mounts.equipMountFromData(person)
end

--[=[
	Starts the mounts system.
	
	```lua
	Mounts.start()
	```
]=]
function Mounts.start(): ()
	Network.EquipMount.on(function(player: Player, mountName: string): ()
		local personFuture = Person.getForPlayer(player)
		local person = personFuture:Unwrap()
		assert(person)
		Mounts.equipMount(person, mountName)
	end)
	Network.UnequipMount.on(function(player: Player): ()
		local personFuture = Person.getForPlayer(player)
		local person = personFuture:Unwrap()
		assert(person)
		Mounts.unequipMount(person)
	end)
end

--[=[
	Initializes the mounts system.
	
	```lua
	Mounts.init()
	```
]=]
function Mounts.init(): ()
	-- Set up character respawn handling
	Person.personAdded:connect(function(person: Person): ()
		local player = person.player
		player.CharacterAdded:Connect(function()
			_handleCharacterAdded(person)
		end)
		-- Equip mount when character is already present
		if player.Character then
			_handleCharacterAdded(person)
		end
	end)
	-- Clean up when player leaves
	Person.personRemoved:connect(function(person: Person.Person)
		local player = person.player
		if equippedMountData[player] then
			local mountModel = equippedMountData[player].Model
			if mountModel then
				mountModel:Destroy()
			end
			equippedMountData[player] = nil
		end
	end)
end

return {
	version = version,

	-- Functions
	init = Mounts.init,
	start = Mounts.start,
	equipMountFromData = Mounts.equipMountFromData,
	equipMount = Mounts.equipMount,
	unequipMount = Mounts.unequipMount,
	giveMount = Mounts.giveMount,

	-- Events
	mountEquipped = mountEquippedEvent,
	mountUnequipped = mountUnequippedEvent,
}
