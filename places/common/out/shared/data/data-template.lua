-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- Complete data template with all factory imports
local migrations = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "utils", "migrations").migrations
-- Import player-related factories
local createPlayerBasicData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "player", "player-basic-data").createPlayerBasicData
local createPlayerStatisticsData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "player", "player-statistics-data").createPlayerStatisticsData
local createSlotbarData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "player", "slotbar-data").createSlotbarData
-- Import economy-related factories
local createCurrencies = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "economy", "currencies").createCurrencies
local createCurrencyExchangerData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "economy", "currency-exchanger-data").createCurrencyExchangerData
-- Import inventory-related factories
local createInventoryData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "inventory", "inventory-data").createInventoryData
local createSummoningData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "inventory", "summoning-data").createSummoningData
-- Import event-related factories
local createBattlepassData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "events", "battlepass-data").createBattlepassData
local createAdventCalendarData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "events", "advent-calendar-data").createAdventCalendarData
-- Import other factories
local createDailyRewardsData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "daily-rewards-data").createDailyRewardsData
local createSettingsData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "settings-data").createSettingsData
local createReceiptHistoryData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "receipt-history-data").createReceiptHistoryData
local createMissionCompletionData = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "missions", "mission-completion-data").createMissionCompletionData
local _misc_factories = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "misc-factories")
local createTeamEventData = _misc_factories.createTeamEventData
local createAFKData = _misc_factories.createAFKData
local createBingoData = _misc_factories.createBingoData
local createIndexData = _misc_factories.createIndexData
local createRedeemedCodes = _misc_factories.createRedeemedCodes
-- Re-export key types for external use
-- Main data template interface
-- Create the actual data template instance
local playerBasicData = createPlayerBasicData()
local _object = table.clone(playerBasicData)
setmetatable(_object, nil)
_object.PlayerStatistics = createPlayerStatisticsData()
_object.Slotbar = createSlotbarData()
_object.MissionCompletionData = createMissionCompletionData()
_object.Currencies = createCurrencies()
_object.CurrencyExchangerData = createCurrencyExchangerData()
_object.AdventCalendarData = createAdventCalendarData()
_object.BattlepassData = createBattlepassData()
_object.TeamEventData = createTeamEventData()
_object.Inventory = createInventoryData()
_object.SummoningData = createSummoningData()
_object.AFKData = createAFKData()
_object.BingoData = createBingoData()
_object.DailyRewardsData = createDailyRewardsData()
_object.IndexData = createIndexData()
_object.ReceiptHistory = createReceiptHistoryData()
_object.RedeemedCodes = createRedeemedCodes()
_object.Settings = createSettingsData()
_object._version = migrations.CurrentVersion
local DATA_TEMPLATE = _object
return {
	DATA_TEMPLATE = DATA_TEMPLATE,
}
