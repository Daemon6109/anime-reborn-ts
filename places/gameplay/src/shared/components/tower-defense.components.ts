import { Entity } from "@rbxts/jecs";
// Import and re-export enums from config
import { TowerType, EnemyType } from "@shared/config/game-config";
export { TowerType, EnemyType };

export const enum DamageType {
	Physical = "Physical",
	Magical = "Magical",
	Pierce = "Pierce",
	Splash = "Splash",
}

export const enum TargetPriority {
	First = "First",
	Last = "Last",
	Strongest = "Strongest",
	Weakest = "Weakest",
	Closest = "Closest",
}

export const enum EffectType {
	Death = "Death",
	Hit = "Hit",
	Slow = "Slow",
	Poison = "Poison",
	Burn = "Burn",
	Freeze = "Freeze",
	Stun = "Stun",
}

export const enum StatusEffectType {
	Slow = "Slow",
	Poison = "Poison",
	Burn = "Burn",
	Freeze = "Freeze",
	Stun = "Stun",
}

// Core Position and Movement Components
export interface PositionComponent {
	position: Vector3;
}

export interface VelocityComponent {
	velocity: Vector3;
}

export interface RotationComponent {
	rotation: CFrame;
}

// Health and Combat Components
export interface HealthComponent {
	current: number;
	maximum: number;
}

export interface DamageComponent {
	amount: number;
	damageType: DamageType;
}

export interface ArmorComponent {
	physical: number;
	magical: number;
	pierce: number;
}

// Tower Components
export interface TowerComponent {
	towerType: TowerType;
	level: number;
	experience: number;
	playerId: string;
	id: string;
}

export interface TargetingComponent {
	range: number;
	targetPriority: TargetPriority;
	currentTarget?: Entity;
	lastTargetTime: number;
}

export interface AttackComponent {
	damage: number;
	attackSpeed: number; // attacks per second
	lastAttackTime: number;
	projectileSpeed?: number;
	piercing?: number;
	splashRadius?: number;
}

export interface UpgradeableComponent {
	upgradePaths: readonly UpgradePath[];
	currentPath?: number;
	upgradeLevel: number;
}

// Enemy Components
export interface EnemyComponent {
	enemyType: EnemyType;
	reward: number;
	speed: number;
	id: string;
}

export interface PathFollowingComponent {
	waypointIndex: number;
	progress: number; // 0-1 between current and next waypoint
	pathId: string;
}

export interface StatusEffectsComponent {
	effects: Map<StatusEffectType, StatusEffect>;
}

export interface WaveComponent {
	enemyType: EnemyType;
	count: number;
	spawnInterval: number;
	lastSpawnTime: number;
	spawned: number;
}

// Projectile Components
export interface ProjectileComponent {
	damage: number;
	target: Entity;
	speed: number;
	piercing: number;
	splashRadius: number;
	damageType: DamageType;
	id: string;
}

// Rendering Components
export interface ModelComponent {
	model: Model;
}

export interface EffectComponent {
	effectType: EffectType;
	duration: number;
	startTime: number;
	intensity: number;
}

// Game State Components
export interface PlayerResourcesComponent {
	gold: number;
	lives: number;
	score: number;
}

export interface GameStateComponent {
	currentWave: number;
	isWaveActive: boolean;
	enemiesRemaining: number;
	waveStartTime: number;
}

// Visualization Components (Client-only)
export interface PlacementPreviewComponent {
	towerType: TowerType;
	valid: boolean;
}

export interface PathVisualizationComponent {
	points: Vector3[];
	connections: Part[];
}

export interface TweenComponent {
	tween?: Tween;
	targetPosition?: Vector3;
	targetCFrame?: CFrame;
	duration: number;
	easingStyle: Enum.EasingStyle;
	easingDirection: Enum.EasingDirection;
}

// Tags (marker components)
export interface PlayerTag {
	playerId: string;
}

export type TowerTag = true;
export type EnemyTag = true;
export type ProjectileTag = true;
export type DeadTag = true;
export type SelectedTag = true;

// Supporting types
export interface StatusEffect {
	type: StatusEffectType;
	duration: number;
	intensity: number;
	startTime: number;
}

export interface UpgradePath {
	name: string;
	cost: number;
	damageMultiplier?: number;
	rangeMultiplier?: number;
	attackSpeedMultiplier?: number;
	specialEffect?: string;
}

// Tower configuration data
export type TowerConfigMap = Record<TowerType, TowerStats>;

export interface TowerStats {
	cost: number;
	damage: number;
	range: number;
	attackSpeed: number;
	projectileSpeed?: number;
	damageType: DamageType;
	description: string;
}

// Enemy configuration data
export type EnemyConfigMap = Record<EnemyType, EnemyStats>;

export interface EnemyStats {
	health: number;
	speed: number;
	armor: ArmorComponent;
	reward: number;
	description: string;
}

// Path data
export interface PathPoint {
	position: Vector3;
	nextIndex?: number;
}

export interface GamePath {
	id: string;
	points: PathPoint[];
	spawnPoint: Vector3;
	endPoint: Vector3;
}
