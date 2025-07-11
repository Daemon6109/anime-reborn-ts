import statusEffects from "@shared/configuration/status-effects-data.json";

export type StatusEffectsRegistry = typeof statusEffects;
export type StatusEffectName = keyof StatusEffectsRegistry;
export type StatusEffectData = StatusEffectsRegistry[StatusEffectName] & {
	damageMultiplier?: number;
};

/**
 * All status effects organized by their internal names
 */
export const StatusEffectsRegistry: StatusEffectsRegistry = statusEffects;

/**
 * Helper functions for working with status effects
 */
export namespace StatusEffectsData {
	/**
	 * Get status effect data by name
	 */
	export function getStatusEffect(name: StatusEffectName): StatusEffectData | undefined {
		return StatusEffectsRegistry[name];
	}

	/**
	 * Get all damage over time effects
	 */
	export function getDamageOverTimeEffects(): Record<string, StatusEffectData> {
		const dotEffects: Record<string, StatusEffectData> = {};
		for (const [name, effect] of pairs(StatusEffectsRegistry)) {
			if ((effect as StatusEffectData).damageMultiplier !== undefined) {
				dotEffects[name as string] = effect;
			}
		}
		return dotEffects;
	}

	/**
	 * Get all crowd control effects (stun, slow, etc.)
	 */
	export function getCrowdControlEffects(): Record<string, StatusEffectData> {
		const ccEffects: Record<string, StatusEffectData> = {};
		const ccNames = ["Stun", "Slow", "Frozen", "Paralysis", "Fear"];

		for (const [name, effect] of pairs(StatusEffectsRegistry)) {
			if (ccNames.includes(name as string)) {
				ccEffects[name as string] = effect;
			}
		}
		return ccEffects;
	}

	/**
	 * Get all stackable effects
	 */
	export function getStackableEffects(): Record<string, StatusEffectData> {
		const stackableEffects: Record<string, StatusEffectData> = {};
		for (const [name, effect] of pairs(StatusEffectsRegistry)) {
			if (effect.stackable === true) {
				stackableEffects[name as string] = effect;
			}
		}
		return stackableEffects;
	}

	/**
	 * Check if effect has cooldown
	 */
	export function hasCooldown(name: StatusEffectName): boolean {
		const effect = StatusEffectsRegistry[name];
		return effect !== undefined && effect.effectCooldown > 0;
	}

	/**
	 * Get effect display name
	 */
	export function getDisplayName(name: StatusEffectName): string | undefined {
		return StatusEffectsRegistry[name]?.displayName;
	}

	/**
	 * Check if effect is stackable
	 */
	export function isStackable(name: StatusEffectName): boolean {
		return StatusEffectsRegistry[name]?.stackable === true;
	}

	/**
	 * Get effect duration
	 */
	export function getDuration(name: StatusEffectName): number | undefined {
		const effect = StatusEffectsRegistry[name];
		return effect && "duration" in effect ? effect.duration : undefined;
	}

	/**
	 * Get damage multiplier for effect
	 */
	export function getDamageMultiplier(name: StatusEffectName): number | undefined {
		const effect = StatusEffectsRegistry[name];
		return effect && "damageMultiplier" in effect ? effect.damageMultiplier : undefined;
	}
}
