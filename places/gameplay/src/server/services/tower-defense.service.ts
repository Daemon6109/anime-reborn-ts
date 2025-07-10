import { Service, OnStart, OnTick } from "@flamework/core";
import * as jecs from "@rbxts/jecs";
import {
	PositionComponent,
	VelocityComponent,
	TargetingComponent,
	AttackComponent,
	HealthComponent,
	TowerComponent,
	EnemyComponent,
	ProjectileComponent,
	TowerTag,
	EnemyTag,
	ProjectileTag,
	DeadTag,
	TowerType,
	EnemyType,
	TargetPriority,
	DamageType,
} from "@shared/components/tower-defense.components";

@Service()
export class TowerDefenseService implements OnStart, OnTick {
	private world!: jecs.World;

	// Components
	private Position!: jecs.Entity<PositionComponent>;
	private Velocity!: jecs.Entity<VelocityComponent>;
	private Health!: jecs.Entity<HealthComponent>;
	private Targeting!: jecs.Entity<TargetingComponent>;
	private Attack!: jecs.Entity<AttackComponent>;
	private Tower!: jecs.Entity<TowerComponent>;
	private Enemy!: jecs.Entity<EnemyComponent>;
	private Projectile!: jecs.Entity<ProjectileComponent>;

	// Tags
	private TowerTag!: jecs.Entity<TowerTag>;
	private EnemyTag!: jecs.Entity<EnemyTag>;
	private ProjectileTag!: jecs.Entity<ProjectileTag>;
	private DeadTag!: jecs.Entity<DeadTag>;

	onStart(): void {
		this.initializeWorld();
		this.spawnInitialEnemies();
		this.createExampleTower();
	}

	onTick(deltaTime: number): void {
		this.updateMovement(deltaTime);
		this.updateTargeting(deltaTime);
		this.updateAttacking(deltaTime);
		this.updateProjectiles(deltaTime);
		this.cleanupDeadEntities();
	}

	private initializeWorld(): void {
		this.world = jecs.world();

		// Register components
		this.Position = this.world.component<PositionComponent>();
		this.Velocity = this.world.component<VelocityComponent>();
		this.Health = this.world.component<HealthComponent>();
		this.Targeting = this.world.component<TargetingComponent>();
		this.Attack = this.world.component<AttackComponent>();
		this.Tower = this.world.component<TowerComponent>();
		this.Enemy = this.world.component<EnemyComponent>();
		this.Projectile = this.world.component<ProjectileComponent>();

		// Register tags
		this.TowerTag = this.world.component<TowerTag>();
		this.EnemyTag = this.world.component<EnemyTag>();
		this.ProjectileTag = this.world.component<ProjectileTag>();
		this.DeadTag = this.world.component<DeadTag>();
	}

	private spawnInitialEnemies(): void {
		// Spawn 5 enemies for testing
		for (let i = 0; i < 5; i++) {
			this.spawnEnemy(new Vector3(math.random(-50, 50), 0, math.random(-50, 50)));
		}
	}

	private createExampleTower(): void {
		const tower = this.world.entity();

		this.world.set(tower, this.Position, {
			position: new Vector3(0, 5, 0),
		});
		this.world.set(tower, this.Tower, {
			towerType: TowerType.BasicTower,
			level: 1,
			experience: 0,
			playerId: "test-player",
			id: tostring(tower),
		});

		this.world.set(tower, this.Targeting, {
			range: 20,
			targetPriority: TargetPriority.Closest,
			lastTargetTime: 0,
		});

		this.world.set(tower, this.Attack, {
			damage: 25,
			attackSpeed: 1.5,
			lastAttackTime: 0,
			projectileSpeed: 30,
		});

		this.world.set(tower, this.Health, {
			current: 100,
			maximum: 100,
		});

		this.world.set(tower, this.TowerTag, true);

		print("Created tower at", this.world.get(tower, this.Position)?.position);
	}

	public spawnEnemy(position: Vector3): jecs.Entity {
		const enemy = this.world.entity();

		this.world.set(enemy, this.Position, { position });
		this.world.set(enemy, this.Velocity, { velocity: Vector3.zAxis.mul(-5) });
		this.world.set(enemy, this.Health, { current: 100, maximum: 100 });
		this.world.set(enemy, this.Enemy, {
			enemyType: EnemyType.BasicEnemy,
			reward: 10,
			speed: 5,
			id: tostring(enemy),
		});

		this.world.set(enemy, this.EnemyTag, true);

		return enemy;
	}

	private updateMovement(deltaTime: number): void {
		// Update positions based on velocity
		for (const [entity, position, velocity] of this.world.query(this.Position, this.Velocity)) {
			const currentPos = this.world.get(entity, this.Position);
			const currentVel = this.world.get(entity, this.Velocity);

			if (currentPos && currentVel) {
				this.world.set(entity, this.Position, {
					position: currentPos.position.add(currentVel.velocity.mul(deltaTime)),
				});
			}
		}
	}

