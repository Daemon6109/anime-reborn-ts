local migrations = require("@self/utils/migrations")

local CURRENT_DATA_VERSION = migrations.CurrentVersion

-- Import player-related modules
local createPlayerBasicData = require("./factories/player/playerbasicdata")
local createPlayerStatisticsData = require("./factories/player/playerstatisticsdata")
local createSlotbarData = require("./factories/player/slotbardata")

-- Import mission-related modules
local createHellTowerData = require("./factories/missions/helltowerdata")
local createMissionCompletionData = require("./factories/missions/missioncompletiondata")

-- Import economy-related modules
local createCurrencies = require("./factories/economy/currencies")
local createCurrencyExchangerData = require("./factories/economy/currencyexchangerdata")

-- Import event-related modules
local createAdventCalendarData = require("./factories/events/adventcalendardata")
local createBattlepassData = require("./factories/events/battlepassdata")
local createTeamEventData = require("./factories/events/teameventdata")

-- Import inventory-related modules
local createInventoryData = require("./factories/inventory/inventorydata")
local createSummoningData = require("./factories/inventory/summoningdata")

-- Import other modules
local createAFKData = require("./factories/afkdata")
local createBingoData = require("./factories/bingodata")
local createBlessing = require("./factories/blessing")
local createBundles = require("./factories/bundles")
local createChallengeLockData = require("./factories/challengelockdata")
local createClaimedLevelRewards = require("./factories/claimedlevelrewards")
local createCollisionEventData = require("./factories/collisioneventdata")
local createDailyRewardsData = require("./factories/dailyrewardsdata")
local createDragonCapsuleData = require("./factories/dragoncapsuledata")
local createDungeonShopData = require("./factories/dungeonshopdata")
local createEffects = require("./factories/effects")
local createEventShopData = require("./factories/eventshopdata")
local createIndexData = require("./factories/indexdata")
local createLeaderboardData = require("./factories/leaderboarddata")
local createMerchantItemsBoughtData = require("./factories/merchantitemsboughtdata")
local createNPCData = require("./factories/npcdata")
local createNPCZonesData = require("./factories/npczonesdata")
local createPatchData = require("./factories/patchdata")
local createPoolData = require("./factories/pooldata")
local createQuestTableData = require("./factories/questtabledata")
local createRaidShopData = require("./factories/raidshopdata")
local createReceiptHistoryData = require("./factories/receipthistorydata")
local createRedeemedCodes = require("./factories/redeemedcodes")
local createSettingsData = require("./factories/settingsdata")
local createSummoningEventData = require("./factories/summoningeventdata")
local createTeams = require("./factories/teams")
local createTournamentsData = require("./factories/tournamentsdata")
local createTraitPity = require("./factories/traitpity")

-- Create DataTemplate instance
local PlayerBasicData = createPlayerBasicData()
local DataTemplate = {
	-- Player basic info
	Level = PlayerBasicData.Level,
	XP = PlayerBasicData.XP,
	RobuxSpent = PlayerBasicData.RobuxSpent,
	CurrentTitle = PlayerBasicData.CurrentTitle,
	EquippedMount = PlayerBasicData.EquippedMount,
	SlotsApplicable = PlayerBasicData.SlotsApplicable,

	-- Player-related data
	PlayerStatistics = createPlayerStatisticsData(),
	Slotbar = createSlotbarData(),

	-- Mission-related data
	MissionCompletionData = createMissionCompletionData(),
	HellTowerData = createHellTowerData(),

	-- Economy-related data
	Currencies = createCurrencies(),
	CurrencyExchangerData = createCurrencyExchangerData(),

	-- Event-related data
	AdventCalendarData = createAdventCalendarData(),
	BattlepassData = createBattlepassData(),
	TeamEventData = createTeamEventData(),

	-- Inventory-related data
	Inventory = createInventoryData(),
	SummoningData = createSummoningData(),

	-- Other data sections
	AFKData = createAFKData(),
	BingoData = createBingoData(),
	Blessing = createBlessing(),
	Bundles = createBundles(),
	ChallengeLockData = createChallengeLockData(),
	ClaimedLevelRewards = createClaimedLevelRewards(),
	CollisionEventData = createCollisionEventData(),
	DailyRewardsData = createDailyRewardsData(),
	DragonCapsuleData = createDragonCapsuleData(),
	Effects = createEffects(),
	EventShopData = createEventShopData(),
	IndexData = createIndexData(),
	LeaderboardData = createLeaderboardData(),
	MerchantItemsBought = createMerchantItemsBoughtData(),
	NPCData = createNPCData(),
	NPCZonesData = createNPCZonesData(),
	PatchData = createPatchData(),
	PoolData = createPoolData(),
	Quests = createQuestTableData(),
	RaidShopData = createRaidShopData(),
	DungeonShopData = createDungeonShopData(),
	RedeemedCodes = createRedeemedCodes(),
	ReceiptHistory = createReceiptHistoryData(),
	Settings = createSettingsData(),
	SummoningEventData = createSummoningEventData(),
	Teams = createTeams(),
	TournamentsData = createTournamentsData(),
	TraitPity = createTraitPity(),

	Easter2025Score = PlayerBasicData.Easter2025Score,
	WinsWithSpeed = PlayerBasicData.WinsWithSpeed,
	_version = CURRENT_DATA_VERSION,
}

-- Freeze the template to prevent accidental modification
table.freeze(DataTemplate)

return DataTemplate
