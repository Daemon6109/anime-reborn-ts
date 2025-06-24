/**
 * Units Registry Data - Migrated from live game
 * Contains all unit configurations, stats, and abilities
 *
 * Note: This is a massive registry with 271+ units. This file contains the core
 * type definitions and units being migrated progressively in batches.
 */

// Core enums based on the live game's system
export type UnitRarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythical" | "Secret" | "Divine" | "Exclusive";
export type UnitElement = "Fire" | "Ice" | "Light" | "Dark" | "Earth" | "Water" | "Air" | "Wind" | "None" | "Fierce";
export type UnitType = "Ground" | "Air" | "Hybrid" | "Farm";
export type PlacementType = "Ground" | "Air" | "Water";
export type AttackType = "Single" | "Full" | "Line" | "Splash" | "AOE" | "Circle" | "Cone" | "Closest" | "Passive";

export interface UnitUpgradeInfo {
	readonly Damage?: number;
	readonly AttackSpeed?: number;
	readonly Range?: number;
	readonly UpgradePrice: number;
	readonly AttackType?: AttackType;
	readonly Ability?: string;
	readonly SpecialAbility?: string;
	readonly AttackSize?: number;
	readonly Money?: number;
	readonly PlacementPrice?: number;
}

export interface UnitEvolveRequirements {
	readonly Items?: Record<string, number>;
	readonly Units?: Record<string, number>;
}

export interface UnitEvolveData {
	readonly Requirements: UnitEvolveRequirements;
	readonly DisplayBuffs: readonly string[];
	readonly TransferStats?: boolean;
	readonly EvolvesInto: string;
}

export interface UnitConfiguration {
	// Visual/UI Configuration
	readonly Viewport: CFrame;
	readonly PreviewViewport: CFrame;
	readonly UnitCardViewport: CFrame;
	readonly CameraOffset?: CFrame;
	readonly CameraZoom?: number;

	// Basic Info
	readonly TrueName: string;
	readonly DisplayName: string;
	readonly Rarity: UnitRarity;

	// Type and Placement
	readonly PlacementType: PlacementType;
	readonly Element: UnitElement;
	readonly UnitType: UnitType;
	readonly MaxPlacementAmount: number;

	// Economy
	readonly PlacementPrice: number;
	readonly SellCost: number;
	readonly CanSell: boolean;
	readonly MaxUpgrades: number;

	// Combat Stats
	readonly Damage: number;
	readonly AttackSpeed: number;
	readonly Range: number;
	readonly AttackType: AttackType;
	readonly AttackSize: number;
	readonly Money?: number; // For farming units

	// Abilities and Effects
	readonly Ability?: string;
	readonly SpecialAbility?: string;
	readonly SpecialAbilityCooldown?: number;
	readonly IsSpecialAbilityGlobalCooldown?: boolean;
	readonly Passives: readonly string[];
	readonly AttackEffect?: string;
	readonly AttackEffectDuration?: number;

	// Critical Hit
	readonly AttackCriticalChance: number;
	readonly AttackCriticalDamage: number;

	// Evolution System
	readonly EvolveData?: readonly UnitEvolveData[];

	// Map Affinity (for evolved units)
	readonly MapAffnity?: string;
	readonly GameTypeAffinity?: readonly string[];
	readonly MapAffnityBoosts?: {
		readonly PermanentDamageMulti?: number;
		readonly PermanentRangeMulti?: number;
		readonly PermanentSpeedMulti?: number;
	};

	// Upgrade Information
	readonly UpgradesInfo: Record<number, UnitUpgradeInfo>;
}

export interface UnitAnimations {
	readonly idle: string;
	readonly walk: string;
	readonly attack?: string;
	readonly special?: string;
}

export interface UnitData {
	readonly configuration: UnitConfiguration;
	readonly animations: UnitAnimations;
	readonly radius: number;
	readonly tradable: boolean;
	readonly evolved?: string; // For evolution units, references base unit
}

/**
 * Units Registry - All units from live game (271 units total)
 * Systematically migrated from Registry.Units
 * Current Progress: A-Units Complete (15 units migrated: Aira, Aira [Evo], Aizen, Aizen [Evo],
 * Akame, Akame [Evo], Android 18, Android 21, Android 21 [Demon], Aokiji, Aokiji [Evo],
 * Aqua, Arlong, Asta, Asta [Evo])
 */
