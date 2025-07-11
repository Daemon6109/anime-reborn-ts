import specialAbilities from "@shared/configuration/special-abilities-data.json";

export type SpecialAbilitiesRegistry = typeof specialAbilities;
export type SpecialAbilityName = keyof SpecialAbilitiesRegistry;
export type SpecialAbilityData = SpecialAbilitiesRegistry[SpecialAbilityName];

/**
 * All special abilities organized by their internal names
 */
export const SpecialAbilitiesRegistry: SpecialAbilitiesRegistry = specialAbilities;

/**
 * Helper functions for working with special abilities
 */
export namespace SpecialAbilitiesData {
	/**
	 * Get special ability data by name
	 */
	export function getSpecialAbility(name: SpecialAbilityName): SpecialAbilityData | undefined {
		return SpecialAbilitiesRegistry[name];
	}
}
