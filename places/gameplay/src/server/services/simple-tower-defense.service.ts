// Simple tower defense system with JECS and Flamework
// This is a basic implementation focusing on core functionality

import { Service, OnStart, OnTick } from "@flamework/core";
import { RunService } from "@rbxts/services";

// For now, let's create a simple working system without JECS complexity
// We'll use a basic object-oriented approach that can be migrated to JECS later

interface Tower {
	id: string;
	position: Vector3;
	type: "Archer" | "Mage" | "Cannon";
	level: number;
	damage: number;
	range: number;
	attackSpeed: number;
	lastAttackTime: number;
	target?: Enemy;
}

interface Enemy {
	id: string;
	position: Vector3;
	health: number;
	maxHealth: number;
	speed: number;
	type: "Goblin" | "Orc" | "Troll";
	reward: number;
	direction: Vector3;
}

interface Projectile {
	id: string;
	position: Vector3;
	velocity: Vector3;
	damage: number;
	target: Enemy;
	speed: number;
}

@Service()
export class TowerDefenseSystem implements OnStart, OnTick {
	private towers: Map<string, Tower> = new Map();
	private enemies: Map<string, Enemy> = new Map();
	private projectiles: Map<string, Projectile> = new Map();

	private nextId = 0;

	onStart(): void {
		print("Tower Defense System Started!");
		this.initializeGame();
	}

	onTick(deltaTime: number): void {
		this.updateEnemyMovement(deltaTime);
		this.updateTowerTargeting();
		this.updateTowerAttacking();
		this.updateProjectiles(deltaTime);
		this.checkCollisions();
		this.cleanupDeadEntities();
		this.spawnEnemiesIfNeeded();
	}

	private initializeGame(): void {
		// Create some initial towers
		this.createTower("Archer", new Vector3(0, 5, 0));
		this.createTower("Mage", new Vector3(10, 5, 0));
		this.createTower("Cannon", new Vector3(-10, 5, 0));

		// Spawn initial enemies
		for (let i = 0; i < 3; i++) {
			this.spawnEnemy("Goblin", new Vector3(math.random(-30, 30), 0, 50));
		}
	}

	private createTower(type: "Archer" | "Mage" | "Cannon", position: Vector3): Tower {
		const id = `tower_${this.nextId++}`;

		const towerStats = {
			Archer: { damage: 25, range: 20, attackSpeed: 1.5 },
			Mage: { damage: 40, range: 15, attackSpeed: 1.0 },
			Cannon: { damage: 100, range: 25, attackSpeed: 0.5 },
		};

		const stats = towerStats[type];
		const tower: Tower = {
			id,
			position,
			type,
			level: 1,
			damage: stats.damage,
			range: stats.range,
			attackSpeed: stats.attackSpeed,
			lastAttackTime: 0,
		};

		this.towers.set(id, tower);
		print(`Created ${type} tower at ${position}`);
		return tower;
	}

	private spawnEnemy(type: "Goblin" | "Orc" | "Troll", position: Vector3): Enemy {
		const id = `enemy_${this.nextId++}`;

		const enemyStats = {
			Goblin: { health: 100, speed: 8, reward: 10 },
			Orc: { health: 200, speed: 6, reward: 20 },
			Troll: { health: 500, speed: 4, reward: 50 },
		};

		const stats = enemyStats[type];
		const enemy: Enemy = {
			id,
			position,
			health: stats.health,
			maxHealth: stats.health,
			speed: stats.speed,
			type,
			reward: stats.reward,
			direction: Vector3.zAxis.mul(-1), // Move towards negative Z
		};

		this.enemies.set(id, enemy);
		return enemy;
	}

	private createProjectile(tower: Tower, target: Enemy): Projectile {
		const id = `projectile_${this.nextId++}`;

		const direction = target.position.sub(tower.position).Unit;
		const projectileSpeed = 30;

		const projectile: Projectile = {
			id,
			position: tower.position.add(new Vector3(0, 2, 0)), // Start above tower
			velocity: direction.mul(projectileSpeed),
			damage: tower.damage,
			target,
			speed: projectileSpeed,
		};

		this.projectiles.set(id, projectile);
		return projectile;
	}

	private updateEnemyMovement(deltaTime: number): void {
		for (const [id, enemy] of this.enemies) {
			// Simple movement towards destination
			const movement = enemy.direction.mul(enemy.speed * deltaTime);
			enemy.position = enemy.position.add(movement);

			// Remove enemies that have moved too far
			if (enemy.position.Z < -50) {
				this.enemies.delete(id);
				print(`Enemy ${enemy.type} reached the end!`);
			}
		}
	}

