import elementalModifiers from "@shared/configuration/elemental-modifiers-data.json";

export type ElementalModifiersRegistry = typeof elementalModifiers;
export type ElementName = keyof ElementalModifiersRegistry;
export type ElementalModifierData = ElementalModifiersRegistry[ElementName];

/**
 * All elemental modifiers organized by their internal names
 */
export const ElementalModifiersRegistry: ElementalModifiersRegistry = elementalModifiers;

/**
 * Helper functions for working with elemental modifiers
 */
export namespace ElementalModifiersData {
	/**
	 * Get elemental modifier data by name
	 */
	export function getElementalModifier(name: ElementName): ElementalModifierData | undefined {
		return ElementalModifiersRegistry[name];
	}

	/**
	 * Get the damage buff for a specific element
	 */
	export function getDamageBuff(name: ElementName): number | undefined {
		return ElementalModifiersRegistry[name]?.DamageBuff;
	}

	/**
	 * Get the damage debuff for a specific element
	 */
	export function getDamageDebuff(name: ElementName): number | undefined {
		return ElementalModifiersRegistry[name]?.DamageDebuff;
	}
}