export const UnitsRegistry: Record<string, UnitData> = {
	// === A-UNITS BATCH 1 ===

	Aira: {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			CameraOffset: new CFrame(0.35, 0.15, 0.05),
			CameraZoom: 65,
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Aira",
			DisplayName: "Airo",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Light",
			UnitType: "Ground",
			MapAffnity: "Ghost Tunnel",
			GameTypeAffinity: ["Portal"],
			MapAffnityBoosts: {
				PermanentDamageMulti: 0.1,
			},
			PlacementPrice: 1455,
			CanSell: true,
			Passives: ["Power Roll"],
			Damage: 400,
			AttackSpeed: 6,
			Range: 17,
			Ability: "Acrobatic Kicks",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Line",
			AttackSize: 13,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							AcrobaticMask: 1,
							RedStar: 4,
							PurpleStar: 4,
						},
					},
					DisplayBuffs: ["+25% Damage", "+1 New Move: Acrobatic Twirls", "+1 Passive Upgrade: Power Roll II"],
					TransferStats: true,
					EvolvesInto: "Aira [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 577, AttackSpeed: 6, Range: 19, UpgradePrice: 2500 },
				2: { Damage: 740, AttackSpeed: 6, Range: 20, UpgradePrice: 3700 },
				3: { Damage: 985, AttackSpeed: 6, Range: 22, UpgradePrice: 5000 },
				4: {
					Damage: 1400,
					AttackSpeed: 5.5,
					Range: 25,
					UpgradePrice: 6450,
					AttackType: "Circle",
					Ability: "Ballerina Swish",
					AttackSize: 10,
				},
				5: { Damage: 1620, AttackSpeed: 5.5, Range: 27, UpgradePrice: 7500 },
				6: { Damage: 1822, AttackSpeed: 5.5, Range: 27, UpgradePrice: 8670 },
				7: { Damage: 2100, AttackSpeed: 5.5, Range: 28, UpgradePrice: 9888 },
				8: { Damage: 2475, AttackSpeed: 5.5, Range: 28, UpgradePrice: 11100 },
			},
		},
		animations: { idle: "92067478307647", walk: "17264216432" },
		radius: 2.5,
		tradable: false,
	},

	"Aira [Evo]": {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.2, 0.3, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			CameraOffset: new CFrame(0.35, 0.15, 0.05),
			CameraZoom: 65,
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Aira [Evo]",
			DisplayName: "Airo [Awoken]",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Light",
			UnitType: "Ground",
			MapAffnity: "Ghost Tunnel",
			GameTypeAffinity: ["Portal"],
			MapAffnityBoosts: {
				PermanentDamageMulti: 0.1,
			},
			PlacementPrice: 1455,
			CanSell: true,
			Passives: ["Power Roll II"],
			Damage: 500,
			AttackSpeed: 6,
			Range: 17,
			Ability: "Acrobatic Kicks",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Line",
			AttackSize: 13,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 721, AttackSpeed: 6, Range: 19, UpgradePrice: 2500 },
				2: { Damage: 925, AttackSpeed: 6, Range: 20, UpgradePrice: 3700 },
				3: { Damage: 1231, AttackSpeed: 6, Range: 22, UpgradePrice: 5000 },
				4: {
					Damage: 1750,
					AttackSpeed: 5.5,
					Range: 25,
					UpgradePrice: 6450,
					AttackType: "Circle",
					Ability: "Ballerina Swish",
					AttackSize: 10,
				},
				5: { Damage: 2025, AttackSpeed: 5.5, Range: 27, UpgradePrice: 7500 },
				6: { Damage: 2277, AttackSpeed: 5.5, Range: 27, UpgradePrice: 8670 },
				7: { Damage: 2625, AttackSpeed: 5.5, Range: 28, UpgradePrice: 9888 },
				8: {
					Damage: 3093,
					AttackSpeed: 5.5,
					Range: 28,
					UpgradePrice: 11100,
					AttackType: "Circle",
					Ability: "Acrobatic Twirls",
					AttackSize: 14,
				},
				9: { Damage: 3285, AttackSpeed: 5.5, Range: 30, UpgradePrice: 13870 },
			},
		},
		animations: { idle: "92067478307647", walk: "17264216432" },
		radius: 2.5,
		tradable: false,
		evolved: "Aira",
	},

	Aizen: {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 2,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Aizen",
			DisplayName: "Aizon",
			Rarity: "Secret",
			PlacementType: "Ground",
			Element: "Wind",
			UnitType: "Ground",
			PlacementPrice: 2100,
			CanSell: true,
			Passives: ["Two Steps Ahead"],
			Damage: 595,
			AttackSpeed: 6,
			Range: 18,
			Ability: "Soul Blast",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 13,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							Hogyoku: 1,
						},
					},
					DisplayBuffs: ["+20% Damage", "+1 New Special Ability: Breakdown Sphere"],
					TransferStats: true,
					EvolvesInto: "Aizen [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 715, AttackSpeed: 6, Range: 20, UpgradePrice: 3500 },
				2: { Damage: 900, AttackSpeed: 6, Range: 22, UpgradePrice: 4200 },
				3: { Damage: 1060, AttackSpeed: 6, Range: 23, UpgradePrice: 5350 },
				4: {
					Damage: 1245,
					AttackSpeed: 6,
					Range: 24,
					UpgradePrice: 6800,
					AttackType: "Circle",
					Ability: "Hado #90",
					AttackSize: 10,
				},
				5: { Damage: 1575, AttackSpeed: 6, Range: 27, UpgradePrice: 8000 },
				6: { Damage: 1800, AttackSpeed: 6, Range: 27, UpgradePrice: 9500 },
				7: { Damage: 2110, AttackSpeed: 6, Range: 28, UpgradePrice: 10888 },
				8: {
					Damage: 2675,
					AttackSpeed: 7,
					Range: 28,
					UpgradePrice: 12222,
					AttackType: "Full",
					Ability: "Spiritual Pressure",
					AttackSize: 18,
				},
			},
		},
		animations: { idle: "17893593497", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	"Aizen [Evo]": {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 2,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Aizen [Evo]",
			DisplayName: "Aizon [Butterfly]",
			Rarity: "Secret",
			PlacementType: "Ground",
			Element: "Wind",
			UnitType: "Hybrid",
			PlacementPrice: 2100,
			CanSell: true,
			Passives: ["Two Steps Ahead"],
			Damage: 743.75,
			AttackSpeed: 6,
			Range: 18,
			Ability: "Soul Blast",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 13,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 893.75, AttackSpeed: 6, Range: 20, UpgradePrice: 3500 },
				2: { Damage: 1125, AttackSpeed: 6, Range: 22, UpgradePrice: 4200 },
				3: { Damage: 1325, AttackSpeed: 6, Range: 23, UpgradePrice: 5350 },
				4: {
					Damage: 1556.25,
					AttackSpeed: 6,
					Range: 24,
					UpgradePrice: 6800,
					AttackType: "Circle",
					Ability: "Hado #90",
					AttackSize: 10,
				},
				5: { Damage: 1968.75, AttackSpeed: 6, Range: 27, UpgradePrice: 8000 },
				6: { Damage: 2250, AttackSpeed: 6, Range: 27, UpgradePrice: 9500 },
				7: { Damage: 2637.5, AttackSpeed: 6, Range: 28, UpgradePrice: 10888 },
				8: {
					Damage: 3343.75,
					AttackSpeed: 6,
					Range: 28,
					UpgradePrice: 12222,
					AttackType: "Full",
					Ability: "Spiritual Pressure",
					AttackSize: 18,
				},
				9: {
					Damage: 4070,
					AttackSpeed: 6,
					Range: 28,
					UpgradePrice: 17600,
					SpecialAbility: "Breakdown Sphere",
				},
			},
		},
		animations: { idle: "115626504370471", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
		evolved: "Aizen",
	},

	Akame: {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Akame",
			DisplayName: "Akume",
			Rarity: "Exclusive",
			PlacementType: "Ground",
			Element: "Fierce",
			UnitType: "Ground",
			PlacementPrice: 1000,
			CanSell: true,
			Passives: ["Poison Sword"],
			Damage: 400,
			AttackSpeed: 6,
			Range: 18,
			Ability: "Eliminate",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 6,
			AttackEffect: "Poison",
			AttackEffectDuration: 25,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							AkaBrace: 1,
						},
					},
					DisplayBuffs: ["+20% Damage", "+1 New Ability: Ennoodzuno"],
					TransferStats: true,
					EvolvesInto: "Akame [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 620, AttackSpeed: 5.5, Range: 19, UpgradePrice: 2200 },
				2: { Damage: 825, AttackSpeed: 5.5, Range: 22, UpgradePrice: 3000 },
				3: { Damage: 988, AttackSpeed: 5.5, Range: 23, UpgradePrice: 4500 },
				4: {
					Damage: 1150,
					AttackSpeed: 5.5,
					Range: 24,
					UpgradePrice: 5300,
					AttackType: "Line",
					AttackSize: 9,
					Ability: "Murasame",
				},
				5: { Damage: 1366, AttackSpeed: 5.5, Range: 25, UpgradePrice: 6500 },
				6: { Damage: 1555, AttackSpeed: 5, Range: 27, UpgradePrice: 7800 },
				7: { Damage: 1900, AttackSpeed: 5, Range: 29, UpgradePrice: 9100 },
			},
		},
		animations: { idle: "134388099837123", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	"Akame [Evo]": {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Akame [Evo]",
			DisplayName: "Akume",
			Rarity: "Exclusive",
			PlacementType: "Ground",
			Element: "Fierce",
			UnitType: "Ground",
			PlacementPrice: 1000,
			CanSell: true,
			Passives: ["Poison Sword"],
			Damage: 500,
			AttackSpeed: 6,
			Range: 18,
			Ability: "Eliminate",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 6,
			AttackEffect: "Poison",
			AttackEffectDuration: 25,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 775, AttackSpeed: 5.5, Range: 19, UpgradePrice: 2200 },
				2: { Damage: 1031, AttackSpeed: 5.5, Range: 22, UpgradePrice: 3000 },
				3: { Damage: 1235, AttackSpeed: 5.5, Range: 23, UpgradePrice: 4500 },
				4: {
					Damage: 1437,
					AttackSpeed: 5.5,
					Range: 24,
					UpgradePrice: 5300,
					AttackType: "Line",
					AttackSize: 9,
					Ability: "Murasame",
				},
				5: { Damage: 1707, AttackSpeed: 5.5, Range: 25, UpgradePrice: 6500 },
				6: { Damage: 1943, AttackSpeed: 5, Range: 27, UpgradePrice: 7800 },
				7: { Damage: 2375, AttackSpeed: 5, Range: 29, UpgradePrice: 9100 },
				8: {
					Damage: 2600,
					AttackSpeed: 5,
					Range: 29,
					UpgradePrice: 10700,
					SpecialAbility: "Ennoodzuno",
				},
			},
		},
		animations: { idle: "134388099837123", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
		evolved: "Akame",
	},

	"Android 18": {
		configuration: {
			Viewport: new CFrame(0, 0.4, -1.4).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 4,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Android 18",
			DisplayName: "Droid 18",
			Rarity: "Legendary",
			PlacementType: "Air",
			Element: "Light",
			UnitType: "Air",
			PlacementPrice: 500,
			CanSell: true,
			Passives: ["Finishing Blow"],
			Damage: 70,
			AttackSpeed: 5,
			Range: 20,
			Ability: "Energy Release Wave",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 6,
			AttackEffect: "",
			AttackEffectDuration: 6,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 85, AttackSpeed: 5, Range: 22, UpgradePrice: 1100 },
				2: { Damage: 105, AttackSpeed: 5, Range: 25, UpgradePrice: 1750 },
				3: { Damage: 140, AttackSpeed: 4, Range: 25, UpgradePrice: 2350 },
				4: {
					Ability: "Energy Blast",
					AttackType: "Circle",
					AttackSize: 9,
					Damage: 190,
					AttackSpeed: 6,
					Range: 25,
					UpgradePrice: 2600,
				},
				5: { Damage: 230, AttackSpeed: 6, Range: 30, UpgradePrice: 3100 },
				6: { Damage: 280, AttackSpeed: 5, Range: 32, UpgradePrice: 4200 },
				7: { Damage: 325, AttackSpeed: 5, Range: 32, UpgradePrice: 5100 },
			},
		},
		animations: { idle: "134468281047458", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	"Android 21": {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Android 21",
			DisplayName: "Twenty One",
			Rarity: "Secret",
			PlacementType: "Air",
			Element: "Dark",
			UnitType: "Air",
			PlacementPrice: 1950,
			CanSell: true,
			Passives: ["Natural Vision"],
			Damage: 190,
			AttackSpeed: 5,
			Range: 18,
			Ability: "Demonic Ki Blast",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 10,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							BlueStar: 10,
							GreenStar: 10,
							OrangeStar: 10,
							PurpleStar: 10,
							RedStar: 10,
							Cupcake: 15,
							RainbowStar: 2,
						},
					},
					DisplayBuffs: ["+25% Damage", "+1 New Move: Death Ball", "+1 New Passive: Together we shine"],
					TransferStats: true,
					EvolvesInto: "Android 21 [Demon]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 250, AttackSpeed: 4.5, Range: 20.5, UpgradePrice: 2100 },
				2: { Damage: 330, AttackSpeed: 4, Range: 21, UpgradePrice: 2600 },
				3: { Damage: 400, AttackSpeed: 3.5, Range: 23, UpgradePrice: 3300 },
				4: { Damage: 475, AttackSpeed: 3.5, Range: 24.5, UpgradePrice: 3800 },
				5: {
					Damage: 550,
					AttackSpeed: 8,
					Range: 26,
					UpgradePrice: 7500,
					Ability: "Raging Ki Explosion",
					AttackType: "Full",
				},
				6: { Damage: 620, AttackSpeed: 8, Range: 27, UpgradePrice: 9600 },
				7: { Damage: 790, AttackSpeed: 8, Range: 27, UpgradePrice: 11000 },
				8: { Damage: 935, AttackSpeed: 8, Range: 30, UpgradePrice: 13000 },
			},
		},
		animations: {
			idle: "18172212518",
			walk: "17264216432",
			special: "18172214963", // tail
			attack: "18172209224", // hair
		},
		radius: 2.5,
		tradable: false,
	},

	"Android 21 [Demon]": {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Android 21 [Demon]",
			DisplayName: "Twenty One [Demon]",
			Rarity: "Secret",
			PlacementType: "Air",
			Element: "Dark",
			UnitType: "Air",
			PlacementPrice: 1950,
			CanSell: true,
			Passives: ["Natural Vision", "Together we shine"],
			Damage: 238,
			AttackSpeed: 5,
			Range: 18,
			Ability: "Demonic Ki Blast",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 10,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 338, AttackSpeed: 4.5, Range: 20.5, UpgradePrice: 2100 },
				2: { Damage: 413, AttackSpeed: 4, Range: 21, UpgradePrice: 2600 },
				3: { Damage: 500, AttackSpeed: 3.5, Range: 23, UpgradePrice: 3300 },
				4: { Damage: 594, AttackSpeed: 3.5, Range: 24.5, UpgradePrice: 3800 },
				5: {
					Damage: 688,
					AttackSpeed: 9,
					Range: 26,
					UpgradePrice: 7500,
					Ability: "Raging Ki Explosion",
					AttackType: "Full",
				},
				6: { Damage: 775, AttackSpeed: 9, Range: 26, UpgradePrice: 9600 },
				7: { Damage: 988, AttackSpeed: 9, Range: 27, UpgradePrice: 11000 },
				8: { Damage: 1169, AttackSpeed: 8.5, Range: 27, UpgradePrice: 13000 },
				9: {
					Damage: 1950,
					AttackSpeed: 8,
					Range: 37,
					UpgradePrice: 13500,
					Ability: "Death Ball",
					AttackSize: 20,
					AttackType: "Circle",
				},
			},
		},
		animations: {
			idle: "18172212518",
			walk: "17264216432",
			special: "18172214963", // tail
			attack: "18172209224", // hair
		},
		radius: 2.5,
		tradable: false,
		evolved: "Android 21",
	},

	Aokiji: {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Aokiji",
			DisplayName: "Aokojo",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Ice",
			UnitType: "Ground",
			PlacementPrice: 1870,
			CanSell: true,
			Passives: ["Ice Breaker"],
			Damage: 175,
			AttackSpeed: 4,
			Range: 16,
			Ability: "Suffocation",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Line",
			AttackSize: 7,
			AttackEffect: "",
			AttackEffectDuration: 3,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							IceFruit: 1,
							RainbowStar: 1,
						},
					},
					DisplayBuffs: ["+25% Damage", "+1 New Passive: Ice Spears"],
					TransferStats: true,
					EvolvesInto: "Aokiji [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 255, AttackSpeed: 4, Range: 18, UpgradePrice: 2450 },
				2: { Damage: 270, AttackSpeed: 4, Range: 20, UpgradePrice: 3000 },
				3: { Damage: 340, AttackSpeed: 4, Range: 22, UpgradePrice: 4760 },
				4: {
					Damage: 400,
					AttackSpeed: 4,
					Range: 22,
					UpgradePrice: 4500,
					AttackType: "Circle",
					Ability: "Ice Ball",
					AttackSize: 10,
				},
				5: { Damage: 470, AttackSpeed: 4, Range: 24, UpgradePrice: 5250 },
				6: { Damage: 520, AttackSpeed: 4, Range: 25, UpgradePrice: 6000 },
				7: { Damage: 655, AttackSpeed: 4.5, Range: 25, UpgradePrice: 7400 },
				8: { Damage: 840, AttackSpeed: 4.5, Range: 26, UpgradePrice: 8500 },
			},
		},
		animations: { idle: "129945398427940", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	"Aokiji [Evo]": {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Aokiji [Evo]",
			DisplayName: "Aokojo [Serious]",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Ice",
			UnitType: "Ground",
			PlacementPrice: 1550,
			CanSell: true,
			Passives: ["Ice Breaker", "Ice Spears"],
			Damage: 218,
			AttackSpeed: 5,
			Range: 16,
			Ability: "Suffocation",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Line",
			AttackSize: 7,
			AttackEffect: "",
			AttackEffectDuration: 3,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 281, AttackSpeed: 4, Range: 18, UpgradePrice: 2450 },
				2: { Damage: 337, AttackSpeed: 4, Range: 20, UpgradePrice: 3000 },
				3: { Damage: 425, AttackSpeed: 4, Range: 22, UpgradePrice: 4760 },
				4: {
					Damage: 500,
					AttackSpeed: 4,
					Range: 22,
					UpgradePrice: 4500,
					AttackType: "Circle",
					Ability: "Ice Ball",
					AttackSize: 10,
				},
				5: { Damage: 587, AttackSpeed: 4, Range: 24, UpgradePrice: 5250 },
				6: { Damage: 650, AttackSpeed: 4, Range: 25, UpgradePrice: 6000 },
				7: { Damage: 818, AttackSpeed: 4.5, Range: 25, UpgradePrice: 7400 },
				8: { Damage: 1050, AttackSpeed: 4.5, Range: 26, UpgradePrice: 8500 },
				9: {
					Damage: 1650,
					AttackSpeed: 5,
					Range: 28,
					UpgradePrice: 11500,
					AttackType: "Full",
					Ability: "Ice Age",
					AttackSize: 13,
				},
			},
		},
		animations: { idle: "129945398427940", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
		evolved: "Aokiji",
	},

	Aqua: {
		configuration: {
			Viewport: new CFrame(0, 0.4, -1.4).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 4,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Aqua",
			DisplayName: "Water Goddess",
			Rarity: "Legendary",
			PlacementType: "Ground",
			Element: "Water",
			UnitType: "Hybrid",
			PlacementPrice: 750,
			CanSell: true,
			Passives: [],
			Damage: 45,
			AttackSpeed: 7,
			Range: 15,
			Ability: "Sacred Create Water",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 6,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 60, AttackSpeed: 7, Range: 15, UpgradePrice: 830 },
				2: { Damage: 75, AttackSpeed: 7, Range: 15, UpgradePrice: 1000 },
				3: { Damage: 95, AttackSpeed: 8, Range: 15, UpgradePrice: 1350 },
				4: {
					Damage: 115,
					AttackSpeed: 7,
					Range: 15,
					SpecialAbility: "Goddesses Grace: Might",
					UpgradePrice: 1750,
				},
				5: { Damage: 140, AttackSpeed: 6.5, Range: 15, AttackSize: 15, UpgradePrice: 2400 },
				6: { Damage: 150, AttackSpeed: 6, Range: 15, UpgradePrice: 3000 },
				7: { Damage: 185, AttackSpeed: 6, Range: 20, UpgradePrice: 4350 },
			},
		},
		animations: { idle: "17893593497", walk: "17264216432" },
		radius: 2.5,
		tradable: false,
	},

	Arlong: {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 4,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Arlong",
			DisplayName: "Arleng",
			Rarity: "Rare",
			PlacementType: "Ground",
			Element: "Fierce",
			UnitType: "Ground",
			PlacementPrice: 500,
			CanSell: true,
			Passives: [],
			Damage: 30,
			AttackSpeed: 7,
			Range: 15,
			Ability: "Shark Bite",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Line",
			AttackSize: 5,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 50, AttackSpeed: 6.5, Range: 15, UpgradePrice: 750 },
				2: { Damage: 86, AttackSpeed: 6.5, Range: 17, UpgradePrice: 1100 },
				3: { Damage: 125, AttackSpeed: 6.5, Range: 19, UpgradePrice: 1300 },
				4: { Damage: 165, AttackSpeed: 6.5, Range: 22, UpgradePrice: 1500 },
				5: { Damage: 200, AttackSpeed: 6, Range: 23, UpgradePrice: 2000 },
			},
		},
		animations: { idle: "94781171912952", walk: "17264216432" },
		radius: 2.5,
		tradable: false,
	},

	Asta: {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Asta",
			DisplayName: "Osta",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Dark",
			UnitType: "Ground",
			PlacementPrice: 1700,
			CanSell: true,
			Passives: ["Anti-Magic Grimoire"],
			Damage: 240,
			AttackSpeed: 7,
			Range: 17,
			Ability: "Boar Thrust",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 7,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							DemonGrimoire: 1,
							RainbowStar: 2,
							GreenStar: 8,
							RedStar: 10,
							OrangeStar: 10,
							DarkStone: 15,
						},
					},
					DisplayBuffs: ["+25% Damage", "+1 New Move: Black Divider", "+1 New Passive: Anti-Magic Swords"],
					TransferStats: true,
					EvolvesInto: "Asta [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 300, AttackSpeed: 7, Range: 17, UpgradePrice: 2600 },
				2: { Damage: 350, AttackSpeed: 6, Range: 20, UpgradePrice: 3400 },
				3: {
					Damage: 400,
					AttackSpeed: 6,
					Range: 20,
					UpgradePrice: 4300,
					AttackType: "Line",
					Ability: "Black Meteorite",
					AttackSize: 6,
				},
				4: { Damage: 460, AttackSpeed: 5.5, Range: 21, UpgradePrice: 5300 },
				5: {
					Damage: 550,
					AttackSpeed: 8,
					Range: 22,
					UpgradePrice: 5500,
					AttackType: "Line",
					Ability: "Black Hurricane",
					AttackSize: 8,
				},
				6: { Damage: 650, AttackSpeed: 8, Range: 25, UpgradePrice: 6000 },
				7: { Damage: 775, AttackSpeed: 7, Range: 28, UpgradePrice: 7500 },
				8: { Damage: 900, AttackSpeed: 6, Range: 31, UpgradePrice: 9000 },
			},
		},
		animations: {
			idle: "93686370326927",
			walk: "17264216432",
			special: "98944742673151", // hair
		},
		radius: 2.5,
		tradable: false,
	},

	"Asta [Evo]": {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Asta [Evo]",
			DisplayName: "Osta [Anti-Form]",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Dark",
			UnitType: "Ground",
			PlacementPrice: 1700,
			CanSell: true,
			Passives: ["Anti-Magic Grimoire", "Brotherhood"],
			Damage: 300,
			AttackSpeed: 7,
			Range: 17,
			Ability: "Boar Thrust",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 7,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 375, AttackSpeed: 7, Range: 17, UpgradePrice: 2600 },
				2: { Damage: 438, AttackSpeed: 6, Range: 20, UpgradePrice: 3400 },
				3: {
					Damage: 500,
					AttackSpeed: 6,
					Range: 20,
					UpgradePrice: 4300,
					AttackType: "Line",
					Ability: "Black Meteorite",
					AttackSize: 6,
				},
				4: { Damage: 575, AttackSpeed: 5.5, Range: 21, UpgradePrice: 5300 },
				5: {
					Damage: 688,
					AttackSpeed: 8,
					Range: 22,
					UpgradePrice: 5500,
					AttackType: "Line",
					Ability: "Black Hurricane",
					AttackSize: 8,
				},
				6: { Damage: 813, AttackSpeed: 8, Range: 25, UpgradePrice: 6000 },
				7: { Damage: 969, AttackSpeed: 7, Range: 28, UpgradePrice: 7500 },
				8: { Damage: 1125, AttackSpeed: 6, Range: 31, UpgradePrice: 9000 },
				9: {
					Damage: 1800,
					AttackSpeed: 8,
					Range: 32,
					UpgradePrice: 11000,
					AttackType: "Line",
					Ability: "Black Divider",
					AttackSize: 10,
				},
			},
		},
		animations: {
			idle: "93686370326927",
			walk: "17264216432",
			special: "98944742673151", // hair
		},
		radius: 2.5,
		tradable: false,
		evolved: "Asta",
	},

	// === B-UNITS BATCH 1 ===

	"Baek YoonHo": {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Baek YoonHo",
			DisplayName: "Book Yoonha [Silver Mane]",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Fire",
			UnitType: "Ground",
			PlacementPrice: 1000,
			CanSell: true,
			Passives: [],
			Damage: 1000,
			AttackSpeed: 8,
			Range: 25,
			Ability: "Fiece Slam",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 4,
			AttackEffect: "",
			AttackEffectDuration: 5,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							Suit: 1,
							RainbowStar: 1,
							RedStar: 5,
							PurpleStar: 5,
							GreenStar: 5,
							BlueStar: 5,
							OrangeStar: 8,
						},
					},
					DisplayBuffs: ["+25% Damage", "+Tiger Slashes", "Passive: Tiger Transformation"],
					TransferStats: true,
					EvolvesInto: "Baek YoonHo [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 1350, AttackSpeed: 5, Range: 20, UpgradePrice: 600 },
				2: { Damage: 1650, AttackSpeed: 5, Range: 22, UpgradePrice: 1000 },
				3: { Damage: 1875, AttackSpeed: 5, Range: 23, UpgradePrice: 1500 },
				4: {
					Damage: 2000,
					AttackSpeed: 5,
					Range: 24,
					UpgradePrice: 2500,
					AttackType: "Circle",
					AttackSize: 15,
					Ability: "Tiger Punches",
				},
			},
		},
		animations: { idle: "113360220002265", walk: "17264216432" },
		radius: 2.5,
		tradable: false,
	},

	"Baek YoonHo [Evo]": {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Baek YoonHo [Evo]",
			DisplayName: "Book Yoonha [Silver Mane]",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Fire",
			UnitType: "Ground",
			PlacementPrice: 1000,
			CanSell: true,
			Passives: ["Tiger Transformation"],
			Damage: 1150,
			AttackSpeed: 8,
			Range: 25,
			Ability: "Fiece Slam",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 4,
			AttackEffect: "",
			AttackEffectDuration: 5,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 1350, AttackSpeed: 7.5, Range: 28, UpgradePrice: 3850 },
				2: { Damage: 1375, AttackSpeed: 7.5, Range: 29, UpgradePrice: 4900 },
				3: { Damage: 1625, AttackSpeed: 7, Range: 30, UpgradePrice: 6075 },
				4: {
					Damage: 1875,
					AttackSpeed: 7,
					Range: 32,
					UpgradePrice: 7500,
					AttackType: "Circle",
					AttackSize: 15,
					Ability: "Tiger Punches",
				},
				5: { Damage: 2062.5, AttackSpeed: 7, Range: 34, UpgradePrice: 9250 },
				6: { Damage: 2750, AttackSpeed: 7, Range: 35, UpgradePrice: 11000 },
				7: { Damage: 3750, AttackSpeed: 7, Range: 35, UpgradePrice: 13750 },
				8: {
					Damage: 5000,
					AttackSpeed: 7,
					Range: 37,
					UpgradePrice: 15000,
					AttackType: "Line",
					AttackSize: 15,
					Ability: "Tiger Slashes",
				},
			},
		},
		animations: { idle: "128321187223716", walk: "17264216432" },
		radius: 2.5,
		tradable: false,
		evolved: "Baek YoonHo",
	},

	Baruk: {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			CameraOffset: new CFrame(0.35, 0.15, 0.05),
			CameraZoom: 65,
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Baruk",
			DisplayName: "Baruk",
			Rarity: "Exclusive",
			PlacementType: "Ground",
			Element: "Light",
			UnitType: "Ground",
			MapAffnity: "Ghost Tunnel",
			GameTypeAffinity: ["Portal"],
			MapAffnityBoosts: {
				PermanentDamageMulti: 0.1,
			},
			PlacementPrice: 1455,
			CanSell: true,
			Passives: [],
			Damage: 400,
			AttackSpeed: 6,
			Range: 17,
			Ability: "Acrobatic Kicks",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Line",
			AttackSize: 13,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 577, AttackSpeed: 6, Range: 19, UpgradePrice: 2500 },
				2: { Damage: 740, AttackSpeed: 6, Range: 20, UpgradePrice: 3700 },
				3: { Damage: 985, AttackSpeed: 6, Range: 22, UpgradePrice: 5000 },
				4: {
					Damage: 1400,
					AttackSpeed: 5.5,
					Range: 25,
					UpgradePrice: 6450,
					AttackType: "Circle",
					Ability: "Ballerina Swish",
					AttackSize: 10,
				},
				5: { Damage: 1620, AttackSpeed: 5.5, Range: 27, UpgradePrice: 7500 },
				6: { Damage: 1822, AttackSpeed: 5.5, Range: 27, UpgradePrice: 8670 },
				7: { Damage: 2100, AttackSpeed: 5.5, Range: 28, UpgradePrice: 9888 },
				8: { Damage: 2475, AttackSpeed: 5.5, Range: 28, UpgradePrice: 11100 },
			},
		},
		animations: { idle: "92067478307647", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	Beerus: {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Beerus",
			DisplayName: "Beruus",
			Rarity: "Secret",
			PlacementType: "Ground",
			Element: "Fire",
			UnitType: "Ground",
			PlacementPrice: 1500,
			CanSell: true,
			Passives: ["God Of Destruction"],
			Damage: 555,
			AttackSpeed: 7.5,
			Range: 18,
			Ability: "Continous Ki Barrage",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 10,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							Pudding: 1,
						},
					},
					DisplayBuffs: [
						"+20% Damage",
						"+1 New Move: Sphere of Destruction",
						"+1 New Passive: God's Presence",
					],
					TransferStats: true,
					EvolvesInto: "Beerus [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 690, AttackSpeed: 7.5, Range: 20, UpgradePrice: 2000 },
				2: { Damage: 800, AttackSpeed: 7.5, Range: 23, UpgradePrice: 3500 },
				3: { Damage: 970, AttackSpeed: 7, Range: 25, UpgradePrice: 5000 },
				4: { Damage: 1175, AttackSpeed: 7, Range: 27, UpgradePrice: 6700 },
				5: {
					Damage: 1400,
					AttackSpeed: 7,
					Range: 29,
					UpgradePrice: 8000,
					AttackType: "Line",
					Ability: "Cataclysmic Orbs",
					AttackSize: 10,
				},
				6: { Damage: 1690, AttackSpeed: 6.5, Range: 30, UpgradePrice: 9500 },
				7: { Damage: 2000, AttackSpeed: 6.5, Range: 31, UpgradePrice: 10420 },
				8: { Damage: 2400, AttackSpeed: 6.5, Range: 32, UpgradePrice: 11500 },
			},
		},
		animations: { idle: "83304444773538", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	"Beerus [Evo]": {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 4,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Beerus [Evo]",
			DisplayName: "Beruus [Destruction]",
			Rarity: "Secret",
			PlacementType: "Ground",
			Element: "Fire",
			UnitType: "Ground",
			PlacementPrice: 1500,
			CanSell: true,
			Passives: ["God Of Destruction", "God's Presence"],
			Damage: 693.75,
			AttackSpeed: 7.5,
			Range: 18,
			Ability: "Continous Ki Barrage",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 10,
			AttackEffect: "Fear",
			AttackEffectDuration: 9999999,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 862.5, AttackSpeed: 7.5, Range: 20, UpgradePrice: 2000 },
				2: { Damage: 1000, AttackSpeed: 7.5, Range: 23, UpgradePrice: 3500 },
				3: { Damage: 1212.5, AttackSpeed: 7, Range: 25, UpgradePrice: 5000 },
				4: { Damage: 1468.75, AttackSpeed: 7, Range: 27, UpgradePrice: 6700 },
				5: {
					Damage: 1750,
					AttackSpeed: 7,
					Range: 29,
					UpgradePrice: 8000,
					AttackType: "Line",
					Ability: "Cataclysmic Orbs",
					AttackSize: 10,
				},
				6: { Damage: 2112.5, AttackSpeed: 6.5, Range: 30, UpgradePrice: 9500 },
				7: { Damage: 2500, AttackSpeed: 6.5, Range: 31, UpgradePrice: 10420 },
				8: { Damage: 3000, AttackSpeed: 6.5, Range: 32, UpgradePrice: 11500 },
				9: {
					Damage: 3750,
					AttackSpeed: 7,
					Range: 34,
					UpgradePrice: 12800,
					AttackType: "Circle",
					Ability: "Sphere of Destruction",
					AttackSize: 15,
				},
			},
		},
		animations: { idle: "83304444773538", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
		evolved: "Beerus",
	},

	Beru: {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Beru",
			DisplayName: "Beru",
			Rarity: "Legendary",
			PlacementType: "Ground",
			Element: "Dark",
			UnitType: "Ground",
			PlacementPrice: 1875,
			CanSell: true,
			Passives: ["Shadow Army"],
			Damage: 7650,
			AttackSpeed: 8,
			Range: 6,
			Ability: "",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 1,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 7650, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
				2: { Damage: 8775, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
				3: { Damage: 9900, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
			},
		},
		animations: { idle: "92067478307647", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	"Beru [Evo]": {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Beru [Evo]",
			DisplayName: "Beru [Evo]",
			Rarity: "Legendary",
			PlacementType: "Ground",
			Element: "Dark",
			UnitType: "Ground",
			PlacementPrice: 1875,
			CanSell: true,
			Passives: ["Shadow Army"],
			Damage: 8775,
			AttackSpeed: 8,
			Range: 6,
			Ability: "",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 1,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 8775, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
				2: { Damage: 9900, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
				3: { Damage: 11025, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
			},
		},
		animations: { idle: "92067478307647", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
		evolved: "Beru",
	},

	"Beru [Evo2]": {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Beru [Evo2]",
			DisplayName: "Beru [Evo2]",
			Rarity: "Legendary",
			PlacementType: "Ground",
			Element: "Dark",
			UnitType: "Ground",
			PlacementPrice: 1875,
			CanSell: true,
			Passives: ["Shadow Army"],
			Damage: 9900,
			AttackSpeed: 8,
			Range: 6,
			Ability: "",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 1,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 9900, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
				2: { Damage: 11025, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
				3: { Damage: 12150, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
			},
		},
		animations: { idle: "92067478307647", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
		evolved: "Beru [Evo]",
	},

	Beta: {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Beta",
			DisplayName: "Beta",
			Rarity: "Rare",
			PlacementType: "Ground",
			Element: "Water",
			UnitType: "Hybrid",
			PlacementPrice: 350,
			CanSell: true,
			Passives: ["Bullet Storm"],
			Damage: 1530,
			AttackSpeed: 7,
			Range: 6,
			Ability: "",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Closest",
			AttackSize: 1,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 1530, AttackSpeed: 7, Range: 6, UpgradePrice: 350 },
				2: { Damage: 1785, AttackSpeed: 7, Range: 6, UpgradePrice: 350 },
				3: { Damage: 2050, AttackSpeed: 7, Range: 6, UpgradePrice: 350 },
			},
		},
		animations: { idle: "92067478307647", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	Blackbeard: {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Blackbeard",
			DisplayName: "Blackbeard",
			Rarity: "Legendary",
			PlacementType: "Ground",
			Element: "Dark",
			UnitType: "Ground",
			PlacementPrice: 1875,
			CanSell: true,
			Passives: ["Quake"],
			Damage: 7650,
			AttackSpeed: 8,
			Range: 6,
			Ability: "",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 1,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 7650, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
				2: { Damage: 8775, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
				3: { Damage: 9900, AttackSpeed: 8, Range: 6, UpgradePrice: 1875 },
			},
		},
		animations: { idle: "92067478307647", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},
};

// Helper functions for querying units
export function getUnitByName(name: string): UnitData | undefined {
	return UnitsRegistry[name];
}

export function getUnitsByRarity(rarity: UnitRarity): UnitData[] {
	const entries = [];
	for (const [, unit] of pairs(UnitsRegistry)) {
		if (unit.configuration.Rarity === rarity) {
			entries.push(unit);
		}
	}
	return entries;
}

export function getUnitsByElement(element: UnitElement): UnitData[] {
	const entries = [];
	for (const [, unit] of pairs(UnitsRegistry)) {
		if (unit.configuration.Element === element) {
			entries.push(unit);
		}
	}
	return entries;
}

export function getEvolutionChain(unitName: string): string[] {
	const unit = UnitsRegistry[unitName];
	if (!unit) return [];

	const chain: string[] = [unitName];

	// Find evolutions
	if (unit.configuration.EvolveData) {
		for (const evolve of unit.configuration.EvolveData) {
			chain.push(evolve.EvolvesInto);
		}
	}

	return chain;
}

export function canEvolve(unitName: string): boolean {
	const unit = UnitsRegistry[unitName];
	return !!(unit?.configuration.EvolveData && unit.configuration.EvolveData.size() > 0);
}

export function getUnitPassives(unitName: string): readonly string[] {
	const unit = UnitsRegistry[unitName];
	return unit?.configuration.Passives || [];
}

export function getAllUnitNames(): string[] {
	const names = [];
	for (const [name] of pairs(UnitsRegistry)) {
		names.push(name);
	}
	return names;
}

export function getUnitsCount(): number {
	let count = 0;
	for (const [,] of pairs(UnitsRegistry)) {
		count++;
	}
	return count;
}
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Baek YoonHo",
			DisplayName: "Book Yoonha [Silver Mane]",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Fire",
			UnitType: "Ground",
			PlacementPrice: 1000,
			CanSell: true,
			Passives: [],
			Damage: 1000,
			AttackSpeed: 8,
			Range: 25,
			Ability: "Fiece Slam",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 4,
			AttackEffect: "",
			AttackEffectDuration: 5,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							Suit: 1,
							RainbowStar: 1,
							RedStar: 5,
							PurpleStar: 5,
							GreenStar: 5,
							BlueStar: 5,
							OrangeStar: 8,
						},
					},
					DisplayBuffs: ["+25% Damage", "+Tiger Slashes", "Passive: Tiger Transformation"],
					TransferStats: true,
					EvolvesInto: "Baek YoonHo [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 1350, AttackSpeed: 5, Range: 20, UpgradePrice: 600 },
				2: { Damage: 1650, AttackSpeed: 5, Range: 22, UpgradePrice: 1000 },
				3: { Damage: 1875, AttackSpeed: 5, Range: 23, UpgradePrice: 1500 },
				4: {
					Damage: 2000,
					AttackSpeed: 5,
					Range: 24,
					UpgradePrice: 2500,
					AttackType: "Circle",
					AttackSize: 15,
					Ability: "Tiger Punches",
				},
			},
		},
		animations: { idle: "113360220002265", walk: "17264216432" },
		radius: 2.5,
		tradable: false,
	},

	"Baek YoonHo [Evo]": {
		configuration: {
			Viewport: new CFrame(0, 0.6, -1.65).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Baek YoonHo [Evo]",
			DisplayName: "Book Yoonha [Silver Mane]",
			Rarity: "Mythical",
			PlacementType: "Ground",
			Element: "Fire",
			UnitType: "Ground",
			PlacementPrice: 1000,
			CanSell: true,
			Passives: ["Tiger Transformation"],
			Damage: 1150,
			AttackSpeed: 8,
			Range: 25,
			Ability: "Fiece Slam",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 4,
			AttackEffect: "",
			AttackEffectDuration: 5,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 1350, AttackSpeed: 7.5, Range: 28, UpgradePrice: 3850 },
				2: { Damage: 1375, AttackSpeed: 7.5, Range: 29, UpgradePrice: 4900 },
				3: { Damage: 1625, AttackSpeed: 7, Range: 30, UpgradePrice: 6075 },
				4: {
					Damage: 1875,
					AttackSpeed: 7,
					Range: 32,
					UpgradePrice: 7500,
					AttackType: "Circle",
					AttackSize: 15,
					Ability: "Tiger Punches",
				},
				5: { Damage: 2062.5, AttackSpeed: 7, Range: 34, UpgradePrice: 9250 },
				6: { Damage: 2750, AttackSpeed: 7, Range: 35, UpgradePrice: 11000 },
				7: { Damage: 3750, AttackSpeed: 7, Range: 35, UpgradePrice: 13750 },
				8: {
					Damage: 5000,
					AttackSpeed: 7,
					Range: 37,
					UpgradePrice: 15000,
					AttackType: "Line",
					AttackSize: 15,
					Ability: "Tiger Slashes",
				},
			},
		},
		animations: { idle: "128321187223716", walk: "17264216432" },
		radius: 2.5,
		tradable: false,
		evolved: "Baek YoonHo",
	},

	Baruk: {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			CameraOffset: new CFrame(0.35, 0.15, 0.05),
			CameraZoom: 65,
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Baruk",
			DisplayName: "Baruk",
			Rarity: "Exclusive",
			PlacementType: "Ground",
			Element: "Light",
			UnitType: "Ground",
			MapAffnity: "Ghost Tunnel",
			GameTypeAffinity: ["Portal"],
			MapAffnityBoosts: {
				PermanentDamageMulti: 0.1,
			},
			PlacementPrice: 1455,
			CanSell: true,
			Passives: [],
			Damage: 400,
			AttackSpeed: 6,
			Range: 17,
			Ability: "Acrobatic Kicks",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Line",
			AttackSize: 13,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 577, AttackSpeed: 6, Range: 19, UpgradePrice: 2500 },
				2: { Damage: 740, AttackSpeed: 6, Range: 20, UpgradePrice: 3700 },
				3: { Damage: 985, AttackSpeed: 6, Range: 22, UpgradePrice: 5000 },
				4: {
					Damage: 1400,
					AttackSpeed: 5.5,
					Range: 25,
					UpgradePrice: 6450,
					AttackType: "Circle",
					Ability: "Ballerina Swish",
					AttackSize: 10,
				},
				5: { Damage: 1620, AttackSpeed: 5.5, Range: 27, UpgradePrice: 7500 },
				6: { Damage: 1822, AttackSpeed: 5.5, Range: 27, UpgradePrice: 8670 },
				7: { Damage: 2100, AttackSpeed: 5.5, Range: 28, UpgradePrice: 9888 },
				8: { Damage: 2475, AttackSpeed: 5.5, Range: 28, UpgradePrice: 11100 },
			},
		},
		animations: { idle: "92067478307647", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	Beerus: {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Beerus",
			DisplayName: "Beruus",
			Rarity: "Secret",
			PlacementType: "Ground",
			Element: "Fire",
			UnitType: "Ground",
			PlacementPrice: 1500,
			CanSell: true,
			Passives: ["God Of Destruction"],
			Damage: 555,
			AttackSpeed: 7.5,
			Range: 18,
			Ability: "Continous Ki Barrage",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 10,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							Pudding: 1,
						},
					},
					DisplayBuffs: ["+20% Damage", "+1 New Move: Sphere of Destruction", "+1 New Passive: God's Presence"],
					TransferStats: true,
					EvolvesInto: "Beerus [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 690, AttackSpeed: 7.5, Range: 20, UpgradePrice: 2000 },
				2: { Damage: 800, AttackSpeed: 7.5, Range: 23, UpgradePrice: 3500 },
				3: { Damage: 970, AttackSpeed: 7, Range: 25, UpgradePrice: 5000 },
				4: { Damage: 1175, AttackSpeed: 7, Range: 27, UpgradePrice: 6700 },
				5: {
					Damage: 1400,
					AttackSpeed: 7,
					Range: 29,
					UpgradePrice: 8000,
					AttackType: "Line",
					Ability: "Cataclysmic Orbs",
					AttackSize: 10,
				},
				6: { Damage: 1690, AttackSpeed: 6.5, Range: 30, UpgradePrice: 9500 },
				7: { Damage: 2000, AttackSpeed: 6.5, Range: 31, UpgradePrice: 10420 },
				8: { Damage: 2400, AttackSpeed: 6.5, Range: 32, UpgradePrice: 11500 },
			},
		},
		animations: { idle: "83304444773538", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
	},

	"Beerus [Evo]": {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 4,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Beerus [Evo]",
			DisplayName: "Beruus [Destruction]",
			Rarity: "Secret",
			PlacementType: "Ground",
			Element: "Fire",
			UnitType: "Ground",
			PlacementPrice: 1500,
			CanSell: true,
			Passives: ["God Of Destruction", "God's Presence"],
			Damage: 693.75,
			AttackSpeed: 7.5,
			Range: 18,
			Ability: "Continous Ki Barrage",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 10,
			AttackEffect: "Fear",
			AttackEffectDuration: 9999999,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 862.5, AttackSpeed: 7.5, Range: 20, UpgradePrice: 2000 },
				2: { Damage: 1000, AttackSpeed: 7.5, Range: 23, UpgradePrice: 3500 },
				3: { Damage: 1212.5, AttackSpeed: 7, Range: 25, UpgradePrice: 5000 },
				4: { Damage: 1468.75, AttackSpeed: 7, Range: 27, UpgradePrice: 6700 },
				5: {
					Damage: 1750,
					AttackSpeed: 7,
					Range: 29,
					UpgradePrice: 8000,
					AttackType: "Line",
					Ability: "Cataclysmic Orbs",
					AttackSize: 10,
				},
				6: { Damage: 2112.5, AttackSpeed: 6.5, Range: 30, UpgradePrice: 9500 },
				7: { Damage: 2500, AttackSpeed: 6.5, Range: 31, UpgradePrice: 10420 },
				8: { Damage: 3000, AttackSpeed: 6.5, Range: 32, UpgradePrice: 11500 },
				9: {
					Damage: 3750,
					AttackSpeed: 7,
					Range: 34,
					UpgradePrice: 12800,
					AttackType: "Circle",
					Ability: "Sphere of Destruction",
					AttackSize: 15,
				},
			},
		},
		animations: { idle: "83304444773538", walk: "17264216432" },
		radius: 2.5,
		tradable: true,
		evolved: "Beerus",
	},

	Beru: {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Beru",
			DisplayName: "Ant King",
			Rarity: "Secret",
			PlacementType: "Air",
			Element: "Fierce",
			UnitType: "Air",
			PlacementPrice: 1780,
			CanSell: true,
			Passives: [],
			Damage: 750,
			AttackSpeed: 13,
			Range: 25,
			Ability: "Revengeful Punch",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Cone",
			AttackSize: 11,
			AttackEffect: "Poison",
			AttackEffectDuration: 7,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			EvolveData: [
				{
					Requirements: {
						Items: {
							AntFace: 1,
							RainbowStar: 1,
							RedStar: 2,
							PurpleStar: 2,
							GreenStar: 2,
							BlueStar: 2,
							OrangeStar: 5,
						},
					},
					DisplayBuffs: ["+25% Damage", "+Passive: Predator's Hunch"],
					TransferStats: true,
					EvolvesInto: "Beru [Evo]",
				},
			],
			UpgradesInfo: {
				1: { Damage: 1100, AttackSpeed: 12, Range: 25, UpgradePrice: 2450 },
				2: { Damage: 1425, AttackSpeed: 11.5, Range: 28, UpgradePrice: 3800 },
				3: { Damage: 1850, AttackSpeed: 10, Range: 28, UpgradePrice: 4200 },
				4: { Damage: 2280, AttackSpeed: 9, Range: 32, UpgradePrice: 5425 },
				5: {
					Damage: 2670,
					AttackSpeed: 9,
					Range: 36,
					UpgradePrice: 6450,
					Ability: "Toxin Spit",
					AttackType: "Cone",
					AttackSize: 19,
				},
				6: { Damage: 3000, AttackSpeed: 9, Range: 36, UpgradePrice: 7825 },
				7: { Damage: 3200, AttackSpeed: 8.6, Range: 38, UpgradePrice: 9480 },
				8: { Damage: 4100, AttackSpeed: 7.5, Range: 38, UpgradePrice: 10760 },
			},
		},
		animations: { idle: "109103009156297" },
		radius: 2.5,
		tradable: false,
	},

	Beta: {
		configuration: {
			Viewport: new CFrame(-0.6, 0.4, -2).mul(CFrame.Angles(0, math.rad(200), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			MaxUpgrades: 5,
			SellCost: 100,
			TrueName: "Beta",
			DisplayName: "Bita",
			Rarity: "Rare",
			PlacementType: "Ground",
			Element: "Dark",
			UnitType: "Ground",
			PlacementPrice: 0,
			CanSell: true,
			Passives: [],
			Damage: 340,
			AttackSpeed: 5,
			Range: 16,
			Ability: "Mana-Powered Arrow",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle",
			AttackSize: 5,
			AttackEffect: "",
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 425, AttackSpeed: 5, Range: 18, UpgradePrice: 0 },
			},
		},
		animations: { idle: "80338065112304", walk: "17264216432" },
		radius: 2.5,
		tradable: false,
	},

	Blackbeard: {
		configuration: {
			Viewport: new CFrame(0, 0.4, -1.4).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0.1, -0.02, -3.3).mul(CFrame.Angles(0, math.rad(180), 0)),
			UnitCardViewport: new CFrame(0.45, 0.65, -1)
				.mul(CFrame.Angles(0, math.rad(180), 0))
				.mul(CFrame.Angles(0, math.rad(-20), 0)),
			MaxPlacementAmount: 3,
			SellCost: 100,
			MaxUpgrades: 5,
			TrueName: "Blackbeard",
			DisplayName: "Darkbeard",
			Rarity: "Legendary",
			PlacementType: "Ground",
			Element: "Dark",
			UnitType: "Ground",
			PlacementPrice: 900,
			CanSell: true,
			Passives: ["Dark Void"],
			Damage: 95,
			AttackSpeed: 9,
			Range: 15,
			Ability: "Vortex",
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Line",
			AttackSize: 6,
			AttackEffect: "Slow",
			AttackEffectDuration: 6,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			UpgradesInfo: {
				1: { Damage: 120, AttackSpeed: 9, Range: 16, UpgradePrice: 1350 },
				2: { Damage: 135, AttackSpeed: 8.5, Range: 17, UpgradePrice: 1800 },
				3: { Damage: 150, AttackSpeed: 8.5, Range: 18, UpgradePrice: 2400 },
				4: { Damage: 190, AttackSpeed: 8.5, Range: 19, UpgradePrice: 3000 },
				5: { Damage: 220, AttackSpeed: 8, Range: 20, UpgradePrice: 4800 },
				6: {
					Damage: 270,
					AttackSpeed: 8,
					Range: 22,
					UpgradePrice: 6200,
					AttackEffectDuration: 8,
					Ability: "Black Hole",
					AttackType: "Full",
				},
				7: { Damage: 320, AttackSpeed: 7.5, Range: 23, UpgradePrice: 7300 },
			},
		},
		animations: {
			idle: "124214532787267",
			walk: "17264216432",
			special: "103195226449249", // cape
		},
		radius: 2.5,
		tradable: false,
	},
};

