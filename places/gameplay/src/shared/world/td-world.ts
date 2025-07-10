import { World } from "@rbxts/jecs";
import * as jecs from "@rbxts/jecs";
import {
	// Core components
	PositionComponent,
	VelocityComponent,
	RotationComponent,
	// Health and combat
	HealthComponent,
	DamageComponent,
	ArmorComponent,
	// Tower components
	TowerComponent,
	TargetingComponent,
	AttackComponent,
	UpgradeableComponent,
	// Enemy components
	EnemyComponent,
	PathFollowingComponent,
	StatusEffectsComponent,
	WaveComponent,
	// Projectile components
	ProjectileComponent,
	// Rendering components
	ModelComponent,
	EffectComponent,
	// Game state
	PlayerResourcesComponent,
	GameStateComponent,
	// Visualization components
	PlacementPreviewComponent,
	PathVisualizationComponent,
	TweenComponent,
	// Tags
	PlayerTag,
	TowerTag,
	EnemyTag,
	ProjectileTag,
	DeadTag,
	SelectedTag,
} from "@shared/components/tower-defense.components";

export class TowerDefenseWorld {
	public readonly world: World;

	// Core Components
	public readonly Position: jecs.Entity<PositionComponent>;
	public readonly Velocity: jecs.Entity<VelocityComponent>;
	public readonly Rotation: jecs.Entity<RotationComponent>;

	// Health and Combat
	public readonly Health: jecs.Entity<HealthComponent>;
	public readonly Damage: jecs.Entity<DamageComponent>;
	public readonly Armor: jecs.Entity<ArmorComponent>;

	// Tower Components
	public readonly Tower: jecs.Entity<TowerComponent>;
	public readonly Targeting: jecs.Entity<TargetingComponent>;
	public readonly Attack: jecs.Entity<AttackComponent>;
	public readonly Upgradeable: jecs.Entity<UpgradeableComponent>;

	// Enemy Components
	public readonly Enemy: jecs.Entity<EnemyComponent>;
	public readonly PathFollowing: jecs.Entity<PathFollowingComponent>;
	public readonly StatusEffects: jecs.Entity<StatusEffectsComponent>;
	public readonly Wave: jecs.Entity<WaveComponent>;

	// Projectile Components
	public readonly Projectile: jecs.Entity<ProjectileComponent>;

	// Rendering Components
	public readonly Model: jecs.Entity<ModelComponent>;
	public readonly Effect: jecs.Entity<EffectComponent>;

	// Visualization Components (Client-only)
	public readonly PlacementPreview: jecs.Entity<PlacementPreviewComponent>;
	public readonly PathVisualization: jecs.Entity<PathVisualizationComponent>;
	public readonly Tween: jecs.Entity<TweenComponent>;

	// Game State
	public readonly PlayerResources: jecs.Entity<PlayerResourcesComponent>;
	public readonly GameState: jecs.Entity<GameStateComponent>;

	// Tags
	public readonly PlayerTag: jecs.Entity<PlayerTag>;
	public readonly TowerTag: jecs.Entity<TowerTag>;
	public readonly EnemyTag: jecs.Entity<EnemyTag>;
	public readonly ProjectileTag: jecs.Entity<ProjectileTag>;
	public readonly DeadTag: jecs.Entity<DeadTag>;
	public readonly SelectedTag: jecs.Entity<SelectedTag>;

	constructor() {
		this.world = jecs.world();

		// Register all components
		this.Position = this.world.component<PositionComponent>();
		this.Velocity = this.world.component<VelocityComponent>();
		this.Rotation = this.world.component<RotationComponent>();

		this.Health = this.world.component<HealthComponent>();
		this.Damage = this.world.component<DamageComponent>();
		this.Armor = this.world.component<ArmorComponent>();

		this.Tower = this.world.component<TowerComponent>();
		this.Targeting = this.world.component<TargetingComponent>();
		this.Attack = this.world.component<AttackComponent>();
		this.Upgradeable = this.world.component<UpgradeableComponent>();

		this.Enemy = this.world.component<EnemyComponent>();
		this.PathFollowing = this.world.component<PathFollowingComponent>();
		this.StatusEffects = this.world.component<StatusEffectsComponent>();
		this.Wave = this.world.component<WaveComponent>();

		this.Projectile = this.world.component<ProjectileComponent>();

		this.Model = this.world.component<ModelComponent>();
		this.Effect = this.world.component<EffectComponent>();

		// Visualization Components
		this.PlacementPreview = this.world.component<PlacementPreviewComponent>();
		this.PathVisualization = this.world.component<PathVisualizationComponent>();
		this.Tween = this.world.component<TweenComponent>();

		// Game State
		this.PlayerResources = this.world.component<PlayerResourcesComponent>();
		this.GameState = this.world.component<GameStateComponent>();

		// Tags (using undefined for tag components)
		this.PlayerTag = this.world.component<PlayerTag>();
		this.TowerTag = this.world.component<TowerTag>();
		this.EnemyTag = this.world.component<EnemyTag>();
		this.ProjectileTag = this.world.component<ProjectileTag>();
		this.DeadTag = this.world.component<DeadTag>();
		this.SelectedTag = this.world.component<SelectedTag>();
	}

	/**
	 * Creates a new entity
	 */
	public createEntity() {
		return this.world.entity();
	}

	/**
	 * Destroys an entity and all its components
	 */
	public destroyEntity(entity: jecs.Entity) {
		// In JECS, we can directly delete the entity
		this.world.delete(entity);
	}

	/**
	 * Get all entities with specific components
	 */
	public query(...components: jecs.Id[]) {
		return this.world.query(...components);
	}
}

// Singleton instance
export const TDWorld = new TowerDefenseWorld();
