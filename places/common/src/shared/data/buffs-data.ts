import buffs from "@shared/configuration/buffs-data.json";

export type StatPotentials = typeof buffs;
export type StatName = keyof Omit<
	StatPotentials,
	"Order" | "OrderNums" | "Weights" | "Weights50Worth" | "Weights100Worth"
>;
export type StatGrade = StatPotentials["Order"][number];

/**
 * Stat potential multipliers for different grades
 * Higher grades provide better stat multipliers
 */
export const StatPotentials: StatPotentials = buffs;

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
	export function getStatPotentialMultiplier(stat: StatName, grade: StatGrade): number {
		return (StatPotentials[stat] as Record<StatGrade, number>)[grade];
	}

	/**
	 * Get all stat grades in order from worst to best
	 */
	export function getStatGradesOrdered(): StatGrade[] {
		return [...StatPotentials.Order];
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
	export function calculateStatWithPotential(baseStat: number, statType: StatName, grade: StatGrade): number {
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
			SS: Color3.fromRGB(255, 255, 0), // Yellow
			SSS: Color3.fromRGB(255, 0, 0), // Red
		};

		return gradeColors[grade];
	}
}
