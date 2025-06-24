/**
 * Buffs Registry Data - Migrated from live game
 * Contains all buff systems including stat potentials
 */

export type StatGrade = "C-" | "C" | "C+" | "B-" | "B" | "B+" | "A-" | "A" | "A+" | "S-" | "S" | "S+";

export interface StatPotentialsData {
	readonly Damage: Record<StatGrade, number>;
	readonly Health: Record<StatGrade, number>;
	readonly Range: Record<StatGrade, number>;
	readonly Speed: Record<StatGrade, number>;
}

/**
 * Stat potential multipliers for different grades
 * Higher grades provide better stat multipliers
 */
export const StatPotentials: StatPotentialsData = {
	Damage: {
		"C-": 0.9,
		C: 0.935,
		"C+": 0.97,
		"B-": 1,
		B: 1.03,
		"B+": 1.065,
		"A-": 1.1,
		A: 1.125,
		"A+": 1.15,
		"S-": 1.175,
		S: 1.2,
		"S+": 1.225,
	},
	Health: {
		"C-": 0.9,
		C: 0.935,
		"C+": 0.97,
		"B-": 1,
		B: 1.03,
		"B+": 1.065,
		"A-": 1.1,
		A: 1.125,
		"A+": 1.15,
		"S-": 1.175,
		S: 1.2,
		"S+": 1.225,
	},
	Range: {
		"C-": 0.85,
		C: 0.9,
		"C+": 0.95,
		"B-": 1,
		B: 1.05,
		"B+": 1.1,
		"A-": 1.15,
		A: 1.2,
		"A+": 1.25,
		"S-": 1.3,
		S: 1.35,
		"S+": 1.4,
	},
	Speed: {
		"C-": 0.85,
		C: 0.9,
		"C+": 0.95,
		"B-": 1,
		B: 1.05,
		"B+": 1.1,
		"A-": 1.15,
		A: 1.2,
		"A+": 1.25,
		"S-": 1.3,
		S: 1.35,
		"S+": 1.4,
	},
} as const;

export interface BuffData {
	readonly name: string;
	readonly displayName: string;
	readonly description: string;
	readonly duration?: number;
	readonly type: "Buff" | "Debuff" | "Special";
	readonly duration?: number;
	readonly stackable?: boolean;
	readonly maxStacks?: number;
	readonly effects: {
		readonly damageMultiplier?: number;
		readonly damageMultiplierPerStack?: number;
		readonly attackSpeedMultiplier?: number; // Maps to Luau's attackSpeedMultiplier
		readonly damageReduction?: number;
		readonly damageReductionPerStack?: number;
		readonly healthPerSecond?: number; // as a percentage, e.g., 0.02 for 2%
		readonly damagePerSecondPerStack?: number; // as a percentage
		readonly damageImmunity?: boolean;
		// Allow any other string keys for effects from Luau
		readonly [effectKey: string]: any;
	};
	readonly visualEffect?: string;
}

/**
 * All buffs organized by their internal names
 */
export const BuffsRegistry: Record<string, BuffData> = {
	StatPotentials: {
		name: "StatPotentials",
		displayName: "Stat Potentials",
		description: "Enhances unit stats based on potential grades",
		type: "Special", // Added type for consistency
		effects: {},
	},
	strength_buff: {
		name: "strength_buff",
		displayName: "Strength",
		description: "Increases damage output",
		type: "Buff",
		duration: 60,
		stackable: false,
		effects: {
			damageMultiplier: 1.25,
		},
		visualEffect: "StrengthAura",
	},
	rage_buff: {
		name: "rage_buff",
		displayName: "Rage",
		description: "Stacking damage increase",
		type: "Buff",
		duration: 30,
		stackable: true,
		maxStacks: 10,
		effects: {
			damageMultiplierPerStack: 0.05,
		},
		visualEffect: "RageParticles",
	},
	haste_buff: {
		name: "haste_buff",
		displayName: "Haste",
		description: "Increases attack speed",
		type: "Buff",
		duration: 45,
		stackable: false,
		effects: {
			attackSpeedMultiplier: 1.3,
		},
		visualEffect: "HasteTrail",
	},
	frenzy_buff: {
		name: "frenzy_buff",
		displayName: "Frenzy",
		description: "Dramatically increases attack speed",
		type: "Buff",
		duration: 15,
		stackable: false,
		effects: {
			attackSpeedMultiplier: 2.0,
		},
		visualEffect: "FrenzyEffect",
	},
	shield_buff: {
		name: "shield_buff",
		displayName: "Shield",
		description: "Reduces incoming damage",
		type: "Buff",
		duration: 120,
		stackable: false,
		effects: {
			damageReduction: 0.25,
		},
		visualEffect: "ShieldGlow",
	},
	armor_buff: {
		name: "armor_buff",
		displayName: "Armor",
		description: "Stacking damage reduction",
		type: "Buff",
		duration: 90,
		stackable: true,
		maxStacks: 5,
		effects: {
			damageReductionPerStack: 0.05,
		},
		visualEffect: "ArmorPlating",
	},
	regeneration_buff: {
		name: "regeneration_buff",
		displayName: "Regeneration",
		description: "Restores health over time",
		type: "Buff",
		duration: 60,
		stackable: false,
		effects: {
			healthPerSecond: 0.02, // 2% per second
		},
		visualEffect: "HealingAura",
	},
	poison_debuff: {
		name: "poison_debuff",
		displayName: "Poison",
		description: "Deals damage over time",
		type: "Debuff",
		duration: 30,
		stackable: true,
		maxStacks: 3,
		effects: {
			damagePerSecondPerStack: 0.01, // 1% per second per stack
		},
		visualEffect: "PoisonCloud",
	},
	slow_debuff: {
		name: "slow_debuff",
		displayName: "Slow",
		description: "Reduces attack speed",
		type: "Debuff",
		duration: 20,
		stackable: false,
		effects: {
			attackSpeedMultiplier: 0.7,
		},
		visualEffect: "SlowEffect",
	},
	weakness_debuff: {
		name: "weakness_debuff",
		displayName: "Weakness",
		description: "Reduces damage output",
		type: "Debuff",
		duration: 40,
		stackable: false,
		effects: {
			damageMultiplier: 0.75,
		},
		visualEffect: "WeaknessAura",
	},
	invincibility_buff: {
		name: "invincibility_buff",
		displayName: "Invincibility",
		description: "Immune to all damage",
		type: "Special",
		duration: 5,
		stackable: false,
		effects: {
			damageImmunity: true,
		},
		visualEffect: "InvincibilityGlow",
	},
} as const;

