// Shared utilities and configurations for the tower defense game

export interface GameConfig {
	towers: {
		[K in TowerType]: TowerConfig;
	};
	enemies: {
		[K in EnemyType]: EnemyConfig;
	};
	waves: WaveConfig[];
}

export interface TowerConfig {
	cost: number;
	damage: number;
	range: number;
	attackSpeed: number;
	upgrades: TowerUpgrade[];
}

export interface TowerUpgrade {
	level: number;
	cost: number;
	damageBonus: number;
	rangeBonus: number;
	attackSpeedBonus: number;
}

export interface EnemyConfig {
	health: number;
	speed: number;
	reward: number;
	armor: number;
}

export interface WaveConfig {
	wave: number;
	enemies: WaveEnemySpawn[];
	delay: number;
}

export interface WaveEnemySpawn {
	type: EnemyType;
	count: number;
	interval: number;
}

export type TowerType = "Archer" | "Mage" | "Cannon" | "Support";
export type EnemyType = "Goblin" | "Orc" | "Troll" | "Boss";

export const GAME_CONFIG: GameConfig = {
	towers: {
		Archer: {
			cost: 100,
			damage: 25,
			range: 20,
			attackSpeed: 1.5,
			upgrades: [
				{ level: 2, cost: 150, damageBonus: 10, rangeBonus: 2, attackSpeedBonus: 0.2 },
				{ level: 3, cost: 300, damageBonus: 20, rangeBonus: 3, attackSpeedBonus: 0.3 },
			],
		},
		Mage: {
			cost: 150,
			damage: 40,
			range: 15,
			attackSpeed: 1.0,
			upgrades: [
				{ level: 2, cost: 200, damageBonus: 20, rangeBonus: 3, attackSpeedBonus: 0.1 },
				{ level: 3, cost: 400, damageBonus: 40, rangeBonus: 5, attackSpeedBonus: 0.2 },
			],
		},
		Cannon: {
			cost: 200,
			damage: 100,
			range: 25,
			attackSpeed: 0.5,
			upgrades: [
				{ level: 2, cost: 300, damageBonus: 50, rangeBonus: 5, attackSpeedBonus: 0.1 },
				{ level: 3, cost: 600, damageBonus: 100, rangeBonus: 8, attackSpeedBonus: 0.2 },
			],
		},
		Support: {
			cost: 120,
			damage: 0,
			range: 30,
			attackSpeed: 2.0,
			upgrades: [
				{ level: 2, cost: 180, damageBonus: 0, rangeBonus: 5, attackSpeedBonus: 0.5 },
				{ level: 3, cost: 360, damageBonus: 0, rangeBonus: 10, attackSpeedBonus: 1.0 },
			],
		},
	},
	enemies: {
		Goblin: {
			health: 100,
			speed: 8,
			reward: 10,
			armor: 0,
		},
		Orc: {
			health: 200,
			speed: 6,
			reward: 20,
			armor: 2,
		},
		Troll: {
			health: 500,
			speed: 4,
			reward: 50,
			armor: 5,
		},
		Boss: {
			health: 1000,
			speed: 3,
			reward: 100,
			armor: 10,
		},
	},
	waves: [
		{
			wave: 1,
			delay: 5,
			enemies: [{ type: "Goblin", count: 10, interval: 1 }],
		},
		{
			wave: 2,
			delay: 10,
			enemies: [
				{ type: "Goblin", count: 15, interval: 0.8 },
				{ type: "Orc", count: 3, interval: 2 },
			],
		},
		{
			wave: 3,
			delay: 15,
			enemies: [
				{ type: "Goblin", count: 20, interval: 0.6 },
				{ type: "Orc", count: 8, interval: 1.5 },
				{ type: "Troll", count: 1, interval: 5 },
			],
		},
		{
			wave: 4,
			delay: 20,
			enemies: [
				{ type: "Orc", count: 15, interval: 1 },
				{ type: "Troll", count: 3, interval: 3 },
			],
		},
		{
			wave: 5,
			delay: 25,
			enemies: [
				{ type: "Goblin", count: 30, interval: 0.5 },
				{ type: "Orc", count: 10, interval: 1.2 },
				{ type: "Troll", count: 5, interval: 2.5 },
				{ type: "Boss", count: 1, interval: 10 },
			],
		},
	],
};

export class GameMath {
	/**
	 * Calculate damage after armor reduction
	 */
	static calculateDamage(baseDamage: number, armor: number): number {
		const damageReduction = armor / (armor + 100);
		return baseDamage * (1 - damageReduction);
	}

