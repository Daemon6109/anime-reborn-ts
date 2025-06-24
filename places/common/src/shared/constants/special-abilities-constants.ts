import { SpecialAbilityVisual } from "./visual-constants"; // Assuming visual constants will be defined elsewhere

// TODO: Define Enums.SpecialCooldownGroups and Enums.SpecialAbilityTypes
// For now, using string as a placeholder
type SpecialCooldownGroups = string;
type SpecialAbilityTypes = string;

interface BuffData {
	Damage?: number;
	AttackSpeed?: number;
	Range?: number;
}

interface HitConfig {
	HitCount: number;
	MultihitDelay: number;
}

interface AbilityData {
	Money?: number;
	Heal?: string | number;
	callback?: (unit: any) => void; // Using 'any' for now, should be a proper Unit type
	onEndCallback?: (unit: any) => void; // Using 'any' for now, should be a proper Unit type
}

export interface SpecialAbilityConfiguration {
	DisplayName: string;
	AbilityImage: string;
	Description?: string;
	Cooldown: number;
	Multiplier?: number;
	Percent?: number;
	IsGlobalCooldown: boolean;
	IsGlobalAbility: boolean;
	CooldownGroup: SpecialCooldownGroups;
	AbilityType: SpecialAbilityTypes;
	Windup: number;
	Duration: number;
	Root?: any; // Should be a proper ModuleScript type
	Status?: string;
	StatusDuration?: number;
	IsSupport?: boolean;
	AbilityData?: AbilityData;
	CustomCallback?: (unit: any) => void; // Using 'any' for now, should be a proper Unit type
	HitConfig?: HitConfig;
	Visuals?: SpecialAbilityVisual; // Link to visual definitions
}

