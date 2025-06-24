// places/common/src/shared/constants/maps-constants.ts

export interface EnemySpawnData {
    EnemyName: string;
    EnemyCount: number;
    PerEnemySpawnDelay: number;
    AsyncSpawn: boolean;
}

export interface EnemyPack {
    Enemies: EnemySpawnData[];
    AfterPackSpawnedDelay: number;
}

export interface WaveData {
    EnemyPacks: EnemyPack[];
    AfterWaveEndedDelay: number;
    Notification?: string;
    IsBoss?: boolean;
    IsLastWave?: boolean;
}

export interface CurrencyRewards {
    Gold?: number;
    Gems?: number;
    [currencyKey: string]: number | undefined; // For other potential currencies
}

export interface ItemRewards {
    [itemName: string]: number;
}

export interface UnitRewards {
    [unitName: string]: number; // Or perhaps unit IDs
}

export interface RewardSet {
    Currencies: CurrencyRewards;
    Items: ItemRewards;
    Units: UnitRewards;
}

export interface Rewards {
    Set: RewardSet;
    FirstClear: RewardSet;
    Random: RewardSet; // Assuming structure similar to RewardSet, might need adjustment
}

export interface StarMission {
    Name: string; // e.g., "BeatStage", "WaveLimitedTime"
    Data: { [key: string]: any }; // Flexible data based on mission name
}

// Using a Record for numbered stars
export type StarRewardsData = Record<number, RewardSet>;
export type StarMissionsData = Record<number, StarMission>;

export interface MapStageData {
    // Identifier for this specific stage, e.g., "Ant_Cave_Story_1"
    id: string;
    // Display name for this stage, e.g., "Ant Cave - Story 1"
    displayName: string;
    mapId: string; // Identifier for the parent map, e.g., "Ant_Cave"
    mode: string; // e.g., "Story", "Challenge", "Infinite"
    difficultyLevel?: number | string; // e.g., 1 or "Easy"

    WaveCount: number;
    Boss?: string; // Enemy name or ID for the boss
    EnemyPool: Record<string, string>; // Maps internal enemy names to actual enemy IDs/names

    ItemPool?: Record<string, any>; // Define more strictly if structure is known
    UnitPool?: Record<string, any>; // Define more strictly if structure is known
    RandomCurrencyPool?: Record<string, any>; // Define more strictly if structure is known

    Rewards: Rewards;
    Star_Rewards: StarRewardsData;
    Star_Missions: StarMissionsData;
    Star_Missions_Nightmare?: StarMissionsData; // Optional nightmare missions

    UnitXPReward: { min: number; max: number }; // Assuming NumberRange.new(min,max) means a min/max range

    Waves: Record<number, WaveData>; // Wave number to WaveData
}

