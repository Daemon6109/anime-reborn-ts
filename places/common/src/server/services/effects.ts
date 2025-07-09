// Packages
import { Service, OnInit } from "@flamework/core";
import { Players } from "@rbxts/services";

// Dependencies
import { DataStore } from "@services/player-data";
import { Analytics } from "@services/analytics";

// Utils
import { safePlayerAdded } from "@shared/utils/safe-player-added";

import type { EffectName, ExactConfiguration, EffectData } from "@shared/types/interface/player-data/effects";
import { effectsData, MULTIPLIER_TYPES } from "@shared/types/interface/player-data/effects";

const version = { major: 1, minor: 0, patch: 0 };

/**
 * Effects service for managing player buffs, debuffs, and multipliers.
 */
@Service()
export class EffectsService implements OnInit {
	public readonly version = version;

	// Effect configurations - initialized from JSON data
	private effectConfigs: Record<EffectName, ExactConfiguration<EffectName>> = effectsData;

	constructor(
		private readonly dataService: DataStore,
		private readonly analytics: Analytics,
	) {}

	onInit() {
		this.setupPlayerHandlers();
		this.setupAnalyticsReporting();

		// Debug: Log available multiplier types
		print(`EffectsService initialized with multiplier types: ${MULTIPLIER_TYPES.join(", ")}`);
	}

	/**
	 * Sets up periodic analytics reporting for effect metrics
	 */
	private setupAnalyticsReporting(): void {
		// Report server-wide effect metrics every 5 minutes
		const ANALYTICS_INTERVAL = 300; // 5 minutes in seconds

		const reportMetrics = () => {
			this.trackEffectPerformanceMetrics();
			task.wait(ANALYTICS_INTERVAL);
			task.spawn(reportMetrics);
		};

		task.spawn(reportMetrics);

		// Report individual player effect usage when they have been online for certain durations
		safePlayerAdded((player) => {
			// Track after 1 minute of play time
			task.spawn(() => {
				task.wait(60);
				if (player.Parent) {
					// Check if player is still in game
					this.trackEffectUsageAnalytics(player);
				}
			});

			// Track after 10 minutes of play time
			task.spawn(() => {
				task.wait(600);
				if (player.Parent) {
					// Check if player is still in game
					this.trackEffectUsageAnalytics(player);
				}
			});
		});
	}