export const SpecialAbilities: { [key: string]: SpecialAbilityConfiguration } = {
	All_Range_Atomic: {
		DisplayName: "All Range: Atomic",
		AbilityImage: "rbxassetid://118971788437448",
		Description: "Using the power of Nuclear Magic, unleashes an immense power, dealing x20 of his DMG to all the enemies on the map. (GLOBAL CD)",
		Cooldown: 300,
		Multiplier: 20,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "Nuke", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 2.95,
		Duration: 0.6,
		// Root: script, // This will be handled differently in TS
		HitConfig: {
			HitCount: 5,
			MultihitDelay: 0.15,
		},
	},
	Anti_Spirit_Domain: {
		DisplayName: "Anti-Spirit Domain",
		AbilityImage: "rbxassetid://110784579191257",
		Description: "Forms an exorcist domain. Enemies who step inside the domain recieve +30% incoming DMG. The domain lasts for 10s. (GLOBAL CD)",
		Cooldown: 50,
		IsSupport: true,
		IsGlobalCooldown: true,
		IsGlobalAbility: false,
		CooldownGroup: "Barrier", // Enums.SpecialCooldownGroups
		AbilityType: "OnTickCallback", // Enums.SpecialAbilityTypes
		AbilityData: {
			// callback and onEndCallback functions will need to be adapted
			// For now, leaving them as placeholders or to be implemented in service logic
		},
		Windup: 0,
		Duration: 10,
		// Root: script,
	},
	Bird_Cage: {
		DisplayName: "Bird Cage",
		AbilityImage: "rbxassetid://73271547622559",
		Description: "String Mage attacks every enemy on the map 15 times dealing 1% of the enemy's max health each hit, 300s Cooldown (GLOBAL CD)",
		Cooldown: 300,
		Percent: 0.01,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "Nuke", // Enums.SpecialCooldownGroups
		AbilityType: "PercentDamage", // Enums.SpecialAbilityTypes
		Windup: 0.5,
		Duration: 1,
		// Root: script,
		HitConfig: {
			HitCount: 15,
			MultihitDelay: 0.05,
		},
	},
	Breakdown_Sphere: {
		DisplayName: "Breakdown Sphere",
		AbilityImage: "rbxassetid://108716801185518",
		Cooldown: 120,
		Multiplier: 1.5,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 3,
		Duration: 2,
		// Root: script,
		Status: "Dark Flames",
		StatusDuration: 16,
		HitConfig: {
			HitCount: 10,
			MultihitDelay: 0.2,
		},
	},
	Cat_Business: {
		DisplayName: "Jay the Catboss",
		AbilityImage: "rbxassetid://18873417331",
		Cooldown: 22,
		IsSupport: true,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "Money", // Enums.SpecialAbilityTypes
		AbilityData: {
			Money: 100000000000,
		},
		Windup: 1,
		Duration: 0,
		// Root: script,
	},
	Delta_Force_Core_Breaker: {
		DisplayName: "Delta Force: Core Breaker",
		AbilityImage: "rbxassetid://92037185591338",
		Description: "Heroically sacrificing himself, one of the brothers causes a map-wide Nuke explosion, dealing 15% damage to enemies (out of their MAX HP), dealing damage to foes, and increasing his remaining brother's DMG by +15%, and RNG by +5% for 800s. (GLOBAL CD)",
		Cooldown: 800,
		Percent: 0.15,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "Nuke", // Enums.SpecialCooldownGroups
		AbilityType: "PercentDamage", // Enums.SpecialAbilityTypes
		Windup: 4.95,
		Duration: 1,
		// Root: script,
		// CustomCallback will be handled in service logic
		HitConfig: {
			HitCount: 1,
			MultihitDelay: 0.35,
		},
	},
	Domain_Expansion_Unlimited_Void: {
		DisplayName: "Unlimited Void",
		AbilityImage: "rbxassetid://18468127403",
		Cooldown: 500,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "Domains", // Enums.SpecialCooldownGroups
		AbilityType: "Stop", // Enums.SpecialAbilityTypes
		Windup: 5,
		Duration: 6,
		// Root: script,
	},
	Dragon_Emperor_Flaming_Wrath: {
		DisplayName: "Dragon Emperor: Flaming Wrath",
		AbilityImage: "rbxassetid://93251523993419",
		Description: "Transforms into the Mythical West Dragon and releases a rain of flaming projectiles, dealing x2.5 of his DMG and applying `Burning` status for 8 seconds.",
		Cooldown: 100,
		Multiplier: 2.5,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 2,
		Duration: 3,
		// Root: script,
		Status: "Burning",
		StatusDuration: 8,
		HitConfig: {
			HitCount: 7,
			MultihitDelay: 0.2,
		},
	},
	Ennoodzuno: {
		DisplayName: "Ennoodzuno",
		AbilityImage: "rbxassetid://97306784778544",
		Description: "Using the power of Poison Curse, enchances her physical strength, increasing DMG by +30% for 10 seconds.",
		Cooldown: 45,
		IsSupport: true,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "Buffs", // Enums.SpecialCooldownGroups
		AbilityType: "BuffByElement", // Enums.SpecialAbilityTypes
		BuffData: {
			Damage: 0.3,
		},
		Windup: 1,
		Duration: 10,
		// Root: script,
	},
	Eternal_Frost_Buddha: {
		DisplayName: "Eternal Frost: Buddha",
		AbilityImage: "rbxassetid://114199403214505",
		Description: "Summons a Frost Statue, dealing x2.5 of his DMG, applying `Frozen` status for 5 seconds.",
		Cooldown: 120,
		Multiplier: 2.5,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 2.7,
		Duration: 1,
		// Root: script,
		Status: "Frozen",
		StatusDuration: 5,
		HitConfig: {
			HitCount: 1,
			MultihitDelay: 0.1,
		},
	},
	Final_Ressuruction: {
		DisplayName: "Final Ressuruction",
		AbilityImage: "rbxassetid://118971788437448",
		Description: "Using the power of his shadows, unleashes an immense power, dealing x25 of his DMG to all the enemies on the map. (GLOBAL CD)",
		Cooldown: 300,
		Multiplier: 25,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "Nuke", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 10,
		Duration: 0.6,
		// Root: script,
		HitConfig: {
			HitCount: 5,
			MultihitDelay: 0.15,
		},
	},
	God_s_Wrath_Meggido: {
		DisplayName: "God's Wrath: Meggido",
		AbilityImage: "rbxassetid://125878032783824",
		Description: "Focusing sun rays through water bubbles - releases precises shots of an immense power. Does x2 of their DMG and applies `Slow` status for 3s.",
		Cooldown: 90,
		Multiplier: 2,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 4,
		Duration: 3,
		// Root: script,
		Status: "Slow",
		StatusDuration: 3,
		HitConfig: {
			HitCount: 7,
			MultihitDelay: 0.35,
		},
	},
	Goddesses_Grace_Agility: {
		DisplayName: "Grace of Agility",
		AbilityImage: "rbxassetid://18864972760",
		Cooldown: 65,
		IsSupport: true,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "Buffs", // Enums.SpecialCooldownGroups
		AbilityType: "Buff", // Enums.SpecialAbilityTypes
		BuffData: {
			AttackSpeed: 0.25,
			Range: 0.45,
		},
		Windup: 1,
		Duration: 30,
		// Root: script,
	},
	Goddesses_Grace_Might: {
		DisplayName: "Grace of Might",
		AbilityImage: "rbxassetid://107241719912180",
		Description: "Channeling her Godly power buffs her fellow adventurer's DMG and RNG by +15% for 45s.",
		Cooldown: 80,
		IsSupport: true,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "Buffs", // Enums.SpecialCooldownGroups
		AbilityType: "Buff", // Enums.SpecialAbilityTypes
		BuffData: {
			Damage: 0.15,
			Range: 0.15,
		},
		Windup: 1,
		Duration: 45,
		// Root: script,
	},
	Healing: {
		DisplayName: "Healing",
		AbilityImage: "rbxassetid://18873417331",
		Description: "Heals the base.",
		Cooldown: 90,
		IsSupport: true,
		IsGlobalCooldown: true,
		IsGlobalAbility: false,
		CooldownGroup: "Heal", // Enums.SpecialCooldownGroups
		AbilityType: "Healing", // Enums.SpecialAbilityTypes
		AbilityData: {
			Heal: "Damage", // This might need specific handling or a more defined type
		},
		Windup: 3,
		Duration: 0,
		// Root: script,
	},
	Heavens_Time_Stop: {
		DisplayName: "Almighty Time Stop",
		AbilityImage: "rbxassetid://122958351137577",
		Description: "With the awakened Godly power, stops the time flow of enemies for 20 seconds. (MAP-WIDE) ; (GLOBAL COOLDOWN)",
		Cooldown: 300,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "Stop", // Enums.SpecialAbilityTypes
		Windup: 2,
		Duration: 20,
		// Root: script,
	},
	Holy_Sword_Excalibur: {
		DisplayName: "Holy Sword: Excalibur",
		AbilityImage: "rbxassetid://109209494536924",
		Description: "Unleashing Excalibur's holy power, deals x3 of her DMG.",
		Cooldown: 120,
		Multiplier: 3,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 2,
		Duration: 3,
		// Root: script,
		HitConfig: {
			HitCount: 10,
			MultihitDelay: 0.1,
		},
	},
	Love_Train: {
		DisplayName: "Love Train",
		AbilityImage: "rbxassetid://86501896578741",
		Description: "Using Love Train places an multi-dimensional barrier on the base, making enemies not being able to reach it for 15s, ability windup is 5s.",
		Cooldown: 500,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "BaseSave", // Enums.SpecialCooldownGroups
		AbilityType: "LoveTrain", // Enums.SpecialAbilityTypes
		Percent: 0.7,
		Windup: 5,
		Duration: 15,
		// Root: script,
	},
	Monarch_Destruction: {
		DisplayName: "Monarch Destruction",
		AbilityImage: "rbxassetid://110868948016520",
		Description: "Using the power of Monarch, unleashes an immense power, dealing 10x of his DMG to all the enemies on the map. (GLOBAL CD)",
		Cooldown: 300,
		Multiplier: 10,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "Nuke", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 0.15,
		Duration: 0.6,
		// Root: script,
		HitConfig: {
			HitCount: 10,
			MultihitDelay: 0.05,
		},
	},
	Purple_Grace_Agility: { // Note: This seems to be a duplicate of Goddesses_Grace_Agility with a different key
		DisplayName: "Grace of Agility",
		AbilityImage: "rbxassetid://18864972760",
		Cooldown: 65,
		IsSupport: true,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "Buffs", // Enums.SpecialCooldownGroups
		AbilityType: "Buff", // Enums.SpecialAbilityTypes
		BuffData: {
			AttackSpeed: 0.25,
			Range: 0.45,
		},
		Windup: 1,
		Duration: 30,
		// Root: script,
	},
	Purple_Grace_Might: { // Note: This seems to be a duplicate of Goddesses_Grace_Might with a different key
		DisplayName: "Grace of Might",
		AbilityImage: "rbxassetid://18864972091",
		Cooldown: 65, // Cooldown is different from Goddesses_Grace_Might (80)
		IsSupport: true,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "Buffs", // Enums.SpecialCooldownGroups
		AbilityType: "Buff", // Enums.SpecialAbilityTypes
		BuffData: {
			Damage: 0.25,
			AttackSpeed: 0.25,
		},
		Windup: 1,
		Duration: 30,
		// Root: script,
	},
	Room: {
		DisplayName: "Room",
		AbilityImage: "rbxassetid://86357188237449",
		Description: "Sentinel uses his powers summoning a massive room dealing x10 damage to all enemies on the map, 500s Cooldown (GLOBAL CD)",
		Cooldown: 500,
		Multiplier: 10,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "Nuke", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 0.15,
		Duration: 0.6,
		// Root: script,
		HitConfig: {
			HitCount: 10,
			MultihitDelay: 0.05,
		},
	},
	Time_Accel: {
		DisplayName: "Time Accel",
		AbilityImage: "rbxassetid://97306784778544",
		Description: "Accelerates his brain processing speed, decreasing SPA by -30% for 10s.",
		Cooldown: 45,
		IsSupport: true,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "Buffs", // Enums.SpecialCooldownGroups
		AbilityType: "SelfBuff", // Enums.SpecialAbilityTypes
		BuffData: {
			AttackSpeed: 0.30,
		},
		Windup: 1,
		Duration: 10,
		// Root: script,
	},
	Time_Magic_Freeze: {
		DisplayName: "Time Freeze",
		AbilityImage: "rbxassetid://115027077806236",
		Description: "Using Time Magic, causes a local time-stop within his range, stopping enemies for 9s.",
		Cooldown: 75,
		IsGlobalCooldown: true, // This was true in Luau
		IsGlobalAbility: false,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "Stop", // Enums.SpecialAbilityTypes
		Windup: 0,
		Duration: 9,
		// Root: script,
	},
	Time_Warp: {
		DisplayName: "Time Warp",
		AbilityImage: "rbxassetid://122958351137577",
		Description: "When this ability is used activate a 10 second time stop, after the end of Time Stop, increase damage taken by 20% (stacks with 10% from Gods Aura) by 5 seconds. (Global CD)",
		Cooldown: 260,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "WhisStop", // Enums.SpecialAbilityTypes
		Windup: 2,
		Duration: 10,
		// Root: script,
	},
	Ulq_Destruction: {
		DisplayName: "The Void's Final Judgment",
		AbilityImage: "rbxassetid://110868948016520",
		Description: "With a cold command, Ulquiorra unleashes The Void's Final Judgment . The world shatters and enemies vanish as the entire map is consumed by an all-consuming void. Does 10x Damage (global cd).",
		Cooldown: 300,
		Multiplier: 10,
		IsGlobalCooldown: true,
		IsGlobalAbility: true,
		CooldownGroup: "Nuke", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 0.15,
		Duration: 0.6,
		// Root: script,
		HitConfig: {
			HitCount: 10,
			MultihitDelay: 0.05,
		},
	},
	Water_Dragon: {
		DisplayName: "Water Dragon",
		AbilityImage: "rbxassetid://125878032783824",
		Description: "Using the Art of Ninjutsu casts Water Dragons, dealing x4 of his DMG, and applies `Slow` status for 3s.",
		Cooldown: 90,
		Multiplier: 4,
		IsGlobalCooldown: false,
		IsGlobalAbility: false,
		CooldownGroup: "General", // Enums.SpecialCooldownGroups
		AbilityType: "Damage", // Enums.SpecialAbilityTypes
		Windup: 2.2,
		Duration: 3,
		// Root: script,
		Status: "Slow",
		StatusDuration: 3,
		HitConfig: {
			HitCount: 1,
			MultihitDelay: 0.35,
		},
	},
};