	private updateTowerTargeting(): void {
		for (const [, tower] of this.towers) {
			let closestEnemy: Enemy | undefined;
			let closestDistance = tower.range;

			// Find closest enemy in range
			for (const [, enemy] of this.enemies) {
				if (enemy.health <= 0) continue;

				const distance = tower.position.sub(enemy.position).Magnitude;
				if (distance < closestDistance) {
					closestDistance = distance;
					closestEnemy = enemy;
				}
			}

			tower.target = closestEnemy;
		}
	}

	private updateTowerAttacking(): void {
		const currentTime = tick();

		for (const [, tower] of this.towers) {
			if (!tower.target || tower.target.health <= 0) continue;

			// Check if enough time has passed since last attack
			const timeSinceLastAttack = currentTime - tower.lastAttackTime;
			const attackCooldown = 1 / tower.attackSpeed;

			if (timeSinceLastAttack >= attackCooldown) {
				// Verify target is still in range
				const distance = tower.position.sub(tower.target.position).Magnitude;
				if (distance <= tower.range) {
					this.createProjectile(tower, tower.target);
					tower.lastAttackTime = currentTime;
				}
			}
		}
	}

	private updateProjectiles(deltaTime: number): void {
		const projectilesToRemove: string[] = [];

		for (const [id, projectile] of this.projectiles) {
			// Update projectile position
			projectile.position = projectile.position.add(projectile.velocity.mul(deltaTime));

			// Check if projectile reached its target or is too far
			const distanceToTarget = projectile.position.sub(projectile.target.position).Magnitude;

			if (distanceToTarget < 2) {
				// Hit the target
				this.damageEnemy(projectile.target, projectile.damage);
				projectilesToRemove.push(id);
			} else if (projectile.position.Magnitude > 200) {
				// Projectile went too far
				projectilesToRemove.push(id);
			}
		}

		// Remove finished projectiles
		for (const id of projectilesToRemove) {
			this.projectiles.delete(id);
		}
	}

	private checkCollisions(): void {
		// Additional collision checking if needed
		// For now, projectile collision is handled in updateProjectiles
	}

	private damageEnemy(enemy: Enemy, damage: number): void {
		enemy.health = math.max(0, enemy.health - damage);

		if (enemy.health <= 0) {
			print(`${enemy.type} defeated! Reward: ${enemy.reward} gold`);
			// In a real game, you'd add the reward to player resources here
		}
	}

	private cleanupDeadEntities(): void {
		// Remove dead enemies
		const deadEnemies: string[] = [];
		for (const [id, enemy] of this.enemies) {
			if (enemy.health <= 0) {
				deadEnemies.push(id);
			}
		}

		for (const id of deadEnemies) {
			this.enemies.delete(id);
		}

		// Remove projectiles targeting dead enemies
		const invalidProjectiles: string[] = [];
		for (const [id, projectile] of this.projectiles) {
			if (projectile.target.health <= 0) {
				invalidProjectiles.push(id);
			}
		}

		for (const id of invalidProjectiles) {
			this.projectiles.delete(id);
		}
	}

	private spawnEnemiesIfNeeded(): void {
		// Spawn new enemies if there are too few
		if (this.enemies.size() < 5) {
			const enemyTypes: ("Goblin" | "Orc" | "Troll")[] = ["Goblin", "Goblin", "Orc", "Troll"];
			const randomType = enemyTypes[math.random(0, enemyTypes.size() - 1)];
			this.spawnEnemy(randomType, new Vector3(math.random(-30, 30), 0, 50));
		}
	}

	// Public methods for external control
	public createTowerAt(type: "Archer" | "Mage" | "Cannon", position: Vector3): Tower {
		return this.createTower(type, position);
	}

	public spawnEnemyWave(count: number, type: "Goblin" | "Orc" | "Troll" = "Goblin"): void {
		for (let i = 0; i < count; i++) {
			this.spawnEnemy(type, new Vector3(math.random(-30, 30), 0, 50));
		}
	}

	public getTowers(): ReadonlyMap<string, Tower> {
		return this.towers;
	}

	public getEnemies(): ReadonlyMap<string, Enemy> {
		return this.enemies;
	}

	public getProjectiles(): ReadonlyMap<string, Projectile> {
		return this.projectiles;
	}
}
