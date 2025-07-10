// Complete data template with all factory imports
import { migrations } from "../utils/migrations.util";

// Import player-related factories
import { PlayerBasicData, createPlayerBasicData } from "./factories/player/player-basic-data";
import { PlayerStatisticsData, createPlayerStatisticsData } from "./factories/player/player-statistics-data";
import { SlotbarData, createSlotbarData } from "./factories/player/slotbar-data";

// Import economy-related factories
import { Currencies, createCurrencies } from "./factories/economy/currencies";
import { CurrencyExchangerData, createCurrencyExchangerData } from "./factories/economy/currency-exchanger-data";

// Import inventory-related factories
import { InventoryData, createInventoryData } from "./factories/inventory/inventory-data";
import { SummoningData, createSummoningData } from "./factories/inventory/summoning-data";

// Import event-related factories
import { BattlepassData, createBattlepassData } from "./factories/events/battlepass-data";
import { AdventCalendarData, createAdventCalendarData } from "./factories/events/advent-calendar-data";

// Import other factories
import { DailyRewardsData, createDailyRewardsData } from "./factories/daily-rewards-data";
import { SettingsData, createSettingsData } from "./factories/settings-data";
import { createReceiptHistoryData } from "./factories/receipt-history-data";
import { MissionCompletionData, createMissionCompletionData } from "./factories/missions/mission-completion-data";
import {
	TeamEventData,
	createTeamEventData,
	AFKData,
	createAFKData,
	BingoData,
	createBingoData,
	IndexData,
	createIndexData,
	createRedeemedCodes,
	BlessingData,
	createBlessingData,
	BundlesData,
	createBundlesData,
	ChallengeLockData,
	createChallengeLockData,
	ClaimedLevelRewardsData,
	createClaimedLevelRewardsData,
	CollisionEventData,
	createCollisionEventData,
	DragonCapsuleData,
	createDragonCapsuleData,
	DungeonShopData,
	createDungeonShopData,
	EffectsData,
	createEffectsData,
	EventShopData,
	createEventShopData,
	LeaderboardData,
	createLeaderboardData,
	MerchantItemsBoughtData,
	createMerchantItemsBoughtData,
	NPCData,
	createNPCData,
	NPCZonesData,
	createNPCZonesData,
	PatchData,
	createPatchData,
	PoolData,
	createPoolData,
	QuestTableData,
	createQuestTableData,
	RaidShopData,
	createRaidShopData,
	SummoningEventData,
	createSummoningEventData,
	TeamsData,
	createTeamsData,
	TournamentsData,
	createTournamentsData,
	TraitPity,
	createTraitPity,
} from "./factories/misc-factories";
import { HellTowerData, createHellTowerData } from "./factories/missions/hell-tower-data";

// Re-export key types for external use
export { PlayerBasicData, PlayerStatisticsData, SlotbarData };
export { Currencies, CurrencyExchangerData };
export { InventoryData, SummoningData };
export { BattlepassData, AdventCalendarData };
export { DailyRewardsData, SettingsData };
export { MissionCompletionData, HellTowerData };
export {
	TeamEventData,
	AFKData,
	BingoData,
	IndexData,
	BlessingData,
	BundlesData,
	ChallengeLockData,
	ClaimedLevelRewardsData,
	CollisionEventData,
	DragonCapsuleData,
	DungeonShopData,
	EffectsData,
	EventShopData,
	LeaderboardData,
	MerchantItemsBoughtData,
	NPCData,
	NPCZonesData,
	PatchData,
	PoolData,
	QuestTableData,
	RaidShopData,
	SummoningEventData,
	TeamsData,
	TournamentsData,
	TraitPity,
};

// Main data template interface
export interface DataTemplate extends PlayerBasicData {
	// Player-related data
	PlayerStatistics: PlayerStatisticsData;
	Slotbar: SlotbarData;

	// Mission-related data
	MissionCompletionData: MissionCompletionData;
	HellTowerData: HellTowerData;

