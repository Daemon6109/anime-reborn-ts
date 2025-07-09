import { Service } from "@flamework/core";
import { Players, RunService, Workspace } from "@rbxts/services";
import { TDWorld } from "../../shared/world/td-world";
import * as jecs from "@rbxts/jecs";
import {
	TowerType,
	EnemyType,
	TargetPriority,
	DamageType,
	EffectType,
} from "../../shared/components/tower-defense.components";

@Service()
export class ECSTowerDefenseService {
	private currentWave = 0;
	private gameActive = false;

	constructor() {
		this.setupGame();
		this.startGameLoop();
	}

	private setupGame() {
		// Initialize a simple game state entity
		const gameStateEntity = TDWorld.createEntity();
		TDWorld.world.set(gameStateEntity, TDWorld.GameState, {
			currentWave: 0,
			isWaveActive: false,
			enemiesRemaining: 0,
			waveStartTime: 0,
		});

		print("ECS Tower Defense Service initialized!");
	}

	private startGameLoop() {
		RunService.Heartbeat.Connect((deltaTime) => {
			this.updateMovementSystem(deltaTime);
			this.updateTargetingSystem();
			this.updateAttackSystem(deltaTime);
			this.updateProjectileSystem(deltaTime);
			this.updateHealthSystem();
		});
	}

	private updateMovementSystem(deltaTime: number) {
		// Update entities with position and velocity
		for (const [entity, position, velocity] of TDWorld.world.query(TDWorld.Position, TDWorld.Velocity)) {
			// Update position based on velocity
			const newPosition = position.position.add(velocity.velocity.mul(deltaTime));
			TDWorld.world.set(entity, TDWorld.Position, {
				position: newPosition,
			});

			// Update visual model if present
			const model = TDWorld.world.get(entity, TDWorld.Model);
			if (model?.model.PrimaryPart) {
				model.model.SetPrimaryPartCFrame(new CFrame(newPosition));
			}
		}
	}

	private updateTargetingSystem() {
		// Update tower targeting
		for (const [towerEntity, targeting, towerPos] of TDWorld.world.query(TDWorld.Targeting, TDWorld.Position)) {
			let closestEnemy: jecs.Entity | undefined;
			let closestDistance = targeting.range;

			// Find enemies in range
			for (const [enemyEntity, enemyPos] of TDWorld.world.query(TDWorld.Position, TDWorld.EnemyTag)) {
				const distance = towerPos.position.sub(enemyPos.position).Magnitude;
				if (distance <= targeting.range && distance < closestDistance) {
					closestDistance = distance;
					closestEnemy = enemyEntity;
				}
			}

			// Update targeting component
			TDWorld.world.set(towerEntity, TDWorld.Targeting, {
				range: targeting.range,
				targetPriority: targeting.targetPriority,
				currentTarget: closestEnemy,
				lastTargetTime: targeting.lastTargetTime,
			});
		}
	}

	private updateAttackSystem(deltaTime: number) {
		const currentTime = tick();

		for (const [towerEntity, attack, targeting] of TDWorld.world.query(TDWorld.Attack, TDWorld.Targeting)) {
			const timeSinceLastAttack = currentTime - attack.lastAttackTime;
			const attackCooldown = 1 / attack.attackSpeed; // Convert attacks per second to cooldown

			if (targeting.currentTarget !== undefined && timeSinceLastAttack >= attackCooldown) {
				this.fireProjectile(towerEntity, targeting.currentTarget, attack.damage);

				// Update attack component
				TDWorld.world.set(towerEntity, TDWorld.Attack, {
					damage: attack.damage,
					attackSpeed: attack.attackSpeed,
					lastAttackTime: currentTime,
					projectileSpeed: attack.projectileSpeed,
					piercing: attack.piercing,
					splashRadius: attack.splashRadius,
				});
			}
		}
	}

