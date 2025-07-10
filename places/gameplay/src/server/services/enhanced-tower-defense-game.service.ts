import { Service, OnStart } from "@flamework/core";
import { Players, RunService } from "@rbxts/services";
import { atom, effect, subscribe } from "@rbxts/charm";
import { Janitor } from "@rbxts/janitor";
import Signal from "@rbxts/lemon-signal";
import { TDWorld } from "@shared/world/td-world";
import * as jecs from "@rbxts/jecs";
import {
	TowerType,
	EnemyType,
	TowerComponent,
	EnemyComponent,
	PositionComponent,
	AttackComponent,
	ProjectileComponent,
	DamageType,
	TargetPriority,
} from "@shared/components/tower-defense.components";
import { TOWER_CONFIGS, ENEMY_CONFIGS, DEFAULT_PATH_POINTS, WAVE_CONFIGS } from "@shared/config/game-config";

interface GameState {
	currentWave: number;
	isWaveActive: boolean;
	enemiesRemaining: number;
	waveStartTime: number;
}

interface PlayerResources {
	gold: number;
	lives: number;
	score: number;
}

@Service()
export class TowerDefenseGameService implements OnStart {
	private readonly janitor = new Janitor();

	// State management with Charm
	private readonly gameStateAtom = atom<GameState>({
		currentWave: 0,
		isWaveActive: false,
		enemiesRemaining: 0,
		waveStartTime: 0,
	});

	private readonly playerResourcesAtom = atom<Map<Player, PlayerResources>>(new Map());
	private readonly towersAtom = atom<Map<string, TowerComponent>>(new Map());
	private readonly enemiesAtom = atom<Map<string, EnemyComponent>>(new Map());

	// Signals for events
	public readonly onEnemySpawned = new Signal<(enemy: EnemyComponent) => void>();
	public readonly onEnemyDefeated = new Signal<(enemyId: string, goldReward: number) => void>();
	public readonly onTowerPlaced = new Signal<(tower: TowerComponent) => void>();
	public readonly onWaveStarted = new Signal<(waveNumber: number) => void>();
	public readonly onWaveCompleted = new Signal<(waveNumber: number) => void>();
	public readonly onGameOver = new Signal<() => void>();

	// Game entities
	private gameStateEntity?: jecs.Entity;
	private readonly enemyEntities = new Map<string, jecs.Entity>();
	private readonly towerEntities = new Map<string, jecs.Entity>();
	private readonly projectileEntities = new Map<string, jecs.Entity>();

	onStart(): void {
		this.setupGameState();
		this.setupPlayerHandling();
		this.setupGameLoop();
		this.setupCharmEffects();

		print("Tower Defense Game Service initialized!");
	}

	private setupGameState(): void {
		// Create main game state entity
		this.gameStateEntity = TDWorld.world.entity();
		TDWorld.world.set(this.gameStateEntity, TDWorld.GameState, {
			currentWave: 0,
			isWaveActive: false,
			enemiesRemaining: 0,
			waveStartTime: 0,
		});

		// Initialize path visualization data
		this.createPathVisualization();
	}

	private setupPlayerHandling(): void {
		this.janitor.Add(
			Players.PlayerAdded.Connect((player) => {
				this.onPlayerJoined(player);
			}),
		);

		this.janitor.Add(
			Players.PlayerRemoving.Connect((player) => {
				this.onPlayerLeaving(player);
			}),
		);

		// Handle existing players
		Players.GetPlayers().forEach((player) => {
			this.onPlayerJoined(player);
		});
	}

	private setupGameLoop(): void {
		this.janitor.Add(
			RunService.Heartbeat.Connect((deltaTime) => {
				this.updateGameSystems(deltaTime);
			}),
		);
	}

	private setupCharmEffects(): void {
		// React to game state changes
		this.janitor.Add(
			subscribe(this.gameStateAtom, (gameState) => {
				if (this.gameStateEntity !== undefined) {
					TDWorld.world.set(this.gameStateEntity, TDWorld.GameState, gameState);
				}
			}),
		);

		// React to player resource changes
		this.janitor.Add(
			subscribe(this.playerResourcesAtom, (resources) => {
				for (const [player, playerResources] of resources) {
					this.updatePlayerResources(player, playerResources);
				}
			}),
		);
	}

