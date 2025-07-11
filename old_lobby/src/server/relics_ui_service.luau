--------------------------------------------------------------------------------
-- relics_ui_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require("@network/server")
local Person = require("@commonserver/person")
local RelicsServer = require("@server/relic_service")

-- Network events
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer_2

--[=[
UI handler service for relic management functionality.

@class RelicsUIService
]=]
local RelicsUIService = {
	version = version,
}

--[=[
Finds which unit has a specific relic equipped.

@param person Person -- The player's person instance
@param relicName string -- The relic to search for
@return string? -- The unit ID that has the relic equipped
]=]
local function getUnitWithRelic(person: Person.Person, relicName: string): string?
	local inventory = person.dataCache().Inventory
	local units = inventory.Units or {}

	for unitId, unitData in units do
		if unitData.Relic == relicName then
			return unitId
		end
	end

	return nil
end

--[=[
Equips a relic to a unit.

@param player Player -- The player equipping the relic
@param unitId string -- The unit to equip the relic to
@param relicName string -- The relic to equip
]=]
function RelicsUIService.equipRelic(player: Player, unitId: string, relicName: string)
	local person = Person.new(player)
	local inventory = person.dataCache().Inventory
	local units = inventory.Units or {}
	local items = inventory.Items or {}

	-- Validate unit and relic exist
	if not units[unitId] or not items[relicName] then
		return
	end

	-- Check if relic is already equipped to another unit
	local currentlyEquippedUnit = getUnitWithRelic(person, relicName)
	if currentlyEquippedUnit then
		RelicsServer:UnequipRelic(player, currentlyEquippedUnit)
	end

	-- Equip the relic
	RelicsServer:EquipRelic(player, unitId, relicName)

	NotifyPlayer:FireClient(player, {
		text = "Equipped relic!",
		color = "Green",
	})
end

--[=[
Unequips a relic from its current unit.

@param player Player -- The player unequipping the relic
@param relicName string -- The relic to unequip
]=]
function RelicsUIService.unequipRelic(player: Player, relicName: string)
	local person = Person.new(player)
	local inventory = person.dataCache().Inventory
	local items = inventory.Items or {}

	-- Validate relic exists
	if not items[relicName] then
		return
	end

	-- Find which unit has the relic
	local unitId = getUnitWithRelic(person, relicName)
	if not unitId then
		return
	end

	-- Unequip the relic
	RelicsServer:UnequipRelic(player, unitId)

	NotifyPlayer:FireClient(player, {
		text = "Unequipped relic!",
		color = "Green",
	})
end

-- Register network handlers
Network.registerHandler("EquipRelic", RelicsUIService.equipRelic)
Network.registerHandler("UnequipRelic", RelicsUIService.unequipRelic)

return RelicsUIService
