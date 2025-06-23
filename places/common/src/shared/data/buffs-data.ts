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
	readonly stackable?: boolean;
	readonly effects: {
		readonly damageMultiplier?: number;
		readonly healthMultiplier?: number;
		readonly speedMultiplier?: number;
		readonly rangeMultiplier?: number;
		readonly critChance?: number;
		readonly critDamage?: number;
	};
}

/**
 * All buffs organized by their internal names
 */
export const BuffsRegistry: Record<string, BuffData> = {
	StatPotentials: {
		name: "StatPotentials",
		displayName: "Stat Potentials",
		description: "Enhances unit stats based on potential grades",
		effects: {},
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