	private updateTargeting(deltaTime: number): void {
		const currentTime = tick();

		// Update tower targeting
		for (const [tower] of this.world.query(this.TowerTag, this.Targeting, this.Position)) {
			const targeting = this.world.get(tower, this.Targeting);
			const towerPos = this.world.get(tower, this.Position);

			if (targeting === undefined || towerPos === undefined) continue;

			let closestEnemy: jecs.Entity | undefined;
			let closestDistance = targeting.range;

			// Find closest enemy in range
			for (const [enemy] of this.world.query(this.EnemyTag, this.Position, this.Health)) {
				const enemyPos = this.world.get(enemy, this.Position);
				const enemyHealth = this.world.get(enemy, this.Health);

				if (!enemyPos || !enemyHealth || enemyHealth.current <= 0) continue;

				const distance = towerPos.position.sub(enemyPos.position).Magnitude;
				if (distance < closestDistance) {
					closestDistance = distance;
					closestEnemy = enemy;
				}
			}

			// Update targeting
			this.world.set(tower, this.Targeting, {
				...targeting,
				currentTarget: closestEnemy,
				lastTargetTime: currentTime,
			});
		}
	}

	private updateAttacking(deltaTime: number): void {
		const currentTime = tick();

		// Update tower attacks
		for (const [tower] of this.world.query(this.TowerTag, this.Attack, this.Targeting, this.Position)) {
			const attack = this.world.get(tower, this.Attack);
			const targeting = this.world.get(tower, this.Targeting);
			const towerPos = this.world.get(tower, this.Position);

			if (
				attack === undefined ||
				targeting === undefined ||
				towerPos === undefined ||
				targeting.currentTarget === undefined
			)
				continue;

			// Check if enough time has passed since last attack
			const timeSinceLastAttack = currentTime - attack.lastAttackTime;
			const attackCooldown = 1 / attack.attackSpeed;

			if (timeSinceLastAttack >= attackCooldown) {
				this.fireProjectile(tower, targeting.currentTarget);

				// Update last attack time
				this.world.set(tower, this.Attack, {
					...attack,
					lastAttackTime: currentTime,
				});
			}
		}
	}

	private fireProjectile(tower: jecs.Entity, target: jecs.Entity): void {
		const towerPos = this.world.get(tower, this.Position);
		const towerAttack = this.world.get(tower, this.Attack);
		const targetPos = this.world.get(target, this.Position);

		if (towerPos === undefined || towerAttack === undefined || targetPos === undefined) return;

		const projectile = this.world.entity();

		// Calculate direction to target
		const direction = targetPos.position.sub(towerPos.position).Unit;
		const speed = towerAttack.projectileSpeed !== undefined ? towerAttack.projectileSpeed : 20;

		this.world.set(projectile, this.Position, {
			position: towerPos.position.add(new Vector3(0, 2, 0)), // Spawn slightly above tower
		});

		this.world.set(projectile, this.Velocity, {
			velocity: direction.mul(speed),
		});

		this.world.set(projectile, this.Projectile, {
			damage: towerAttack.damage,
			target,
			speed,
			piercing: towerAttack.piercing !== undefined ? towerAttack.piercing : 0,
			splashRadius: towerAttack.splashRadius !== undefined ? towerAttack.splashRadius : 0,
			damageType: DamageType.Physical,
			id: tostring(projectile),
		});

		this.world.set(projectile, this.ProjectileTag, true);
	}

	private updateProjectiles(deltaTime: number): void {
		// Update projectile movement and collision
		for (const [projectile] of this.world.query(
			this.ProjectileTag,
			this.Position,
			this.Velocity,
			this.Projectile,
		)) {
			const projData = this.world.get(projectile, this.Projectile);
			const projPos = this.world.get(projectile, this.Position);

			if (!projData || !projPos) continue;

			// Check if projectile hit its target
			const targetPos = this.world.get(projData.target, this.Position);
			const targetHealth = this.world.get(projData.target, this.Health);

			if (targetPos && targetHealth && targetHealth.current > 0) {
				const distance = projPos.position.sub(targetPos.position).Magnitude;

				// Hit if close enough
				if (distance < 2) {
					this.damageEntity(projData.target, projData.damage);
					this.world.set(projectile, this.DeadTag, true);
					continue;
				}
			} else {
				// Target is dead or doesn't exist, remove projectile
				this.world.set(projectile, this.DeadTag, true);
				continue;
			}

			// Remove projectile if it's too far from origin
			if (projPos.position.Magnitude > 200) {
				this.world.set(projectile, this.DeadTag, true);
			}
		}
	}

	private damageEntity(entity: jecs.Entity, damage: number): void {
		const health = this.world.get(entity, this.Health);
		if (!health) return;

		const newHealth = math.max(0, health.current - damage);
		this.world.set(entity, this.Health, {
			...health,
			current: newHealth,
		});

		// Mark as dead if health reaches 0
		if (newHealth <= 0) {
			this.world.set(entity, this.DeadTag, true);
			print("Entity died!");
		}
	}

	private cleanupDeadEntities(): void {
		// Remove all entities marked as dead
		for (const [entity] of this.world.query(this.DeadTag)) {
			// In a real game, you might want to play death effects here
			if (this.world.has(entity, this.EnemyTag)) {
				print("Enemy defeated!");
				// Spawn a new enemy to keep the action going
				this.spawnEnemy(new Vector3(math.random(-50, 50), 0, 50));
			}

			// Remove the entity (this removes all its components)
			this.world.delete(entity);
		}
	}

	public getWorld(): jecs.World {
		return this.world;
	}
}