// This will hold all map stage configurations
export const MAP_STAGES_DATA: Record<string, MapStageData> = {
    "Ant_Cave_Story_1": {
        id: "Ant_Cave_Story_1",
        displayName: "Ant Cave - Story 1",
        mapId: "Ant_Cave",
        mode: "Story",
        difficultyLevel: 1,
        WaveCount: 15,
        Boss: "Ant Cave [1]",
        EnemyPool: {
            "Flying Angel": "Ant Cave [Aerial]",
            "Shielder Angel": "Ant Cave [Basic]",
            "Angel": "Ant Cave [Basic]",
            "Guardian Angel": "Ant Cave [Basic]",
            "Speedster Angel": "Ant Cave [Basic]",
            "Explosive Angel": "Ant Cave [Basic]",
        },
        ItemPool: {},
        UnitPool: {},
        RandomCurrencyPool: {},
        Rewards: {
            Set: {
                Currencies: { Gold: 100 /*placeholder for Constants.BASE_GOLD_REWARD*/, Gems: 5 /*placeholder for Constants.BASE_GEM_REWARD*/ },
                Items: {},
                Units: {},
            },
            FirstClear: {
                Currencies: { Gold: 200 /*placeholder for Constants.FIRST_CLEAR_BONUS_GOLD*/, Gems: 10 /*placeholder for Constants.FIRST_CLEAR_BONUS_GEMS*/ },
                Items: {},
                Units: {},
            },
            Random: {
                Currencies: {},
                Items: {},
                Units: {},
            },
        },
        Star_Rewards: {
            1: { Currencies: { Gems: 60 }, Items: {}, Units: {} },
            2: { Currencies: { Gems: 60 }, Items: {}, Units: {} },
            3: { Currencies: {}, Items: { "TraitCrystal": 1 }, Units: {} },
        },
        Star_Missions: {
            1: { Name: "BeatStage", Data: {} },
            2: { Name: "WaveLimitedTime", Data: { Wave: 13, Time: 35 } },
            3: { Name: "HaveBaseHP", Data: { HP: 0.85 } },
        },
        Star_Missions_Nightmare: {
            1: { Name: "BeatStage", Data: {} },
            2: { Name: "WaveLimitedTime", Data: { Wave: 13, Time: 25 } },
            3: { Name: "HaveBaseHP", Data: { HP: 0.95 } },
        },
        UnitXPReward: { min: 500, max: 5000 },
        Waves: {
            1: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 0 }],
                AfterWaveEndedDelay: 3,
            },
            2: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 2, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 0 }],
                AfterWaveEndedDelay: 3,
            },
            3: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 6, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 3, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 0 }],
                Notification: "Speedsters incoming!",
                AfterWaveEndedDelay: 3,
            },
            4: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 8, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 3, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 3, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 0 }],
                AfterWaveEndedDelay: 3,
            },
            5: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 8, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 4, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                AfterWaveEndedDelay: 3,
            },
            6: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 10, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 4, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                AfterWaveEndedDelay: 3,
            },
            7: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 10, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                Notification: "Be careful! Shielders incoming!",
                AfterWaveEndedDelay: 3,
            },
            8: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 10, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 4, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 4, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                AfterWaveEndedDelay: 3,
            },
            9: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 10, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 6, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                Notification: "Be careful! Guardians incoming!",
                AfterWaveEndedDelay: 3,
            },
            10: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 10, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 7, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                AfterWaveEndedDelay: 3,
            },
            11: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 8, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                AfterWaveEndedDelay: 3,
            },
            12: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 10, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 3, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                AfterWaveEndedDelay: 3,
            },
            13: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 10, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 6, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                AfterWaveEndedDelay: 3,
            },
            14: {
                EnemyPacks: [{ Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 12, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 10, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 }],
                AfterWaveEndedDelay: 3,
            },
            15: {
                EnemyPacks: [
                    { Enemies: [{ EnemyName: "Ant Cave [Basic]", EnemyCount: 10, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Basic]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }, { EnemyName: "Ant Cave [Aerial]", EnemyCount: 5, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 1.5 },
                    { Enemies: [{ EnemyName: "Ant Cave [1]", EnemyCount: 1, PerEnemySpawnDelay: 0.7, AsyncSpawn: false }], AfterPackSpawnedDelay: 0 }
                ],
                IsBoss: true,
                IsLastWave: true,
                AfterWaveEndedDelay: 3,
            },
        },
    }
    // More map stages will be added here
};

// Potentially a simpler structure for overall Map information (like from Maps.luau or directory init.luau)
export interface MapGroupInfo {
    id: string; // e.g., "Ant_Cave", matches mapId in MapStageData
    name: string; // e.g., "Ant Cave"
    iconAssetId?: string;
    placeId?: number | string;
    order?: number; // from MapOrder/Info.luau
    // Could also include a list of stage IDs that belong to this group, if not inferred otherwise
    // stages: string[];
}

export const MAP_GROUP_INFO_DATA: Record<string, MapGroupInfo> = {
    // Example:
    // "Ant_Cave": { id: "Ant_Cave", name: "Ant Cave", order: 8, iconAssetId: "rbxassetid://...", placeId: "...", stages: ["Ant_Cave_Story_1", ...] }
};