	/**
	 * Calculate distance between two Vector3 points
	 */
	static distance(a: Vector3, b: Vector3): number {
		return a.sub(b).Magnitude;
	}

	/**
	 * Linear interpolation between two values
	 */
	static lerp(a: number, b: number, t: number): number {
		return a + (b - a) * t;
	}

	/**
	 * Check if a point is within a circle
	 */
	static isInCircle(point: Vector3, center: Vector3, radius: number): boolean {
		return this.distance(point, center) <= radius;
	}

	/**
	 * Get a random spawn position around the map edges
	 */
	static getRandomSpawnPosition(): Vector3 {
		const side = math.random(1, 4);
		const mapSize = 50;

		switch (side) {
			case 1: // North
				return new Vector3(math.random(-mapSize, mapSize), 0, mapSize);
			case 2: // East
				return new Vector3(mapSize, 0, math.random(-mapSize, mapSize));
			case 3: // South
				return new Vector3(math.random(-mapSize, mapSize), 0, -mapSize);
			case 4: // West
				return new Vector3(-mapSize, 0, math.random(-mapSize, mapSize));
			default:
				return new Vector3(0, 0, mapSize);
		}
	}

	/**
	 * Get direction towards the center of the map
	 */
	static getDirectionToCenter(position: Vector3): Vector3 {
		const center = new Vector3(0, 0, 0);
		return center.sub(position).Unit;
	}
}

export class PathfindingUtils {
	/**
	 * Simple pathfinding - moves towards center with some randomness
	 */
	static getNextDirection(currentPosition: Vector3, targetPosition: Vector3): Vector3 {
		const directDirection = targetPosition.sub(currentPosition).Unit;

		// Add some randomness to prevent all enemies following exact same path
		const randomOffset = new Vector3((math.random() - 0.5) * 0.3, 0, (math.random() - 0.5) * 0.3);

		return directDirection.add(randomOffset).Unit;
	}

	/**
	 * Check if position is valid for movement (not blocked by towers)
	 */
	static isValidPosition(position: Vector3, occupiedPositions: Vector3[]): boolean {
		const minDistance = 3; // Minimum distance from towers

		for (const occupied of occupiedPositions) {
			if (GameMath.distance(position, occupied) < minDistance) {
				return false;
			}
		}

		return true;
	}
}

export class EffectUtils {
	/**
	 * Create a simple hit effect at position
	 */
	static createHitEffect(position: Vector3, color: Color3 = Color3.fromRGB(255, 255, 0)): void {
		const effect = new Instance("Explosion");
		effect.Position = position;
		effect.BlastRadius = 5;
		effect.BlastPressure = 0;
		effect.Parent = game.Workspace;

		// Remove the explosion after a short time
		game.GetService("Debris").AddItem(effect, 2);
	}

	/**
	 * Create a death effect for enemies
	 */
	static createDeathEffect(position: Vector3, enemyType: EnemyType): void {
		const colors = {
			Goblin: Color3.fromRGB(0, 255, 0),
			Orc: Color3.fromRGB(255, 165, 0),
			Troll: Color3.fromRGB(255, 0, 0),
			Boss: Color3.fromRGB(128, 0, 128),
		};

		this.createHitEffect(position, colors[enemyType]);
	}
}

export class WaveManager {
	private currentWave = 0;
	private isWaveActive = false;
	private waveStartTime = 0;

	getCurrentWave(): number {
		return this.currentWave;
	}

	isCurrentWaveActive(): boolean {
		return this.isWaveActive;
	}

	startNextWave(): WaveConfig | undefined {
		if (this.isWaveActive) return undefined;

		if (this.currentWave >= GAME_CONFIG.waves.size()) {
			// All waves completed
			return undefined;
		}

		const wave = GAME_CONFIG.waves[this.currentWave];
		this.currentWave++;
		this.isWaveActive = true;
		this.waveStartTime = tick();

		return wave;
	}

	completeWave(): void {
		this.isWaveActive = false;
	}

	getTimeUntilNextWave(): number {
		if (this.isWaveActive) return 0;

		const currentWave = GAME_CONFIG.waves[this.currentWave];
		if (!currentWave) return 0;

		const timeSinceWaveEnd = tick() - this.waveStartTime;
		return math.max(0, currentWave.delay - timeSinceWaveEnd);
	}
}
