local module = {}

local Maid = require(game.ReplicatedStorage.Maid).new()
local HTTP = game:GetService("HttpService")

local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)
local uiCommunication = game.ReplicatedStorage.Events.UiCommunication

local RNG = require(script.Libs.RNG)

local CachedPools = {}

local function Merge(Table1, Table2)
	for Type, TypeTable in Table2 do
		for ItemName, ItemQuantity in TypeTable do
			Table1[Type] = Table1[Type] or {}
			Table1[Type][ItemName] = Table1[Type][ItemName] or 0
			Table1[Type][ItemName] += ItemQuantity
		end
	end
end

function module:CloneTable(original)
	local copy = {}

	for key, value in pairs(original) do
		if type(value) == "table" then
			copy[key] = self:CloneTable(value)
		else
			copy[key] = value
		end
	end
	return copy
end

function module:GiveUnits(Player, RewardTable)
	--// Variables
	local uuids = {}
	local HasRareUnit = false
	local units = {}
	local _gold = 0

	--// PlayerData
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
	local plrLevel = PlayerProfileClass:GetField("Level")
	local products = PlayerProfileClass:GetField("ProductsBought")
	local statistics = PlayerProfileClass:GetField("PlayerStatistics")
	local autoSell = PlayerProfileClass:GetField("Settings").AutoSell

	--// Registry
	local SummonHandler = _G.serverServices.SummonHandler
	local unitManager = _G.serverServices.UnitManager
	local GohanLimitUpdater = _G.serverServices.GohanLimitUpdater
	local PlayerService = _G.serverServices.PlayerService
	local gameFunctions = require(ReplicatedStorage.Libs.GameFunctions)
	local unitRegistry = _G.Registry.registry.Units

	local function statUpdate(unit)
		if unitRegistry[unit].configuration.Rarity == "Secret" then
			PlayerProfileClass:WriteDirectory("PlayerStatistics/SummonedSecrets", statistics.SummonedSecrets + 1, false)
		end
		if unitRegistry[unit].configuration.Rarity == "Mythical" then
			PlayerProfileClass:WriteDirectory(
				"PlayerStatistics/SummonedMythicals",
				statistics.SummonedMythicals + 1,
				false
			)
		end
	end

	for unit, v in RewardTable.Units do
		for i = 1, v do
			table.insert(units, unit)
		end
	end

	local amount = #units

	for i, v in units do
		local _reg = unitRegistry[v]
		if
			_reg.configuration.Rarity == "Secret"
			or _reg.configuration.Rarity == "Mythical"
			or _reg.configuration.Rarity == "Exclusive"
		then
			HasRareUnit = true
		end

		local IsShiny

		if not table.find({ "Epic", "Rare" }, unitRegistry[v].configuration.Rarity) then
			if plrLevel >= 10 or products["1932432116"] then
				local ROLLED_SHINY_ODD = Random.new():NextInteger(1, 100 * 10)
				local CURRENT_LUCK_ODD_THRESHOLD = (SummonHandler:CalculateShinyChance(Player) * 10) * 3
				IsShiny = ROLLED_SHINY_ODD <= CURRENT_LUCK_ODD_THRESHOLD --Random.new():NextInteger(1,100*10) <= self:CalculateShinyChance(player)*10

				if IsShiny then
					PlayerProfileClass:WriteDirectory(
						"PlayerStatistics/SummonedShinies",
						statistics.SummonedShinies + 1,
						true
					)
				end
			end
		end

		if not IsShiny and table.find(autoSell, unitRegistry[v].configuration.Rarity) then
			local EventSummonable = unitRegistry[v].raw:FindFirstChild("EventSummonable")
			EventSummonable = EventSummonable and EventSummonable.Value
			local cost = gameFunctions:CalculateSellCost(unitRegistry[v].configuration.Rarity, 1, EventSummonable)
			_gold += cost
			table.insert(uuids, v)
			continue
		end

		local _UnitAdditionalData = IsShiny and { Shiny = true } or nil

		local uuid = unitManager:giveUnit(Player, v, 1, _UnitAdditionalData, true)
		table.insert(uuids, uuid[1])

		SummonHandler:Chat(Player, v, IsShiny)

		statUpdate(v)
	end

	if _gold > 0 then
		PlayerService:GiveCurrency(Player, "Gold", _gold, true)
	end

	PlayerProfileClass:WriteDirectory("PlayerStatistics/TotalSummons", statistics.TotalSummons + amount, true)

	if HasRareUnit then
		DataAPI:SaveProfile(Player)
	end

	uiCommunication:FireClient(Player, "Summon/DragonCapsuleCutscene", uuids)
end

function module:GivePool(Player, PoolName, GenerateOnly)
	--print('Giving pool!')

	--// Load the Pool
	if not CachedPools[PoolName] then
		CachedPools[PoolName] = require(ReplicatedStorage.Registry.Pools[PoolName])
	end

	local PoolTable = CachedPools[PoolName].Get()

	--// Convert to RNG Table
	local InfoTable = {}
	local RNGTable = {}
	local TotalChance = 0

	local SaveRandomRewards = {}

	for Type, TypeTable in PoolTable do
		if Type == "Guaranteed" then
			continue
		end
		for ItemName, ItemTable in TypeTable do
			if ItemTable.Rewards then
				SaveRandomRewards[ItemName] = {
					Rewards = ItemTable.Rewards,
					Type = Type,
				}
			end
			RNGTable[ItemName] = ItemTable.Chance
			TotalChance += ItemTable.Chance
			InfoTable[ItemName] = ItemTable
			InfoTable[ItemName].Type = Type
		end
	end

	--// If player gets nothing
	if TotalChance < 100 then
		RNGTable["Nothing"] = 100 - TotalChance
	end

	--// Choose Item
	local ItemChosen = RNG(RNGTable)

	if SaveRandomRewards[ItemChosen] then
		RNGTable = {}
		TotalChance = 0
		InfoTable = {}

		for ItemName, ItemTable in SaveRandomRewards[ItemChosen].Rewards do
			RNGTable[ItemName] = ItemTable.Chance
			TotalChance += ItemTable.Chance
			InfoTable[ItemName] = ItemTable
			InfoTable[ItemName].Type = SaveRandomRewards[ItemChosen].Type
		end

		ItemChosen = RNG(RNGTable)
		print(ItemChosen)
	end

	--// Clone Table
	local GuaranteedTable

	if PoolTable.Guaranteed then
		GuaranteedTable = self:CloneTable(PoolTable.Guaranteed)
	end

	--warn(ItemChosen)
	if ItemChosen == "Nothing" then
		warn("Returning", GuaranteedTable)
		return GuaranteedTable
	end

	--// Constants
	local ItemName = ItemChosen
	local ItemTable = InfoTable[ItemChosen]

	--// Cleanup
	table.clear(InfoTable)
	table.clear(RNGTable)
	InfoTable = nil
	RNGTable = nil

	--// Award Player
	--warn('Awarding',ItemName,ItemTable)

	local RewardTable = {
		[ItemTable.Type] = {
			[ItemName] = ItemTable.Quantity,
		},
	}

	if GuaranteedTable then
		Merge(RewardTable, GuaranteedTable)
	end
	--warn('RewardTable',RewardTable)
	if GenerateOnly then
		return RewardTable
	end

	--// Give & Remove Units
	if RewardTable.Units then
		self:GiveUnits(Player, RewardTable)
		RewardTable.Units = nil
	end

	RewardLibrary:RewardPlayer(Player, RewardTable)

	return RewardTable
end

function module:start() end

return module
