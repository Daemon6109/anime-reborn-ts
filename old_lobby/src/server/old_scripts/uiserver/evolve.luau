local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EvolveLibrary = require(ReplicatedStorage.Libs.EvolveLibrary)
local UnitManager = _G.serverServices.UnitManager
local ItemManager = _G.serverServices.ItemManager
local UnitRegistry = _G.Registry.registry.Units
local StatPotentialsRegistry = _G.Registry.registry.Buffs.StatPotentials

local UiCommunication = ReplicatedStorage.Events.UiCommunication

local CopyStats = { -- Stats to transfer from the old unit to the evolved one if TransferStats is true
	"Level",
	"XP",
	"StatsPotential",
	"Traits",
	"Shiny",
	"Eliminations",
	"Relic",
}

local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local IncrementalChances = {
	[1] = {
		Chance = 20,
		Incremental = 0,
	},

	[2] = {
		Chance = 20,
		Incremental = 2,
	},

	[3] = {
		Chance = 45,
		Incremental = 1,
	},

	[4] = {
		Chance = 10,
		Incremental = 3,
	},

	[5] = {
		Chance = 5,
		Incremental = 4,
	},
}

--//
local function GetRandomIncremental()
	local RandomObject = Random.new()
	local weight = 0

	for i, v in IncrementalChances do
		local Chance = v.Chance

		weight += Chance * 100000
	end

	local NewRandom = RandomObject:NextNumber(1, weight)

	for i, v in IncrementalChances do
		local Chance = v.Chance

		weight -= Chance * 100000

		if NewRandom > weight then
			return v.Incremental
		end
	end
end

local Evolve = {

	EvolveUnit = function(player: Player, UnitId: string, Path: number)
		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)

		if not PlayerProfileClass then
			return
		end

		local PlayerInventory = PlayerProfileClass:GetField("Inventory")
		local PlayerUnits = PlayerInventory.Units
		local PlayerItems = PlayerInventory.Items

		local UnitData = PlayerUnits[UnitId]

		if not UnitData then
			return
		end
		if not EvolveLibrary:CanEvolveUnit(player, UnitId, Path) then
			return
		end

		local EvolveData = UnitRegistry[UnitData.UnitName].configuration.EvolveData[Path]
		local EvolvesInto = EvolveData.EvolvesInto
		local Requirements = EvolveData.Requirements

		local TransferData = {}

		if EvolveData.TransferStats then
			for _, stat in CopyStats do
				TransferData[stat] = UnitData[stat]
			end
		end

		--// Subtract the items before giving the player the evolved unit
		UnitManager:removeUnits(player, { UnitId })

		trackEngagement(player, "Evolve")

		for requirementName, value in Requirements do
			if type(value) ~= "table" then
				continue
			end

			for item, amount in value do
				if requirementName == "Units" then
					local TotalFound = 0

					for id, FoundUnit in PlayerUnits do
						if TotalFound >= amount then
							break
						end

						if FoundUnit.UnitName == item and not FoundUnit.Locked then
							UnitManager:removeUnits(player, { id })
							TotalFound += 1
						end
					end
				elseif requirementName == "Items" then
					ItemManager:GiveItems(player, { [item] = -amount })
				end
			end
		end

		--// Roll the potentials
		for name, value in TransferData.StatsPotential do
			local IncrementBy = GetRandomIncremental()

			if IncrementBy == 0 then
				continue
			end

			local Symbol = StatPotentialsRegistry:GetSymbol(value, name)
			local SymbolNumber = StatPotentialsRegistry.OrderNums[Symbol]

			local HighestNumber = #StatPotentialsRegistry.Order
			local FinalAmount = math.clamp(SymbolNumber + IncrementBy, 1, HighestNumber)

			local NewRank = StatPotentialsRegistry.Order[FinalAmount]
			local NextRank = StatPotentialsRegistry.Order[FinalAmount + 1]
			local NewValue = StatPotentialsRegistry[name][NewRank]

			if NewRank ~= "SSS" then
				TransferData.StatsPotential[name] = math.random(
					NewValue * 1000,
					(StatPotentialsRegistry[name][NextRank] - 0.001) * 1000
				) / 1000
			else
				TransferData.StatsPotential[name] = NewValue
			end
		end

		--// Give the player the evolved unit
		local IdList = UnitManager:giveUnit(player, EvolvesInto, 1, TransferData)
		--if EvolvesInto == "Vegeta [Evo]" then
		--	_G.serverServices.QuestHandler:GivePoints(player, "RebornQuest2", 1)
		--elseif EvolvesInto == "Freiza [Evo]" then
		--	_G.serverServices.QuestHandler:GivePoints(player, "RebornQuest4", 1)
		--elseif EvolvesInto == "Jiren [Evo]" then
		--	_G.serverServices.QuestHandler:GivePoints(player, "RebornQuest3", 1)
		--elseif EvolvesInto == "Whis [Evo]" then
		--	_G.serverServices.QuestHandler:GivePoints(player, "RebornQuest5", 1)
		--end
		--// Cutscene
		UiCommunication:FireClient(player, "Evolve/OnEvolveSuccess", IdList[1])
	end,
}

return Evolve
