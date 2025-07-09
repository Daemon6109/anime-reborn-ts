import { Entity } from "@rbxts/jecs";

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
}

// Rendering Components
export interface ModelComponent {
	model: Model;
}

export interface EffectComponent {
	effectType: EffectType;
	duration: number;
	startTime: number;
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

// Tags (components without data)
export type PlayerTag = undefined;
export type TowerTag = undefined;
export type EnemyTag = undefined;
export type ProjectileTag = undefined;
export type DeadTag = undefined;
export type SelectedTag = undefined;

// Enums and Types
export enum TowerType {
	Archer = "Archer",
	Mage = "Mage",
	Cannon = "Cannon",
	Support = "Support",
}

export enum EnemyType {
	Goblin = "Goblin",
	Orc = "Orc",
	Troll = "Troll",
	Boss = "Boss",
}

export enum TargetPriority {
	First = "First",
	Last = "Last",
	Closest = "Closest",
	Strongest = "Strongest",
	Weakest = "Weakest",
}

export enum DamageType {
	Physical = "Physical",
	Magical = "Magical",
	Pierce = "Pierce",
	True = "True",
}

export enum StatusEffectType {
	Slow = "Slow",
	Freeze = "Freeze",
	Burn = "Burn",
	Poison = "Poison",
	Stun = "Stun",
}

export enum EffectType {
	Hit = "Hit",
	Death = "Death",
	Explosion = "Explosion",
	Heal = "Heal",
}

export interface StatusEffect {
	type: StatusEffectType;
	intensity: number;
	duration: number;
	startTime: number;
}

export interface UpgradePath {
	name: string;
	description: string;
	cost: number;
	requirements: UpgradeRequirement[];
	bonuses: UpgradeBonus[];
}

export interface UpgradeRequirement {
	type: "level" | "tower_count" | "wave";
	value: number;
}

export interface UpgradeBonus {
	stat: keyof AttackComponent | keyof TargetingComponent;
	type: "add" | "multiply";
	value: number;
}