	/**
	 * Applies an effect to a player
	 */
	public async applyEffect(player: Player, effect: EffectName, duration: number): Promise<boolean> {
		if (!this.effectConfigs[effect]) {
			warn(`Invalid effect: ${effect}`);
			return false;
		}

		const playerStore = this.dataService.getPlayerStore();
		const currentTime = DateTime.now().UnixTimestamp;

		try {
			await playerStore.updateAsync(player, (playerData) => {
				const effects = playerData.effects || [];

				// Find existing effect
				const existingEffectIndex = effects.findIndex((e) => e.id === effect);

				if (existingEffectIndex !== -1) {
					// If effect is already active, extend duration
					const existingEffect = effects[existingEffectIndex];
					if (this.isEffectActiveInternal(effects, effect, currentTime)) {
						effects[existingEffectIndex] = {
							id: effect,
							duration: existingEffect.duration + duration,
							startTime: existingEffect.startTime,
						};
					} else {
						// Replace expired effect with new one
						effects[existingEffectIndex] = {
							id: effect,
							duration: duration,
							startTime: currentTime,
						};
					}
				} else {
					// Add new effect
					effects.push({
						id: effect,
						duration: duration,
						startTime: currentTime,
					});
				}

				playerData.effects = effects;
				return true; // Commit changes
			});

			// Track effect application analytics
			this.analytics.LogEffectEvent(player, "effect_applied", effect, duration, {
				effect_type: this.effectConfigs[effect]?.DisplayName ?? effect,
				effect_category: "buff", // Could be extended to support different categories
			});

			print(`Applied effect ${effect} to ${player.Name} for ${duration} seconds`);
			return true;
		} catch (error) {
			warn(`Failed to apply effect ${effect} to ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Revokes an effect from a player
	 */
	public async revokeEffect(player: Player, effect: EffectName): Promise<boolean> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			await playerStore.updateAsync(player, (playerData) => {
				const effects = playerData.effects || [];
				const originalLength = effects.size();

				// Filter out the effect to remove
				playerData.effects = effects.filter((e) => e.id !== effect);

				// Return true if we actually removed something
				return playerData.effects.size() < originalLength;
			});

			// Track effect removal analytics
			this.analytics.LogEffectEvent(player, "effect_revoked", effect, undefined, {
				effect_type: this.effectConfigs[effect]?.DisplayName ?? effect,
				removal_type: "manual",
			});

			print(`Revoked effect ${effect} from ${player.Name}`);
			return true;
		} catch (error) {
			warn(`Failed to revoke effect ${effect} from ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Checks if an effect is currently active for a player
	 */
	public async isEffectActive(player: Player, effect: EffectName): Promise<boolean> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			const playerData = await playerStore.get(player);
			const effects = playerData.effects || [];
			const currentTime = DateTime.now().UnixTimestamp;

			return this.isEffectActiveInternal(effects, effect, currentTime);
		} catch (error) {
			warn(`Failed to check effect status for ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Internal helper to check if effect is active
	 */
	private isEffectActiveInternal(effects: EffectData[], effect: EffectName, currentTime: number): boolean {
		const effectData = effects.find((e) => e.id === effect);
		if (!effectData) {
			return false;
		}

		return effectData.startTime + effectData.duration > currentTime;
	}

	/**
	 * Gets all active effects for a player
	 */
	public async getAllActiveEffects(player: Player): Promise<Record<EffectName, EffectData>> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			const playerData = await playerStore.get(player);
			const allEffects = playerData.effects || [];
			const activeEffects: Record<EffectName, EffectData> = {} as Record<EffectName, EffectData>;
			const currentTime = DateTime.now().UnixTimestamp;

			for (const effectData of allEffects) {
				if (this.isEffectActiveInternal(allEffects, effectData.id as EffectName, currentTime)) {
					activeEffects[effectData.id as EffectName] = effectData;
				}
			}

			return activeEffects;
		} catch (error) {
			warn(`Failed to get active effects for ${player.Name}: ${error}`);
			return {} as Record<EffectName, EffectData>;
		}
	}

	/**
	 * Calculates the total multiplier for a specific type from all active effects
	 */
	public async calculateMultiplier(player: Player, multiplierType: string): Promise<number> {
		// Validate multiplier type
		if (!this.isValidMultiplierType(multiplierType)) {
			warn(`Invalid multiplier type: ${multiplierType}. Available types: ${MULTIPLIER_TYPES.join(", ")}`);
			return 1;
		}

		const activeEffects = await this.getAllActiveEffects(player);
		let multiplier = 1;

		for (const [effectName, effectData] of pairs(activeEffects)) {
			const effectConfig = this.effectConfigs[effectName];
			if (effectConfig?.Multiplier && multiplierType in effectConfig.Multiplier) {
				const multiplierValue = (effectConfig.Multiplier as Record<string, number>)[multiplierType];
				if (multiplierValue !== undefined) {
					multiplier += multiplierValue - 1;
				}
			}
		}

		return multiplier;
	}

	/**
	 * Validates if a multiplier type exists in the configuration
	 */
	public isValidMultiplierType(multiplierType: string): boolean {
		return MULTIPLIER_TYPES.includes(multiplierType);
	}

	/**
	 * Calculates multipliers for all types and returns a summary
	 */
	public async calculateAllMultipliers(player: Player): Promise<Record<string, number>> {
		const results: Record<string, number> = {};

		for (const multiplierType of MULTIPLIER_TYPES) {
			results[multiplierType] = await this.calculateMultiplier(player, multiplierType);
		}

		return results;
	}

	/**
	 * Gets effect configuration
	 */
	public getEffectConfig(effect: EffectName): ExactConfiguration<EffectName> | undefined {
		return this.effectConfigs[effect];
	}

	/**
	 * Gets all effect configurations
	 */
	public getAllEffectConfigs(): Record<EffectName, ExactConfiguration<EffectName>> {
		return { ...this.effectConfigs };
	}

	/**
	 * Sets effect configuration
	 */
	public setEffectConfig(effect: EffectName, config: ExactConfiguration<EffectName>) {
		this.effectConfigs[effect] = config;
	}

	/**
	 * Gets remaining time for an effect
	 */
	public async getEffectRemainingTime(player: Player, effect: EffectName): Promise<number> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			const playerData = await playerStore.get(player);
			const effects = playerData.effects || [];
			const effectData = effects.find((e) => e.id === effect);

			if (!effectData) {
				return 0;
			}

			const currentTime = DateTime.now().UnixTimestamp;
			const endTime = effectData.startTime + effectData.duration;

			return math.max(0, endTime - currentTime);
		} catch (error) {
			warn(`Failed to get effect remaining time for ${player.Name}: ${error}`);
			return 0;
		}
	}

	/**
	 * Cleans up expired effects for a player
	 */
	public async cleanupExpiredEffects(player: Player): Promise<void> {
		const playerStore = this.dataService.getPlayerStore();
		const currentTime = DateTime.now().UnixTimestamp;

		try {
			let expiredCount = 0;
			const expiredEffects: EffectName[] = [];

			await playerStore.updateAsync(player, (playerData) => {
				const effects = playerData.effects || [];
				const originalLength = effects.size();

				// Track expired effects before filtering
				for (const effectData of effects) {
					if (!this.isEffectActiveInternal(effects, effectData.id as EffectName, currentTime)) {
						expiredCount++;
						expiredEffects.push(effectData.id as EffectName);
					}
				}

				// Filter out expired effects
				playerData.effects = effects.filter((effectData) =>
					this.isEffectActiveInternal(effects, effectData.id as EffectName, currentTime),
				);

				// Only commit if there are changes
				return playerData.effects.size() < originalLength;
			});

			// Track expired effects analytics
			if (expiredCount > 0) {
				this.analytics.LogCustomEvent(player, "effects_expired", expiredCount, {
					expired_count: tostring(expiredCount),
					expired_effects: expiredEffects.join(","),
				});
			}
		} catch (error) {
			warn(`Failed to cleanup expired effects for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Cleans up expired effects for all players
	 */
	public async cleanupExpiredEffectsForAllPlayers(): Promise<void> {
		const playerStore = this.dataService.getPlayerStore();
		const allPlayers = Players.GetPlayers();
		const currentTime = DateTime.now().UnixTimestamp;

		for (const player of allPlayers) {
			try {
				await playerStore.updateAsync(player, (playerData) => {
					const effects = playerData.effects || [];
					const originalLength = effects.size();

					// Filter out expired effects
					playerData.effects = effects.filter((effectData) =>
						this.isEffectActiveInternal(effects, effectData.id as EffectName, currentTime),
					);

					// Only commit if there are changes
					return playerData.effects.size() < originalLength;
				});
			} catch (error) {
				warn(`Failed to cleanup expired effects for ${player.Name}: ${error}`);
			}
		}
	}

	/**
	 * Apply multiple effects at once - optimized to use a single database transaction
	 */
	public async applyMultipleEffects(
		player: Player,
		effectsToApply: Array<{ effect: EffectName; duration: number }>,
	): Promise<boolean> {
		const playerStore = this.dataService.getPlayerStore();
		const currentTime = DateTime.now().UnixTimestamp;

		// Validate all effects first
		for (const { effect } of effectsToApply) {
			if (!this.effectConfigs[effect]) {
				warn(`Invalid effect: ${effect}`);
				return false;
			}
		}

		try {
			await playerStore.updateAsync(player, (playerData) => {
				const effects = playerData.effects || [];

				for (const { effect, duration } of effectsToApply) {
					// Find existing effect
					const existingEffectIndex = effects.findIndex((e) => e.id === effect);

					if (existingEffectIndex !== -1) {
						// If effect is already active, extend duration
						const existingEffect = effects[existingEffectIndex];
						if (this.isEffectActiveInternal(effects, effect, currentTime)) {
							effects[existingEffectIndex] = {
								id: effect,
								duration: existingEffect.duration + duration,
								startTime: existingEffect.startTime,
							};
						} else {
							// Replace expired effect with new one
							effects[existingEffectIndex] = {
								id: effect,
								duration: duration,
								startTime: currentTime,
							};
						}
					} else {
						// Add new effect
						effects.push({
							id: effect,
							duration: duration,
							startTime: currentTime,
						});
					}
				}

				playerData.effects = effects;
				return true; // Commit changes
			});

			// Track multiple effects application analytics
			this.analytics.LogCustomEvent(player, "multiple_effects_applied", effectsToApply.size(), {
				effect_count: tostring(effectsToApply.size()),
				effect_names: effectsToApply.map(({ effect }) => effect).join(","),
			});

			print(`Applied ${effectsToApply.size()} effects to ${player.Name}`);
			return true;
		} catch (error) {
			warn(`Failed to apply multiple effects to ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Gets the count of active effects for a player
	 */
	public async getActiveEffectCount(player: Player): Promise<number> {
		const activeEffects = await this.getAllActiveEffects(player);
		let count = 0;
		for (const [effectName] of pairs(activeEffects)) {
			count++;
		}
		return count;
	}

	/**
	 * Checks if any effects are active for a player
	 */
	public async hasAnyActiveEffects(player: Player): Promise<boolean> {
		const count = await this.getActiveEffectCount(player);
		return count > 0;
	}

	/**
	 * Gets a summary of all effect types and their remaining times for debugging
	 */
	public async getEffectSummary(player: Player): Promise<Record<EffectName, number>> {
		const activeEffects = await this.getAllActiveEffects(player);
		const summary: Record<EffectName, number> = {} as Record<EffectName, number>;

		for (const [effectName, effectData] of pairs(activeEffects)) {
			const remainingTime = await this.getEffectRemainingTime(player, effectName);
			summary[effectName] = remainingTime;
		}

		return summary;
	}

	/**
	 * Tracks effect usage patterns and performance analytics
	 */
	public async trackEffectUsageAnalytics(player: Player): Promise<void> {
		try {
			const activeEffects = await this.getAllActiveEffects(player);
			const effectCount = await this.getActiveEffectCount(player);

			// Track effect usage patterns and combinations
			this.analytics.LogCustomEvent(player, "effect_usage_snapshot", effectCount, {
				total_effects: tostring(effectCount),
				timestamp: tostring(DateTime.now().UnixTimestamp),
			});

			// Track effect combinations if multiple effects are active
			if (effectCount > 1) {
				this.trackEffectCombinations(player);
			}

			// Track individual effect types and their remaining durations
			for (const [effectName, effectData] of pairs(activeEffects)) {
				const remainingTime = await this.getEffectRemainingTime(player, effectName);
				const effectConfig = this.effectConfigs[effectName];

				this.analytics.LogCustomEvent(player, "individual_effect_status", 1, {
					effect_name: effectName,
					remaining_time: tostring(remainingTime),
					effect_display_name: effectConfig?.DisplayName ?? effectName,
					effect_description: effectConfig?.Description ?? "",
				});
			}

			// Track multiplier usage patterns
			for (const multiplierType of MULTIPLIER_TYPES) {
				const multiplier = await this.calculateMultiplier(player, multiplierType);
				if (multiplier > 1) {
					this.analytics.LogCustomEvent(player, "multiplier_active", math.floor(multiplier * 100), {
						multiplier_type: multiplierType,
						multiplier_value: tostring(multiplier),
						boost_percentage: tostring((multiplier - 1) * 100),
					});
				}
			}
		} catch (error) {
			warn(`Failed to track effect usage analytics for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Tracks effect performance metrics over time
	 */
	public async trackEffectPerformanceMetrics(): Promise<void> {
		const allPlayers = Players.GetPlayers();
		let totalActiveEffects = 0;
		let playersWithEffects = 0;
		const effectTypeUsage: Record<string, number> = {};

		for (const player of allPlayers) {
			try {
				const activeEffects = await this.getAllActiveEffects(player);
				let effectCount = 0;

				// Count effects manually since we can't use Object.keys
				for (const [effectName] of pairs(activeEffects)) {
					effectCount++;
					// Track usage by effect type
					effectTypeUsage[effectName] = (effectTypeUsage[effectName] ?? 0) + 1;
				}

				if (effectCount > 0) {
					playersWithEffects++;
					totalActiveEffects += effectCount;
				}
			} catch (error) {
				warn(`Failed to analyze effects for ${player.Name}: ${error}`);
			}
		}

		// Log server-wide effect metrics
		if (allPlayers.size() > 0) {
			const averageEffectsPerPlayer = totalActiveEffects / allPlayers.size();
			const effectAdoptionRate = playersWithEffects / allPlayers.size();

			// Use a system player or the first player for server metrics
			const systemPlayer = allPlayers[0];
			if (systemPlayer) {
				// Get most used effects manually
				const effectEntries: Array<[string, number]> = [];
				for (const [effectName, count] of pairs(effectTypeUsage)) {
					effectEntries.push([effectName, count]);
				}

				// Sort by usage count and get top 3
				table.sort(effectEntries, (a, b) => a[1] > b[1]);
				const topEffects: string[] = [];
				for (let i = 0; i < 3 && i < effectEntries.size(); i++) {
					topEffects.push(effectEntries[i][0]);
				}

				this.analytics.LogCustomEvent(systemPlayer, "server_effect_metrics", totalActiveEffects, {
					total_effects: tostring(totalActiveEffects),
					players_with_effects: tostring(playersWithEffects),
					total_players: tostring(allPlayers.size()),
					average_effects_per_player: tostring(averageEffectsPerPlayer),
					effect_adoption_rate: tostring(effectAdoptionRate),
					most_used_effects: topEffects.join(","),
				});
			}
		}
	}

	/**
	 * Setup player join/leave handlers
	 */
	private setupPlayerHandlers(): void {
		safePlayerAdded(async (player) => {
			// Initialize effects when player joins
			await this.cleanupExpiredEffects(player);

			// Track player session start with effects
			const activeEffectCount = await this.getActiveEffectCount(player);
			this.analytics.LogCustomEvent(player, "effects_session_start", activeEffectCount, {
				active_effect_count: tostring(activeEffectCount),
			});
		});

		Players.PlayerRemoving.Connect((player) => {
			// Save remaining effect durations when player leaves
			// Note: We don't use async/await here as the player may disconnect before completion
			const playerStore = this.dataService.getPlayerStore();
			const currentTime = DateTime.now().UnixTimestamp;

			// Use spawn to prevent yielding in the PlayerRemoving handler
			task.spawn(() => {
				try {
					playerStore.updateAsync(player, (playerData) => {
						const effects = playerData.effects || [];
						const originalLength = effects.size();

						// Update remaining durations for active effects and remove expired ones
						const updatedEffects: EffectData[] = [];

						for (const effectData of effects) {
							if (this.isEffectActiveInternal(effects, effectData.id as EffectName, currentTime)) {
								const remainingTime = effectData.startTime + effectData.duration - currentTime;
								updatedEffects.push({
									id: effectData.id,
									duration: remainingTime,
									startTime: currentTime, // Reset start time to when they leave
								});
							}
							// Expired effects are simply not added to updatedEffects (removed)
						}

						if (updatedEffects.size() !== originalLength) {
							playerData.effects = updatedEffects;
							return true;
						}

						return false; // No changes needed
					});
				} catch (error) {
					warn(`Failed to save effect durations for leaving player ${player.Name}: ${error}`);
				}
			});
		});
	}

	/**
	 * Tracks effect combinations and their multiplier impact
	 */
	public async trackEffectCombinations(player: Player): Promise<void> {
		try {
			const activeEffects = await this.getAllActiveEffects(player);
			const effectNames: string[] = [];

			for (const [effectName] of pairs(activeEffects)) {
				effectNames.push(effectName);
			}

			if (effectNames.size() > 1) {
				// Track combinations of 2 or more effects
				const combination = effectNames.sort().join("+");

				// Calculate total multiplier impact
				let totalMultiplierBoost = 0;

				for (const multiplierType of MULTIPLIER_TYPES) {
					const multiplier = await this.calculateMultiplier(player, multiplierType);
					totalMultiplierBoost += multiplier - 1; // Get the boost amount
				}

				this.analytics.LogCustomEvent(player, "effect_combination_used", effectNames.size(), {
					combination: combination,
					effect_count: tostring(effectNames.size()),
					total_multiplier_boost: tostring(totalMultiplierBoost),
					combination_hash: tostring(combination.size()), // Simple hash for grouping
				});
			}
		} catch (error) {
			warn(`Failed to track effect combinations for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Gets all available multiplier types from the configuration
	 */
	public getAvailableMultiplierTypes(): readonly string[] {
		return MULTIPLIER_TYPES;
	}

	/**
	 * Gets all active multipliers for a player across all types
	 */
	public async getAllActiveMultipliers(player: Player): Promise<Record<string, number>> {
		const multipliers: Record<string, number> = {};

		for (const multiplierType of MULTIPLIER_TYPES) {
			const multiplier = await this.calculateMultiplier(player, multiplierType);
			if (multiplier > 1) {
				multipliers[multiplierType] = multiplier;
			}
		}

		return multipliers;
	}
}
