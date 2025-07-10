import { Service, OnStart, OnTick } from "@flamework/core";
import { RunService } from "@rbxts/services";
import {
	GAME_CONFIG,
	GameMath,
	EffectUtils,
	WaveManager,
	TowerType,
	EnemyType,
} from "@shared/utils/tower-defense.utils";

interface Tower {
	id: string;
	position: Vector3;
	type: TowerType;
	level: number;
	damage: number;
	range: number;
	attackSpeed: number;
	lastAttackTime: number;
	target?: Enemy;
	visual?: Instance;
}

interface Enemy {
	id: string;
	position: Vector3;
	health: number;
	maxHealth: number;
	speed: number;
	type: EnemyType;
	reward: number;
	armor: number;
	direction: Vector3;
	visual?: Instance;
}

interface Projectile {
	id: string;
	position: Vector3;
	velocity: Vector3;
	damage: number;
	target: Enemy;
	speed: number;
	visual?: Instance;
}

@Service()
export class EnhancedTowerDefenseService implements OnStart, OnTick {
	private towers: Map<string, Tower> = new Map();
	private enemies: Map<string, Enemy> = new Map();
	private projectiles: Map<string, Projectile> = new Map();
	private waveManager = new WaveManager();

	private nextId = 0;
	private playerGold = 1000;
	private playerLives = 20;
	private lastWaveCheck = 0;

	onStart(): void {
		print("Enhanced Tower Defense System Started!");
		this.setupTestScenario();
	}

	onTick(deltaTime: number): void {
		this.updateWaveManagement();
		this.updateEnemyMovement(deltaTime);
		this.updateTowerTargeting();
		this.updateTowerAttacking();
		this.updateProjectiles(deltaTime);
		this.checkCollisions();
		this.cleanupDeadEntities();
	}

	private setupTestScenario(): void {
		// Create some initial towers for testing
		this.createTower("Archer", new Vector3(0, 5, 0));
		this.createTower("Mage", new Vector3(10, 5, 0));
		this.createTower("Cannon", new Vector3(-10, 5, 0));

		// Start the first wave
		this.startNextWave();
	}

	private updateWaveManagement(): void {
		const currentTime = tick();

		// Check if we should start a new wave
		if (!this.waveManager.isCurrentWaveActive() && currentTime - this.lastWaveCheck > 1) {
			this.lastWaveCheck = currentTime;

			if (this.enemies.size() === 0) {
				this.startNextWave();
			}
		}
	}

	private startNextWave(): void {
		const wave = this.waveManager.startNextWave();
		if (!wave) {
			print("All waves completed! Victory!");
			return;
		}

		print(`Starting Wave ${wave.wave}`);

		// Spawn enemies according to wave configuration
		let totalDelay = 0;
		for (const enemySpawn of wave.enemies) {
			for (let i = 0; i < enemySpawn.count; i++) {
				task.wait(enemySpawn.interval);
				this.spawnEnemy(enemySpawn.type);
				totalDelay += enemySpawn.interval;
			}
		}
	}

	public createTower(towerType: TowerType, position: Vector3): Tower | undefined {
		const config = GAME_CONFIG.towers[towerType];

		if (this.playerGold < config.cost) {
			print(`Not enough gold! Need ${config.cost}, have ${this.playerGold}`);
			return undefined;
		}

		const id = `tower_${this.nextId++}`;
		const tower: Tower = {
			id,
			position,
			type: towerType,
			level: 1,
			damage: config.damage,
			range: config.range,
			attackSpeed: config.attackSpeed,
			lastAttackTime: 0,
		};

		this.towers.set(id, tower);
		this.playerGold -= config.cost;
		this.createTowerVisual(tower);

		print(`Created ${towerType} tower at ${position} for ${config.cost} gold`);
		return tower;
	}