	private onPlayerJoined(player: Player): void {
		// Initialize player resources
		const currentResources = this.playerResourcesAtom();
		const newResources = new Map<Player, PlayerResources>();
		for (const [p, r] of currentResources) {
			newResources.set(p, r);
		}
		newResources.set(player, {
			gold: 500, // Starting gold
			lives: 20, // Starting lives
			score: 0,
		});
		this.playerResourcesAtom(newResources);

		// Create player entity
		const playerEntity = TDWorld.world.entity();
		TDWorld.world.set(playerEntity, TDWorld.PlayerTag, { playerId: tostring(player.UserId) });
		TDWorld.world.set(playerEntity, TDWorld.PlayerResources, newResources.get(player)!);

		print(`Player ${player.Name} joined the tower defense game`);
	}

	private onPlayerLeaving(player: Player): void {
		// Clean up player resources
		const currentResources = this.playerResourcesAtom();
		const newResources = new Map<Player, PlayerResources>();
		for (const [p, r] of currentResources) {
			if (p !== player) {
				newResources.set(p, r);
			}
		}
		this.playerResourcesAtom(newResources);

		// Remove player towers
		const towers = this.towersAtom();
		const newTowers = new Map<string, TowerComponent>();
		for (const [towerId, tower] of towers) {
			if (tower.playerId !== tostring(player.UserId)) {
				newTowers.set(towerId, tower);
			} else {
				this.removeTower(towerId);
			}
		}
		this.towersAtom(newTowers);

		print(`Player ${player.Name} left the tower defense game`);
	}

	private updateGameSystems(deltaTime: number): void {
		this.updateMovementSystem(deltaTime);
		this.updateTargetingSystem();
		this.updateAttackSystem(deltaTime);
		this.updateProjectileSystem(deltaTime);
		this.updateHealthSystem();
		this.updateWaveSystem(deltaTime);
	}

	private updateMovementSystem(deltaTime: number): void {
		// Update enemy movement along paths
		for (const [entity, position, velocity, pathFollowing] of TDWorld.world.query(
			TDWorld.Position,
			TDWorld.Velocity,
			TDWorld.PathFollowing,
		)) {
			const currentPoint = DEFAULT_PATH_POINTS[pathFollowing.waypointIndex];
			const nextIndex = pathFollowing.waypointIndex + 1;

			if (nextIndex >= DEFAULT_PATH_POINTS.size()) {
				// Enemy reached the end
				this.handleEnemyReachedEnd(entity);
				continue;
			}

			const nextPoint = DEFAULT_PATH_POINTS[nextIndex];
			const direction = nextPoint.sub(currentPoint).Unit;
			const distance = currentPoint.add(direction.mul(velocity.velocity.Magnitude * deltaTime));

			// Check if reached next waypoint
			if (position.position.sub(nextPoint).Magnitude < 1) {
				pathFollowing.waypointIndex = nextIndex;
				pathFollowing.progress = 0;
			} else {
				pathFollowing.progress = math.min(
					1,
					pathFollowing.progress +
						(velocity.velocity.Magnitude * deltaTime) / currentPoint.sub(nextPoint).Magnitude,
				);
			}

			// Update position
			TDWorld.world.set(entity, TDWorld.Position, {
				position: currentPoint.Lerp(nextPoint, pathFollowing.progress),
			});
		}

		// Update projectile movement
		for (const [entity, position, projectile] of TDWorld.world.query(TDWorld.Position, TDWorld.Projectile)) {
			const targetEntity = projectile.target;
			if (!TDWorld.world.has(targetEntity, TDWorld.Position)) {
				// Target no longer exists, remove projectile
				this.removeProjectile(entity);
				continue;
			}

			const targetPosition = TDWorld.world.get(targetEntity, TDWorld.Position)!;
			const direction = targetPosition.position.sub(position.position).Unit;
			const newPosition = position.position.add(direction.mul(projectile.speed * deltaTime));

			TDWorld.world.set(entity, TDWorld.Position, { position: newPosition });

			// Check collision
			if (newPosition.sub(targetPosition.position).Magnitude < 1) {
				this.handleProjectileHit(entity, targetEntity, projectile);
			}
		}
	}

