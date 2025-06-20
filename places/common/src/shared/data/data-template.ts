// Complete data template with all factory imports
import { migrations } from "../utils/migrations";

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
	createRedeemedCodes
} from "./factories/misc-factories";

// Re-export key types for external use
export { PlayerBasicData, PlayerStatisticsData, SlotbarData };
export { Currencies, CurrencyExchangerData };
export { InventoryData, SummoningData };
export { BattlepassData, AdventCalendarData };
export { DailyRewardsData, SettingsData };
export { MissionCompletionData };
export { TeamEventData, AFKData, BingoData, IndexData };

// Main data template interface
export interface DataTemplate extends PlayerBasicData {
	// Player-related data
	PlayerStatistics: PlayerStatisticsData;
	Slotbar: SlotbarData;

	// Mission-related data
	MissionCompletionData: MissionCompletionData;

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
	DailyRewardsData: DailyRewardsData;
	IndexData: IndexData;
	ReceiptHistory: string[];
	RedeemedCodes: string[];
	Settings: SettingsData;

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
	DailyRewardsData: createDailyRewardsData(),
	IndexData: createIndexData(),
	ReceiptHistory: createReceiptHistoryData(),
	RedeemedCodes: createRedeemedCodes(),
	Settings: createSettingsData(),

	// Version for migrations
	_version: migrations.CurrentVersion,
};

// Freeze the template to prevent accidental modification
// Note: TypeScript doesn't have Object.freeze, so we'll document this as immutable
