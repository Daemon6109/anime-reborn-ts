// Tower Defense Game Configuration

// Tower Types
export enum TowerType {
	BasicTower = "BasicTower",
	ArcherTower = "ArcherTower",
	MageTower = "MageTower",
	CannonTower = "CannonTower",
}

// Enemy Types
export enum EnemyType {
	BasicEnemy = "BasicEnemy",
	FastEnemy = "FastEnemy",
	TankEnemy = "TankEnemy",
	FlyingEnemy = "FlyingEnemy",
}

// Effect Types
export enum EffectType {
	Death = "Death",
	Hit = "Hit",
	Slow = "Slow",
	Poison = "Poison",
	Burn = "Burn",
	Freeze = "Freeze",
	Stun = "Stun",
}

// Damage Types
export enum DamageType {
	Physical = "Physical",
	Magical = "Magical",
	True = "True",
}

// Game States
export enum GameState {
	WAITING = "WAITING",
	ACTIVE = "ACTIVE",
	PAUSED = "PAUSED",
	ENDED = "ENDED",
}

// Tower Configuration Interface
export interface TowerConfig {
	name: string;
	cost: number;
	damage: number;
	range: number;
	fireRate: number;
	attackSpeed: number;
	projectileSpeed: number;
	color: Color3;
	size: Vector3;
	special?: {
		splashRadius?: number;
		slowEffect?: number;
		slowDuration?: number;
	};
}

// Enemy Configuration Interface
export interface EnemyConfig {
	name: string;
	health: number;
	speed: number;
	reward: number;
	color: Color3;
	size: Vector3;
	special?: {
		flying?: boolean;
		armor?: number;
	};
}

// Wave Configuration Interface
export interface WaveConfig {
	enemyType: EnemyType;
	count: number;
	spawnDelay: number;
	healthMultiplier?: number;
	speedMultiplier?: number;
	rewardMultiplier?: number;
}

// Main Game Configuration interface
export interface GameConfig {
	towers: Record<TowerType, TowerConfig>;
	enemies: Record<EnemyType, EnemyConfig>;
	waves: WaveConfig[][];
	path: Vector3[];
	constants: typeof GAME_CONSTANTS;
}

// Tower Configurations
export const TOWER_CONFIGS: Record<TowerType, TowerConfig> = {
	[TowerType.BasicTower]: {
		name: "Basic Tower",
		cost: 50,
		damage: 25,
		range: 15,
		fireRate: 1.5,
		attackSpeed: 1.5,
		projectileSpeed: 50,
		color: new Color3(0.5, 0.5, 0.5),
		size: Vector3.one.mul(new Vector3(2, 4, 2)),
	},
	[TowerType.ArcherTower]: {
		name: "Archer Tower",
		cost: 150,
		damage: 100,
		range: 25,
		fireRate: 0.5,
		attackSpeed: 0.5,
		projectileSpeed: 100,
		color: new Color3(0.2, 0.8, 0.2),
		size: Vector3.one.mul(new Vector3(2, 6, 2)),
	},
	[TowerType.MageTower]: {
		name: "Mage Tower",
		cost: 200,
		damage: 50,
		range: 12,
		fireRate: 1,
		attackSpeed: 1,
		projectileSpeed: 30,
		color: new Color3(0.8, 0.2, 0.2),
		size: Vector3.one.mul(new Vector3(3, 4, 3)),
		special: {
			splashRadius: 8,
		},
	},
	[TowerType.CannonTower]: {
		name: "Cannon Tower",
		cost: 100,
		damage: 15,
		range: 18,
		fireRate: 2,
		attackSpeed: 2,
		projectileSpeed: 40,
		color: new Color3(0.2, 0.2, 0.8),
		size: Vector3.one.mul(new Vector3(2, 4, 2)),
		special: {
			slowEffect: 0.5,
			slowDuration: 3,
		},
	},
};