	private updateTargetingSystem(): void {
		for (const [entity, position, targeting] of TDWorld.world.query(TDWorld.Position, TDWorld.Targeting)) {
			let bestTarget: jecs.Entity | undefined;
			let bestScore = math.huge;

			// Find enemies in range
			for (const [enemyEntity, enemyPosition] of TDWorld.world.query(TDWorld.Position, TDWorld.Enemy)) {
				const distance = position.position.sub(enemyPosition.position).Magnitude;
				if (distance <= targeting.range) {
					let score = distance;

					// Apply target priority
					switch (targeting.targetPriority) {
						case TargetPriority.First: {
							const pathFollowing = TDWorld.world.get(enemyEntity, TDWorld.PathFollowing);
							if (pathFollowing) {
								score = -(pathFollowing.waypointIndex + pathFollowing.progress);
							}
							break;
						}
						case TargetPriority.Last: {
							const pathFollowing = TDWorld.world.get(enemyEntity, TDWorld.PathFollowing);
							if (pathFollowing) {
								score = pathFollowing.waypointIndex + pathFollowing.progress;
							}
							break;
						}
						case TargetPriority.Strongest: {
							const health = TDWorld.world.get(enemyEntity, TDWorld.Health);
							if (health) {
								score = -health.current;
							}
							break;
						}
						case TargetPriority.Weakest: {
							const health = TDWorld.world.get(enemyEntity, TDWorld.Health);
							if (health) {
								score = health.current;
							}
							break;
						}
						case TargetPriority.Closest:
						default:
							// score is already distance
							break;
					}

					if (score < bestScore) {
						bestScore = score;
						bestTarget = enemyEntity;
					}
				}
			}

			targeting.currentTarget = bestTarget;
			TDWorld.world.set(entity, TDWorld.Targeting, targeting);
		}
	}

	private updateAttackSystem(deltaTime: number): void {
		const currentTime = tick();

		for (const [entity, attack, targeting, position] of TDWorld.world.query(
			TDWorld.Attack,
			TDWorld.Targeting,
			TDWorld.Position,
		)) {
			if (targeting.currentTarget !== undefined) {
				if (currentTime - attack.lastAttackTime >= 1 / attack.attackSpeed) {
					// Create projectile
					this.createProjectile(entity, targeting.currentTarget, attack, position);
					attack.lastAttackTime = currentTime;
					TDWorld.world.set(entity, TDWorld.Attack, attack);
				}
			}
		}
	}

	private updateProjectileSystem(deltaTime: number): void {
		// Movement is handled in updateMovementSystem
	}

	private updateHealthSystem(): void {
		// Check for dead enemies
		for (const [entity, health] of TDWorld.world.query(TDWorld.Health, TDWorld.Enemy)) {
			if (health.current <= 0) {
				this.handleEnemyDeath(entity);
			}
		}
	}

	private updateWaveSystem(deltaTime: number): void {
		const gameState = this.gameStateAtom();
		const currentTime = tick();

		if (!gameState.isWaveActive && gameState.enemiesRemaining === 0) {
			// Check if ready for next wave
			if (gameState.currentWave < WAVE_CONFIGS.size()) {
				// Auto-start next wave after delay
				if (currentTime - gameState.waveStartTime > 10) {
					this.startNextWave();
				}
			}
		}

		// Spawn enemies for current wave
		if (gameState.isWaveActive) {
			this.spawnWaveEnemies(deltaTime);
		}
	}

	private createPathVisualization(): void {
		// This will be used by clients to show the path
		const pathEntity = TDWorld.world.entity();
		TDWorld.world.set(pathEntity, TDWorld.PathVisualization, {
			points: DEFAULT_PATH_POINTS,
			connections: [], // Will be populated on client
		});
	}

