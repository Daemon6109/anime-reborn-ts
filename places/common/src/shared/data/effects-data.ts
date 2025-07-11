import effects from "@shared/configuration/effects-data.json";

// Performance-optimized exact typing from JSON
export const effectsData = effects as typeof effects;

// Extract actual effect names as literal union type from the JSON
export type EffectName = keyof typeof effectsData;
export type EffectsRegistry = typeof effects;
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

export interface PlayerEffectData {
	id: EffectName; // unique identifier for the effect
	duration: number; // duration in seconds
	startTime: number; // Unix timestamp when effect started
}

export type ExactConfiguration<T extends EffectName> = (typeof effectsData)[T];

// Dynamically extract all multiplier types from the effects configuration
type ExtractMultiplierKeys<T> = T extends { Multiplier: infer M } ? keyof M : never;
export type MultiplierType = ExtractMultiplierKeys<(typeof effectsData)[EffectName]>;

// Create a constant array of effect names for runtime use
export const EFFECT_NAMES = (() => {
	const effectNames: EffectName[] = [];

	// Extract all effect names from the effects configuration
	for (const [effectName] of pairs(effectsData)) {
		effectNames.push(effectName);
	}

	return effectNames as readonly EffectName[];
})();

// Create a constant array of multiplier types for runtime use
export const MULTIPLIER_TYPES = (() => {
	const multiplierTypes = new Set<string>();

	// Extract all multiplier keys from all effects
	for (const [effectName, effectConfig] of pairs(effectsData)) {
		if (effectConfig.Multiplier) {
			for (const [multiplierKey] of pairs(effectConfig.Multiplier)) {
				multiplierTypes.add(multiplierKey as string);
			}
		}
	}

	return [...multiplierTypes] as readonly string[];
})();
