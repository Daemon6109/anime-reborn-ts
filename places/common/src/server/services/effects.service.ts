import { Service, OnInit } from "@flamework/core";
import { Players } from "@rbxts/services";
import { DataService } from "./data.service";

const version = { major: 1, minor: 0, patch: 0 };

export interface EffectData {
	Duration: number; // Duration in seconds
	StartTime: number; // Unix timestamp when effect started
}

export interface EffectConfig {
	Name: string;
	Description: string;
	Multiplier?: Record<string, number>; // Multiplier values by type
	Icon?: string;
	Rarity?: "Common" | "Rare" | "Epic" | "Legendary";
}

export type EffectType =
	| "ExpBoost"
	| "GoldBoost"
	| "GemBoost"
	| "DamageBoost"
	| "SpeedBoost"
	| "LuckBoost"
	| "HealthBoost"
	| "DefenseBoost";

/**
 * Effects service for managing player buffs, debuffs, and multipliers.
 */
@Service()
export class EffectsService implements OnInit {
	public readonly version = version;

	// Effect configurations
	private effectConfigs: Record<EffectType, EffectConfig> = {} as Record<EffectType, EffectConfig>;

	constructor(private readonly dataService: DataService) {}

	public onInit(): void {
		this.loadDefaultEffectConfigs();
		this.setupPlayerHandlers();
		print("EffectsService initialized");
	}

	/**
	 * Loads default effect configurations
	 */
	private loadDefaultEffectConfigs(): void {
		this.effectConfigs = {
			ExpBoost: {
				Name: "Experience Boost",
				Description: "Increases experience gained",
				Multiplier: { Experience: 2.0 },
				Icon: "🔥",
				Rarity: "Common",
			},
			GoldBoost: {
				Name: "Gold Boost",
				Description: "Increases gold earned",
				Multiplier: { Gold: 1.5 },
				Icon: "💰",
				Rarity: "Common",
			},
			GemBoost: {
				Name: "Gem Boost",
				Description: "Increases gems earned",
				Multiplier: { Gems: 2.0 },
				Icon: "💎",
				Rarity: "Rare",
			},
			DamageBoost: {
				Name: "Damage Boost",
				Description: "Increases damage dealt",
				Multiplier: { Damage: 1.25 },
				Icon: "⚔️",
				Rarity: "Epic",
			},
			SpeedBoost: {
				Name: "Speed Boost",
				Description: "Increases movement speed",
				Multiplier: { Speed: 1.3 },
				Icon: "⚡",
				Rarity: "Common",
			},
			LuckBoost: {
				Name: "Luck Boost",
				Description: "Increases drop chance",
				Multiplier: { Luck: 1.5 },
				Icon: "🍀",
				Rarity: "Rare",
			},
			HealthBoost: {
				Name: "Health Boost",
				Description: "Increases maximum health",
				Multiplier: { Health: 1.2 },
				Icon: "❤️",
				Rarity: "Epic",
			},
			DefenseBoost: {
				Name: "Defense Boost",
				Description: "Reduces damage taken",
				Multiplier: { Defense: 1.3 },
				Icon: "🛡️",
				Rarity: "Epic",
			},
		};
	}