	public placeTower(player: Player, towerType: TowerType, position: Vector3): boolean {
		const resources = this.playerResourcesAtom().get(player);
		if (!resources) return false;

		const towerConfig = TOWER_CONFIGS[towerType];
		if (resources.gold < towerConfig.cost) return false;

		// Check if position is valid (not too close to path, not overlapping with other towers)
		if (!this.isValidTowerPosition(position)) return false;

		// Create tower entity
		const towerId = `tower_${tick()}_${math.random()}`;
		const towerEntity = TDWorld.world.entity();

		const tower: TowerComponent = {
			towerType,
			level: 1,
			experience: 0,
			playerId: tostring(player.UserId),
			id: towerId,
		};

		TDWorld.world.set(towerEntity, TDWorld.Tower, tower);
		TDWorld.world.set(towerEntity, TDWorld.Position, { position });
		TDWorld.world.set(towerEntity, TDWorld.Targeting, {
			range: towerConfig.range,
			targetPriority: TargetPriority.First,
			lastTargetTime: 0,
		});
		TDWorld.world.set(towerEntity, TDWorld.Attack, {
			damage: towerConfig.damage,
			attackSpeed: towerConfig.attackSpeed,
			lastAttackTime: 0,
			projectileSpeed: towerConfig.projectileSpeed,
		});
		TDWorld.world.set(towerEntity, TDWorld.TowerTag, true);

		// Update state
		const towers = this.towersAtom();
		const newTowers = new Map<string, TowerComponent>();
		for (const [id, t] of towers) {
			newTowers.set(id, t);
		}
		newTowers.set(towerId, tower);
		this.towersAtom(newTowers);

		this.towerEntities.set(towerId, towerEntity);

		// Deduct cost
		const currentResources = this.playerResourcesAtom();
		const newResources = new Map<Player, PlayerResources>();
		for (const [p, r] of currentResources) {
			newResources.set(p, r);
		}
		newResources.set(player, {
			...resources,
			gold: resources.gold - towerConfig.cost,
		});
		this.playerResourcesAtom(newResources);

		this.onTowerPlaced.Fire(tower);
		print(`Tower ${towerType} placed at ${position} by ${player.Name}`);

		return true;
	}

	public startNextWave(): void {
		const gameState = this.gameStateAtom();
		const nextWave = gameState.currentWave + 1;

		if (nextWave > WAVE_CONFIGS.size()) {
			// Game completed
			this.onGameOver.Fire();
			return;
		}

		const newGameState: GameState = {
			currentWave: nextWave,
			isWaveActive: true,
			enemiesRemaining: this.calculateWaveEnemyCount(nextWave - 1),
			waveStartTime: tick(),
		};

		this.gameStateAtom(newGameState);
		this.onWaveStarted.Fire(nextWave);

		print(`Wave ${nextWave} started!`);
	}

	private spawnWaveEnemies(deltaTime: number): void {
		// Implementation for spawning enemies based on wave configuration
		// This would be more complex in a real implementation
	}

	private spawnEnemy(enemyType: EnemyType): void {
		const enemyId = `enemy_${tick()}_${math.random()}`;
		const enemyConfig = ENEMY_CONFIGS[enemyType];
		const enemyEntity = TDWorld.world.entity();

		const enemy: EnemyComponent = {
			enemyType,
			reward: enemyConfig.reward,
			speed: enemyConfig.speed,
			id: enemyId,
		};

		TDWorld.world.set(enemyEntity, TDWorld.Enemy, enemy);
		TDWorld.world.set(enemyEntity, TDWorld.Position, { position: DEFAULT_PATH_POINTS[0] });
		TDWorld.world.set(enemyEntity, TDWorld.Velocity, { velocity: new Vector3(enemyConfig.speed, 0, 0) });
		TDWorld.world.set(enemyEntity, TDWorld.Health, {
			current: enemyConfig.health,
			maximum: enemyConfig.health,
		});
		TDWorld.world.set(enemyEntity, TDWorld.PathFollowing, {
			waypointIndex: 0,
			progress: 0,
			pathId: "main",
		});
		TDWorld.world.set(enemyEntity, TDWorld.EnemyTag, true);

		// Update state
		const enemies = this.enemiesAtom();
		const newEnemies = new Map<string, EnemyComponent>();
		for (const [id, e] of enemies) {
			newEnemies.set(id, e);
		}
		newEnemies.set(enemyId, enemy);
		this.enemiesAtom(newEnemies);

		this.enemyEntities.set(enemyId, enemyEntity);
		this.onEnemySpawned.Fire(enemy);
	}

