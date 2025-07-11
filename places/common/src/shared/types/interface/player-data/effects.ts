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

// Types
import type { PlayerEffectData } from "@shared/data/effects-data";

export type { PlayerEffectData };
export default PlayerEffectData;