	private spawnEnemy(enemyType: EnemyType): Enemy {
		const id = `enemy_${this.nextId++}`;
		const config = GAME_CONFIG.enemies[enemyType];
		const spawnPosition = GameMath.getRandomSpawnPosition();

		const enemy: Enemy = {
			id,
			position: spawnPosition,
			health: config.health,
			maxHealth: config.health,
			speed: config.speed,
			type: enemyType,
			reward: config.reward,
			armor: config.armor,
			direction: GameMath.getDirectionToCenter(spawnPosition),
		};

		this.enemies.set(id, enemy);
		this.createEnemyVisual(enemy);

		return enemy;
	}

	private createProjectile(tower: Tower, target: Enemy): Projectile {
		const id = `projectile_${this.nextId++}`;
		const direction = target.position.sub(tower.position).Unit;
		const projectileSpeed = 30;

		const projectile: Projectile = {
			id,
			position: tower.position.add(new Vector3(0, 2, 0)),
			velocity: direction.mul(projectileSpeed),
			damage: tower.damage,
			target,
			speed: projectileSpeed,
		};

		this.projectiles.set(id, projectile);
		this.createProjectileVisual(projectile);

		return projectile;
	}

	private updateEnemyMovement(deltaTime: number): void {
		const towerPositions: Vector3[] = [];
		this.towers.forEach((tower) => towerPositions.push(tower.position));

		for (const [id, enemy] of this.enemies) {
			// Update direction towards center with pathfinding
			const center = new Vector3(0, 0, 0);
			enemy.direction = GameMath.getDirectionToCenter(enemy.position);

			// Calculate new position
			const movement = enemy.direction.mul(enemy.speed * deltaTime);
			const newPosition = enemy.position.add(movement);

			// Check if new position is valid
			if (math.abs(newPosition.X) < 60 && math.abs(newPosition.Z) < 60) {
				enemy.position = newPosition;
				this.updateEnemyVisual(enemy);
			}

			// Check if enemy reached the center (player loses life)
			if (GameMath.distance(enemy.position, center) < 3) {
				this.enemies.delete(id);
				this.playerLives--;
				this.destroyEnemyVisual(enemy);
				print(`Enemy ${enemy.type} reached the center! Lives remaining: ${this.playerLives}`);

				if (this.playerLives <= 0) {
					print("Game Over! No lives remaining!");
				}
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

				const distance = GameMath.distance(tower.position, enemy.position);
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
				const distance = GameMath.distance(tower.position, tower.target.position);
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
			this.updateProjectileVisual(projectile);

			// Check if projectile reached its target or is too far
			const distanceToTarget = GameMath.distance(projectile.position, projectile.target.position);

			if (distanceToTarget < 2) {
				// Hit the target
				const actualDamage = GameMath.calculateDamage(projectile.damage, projectile.target.armor);
				this.damageEnemy(projectile.target, actualDamage);
				EffectUtils.createHitEffect(projectile.position);
				projectilesToRemove.push(id);
			} else if (projectile.position.Magnitude > 200) {
				// Projectile went too far
				projectilesToRemove.push(id);
			}
		}

		// Remove finished projectiles
		for (const id of projectilesToRemove) {
			const projectile = this.projectiles.get(id);
			if (projectile) {
				this.destroyProjectileVisual(projectile);
				this.projectiles.delete(id);
			}
		}
	}

	private checkCollisions(): void {
		// Additional collision checking if needed
	}

	private damageEnemy(enemy: Enemy, damage: number): void {
		enemy.health = math.max(0, enemy.health - damage);

		if (enemy.health <= 0) {
			this.playerGold += enemy.reward;
			EffectUtils.createDeathEffect(enemy.position, enemy.type);
			print(`${enemy.type} defeated! Gained ${enemy.reward} gold. Total: ${this.playerGold}`);
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
			const enemy = this.enemies.get(id);
			if (enemy) {
				this.destroyEnemyVisual(enemy);
				this.enemies.delete(id);
			}
		}

		// Remove projectiles targeting dead enemies
		const invalidProjectiles: string[] = [];
		for (const [id, projectile] of this.projectiles) {
			if (projectile.target.health <= 0) {
				invalidProjectiles.push(id);
			}
		}

		for (const id of invalidProjectiles) {
			const projectile = this.projectiles.get(id);
			if (projectile) {
				this.destroyProjectileVisual(projectile);
				this.projectiles.delete(id);
			}
		}

		// Check if wave is complete
		if (this.enemies.size() === 0 && this.waveManager.isCurrentWaveActive()) {
			this.waveManager.completeWave();
			print("Wave completed!");
		}
	}

	// Visual creation and management methods
	private createTowerVisual(tower: Tower): void {
		const visual = new Instance("Part");
		visual.Name = `${tower.type}Tower_${tower.id}`;
		visual.Size = new Vector3(4, 6, 4);
		visual.Position = tower.position.add(new Vector3(0, 3, 0));
		visual.Anchored = true;
		visual.CanCollide = false;
		visual.Parent = game.Workspace;

		const colors = {
			Archer: Color3.fromRGB(139, 69, 19),
			Mage: Color3.fromRGB(128, 0, 128),
			Cannon: Color3.fromRGB(64, 64, 64),
			Support: Color3.fromRGB(0, 255, 0),
		};
		visual.Color = colors[tower.type];

		tower.visual = visual;
	}

	private createEnemyVisual(enemy: Enemy): void {
		const visual = new Instance("Part");
		visual.Name = `${enemy.type}Enemy_${enemy.id}`;
		visual.Size = new Vector3(2, 3, 2);
		visual.Position = enemy.position.add(new Vector3(0, 1.5, 0));
		visual.Anchored = true;
		visual.CanCollide = false;
		visual.Parent = game.Workspace;

		const colors = {
			Goblin: Color3.fromRGB(0, 128, 0),
			Orc: Color3.fromRGB(255, 165, 0),
			Troll: Color3.fromRGB(139, 0, 0),
			Boss: Color3.fromRGB(128, 0, 128),
		};
		visual.Color = colors[enemy.type];

		enemy.visual = visual;
	}

	private createProjectileVisual(projectile: Projectile): void {
		const visual = new Instance("Part");
		visual.Name = `Projectile_${projectile.id}`;
		visual.Size = new Vector3(0.5, 0.5, 0.5);
		visual.Position = projectile.position;
		visual.Anchored = true;
		visual.CanCollide = false;
		visual.Shape = Enum.PartType.Ball;
		visual.Color = Color3.fromRGB(255, 255, 0);
		visual.Parent = game.Workspace;

		projectile.visual = visual;
	}

	private updateEnemyVisual(enemy: Enemy): void {
		if (enemy.visual && enemy.visual.IsA("Part")) {
			enemy.visual.Position = enemy.position.add(new Vector3(0, 1.5, 0));
		}
	}

	private updateProjectileVisual(projectile: Projectile): void {
		if (projectile.visual && projectile.visual.IsA("Part")) {
			projectile.visual.Position = projectile.position;
		}
	}

	private destroyEnemyVisual(enemy: Enemy): void {
		if (enemy.visual) {
			enemy.visual.Destroy();
		}
	}

	private destroyProjectileVisual(projectile: Projectile): void {
		if (projectile.visual) {
			projectile.visual.Destroy();
		}
	}

	// Public methods for external control
	public getGameState() {
		return {
			currentWave: this.waveManager.getCurrentWave(),
			isWaveActive: this.waveManager.isCurrentWaveActive(),
			playerGold: this.playerGold,
			playerLives: this.playerLives,
			towersCount: this.towers.size(),
			enemiesCount: this.enemies.size(),
		};
	}

	public upgradeTower(towerId: string): boolean {
		const tower = this.towers.get(towerId);
		if (!tower) return false;

		const config = GAME_CONFIG.towers[tower.type];
		const upgrade = config.upgrades[tower.level - 1];

		if (!upgrade || this.playerGold < upgrade.cost) return false;

		// Apply upgrade
		tower.level = upgrade.level;
		tower.damage += upgrade.damageBonus;
		tower.range += upgrade.rangeBonus;
		tower.attackSpeed += upgrade.attackSpeedBonus;
		this.playerGold -= upgrade.cost;

		print(`Upgraded ${tower.type} to level ${tower.level} for ${upgrade.cost} gold`);
		return true;
	}
}