	private updateProjectileSystem(deltaTime: number) {
		for (const [projectileEntity, projectile, position] of TDWorld.world.query(
			TDWorld.Projectile,
			TDWorld.Position,
		)) {
			// Check if target still exists
			if (!TDWorld.world.contains(projectile.target)) {
				TDWorld.destroyEntity(projectileEntity);
				continue;
			}

			// Get target position
			const targetPos = TDWorld.world.get(projectile.target, TDWorld.Position);
			if (!targetPos) {
				TDWorld.destroyEntity(projectileEntity);
				continue;
			}

			// Move towards target
			const direction = targetPos.position.sub(position.position).Unit;
			const velocity = direction.mul(projectile.speed);

			TDWorld.world.set(projectileEntity, TDWorld.Velocity, {
				velocity: velocity,
			});

			// Check if hit target
			const distance = targetPos.position.sub(position.position).Magnitude;
			if (distance < 2) {
				this.hitTarget(projectile.target, projectile.damage);
				TDWorld.destroyEntity(projectileEntity);
			}
		}
	}

	private updateHealthSystem() {
		// Handle entities with zero health
		for (const [entity, health] of TDWorld.world.query(TDWorld.Health)) {
			if (health.current <= 0) {
				this.createDeathEffect(entity);
				TDWorld.destroyEntity(entity);
			}
		}
	}

	private fireProjectile(fromEntity: jecs.Entity, targetEntity: jecs.Entity, damage: number) {
		const fromPos = TDWorld.world.get(fromEntity, TDWorld.Position);
		if (!fromPos) return;

		const projectileEntity = TDWorld.createEntity();

		// Set projectile components
		TDWorld.world.set(projectileEntity, TDWorld.Position, {
			position: fromPos.position,
		});

		TDWorld.world.set(projectileEntity, TDWorld.Velocity, {
			velocity: new Vector3(0, 0, 0), // Will be updated in updateProjectileSystem
		});

		TDWorld.world.set(projectileEntity, TDWorld.Projectile, {
			damage: damage,
			target: targetEntity,
			speed: 50,
			piercing: 0,
			splashRadius: 0,
			damageType: DamageType.Physical,
		});

		TDWorld.world.add(projectileEntity, TDWorld.ProjectileTag);

		// Create visual model
		this.createProjectileModel(projectileEntity);
	}

	private hitTarget(targetEntity: jecs.Entity, damage: number) {
		const health = TDWorld.world.get(targetEntity, TDWorld.Health);
		if (!health) return;

		// Apply damage
		TDWorld.world.set(targetEntity, TDWorld.Health, {
			current: health.current - damage,
			maximum: health.maximum,
		});

		// Create hit effect
		const position = TDWorld.world.get(targetEntity, TDWorld.Position);
		if (position) {
			this.createHitEffect(position.position);
		}
	}

	private createDeathEffect(entity: jecs.Entity) {
		const position = TDWorld.world.get(entity, TDWorld.Position);
		if (!position) return;

		const effectEntity = TDWorld.createEntity();
		TDWorld.world.set(effectEntity, TDWorld.Position, {
			position: position.position,
		});

		TDWorld.world.set(effectEntity, TDWorld.Effect, {
			effectType: EffectType.Death,
			duration: 2,
			startTime: tick(),
		});
	}

	private createHitEffect(position: Vector3) {
		const effectEntity = TDWorld.createEntity();
		TDWorld.world.set(effectEntity, TDWorld.Position, {
			position: position,
		});

		TDWorld.world.set(effectEntity, TDWorld.Effect, {
			effectType: EffectType.Hit,
			duration: 0.5,
			startTime: tick(),
		});
	}

	private createProjectileModel(projectileEntity: jecs.Entity) {
		const part = new Instance("Part");
		part.Name = "Projectile";
		part.Size = new Vector3(0.5, 0.5, 0.5);
		part.Material = Enum.Material.Neon;
		part.Color = Color3.fromRGB(0, 162, 255); // Bright blue
		part.Shape = Enum.PartType.Ball;
		part.CanCollide = false;
		part.Anchored = true;
		part.Parent = Workspace;

		// Wrap part in a model
		const model = new Instance("Model");
		model.Name = "ProjectileModel";
		part.Parent = model;
		model.PrimaryPart = part;
		model.Parent = Workspace;

		TDWorld.world.set(projectileEntity, TDWorld.Model, {
			model: model,
		});
	}