	// Economy-related data
	Currencies: Currencies;
	CurrencyExchangerData: CurrencyExchangerData;

	// Event-related data
	AdventCalendarData: AdventCalendarData;
	BattlepassData: BattlepassData;
	TeamEventData: TeamEventData;

	// Inventory-related data
	Inventory: InventoryData;
	SummoningData: SummoningData;

	// Other data sections
	AFKData: AFKData;
	BingoData: BingoData;
	Blessing: BlessingData;
	Bundles: BundlesData;
	ChallengeLockData: ChallengeLockData;
	ClaimedLevelRewards: ClaimedLevelRewardsData;
	CollisionEventData: CollisionEventData;
	DailyRewardsData: DailyRewardsData;
	DragonCapsuleData: DragonCapsuleData;
	DungeonShopData: DungeonShopData;
	Effects: EffectsData;
	EventShopData: EventShopData;
	IndexData: IndexData;
	LeaderboardData: LeaderboardData;
	MerchantItemsBought: MerchantItemsBoughtData;
	NPCData: NPCData;
	NPCZonesData: NPCZonesData;
	PatchData: PatchData;
	PoolData: PoolData;
	Quests: QuestTableData;
	RaidShopData: RaidShopData;
	ReceiptHistory: string[];
	RedeemedCodes: string[];
	Settings: SettingsData;
	SummoningEventData: SummoningEventData;
	Teams: TeamsData;
	TournamentsData: TournamentsData;
	TraitPity: TraitPity;

	// Version for migrations
	_version: number;

	// Index signature for additional properties
	[key: string]: unknown;
}

// Create the actual data template instance
const playerBasicData = createPlayerBasicData();

export const DATA_TEMPLATE: DataTemplate = {
	// Player basic info (spread from PlayerBasicData)
	...playerBasicData,

	// Player-related data
	PlayerStatistics: createPlayerStatisticsData(),
	Slotbar: createSlotbarData(),

	// Mission-related data
	MissionCompletionData: createMissionCompletionData(),
	HellTowerData: createHellTowerData(),

	// Economy-related data
	Currencies: createCurrencies(),
	CurrencyExchangerData: createCurrencyExchangerData(),

	// Event-related data
	AdventCalendarData: createAdventCalendarData(),
	BattlepassData: createBattlepassData(),
	TeamEventData: createTeamEventData(),

	// Inventory-related data
	Inventory: createInventoryData(),
	SummoningData: createSummoningData(),

	// Other data sections
	AFKData: createAFKData(),
	BingoData: createBingoData(),
	Blessing: createBlessingData(),
	Bundles: createBundlesData(),
	ChallengeLockData: createChallengeLockData(),
	ClaimedLevelRewards: createClaimedLevelRewardsData(),
	CollisionEventData: createCollisionEventData(),
	DailyRewardsData: createDailyRewardsData(),
	DragonCapsuleData: createDragonCapsuleData(),
	DungeonShopData: createDungeonShopData(),
	Effects: createEffectsData(),
	EventShopData: createEventShopData(),
	IndexData: createIndexData(),
	LeaderboardData: createLeaderboardData(),
	MerchantItemsBought: createMerchantItemsBoughtData(),
	NPCData: createNPCData(),
	NPCZonesData: createNPCZonesData(),
	PatchData: createPatchData(),
	PoolData: createPoolData(),
	Quests: createQuestTableData(),
	RaidShopData: createRaidShopData(),
	ReceiptHistory: createReceiptHistoryData(),
	RedeemedCodes: createRedeemedCodes(),
	Settings: createSettingsData(),
	SummoningEventData: createSummoningEventData(),
	Teams: createTeamsData(),
	TournamentsData: createTournamentsData(),
	TraitPity: createTraitPity(),

	// Version for migrations
	_version: migrations.CurrentVersion,
};

// Freeze the template to prevent accidental modification
// Note: TypeScript doesn't have Object.freeze, so we'll document this as immutable
