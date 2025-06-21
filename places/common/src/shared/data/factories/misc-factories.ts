// Simple factories for various data types

export interface TeamEventData {
	HasClaimed: boolean;
	Team: string;
}

export function createTeamEventData(): TeamEventData {
	return {
		HasClaimed: false,
		Team: "None",
	};
}

export interface AFKData {
	afkTime: number;
	lastAfkClaim: number;
}

export function createAFKData(): AFKData {
	return {
		afkTime: 0,
		lastAfkClaim: 0,
	};
}

export interface BingoData {
	completedCells: number[];
	currentCard: string;
}

export function createBingoData(): BingoData {
	return {
		completedCells: [],
		currentCard: "",
	};
}

export interface IndexData {
	lastUpdate: number;
	entries: Record<string, unknown>;
}

export function createIndexData(): IndexData {
	return {
		lastUpdate: 0,
		entries: {},
	};
}

export interface RedeemedCodes {
	codes: string[];
}

export function createRedeemedCodes(): string[] {
	return [];
}

export interface BlessingData {
	equipped: string[];
	unlocked: string[];
}

export function createBlessingData(): BlessingData {
	return {
		equipped: [],
		unlocked: [],
	};
}

export interface BundlesData {
	owned: string[];
}

export function createBundlesData(): BundlesData {
	return {
		owned: [],
	};
}

export interface ChallengeLockData {
	unlocked: string[];
}

export function createChallengeLockData(): ChallengeLockData {
	return {
		unlocked: [],
	};
}

export interface ClaimedLevelRewardsData {
	claimed: number[];
}

export function createClaimedLevelRewardsData(): ClaimedLevelRewardsData {
	return {
		claimed: [],
	};
}

export interface CollisionEventData {
	completed: string[];
}

export function createCollisionEventData(): CollisionEventData {
	return {
		completed: [],
	};
}

export interface DragonCapsuleData {
	orbs: number;
}

export function createDragonCapsuleData(): DragonCapsuleData {
	return {
		orbs: 0,
	};
}

export interface DungeonShopData {
	items: Record<string, number>;
}

export function createDungeonShopData(): DungeonShopData {
	return {
		items: {},
	};
}

export interface EffectsData {
	equipped: string[];
}

export function createEffectsData(): EffectsData {
	return {
		equipped: [],
	};
}

export interface EventShopData {
	items: Record<string, number>;
}

export function createEventShopData(): EventShopData {
	return {
		items: {},
	};
}

export interface LeaderboardData {
	season: number;
}

export function createLeaderboardData(): LeaderboardData {
	return {
		season: 0,
	};
}

export interface MerchantItemsBoughtData {
	items: Record<string, number>;
}

export function createMerchantItemsBoughtData(): MerchantItemsBoughtData {
	return {
		items: {},
	};
}

export interface NPCData {
	interacted: string[];
}

export function createNPCData(): NPCData {
	return {
		interacted: [],
	};
}

export interface NPCZonesData {
	zones: string[];
}

export function createNPCZonesData(): NPCZonesData {
	return {
		zones: [],
	};
}

export interface PatchData {
	seen: string[];
}

export function createPatchData(): PatchData {
	return {
		seen: [],
	};
}

export interface PoolData {
	pools: Record<string, number>;
}

export function createPoolData(): PoolData {
	return {
		pools: {},
	};
}

export interface QuestTableData {
	quests: Record<
		string,
		{
			completed: boolean;
			progress: number;
		}
	>;
}

export function createQuestTableData(): QuestTableData {
	return {
		quests: {},
	};
}

export interface RaidShopData {
	items: Record<string, number>;
}

export function createRaidShopData(): RaidShopData {
	return {
		items: {},
	};
}

export interface SummoningEventData {
	summoned: boolean;
}

export function createSummoningEventData(): SummoningEventData {
	return {
		summoned: false,
	};
}

export interface TeamsData {
	team: string;
}

export function createTeamsData(): TeamsData {
	return {
		team: "None",
	};
}

export interface TournamentsData {
	wins: number;
}

export function createTournamentsData(): TournamentsData {
	return {
		wins: 0,
	};
}

export interface TraitPity {
	pity: number;
}

export function createTraitPity(): TraitPity {
	return {
		pity: 0,
	};
}