	// Public API methods
	public placeTower(position: Vector3, towerType: TowerType): jecs.Entity {
		const towerEntity = TDWorld.createEntity();

		// Add tower components
		TDWorld.world.add(towerEntity, TDWorld.TowerTag);

		TDWorld.world.set(towerEntity, TDWorld.Position, {
			position: position,
		});

		TDWorld.world.set(towerEntity, TDWorld.Tower, {
			towerType: towerType,
			level: 1,
			experience: 0,
		});

		TDWorld.world.set(towerEntity, TDWorld.Targeting, {
			range: 20,
			targetPriority: TargetPriority.Closest,
			currentTarget: undefined,
			lastTargetTime: 0,
		});

		TDWorld.world.set(towerEntity, TDWorld.Attack, {
			damage: 10,
			attackSpeed: 1,
			lastAttackTime: 0,
			projectileSpeed: 50,
			piercing: 0,
			splashRadius: 0,
		});

		// Create visual model
		this.createTowerModel(towerEntity, towerType);

		return towerEntity;
	}

	public spawnEnemy(position: Vector3, enemyType: EnemyType): jecs.Entity {
		const enemyEntity = TDWorld.createEntity();

		// Add enemy components
		TDWorld.world.add(enemyEntity, TDWorld.EnemyTag);

		TDWorld.world.set(enemyEntity, TDWorld.Position, {
			position: position,
		});

		TDWorld.world.set(enemyEntity, TDWorld.Enemy, {
			enemyType: enemyType,
			reward: 10,
			speed: 5,
		});

		TDWorld.world.set(enemyEntity, TDWorld.Health, {
			current: 100,
			maximum: 100,
		});

		TDWorld.world.set(enemyEntity, TDWorld.Velocity, {
			velocity: new Vector3(5, 0, 0), // Move right
		});

		// Create visual model
		this.createEnemyModel(enemyEntity, enemyType);

		return enemyEntity;
	}

	private createTowerModel(towerEntity: jecs.Entity, type: TowerType) {
		const part = new Instance("Part");
		part.Name = `Tower_${type}`;
		part.Size = new Vector3(4, 4, 4);
		part.Color = Color3.fromRGB(99, 95, 98); // Dark stone gray
		part.Shape = Enum.PartType.Cylinder;
		part.CanCollide = false;
		part.Anchored = true;

		const model = new Instance("Model");
		model.Name = `TowerModel_${type}`;
		part.Parent = model;
		model.PrimaryPart = part;
		model.Parent = Workspace;

		TDWorld.world.set(towerEntity, TDWorld.Model, {
			model: model,
		});
	}

	private createEnemyModel(enemyEntity: jecs.Entity, type: EnemyType) {
		const part = new Instance("Part");
		part.Name = `Enemy_${type}`;
		part.Size = new Vector3(2, 2, 2);
		part.Color = Color3.fromRGB(196, 40, 28); // Bright red
		part.Shape = Enum.PartType.Block;
		part.CanCollide = false;
		part.Anchored = true;

		const model = new Instance("Model");
		model.Name = `EnemyModel_${type}`;
		part.Parent = model;
		model.PrimaryPart = part;
		model.Parent = Workspace;

		TDWorld.world.set(enemyEntity, TDWorld.Model, {
			model: model,
		});
	}

	// Utility methods
	public getTowerCount(): number {
		let count = 0;
		for (const [_] of TDWorld.world.query(TDWorld.TowerTag)) {
			count++;
		}
		return count;
	}

	public getEnemyCount(): number {
		let count = 0;
		for (const [_] of TDWorld.world.query(TDWorld.EnemyTag)) {
			count++;
		}
		return count;
	}

	public getCurrentWave(): number {
		return this.currentWave;
	}
}