	private createProjectile(
		towerEntity: jecs.Entity,
		targetEntity: jecs.Entity,
		attack: AttackComponent,
		towerPosition: PositionComponent,
	): void {
		const projectileId = `projectile_${tick()}_${math.random()}`;
		const projectileEntity = TDWorld.world.entity();

		const projectile: ProjectileComponent = {
			damage: attack.damage,
			target: targetEntity,
			speed: attack.projectileSpeed !== undefined ? attack.projectileSpeed : 20,
			piercing: attack.piercing !== undefined ? attack.piercing : 0,
			splashRadius: attack.splashRadius !== undefined ? attack.splashRadius : 0,
			damageType: DamageType.Physical, // Get from tower config
			id: projectileId,
		};

		TDWorld.world.set(projectileEntity, TDWorld.Projectile, projectile);
		TDWorld.world.set(projectileEntity, TDWorld.Position, { position: towerPosition.position });
		TDWorld.world.set(projectileEntity, TDWorld.ProjectileTag, true);

		this.projectileEntities.set(projectileId, projectileEntity);
	}

	private handleProjectileHit(
		projectileEntity: jecs.Entity,
		targetEntity: jecs.Entity,
		projectile: ProjectileComponent,
	): void {
		// Apply damage
		const health = TDWorld.world.get(targetEntity, TDWorld.Health);
		if (health) {
			health.current = math.max(0, health.current - projectile.damage);
			TDWorld.world.set(targetEntity, TDWorld.Health, health);
		}

		// Remove projectile
		this.removeProjectile(projectileEntity);
	}

	private handleEnemyDeath(enemyEntity: jecs.Entity): void {
		const enemy = TDWorld.world.get(enemyEntity, TDWorld.Enemy);
		if (!enemy) return;

		// Award gold to all players
		const playerResources = this.playerResourcesAtom();
		const newResources = new Map<Player, PlayerResources>();
		for (const [p, r] of playerResources) {
			newResources.set(p, r);
		}

		for (const [player, resources] of playerResources) {
			newResources.set(player, {
				...resources,
				gold: resources.gold + enemy.reward,
				score: resources.score + enemy.reward * 10,
			});
		}

		this.playerResourcesAtom(newResources);

		// Update game state
		const gameState = this.gameStateAtom();
		this.gameStateAtom({
			...gameState,
			enemiesRemaining: gameState.enemiesRemaining - 1,
		});

		// Remove from state
		const enemies = this.enemiesAtom();
		const newEnemies = new Map<string, EnemyComponent>();
		for (const [id, e] of enemies) {
			if (id !== enemy.id) {
				newEnemies.set(id, e);
			}
		}
		this.enemiesAtom(newEnemies);

		this.enemyEntities.delete(enemy.id);
		TDWorld.world.delete(enemyEntity);

		this.onEnemyDefeated.Fire(enemy.id, enemy.reward);
	}

	private handleEnemyReachedEnd(enemyEntity: jecs.Entity): void {
		const enemy = TDWorld.world.get(enemyEntity, TDWorld.Enemy);
		if (!enemy) return;

		// Reduce lives for all players
		const playerResources = this.playerResourcesAtom();
		const newResources = new Map<Player, PlayerResources>();
		for (const [p, r] of playerResources) {
			newResources.set(p, r);
		}

		for (const [player, resources] of playerResources) {
			newResources.set(player, {
				...resources,
				lives: resources.lives - 1,
			});

			if (resources.lives <= 1) {
				this.onGameOver.Fire();
			}
		}

		this.playerResourcesAtom(newResources);

		// Remove enemy
		const enemies = this.enemiesAtom();
		const newEnemies = new Map<string, EnemyComponent>();
		for (const [id, e] of enemies) {
			if (id !== enemy.id) {
				newEnemies.set(id, e);
			}
		}
		this.enemiesAtom(newEnemies);

		this.enemyEntities.delete(enemy.id);
		TDWorld.world.delete(enemyEntity);
	}

	private removeProjectile(projectileEntity: jecs.Entity): void {
		const projectile = TDWorld.world.get(projectileEntity, TDWorld.Projectile);
		if (projectile) {
			this.projectileEntities.delete(projectile.id);
		}
		TDWorld.world.delete(projectileEntity);
	}

	private removeTower(towerId: string): void {
		const towerEntity = this.towerEntities.get(towerId);
		if (towerEntity !== undefined) {
			TDWorld.world.delete(towerEntity);
			this.towerEntities.delete(towerId);
		}
	}

	private updatePlayerResources(player: Player, resources: PlayerResources): void {
		// Find player entity and update
		for (const [entity, playerTag] of TDWorld.world.query(TDWorld.PlayerTag)) {
			if (playerTag.playerId === tostring(player.UserId)) {
				TDWorld.world.set(entity, TDWorld.PlayerResources, resources);
				break;
			}
		}
	}