	/**
	 * Applies an effect to a player
	 */
	public async applyEffect(player: Player, effect: EffectType, duration: number): Promise<boolean> {
		if (!this.effectConfigs[effect]) {
			warn(`Invalid effect: ${effect}`);
			return false;
		}

		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get player data for ${player.Name}`);
			return false;
		}

		const newData = { ...playerData };
		const effects = newData.Effects as unknown as Record<string, EffectData>;

		const currentTime = DateTime.now().UnixTimestamp;

		// If effect is already active, extend duration
		if (this.isEffectActiveInternal(effects, effect, currentTime)) {
			const existingEffect = effects[effect];
			effects[effect] = {
				Duration: existingEffect.Duration + duration,
				StartTime: existingEffect.StartTime,
			};
		} else {
			// Apply new effect
			effects[effect] = {
				Duration: duration,
				StartTime: currentTime,
			};
		}

		this.dataService.setCache(player, newData);
		print(`Applied effect ${effect} to ${player.Name} for ${duration} seconds`);
		return true;
	}

	/**
	 * Revokes an effect from a player
	 */
	public async revokeEffect(player: Player, effect: EffectType): Promise<boolean> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get player data for ${player.Name}`);
			return false;
		}

		const newData = { ...playerData };
		const effects = newData.Effects as unknown as Record<string, EffectData>;

		if (effects[effect]) {
			delete effects[effect];
			this.dataService.setCache(player, newData);
			print(`Revoked effect ${effect} from ${player.Name}`);
			return true;
		}

		return false;
	}

	/**
	 * Checks if an effect is currently active for a player
	 */
	public async isEffectActive(player: Player, effect: EffectType): Promise<boolean> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return false;
		}

		const effects = playerData.Effects as unknown as Record<string, EffectData>;
		const currentTime = DateTime.now().UnixTimestamp;

		return this.isEffectActiveInternal(effects, effect, currentTime);
	}

	/**
	 * Internal helper to check if effect is active
	 */
	private isEffectActiveInternal(
		effects: Record<string, EffectData>,
		effect: EffectType,
		currentTime: number,
	): boolean {
		const effectData = effects[effect];
		if (!effectData) {
			return false;
		}

		return effectData.StartTime + effectData.Duration > currentTime;
	}

	/**
	 * Gets all active effects for a player
	 */
	public async getAllActiveEffects(player: Player): Promise<Record<EffectType, EffectData>> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return {} as Record<EffectType, EffectData>;
		}

		const allEffects = playerData.Effects as unknown as Record<string, EffectData>;
		const activeEffects: Record<EffectType, EffectData> = {} as Record<EffectType, EffectData>;
		const currentTime = DateTime.now().UnixTimestamp;

		for (const [effectName, effectData] of pairs(allEffects)) {
			if (this.isEffectActiveInternal(allEffects, effectName as EffectType, currentTime)) {
				activeEffects[effectName as EffectType] = effectData;
			}
		}

		return activeEffects;
	}

	/**
	 * Calculates the total multiplier for a specific type from all active effects
	 */
	public async calculateMultiplier(player: Player, multiplierType: string): Promise<number> {
		const activeEffects = await this.getAllActiveEffects(player);
		let multiplier = 1;

		for (const [effectName, effectData] of pairs(activeEffects)) {
			const effectConfig = this.effectConfigs[effectName];
			if (effectConfig?.Multiplier?.[multiplierType] !== undefined) {
				multiplier += effectConfig.Multiplier[multiplierType] - 1;
			}
		}

		return multiplier;
	}

	/**
	 * Gets effect configuration
	 */
	public getEffectConfig(effect: EffectType): EffectConfig | undefined {
		return this.effectConfigs[effect];
	}

	/**
	 * Gets all effect configurations
	 */
	public getAllEffectConfigs(): Record<EffectType, EffectConfig> {
		return { ...this.effectConfigs };
	}

	/**
	 * Sets effect configuration
	 */
	public setEffectConfig(effect: EffectType, config: EffectConfig): void {
		this.effectConfigs[effect] = config;
	}

	/**
	 * Gets remaining time for an effect
	 */
	public async getEffectRemainingTime(player: Player, effect: EffectType): Promise<number> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return 0;
		}

		const effects = playerData.Effects as unknown as Record<string, EffectData>;
		const effectData = effects[effect];

		if (!effectData) {
			return 0;
		}

		const currentTime = DateTime.now().UnixTimestamp;
		const endTime = effectData.StartTime + effectData.Duration;

		return math.max(0, endTime - currentTime);
	}

	/**
	 * Cleans up expired effects for a player
	 */
	public async cleanupExpiredEffects(player: Player): Promise<void> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return;
		}

		const newData = { ...playerData };
		const effects = newData.Effects as unknown as Record<string, EffectData>;
		const currentTime = DateTime.now().UnixTimestamp;
		let hasChanges = false;

		for (const [effectName, effectData] of pairs(effects)) {
			if (!this.isEffectActiveInternal(effects, effectName as EffectType, currentTime)) {
				delete effects[effectName];
				hasChanges = true;
			}
		}

		if (hasChanges) {
			this.dataService.setCache(player, newData);
		}
	}

	/**
	 * Apply multiple effects at once
	 */
	public async applyMultipleEffects(
		player: Player,
		effectsToApply: Array<{ effect: EffectType; duration: number }>,
	): Promise<boolean> {
		let allSuccessful = true;

		for (const { effect, duration } of effectsToApply) {
			const success = await this.applyEffect(player, effect, duration);
			if (!success) {
				allSuccessful = false;
			}
		}

		return allSuccessful;
	}

	/**
	 * Setup player join/leave handlers
	 */
	private setupPlayerHandlers(): void {
		Players.PlayerAdded.Connect((player) => {
			// Initialize effects when player joins
			task.wait(1); // Wait for data to load
			this.cleanupExpiredEffects(player);
		});

		Players.PlayerRemoving.Connect((player) => {
			// Save remaining effect durations when player leaves
			task.spawn(async () => {
				const playerData = await this.dataService.getCache(player);
				if (!playerData) {
					return;
				}

				const newData = { ...playerData };
				const effects = newData.Effects as unknown as Record<string, EffectData>;
				const currentTime = DateTime.now().UnixTimestamp;

				// Update remaining durations for active effects
				for (const [effectName, effectData] of pairs(effects)) {
					if (this.isEffectActiveInternal(effects, effectName as EffectType, currentTime)) {
						const remainingTime = effectData.StartTime + effectData.Duration - currentTime;
						effects[effectName] = {
							Duration: remainingTime,
							StartTime: currentTime, // Reset start time to when they leave
						};
					} else {
						// Remove expired effects
						delete effects[effectName];
					}
				}

				this.dataService.setCache(player, newData);
			});
		});

		// Periodic cleanup task
		task.spawn(() => {
			// eslint-disable-next-line no-constant-condition
			while (true) {
				task.wait(60); // Every minute

				const players = Players.GetPlayers();
				for (const player of players) {
					this.cleanupExpiredEffects(player);
				}
			}
		});
	}
}