/**
 * Helper functions for working with buffs and stat potentials
 */
export namespace BuffsData {
	/**
	 * Get buff data by name
	 */
	export function getBuff(name: string): BuffData | undefined {
		return BuffsRegistry[name];
	}

	/**
	 * Get stat potential multiplier
	 */
	export function getStatPotentialMultiplier(stat: keyof StatPotentialsData, grade: StatGrade): number {
		return StatPotentials[stat][grade];
	}

	/**
	 * Get all stat grades in order from worst to best
	 */
	export function getStatGradesOrdered(): StatGrade[] {
		return ["C-", "C", "C+", "B-", "B", "B+", "A-", "A", "A+", "S-", "S", "S+"];
	}

	/**
	 * Compare two stat grades (returns true if first is better than second)
	 */
	export function isGradeBetter(grade1: StatGrade, grade2: StatGrade): boolean {
		const orderedGrades = getStatGradesOrdered();
		const index1 = orderedGrades.indexOf(grade1);
		const index2 = orderedGrades.indexOf(grade2);
		return index1 > index2;
	}

	/**
	 * Get the next higher grade (if any)
	 */
	export function getNextGrade(grade: StatGrade): StatGrade | undefined {
		const orderedGrades = getStatGradesOrdered();
		const currentIndex = orderedGrades.indexOf(grade);
		if (currentIndex < orderedGrades.size() - 1) {
			return orderedGrades[currentIndex + 1];
		}
		return undefined;
	}

	/**
	 * Get the previous lower grade (if any)
	 */
	export function getPreviousGrade(grade: StatGrade): StatGrade | undefined {
		const orderedGrades = getStatGradesOrdered();
		const currentIndex = orderedGrades.indexOf(grade);
		if (currentIndex > 0) {
			return orderedGrades[currentIndex - 1];
		}
		return undefined;
	}

	/**
	 * Calculate total stat multiplier with potential
	 */
	export function calculateStatWithPotential(
		baseStat: number,
		statType: keyof StatPotentialsData,
		grade: StatGrade,
	): number {
		const multiplier = getStatPotentialMultiplier(statType, grade);
		return baseStat * multiplier;
	}

	/**
	 * Get random stat grade with weighted probability
	 * Higher grades are rarer
	 */
	export function getRandomStatGrade(): StatGrade {
		const random = math.random();

		// Weighted probabilities (higher grades are rarer)
		if (random < 0.15) return "C-";
		if (random < 0.25) return "C";
		if (random < 0.35) return "C+";
		if (random < 0.5) return "B-";
		if (random < 0.65) return "B";
		if (random < 0.78) return "B+";
		if (random < 0.88) return "A-";
		if (random < 0.94) return "A";
		if (random < 0.97) return "A+";
		if (random < 0.985) return "S-";
		if (random < 0.995) return "S";
		return "S+";
	}

	/**
	 * Get grade color for UI display
	 */
	export function getGradeColor(grade: StatGrade): Color3 {
		const gradeColors: Record<StatGrade, Color3> = {
			"C-": Color3.fromRGB(150, 150, 150), // Gray
			C: Color3.fromRGB(180, 180, 180),
			"C+": Color3.fromRGB(210, 210, 210),
			"B-": Color3.fromRGB(100, 200, 100), // Green
			B: Color3.fromRGB(120, 220, 120),
			"B+": Color3.fromRGB(140, 240, 140),
			"A-": Color3.fromRGB(100, 150, 255), // Blue
			A: Color3.fromRGB(120, 170, 255),
			"A+": Color3.fromRGB(140, 190, 255),
			"S-": Color3.fromRGB(255, 100, 255), // Purple
			S: Color3.fromRGB(255, 120, 255),
			"S+": Color3.fromRGB(255, 140, 255),
		};

		return gradeColors[grade];
	}
}