// Enemy Configurations
export const ENEMY_CONFIGS: Record<EnemyType, EnemyConfig> = {
	[EnemyType.BasicEnemy]: {
		name: "Basic Enemy",
		health: 100,
		speed: 8,
		reward: 10,
		color: new Color3(0.8, 0.4, 0.4),
		size: Vector3.one.mul(new Vector3(1.5, 1.5, 1.5)),
	},
	[EnemyType.FastEnemy]: {
		name: "Fast Enemy",
		health: 60,
		speed: 16,
		reward: 15,
		color: new Color3(0.4, 0.8, 0.4),
		size: Vector3.one.mul(new Vector3(1, 1, 1)),
	},
	[EnemyType.TankEnemy]: {
		name: "Tank Enemy",
		health: 300,
		speed: 4,
		reward: 25,
		color: new Color3(0.4, 0.4, 0.8),
		size: Vector3.one.mul(new Vector3(2.5, 2.5, 2.5)),
		special: {
			armor: 10,
		},
	},
	[EnemyType.FlyingEnemy]: {
		name: "Flying Enemy",
		health: 80,
		speed: 12,
		reward: 20,
		color: new Color3(0.8, 0.8, 0.4),
		size: Vector3.one.mul(new Vector3(1.2, 1.2, 1.2)),
		special: {
			flying: true,
		},
	},
};

// Default Path Points
export const DEFAULT_PATH_POINTS: Vector3[] = [
	Vector3.one.mul(new Vector3(-50, 2, 0)),
	Vector3.one.mul(new Vector3(-30, 2, 0)),
	Vector3.one.mul(new Vector3(-30, 2, 20)),
	Vector3.one.mul(new Vector3(0, 2, 20)),
	Vector3.one.mul(new Vector3(0, 2, -20)),
	Vector3.one.mul(new Vector3(30, 2, -20)),
	Vector3.one.mul(new Vector3(30, 2, 0)),
	Vector3.one.mul(new Vector3(50, 2, 0)),
];

// Wave Configurations
export const WAVE_CONFIGS: WaveConfig[][] = [
	// Wave 1
	[
		{
			enemyType: EnemyType.BasicEnemy,
			count: 10,
			spawnDelay: 1,
		},
	],
	// Wave 2
	[
		{
			enemyType: EnemyType.BasicEnemy,
			count: 15,
			spawnDelay: 0.8,
		},
	],
	// Wave 3
	[
		{
			enemyType: EnemyType.BasicEnemy,
			count: 8,
			spawnDelay: 1,
		},
		{
			enemyType: EnemyType.FastEnemy,
			count: 5,
			spawnDelay: 1.2,
		},
	],
	// Wave 4
	[
		{
			enemyType: EnemyType.BasicEnemy,
			count: 12,
			spawnDelay: 0.7,
		},
		{
			enemyType: EnemyType.FastEnemy,
			count: 8,
			spawnDelay: 1,
		},
	],
	// Wave 5 - Boss Wave
	[
		{
			enemyType: EnemyType.TankEnemy,
			count: 3,
			spawnDelay: 2,
			healthMultiplier: 1.5,
			rewardMultiplier: 2,
		},
	],
];

// Game Constants
export const GAME_CONSTANTS = {
	STARTING_MONEY: 500,
	STARTING_LIVES: 20,
	TOWER_PLACEMENT_GRID_SIZE: 4,
	MAX_TOWER_COUNT: 50,
	WAVE_PREP_TIME: 10,
	ENEMY_SPAWN_HEIGHT: 2,
	PROJECTILE_CLEANUP_TIME: 10,
} as const;

// Main Game Configuration Export
export const GameConfig: GameConfig = {
	towers: TOWER_CONFIGS,
	enemies: ENEMY_CONFIGS,
	waves: WAVE_CONFIGS,
	path: DEFAULT_PATH_POINTS,
	constants: GAME_CONSTANTS,
};

// Named exports for convenience
export const TowerConfig = TOWER_CONFIGS;
export const EnemyConfig = ENEMY_CONFIGS;

// Validation Functions
export function isValidTowerType(value: unknown): value is TowerType {
	return typeIs(value, "string") && (value as string) in TowerType;
}

export function isValidEnemyType(value: unknown): value is EnemyType {
	return typeIs(value, "string") && (value as string) in EnemyType;
}

export function isValidGameState(value: unknown): value is GameState {
	return typeIs(value, "string") && (value as string) in GameState;
}
