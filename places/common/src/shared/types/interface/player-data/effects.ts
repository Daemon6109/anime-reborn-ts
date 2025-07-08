// Configuration
import effectsDataRaw from "@shared/configuration/effects-data.json";
// Performance-optimized exact typing from JSON
export const effectsData = effectsDataRaw as typeof effectsDataRaw;

// Extract actual effect names as literal union type from the JSON
export type EffectName = keyof typeof effectsData;
export type ExactConfiguration<T extends EffectName> = (typeof effectsData)[T];

// Dynamically extract all multiplier types from the effects configuration
type ExtractMultiplierKeys<T> = T extends { Multiplier: infer M } ? keyof M : never;
export type MultiplierType = ExtractMultiplierKeys<(typeof effectsData)[EffectName]>;

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

export interface EffectData {
	id: EffectName; // unique identifier for the effect
	duration: number; // duration in seconds
	startTime: number; // Unix timestamp when effect started
}

export default interface PlayerDataEffects {
	id: EffectName; // unique identifier for the effect
	duration: number; // duration in seconds
	startTime: number; // Unix timestamp when effect started
}