// Helper functions for querying units
export function getUnitByName(name: string): UnitData | undefined {
	return UnitsRegistry[name];
}

export function getUnitsByRarity(rarity: UnitRarity): UnitData[] {
	const entries = [];
	for (const [, unit] of pairs(UnitsRegistry)) {
		if (unit.configuration.Rarity === rarity) {
			entries.push(unit);
		}
	}
	return entries;
}

export function getUnitsByElement(element: UnitElement): UnitData[] {
	const entries = [];
	for (const [, unit] of pairs(UnitsRegistry)) {
		if (unit.configuration.Element === element) {
			entries.push(unit);
		}
	}
	return entries;
}

export function getEvolutionChain(unitName: string): string[] {
	const unit = UnitsRegistry[unitName];
	if (!unit) return [];

	const chain: string[] = [unitName];

	// Find evolutions
	if (unit.configuration.EvolveData) {
		for (const evolve of unit.configuration.EvolveData) {
			chain.push(evolve.EvolvesInto);
		}
	}

	return chain;
}

export function canEvolve(unitName: string): boolean {
	const unit = UnitsRegistry[unitName];
	return !!(unit?.configuration.EvolveData && unit.configuration.EvolveData.size() > 0);
}

export function getUnitPassives(unitName: string): readonly string[] {
	const unit = UnitsRegistry[unitName];
	return unit?.configuration.Passives || [];
}

export function getAllUnitNames(): string[] {
	const names = [];
	for (const [name] of pairs(UnitsRegistry)) {
		names.push(name);
	}
	return names;
}

export function getUnitsCount(): number {
	let count = 0;
	for (const [,] of pairs(UnitsRegistry)) {
		count++;
	}
	return count;
}
