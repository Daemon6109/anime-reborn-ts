import effects from "@shared/configuration/effects-data.json";

export type EffectsRegistry = typeof effects;
export type EffectName = keyof EffectsRegistry;
export type EffectData = EffectsRegistry[EffectName];
export type EffectMultiplier = EffectData["Multiplier"];

/**
 * All effects organized by their internal names
 */
export const EffectsRegistry: EffectsRegistry = effects;

/**
 * Helper functions for working with effects
 */
export namespace EffectsData {
	/**
	 * Get effect data by name
	 */
	export function getEffect(name: EffectName): EffectData | undefined {
		return EffectsRegistry[name];
	}

	/**
	 * Get the icon for a specific effect
	 */
	export function getIcon(name: EffectName): string | undefined {
		return EffectsRegistry[name]?.Icon;
	}

	/**
	 * Get the description for a specific effect
	 */
	export function getDescription(name: EffectName): string | undefined {
		return EffectsRegistry[name]?.Description;
	}

	/**
	 * Get the display name for a specific effect
	 */
	export function getDisplayName(name: EffectName): string | undefined {
		return EffectsRegistry[name]?.DisplayName;
	}

	/**
	 * Get the multiplier for a specific effect
	 */
	export function getMultiplier(name: EffectName): EffectMultiplier | undefined {
		return EffectsRegistry[name]?.Multiplier;
	}
}