	private isValidTowerPosition(position: Vector3): boolean {
		// Check distance from path
		for (const point of DEFAULT_PATH_POINTS) {
			if (position.sub(point).Magnitude < 5) {
				return false; // Too close to path
			}
		}

		// Check distance from other towers
		for (const [entity, towerPosition] of TDWorld.world.query(TDWorld.Position, TDWorld.Tower)) {
			if (position.sub(towerPosition.position).Magnitude < 8) {
				return false; // Too close to another tower
			}
		}

		return true;
	}

	private calculateWaveEnemyCount(waveIndex: number): number {
		if (waveIndex >= WAVE_CONFIGS.size()) return 0;

		const wave = WAVE_CONFIGS[waveIndex];
		let total = 0;
		for (const enemyGroup of wave) {
			total += enemyGroup.count;
		}
		return total;
	}

	// Public API for networking
	public getGameState(): GameState {
		return this.gameStateAtom();
	}

	public getPlayerResources(player: Player): PlayerResources | undefined {
		return this.playerResourcesAtom().get(player);
	}

	public getTowers(): Map<string, TowerComponent> {
		return this.towersAtom();
	}

	public getEnemies(): Map<string, EnemyComponent> {
		return this.enemiesAtom();
	}

	public upgradeTower(player: Player, towerId: string): boolean {
		const tower = this.towersAtom().get(towerId);
		if (tower === undefined) return false;

		const resources = this.playerResourcesAtom().get(player);
		if (resources === undefined) return false;

		const towerConfig = TOWER_CONFIGS[tower.towerType];
		const upgradeCost = towerConfig.cost * 1.5; // Assume upgrade cost is 1.5x base cost
		if (resources.gold < upgradeCost) return false;

		// Update tower
		tower.level += 1;
		const newTowers = new Map<string, TowerComponent>();
		for (const [id, t] of this.towersAtom()) {
			newTowers.set(id, t);
		}
		newTowers.set(towerId, tower);
		this.towersAtom(newTowers);

		// Deduct cost
		const newResources = new Map<Player, PlayerResources>();
		for (const [p, r] of this.playerResourcesAtom()) {
			newResources.set(p, r);
		}
		newResources.set(player, {
			...resources,
			gold: resources.gold - upgradeCost,
		});
		this.playerResourcesAtom(newResources);

		return true;
	}

	public sellTower(player: Player, towerId: string): void {
		const tower = this.towersAtom().get(towerId);
		if (tower === undefined || tower.playerId !== tostring(player.UserId)) return;

		const towerConfig = TOWER_CONFIGS[tower.towerType];
		const sellValue = towerConfig.cost * 0.75; // Sell for 75% of cost

		// Update player resources
		const resources = this.playerResourcesAtom().get(player);
		if (resources) {
			const newResources = new Map<Player, PlayerResources>();
			for (const [p, r] of this.playerResourcesAtom()) {
				newResources.set(p, r);
			}
			newResources.set(player, {
				...resources,
				gold: resources.gold + sellValue,
			});
			this.playerResourcesAtom(newResources);
		}

		// Remove tower
		this.removeTower(towerId);
		const newTowers = new Map<string, TowerComponent>();
		for (const [id, t] of this.towersAtom()) {
			if (id !== towerId) {
				newTowers.set(id, t);
			}
		}
		this.towersAtom(newTowers);
	}

	public getTowerConfig(towerType: TowerType) {
		return TOWER_CONFIGS[towerType];
	}

	public getEnemyConfig(enemyType: EnemyType) {
		return ENEMY_CONFIGS[enemyType];
	}

	public getPath(): Vector3[] {
		return DEFAULT_PATH_POINTS;
	}

	public findEntityFromId(id: string): jecs.Entity | undefined {
		const enemyEntity = this.enemyEntities.get(id);
		if (enemyEntity !== undefined) return enemyEntity;

		const towerEntity = this.towerEntities.get(id);
		if (towerEntity !== undefined) return towerEntity;

		const projectileEntity = this.projectileEntities.get(id);
		if (projectileEntity !== undefined) return projectileEntity;

		return undefined;
	}

	destroy(): void {
		this.janitor.Cleanup();
	}
}
