local Relics = {}
local DataAccess = require(game:GetService("ServerScriptService").ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()
local Players = game:GetService("Players")
local Registry = _G.Registry.registry
local RelicsRegistry = Registry.Items

function Relics:GetNewRelicData(Player: Player, RelicName: string)
	assert(RelicsRegistry[RelicName], `[RELICS] Relic named {RelicName} doesn't exist`)

	local RelicData = RelicsRegistry[RelicName]
	local NewRelicStats = {
		["Relic"] = true,
		["Stats"] = {},
	}

	for StatName, Range in RelicData.configuration.StatRanges do
		NewRelicStats.Stats[StatName] = 1 + (math.random(Range.Min, Range.Max) / 100)
	end

	return NewRelicStats
end

function Relics:CheckRelicCondition(Unit: { any }, RelicName: string)
	local RelicData = RelicsRegistry[RelicName]

	if RelicData.CheckCondition then
		return RelicData:CheckCondition(Unit)
	end

	return true
end

function Relics:EquipRelic(Player: Player, UnitUUID: string, RelicUUID: string)
	local ProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
	local Inventory = ProfileClass:GetField("Inventory")
	local Units = Inventory.Units
	local Items = Inventory.Items
	local FoundUnit = Units[UnitUUID]
	local FoundRelic = Items[RelicUUID]

	if FoundUnit and FoundRelic then
		local Condition = Relics:CheckRelicCondition(FoundUnit, FoundRelic.Name)

		if Condition then
			ProfileClass:WriteDirectory(`Inventory/Units/{UnitUUID}/Relic`, RelicUUID, true)
			_G.serverServices.UnitManager:UpdateSlotbar(Player)
		end
	end
end

function Relics:UnequipRelic(Player: Player, UnitUUID: string)
	local ProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
	local Inventory = ProfileClass:GetField("Inventory")
	local Units = Inventory.Units
	local FoundUnit = Units[UnitUUID]

	if FoundUnit then
		ProfileClass:WriteDirectory(`Inventory/Units/{UnitUUID}/Relic`, "", true)
		_G.serverServices.UnitManager:UpdateSlotbar(Player)
	end
end

function Relics:start() end

return Relics
