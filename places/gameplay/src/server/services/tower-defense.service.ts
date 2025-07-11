import { Service, OnStart } from "@flamework/core";
import { Players, RunService, Workspace } from "@rbxts/services";
import { Janitor } from "@rbxts/janitor";
import { atom, subscribe } from "@rbxts/charm";
import ServerNetwork from "@network/server";
import * as jecs from "@rbxts/jecs";
import { safePlayerAdded } from "@common/shared/utils/safe-player-added.util";
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
import { TDWorld } from "@shared/world/td-world";
import { Signal } from "@rbxts/lemon-signal";
import {
	Tower as NetworkTower,
	Enemy as NetworkEnemy,
	Projectile as NetworkProjectile,
	GameState as NetworkGameState,
	EnemyDeathData,
	PlaceTowerData,
	TowerIdData,
	EnemyType as NetworkEnemyType,
	TowerType as NetworkTowerType,
} from "@network/types";

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
export class TowerDefenseService implements OnStart {
	private readonly janitor = new Janitor();
	private gameStateEntity!: jecs.Entity;
	private readonly enemyEntities = new Map<string, jecs.Entity>();
	private readonly towerEntities = new Map<string, jecs.Entity>();
	private readonly projectileEntities = new Map<string, jecs.Entity>();

	// Game state atoms
	private readonly gameStateAtom = atom<GameState>({
		currentWave: 0,
		isWaveActive: false,
		enemiesRemaining: 0,
		waveStartTime: 0,
	});

	private readonly playerResourcesAtom = atom<Map<Player, PlayerResources>>(new Map());
	private readonly towersAtom = atom<Map<string, TowerComponent>>(new Map());
	private readonly enemiesAtom = atom<Map<string, EnemyComponent>>(new Map());

	public readonly onGameOver = new Signal<() => void>();

	onStart(): void {
		this.setupBaseplate();
		this.setupGameState();
		this.setupPlayerHandling();
		this.setupGameLoop();
		this.setupCharmEffects();
		this.setupNetworkListeners();

		print("Tower Defense Game Service initialized!");
	}

	private setupBaseplate(): void {
		const ground = new Instance("Part");
		ground.Name = "Ground";
		ground.Size = new Vector3(512, 1, 512);
		ground.Position = new Vector3(0, -0.5, 0);
		ground.Anchored = true;
		ground.Parent = Workspace;

		const spawnLocation = new Instance("SpawnLocation");
		spawnLocation.Name = "SpawnLocation";
		spawnLocation.Position = new Vector3(0, 5, 0);
		spawnLocation.Anchored = true;
		spawnLocation.Parent = Workspace;
	}

	private setupNetworkListeners(): void {
		ServerNetwork.TowerDefense.PlaceTowerRequest.on((player, request) => {
			this.placeTower(player, request.towerType as TowerType, request.position);
		});
		ServerNetwork.TowerDefense.StartWaveRequest.on((player) => {
			this.startNextWave();
		});
		ServerNetwork.TowerDefense.UpgradeTowerRequest.on((player, request) => {
			// TODO: Implement tower upgrading
		});
		ServerNetwork.TowerDefense.SellTowerRequest.on((player, request) => {
			// TODO: Implement tower selling
		});
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
			safePlayerAdded((player) => {
				this.onPlayerJoined(player);
			}),
		);

		this.janitor.Add(
			Players.PlayerRemoving.Connect((player) => {
				this.onPlayerLeaving(player);
			}),
		);
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

		// Send initial game state
		const gameState = this.gameStateAtom();
		ServerNetwork.TowerDefense.GameStateUpdated.fire(player, {
			currentWave: gameState.currentWave,
			isWaveActive: gameState.isWaveActive,
			enemiesRemaining: gameState.enemiesRemaining,
			playerGold: newResources.get(player)!.gold,
			playerLives: newResources.get(player)!.lives,
		});

		// Send full enemy and tower state to new player
		const enemies = this.enemiesAtom();
		for (const [id, enemy] of enemies) {
			const enemyEntity = this.enemyEntities.get(id);
			if (enemyEntity) {
				const position = TDWorld.world.get(enemyEntity, TDWorld.Position);
				const health = TDWorld.world.get(enemyEntity, TDWorld.Health);
				if (position && health) {
					ServerNetwork.TowerDefense.EnemySpawned.fire(player, {
						id: enemy.id,
						enemyType: enemy.enemyType as unknown as NetworkEnemyType,
						position: position.position,
						health: health.current,
						maxHealth: health.maximum,
						speed: enemy.speed,
						pathProgress: 0,
					});
				}
			}
		}

		const towers = this.towersAtom();
		for (const [id, tower] of towers) {
			const towerEntity = this.towerEntities.get(id);
			if (towerEntity) {
				const position = TDWorld.world.get(towerEntity, TDWorld.Position);
				if (position) {
					const towerConfig = TOWER_CONFIGS[tower.towerType];
					ServerNetwork.TowerDefense.TowerPlaced.fire(player, {
						id: tower.id,
						towerType: tower.towerType as unknown as NetworkTowerType,
						position: position.position,
						level: tower.level,
						damage: towerConfig.damage,
						range: towerConfig.range,
						attackSpeed: towerConfig.attackSpeed,
						playerId: tower.playerId,
					});
				}
			}
		}
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
		for (const [id, t] of towers) {
			if (t.playerId !== tostring(player.UserId)) {
				newTowers.set(id, t);
			} else {
				this.removeTower(id);
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
		const playerResources = newResources.get(player)!;
		newResources.set(player, {
			...playerResources,
			gold: playerResources.gold - towerConfig.cost,
		});
		this.playerResourcesAtom(newResources);

		const networkTower: NetworkTower = {
			id: towerId,
			towerType: towerType as unknown as NetworkTowerType,
			position: position,
			level: 1,
			damage: towerConfig.damage,
			range: towerConfig.range,
			attackSpeed: towerConfig.attackSpeed,
			playerId: tostring(player.UserId),
		};
		ServerNetwork.TowerDefense.TowerPlaced.fireAll(networkTower);

		print(`Tower ${towerType} placed at ${position} by ${player.Name}`);

		return true;
	}

	public startNextWave(): void {
		const gameState = this.gameStateAtom();
		const nextWave = gameState.currentWave + 1;

		if (nextWave > WAVE_CONFIGS.size()) {
			// Game completed
			print("All waves completed!");
			this.onGameOver.Fire();
			return;
		}

		const waveConfig = WAVE_CONFIGS[nextWave - 1];
		const newGameState: GameState = {
			currentWave: nextWave,
			isWaveActive: true,
			enemiesRemaining: this.calculateWaveEnemyCount(nextWave - 1),
			waveStartTime: tick(),
		};

		this.gameStateAtom(newGameState);
		ServerNetwork.TowerDefense.GameStateUpdated.fireAll({
			...newGameState,
			playerGold: 0, // These will be updated per player
			playerLives: 0,
		});

		print(`Wave ${nextWave} started!`);
	}

	private spawnWaveEnemies(deltaTime: number): void {
		const gameState = this.gameStateAtom();
		if (!gameState.isWaveActive) return;

		const waveIndex = gameState.currentWave - 1;
		if (waveIndex < 0 || waveIndex >= WAVE_CONFIGS.size()) return;

		const waveConfig = WAVE_CONFIGS[waveIndex];
		const elapsedTime = tick() - gameState.waveStartTime;

		for (const enemyGroup of waveConfig) {
			const spawnCount = math.floor(elapsedTime / enemyGroup.spawnDelay);
			const spawnedSoFar = this.getSpawnedCountForWave(waveIndex, enemyGroup.enemyType);

			if (spawnedSoFar < enemyGroup.count && spawnCount > spawnedSoFar) {
				this.spawnEnemy(enemyGroup.enemyType);
			}
		}
	}

	private getSpawnedCountForWave(waveIndex: number, enemyType: EnemyType): number {
		// This is a simplified way to track spawned enemies.
		// A more robust solution would be needed for complex scenarios.
		let count = 0;
		for (const [id, enemy] of this.enemiesAtom()) {
			if (enemy.enemyType === enemyType) {
				// This doesn't distinguish waves, needs improvement
				count++;
			}
		}
		return count;
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

		ServerNetwork.TowerDefense.EnemySpawned.fireAll({
			id: enemyId,
			enemyType: enemyType as unknown as NetworkEnemyType,
			position: DEFAULT_PATH_POINTS[0],
			health: enemyConfig.health,
			maxHealth: enemyConfig.health,
			speed: enemyConfig.speed,
			pathProgress: 0,
		});
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

		const networkProjectile: NetworkProjectile = {
			id: projectileId,
			position: towerPosition.position,
			targetPosition: TDWorld.world.get(targetEntity, TDWorld.Position)!.position,
			damage: projectile.damage,
			speed: projectile.speed,
		};
		ServerNetwork.TowerDefense.ProjectileCreated.fireAll(networkProjectile);
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
		const newGameState = {
			...gameState,
			enemiesRemaining: math.max(0, gameState.enemiesRemaining - 1),
		};
		this.gameStateAtom(newGameState);

		if (newGameState.isWaveActive && newGameState.enemiesRemaining === 0) {
			// Wave cleared
			newGameState.isWaveActive = false;
			newGameState.waveStartTime = tick(); // Reset for inter-wave timer
			this.gameStateAtom(newGameState);
		}

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

		ServerNetwork.TowerDefense.EnemyDied.fireAll({
			enemyId: enemy.id,
			goldReward: enemy.reward,
		});
	}

	private handleEnemyReachedEnd(enemyEntity: jecs.Entity): void {
		const enemy = TDWorld.world.get(enemyEntity, TDWorld.Enemy);
		if (!enemy) return;

		// Reduce lives for all players
		const playerResources = this.playerResourcesAtom();
		const newResources = new Map<Player, PlayerResources>();
		let gameOver = false;
		for (const [p, r] of playerResources) {
			newResources.set(p, r);
		}

		for (const [player, resources] of playerResources) {
			const newPlayerResources = {
				...resources,
				lives: resources.lives - 1,
			};
			newResources.set(player, newPlayerResources);

			if (newPlayerResources.lives <= 0) {
				gameOver = true;
			}
		}

		this.playerResourcesAtom(newResources);

		if (gameOver) {
			this.onGameOver.Fire();
			print("Game Over! A player has run out of lives.");
		}

		// Update game state
		const gameState = this.gameStateAtom();
		const newGameState = {
			...gameState,
			enemiesRemaining: math.max(0, gameState.enemiesRemaining - 1),
		};
		this.gameStateAtom(newGameState);

		if (newGameState.isWaveActive && newGameState.enemiesRemaining === 0) {
			// Wave cleared
			newGameState.isWaveActive = false;
			newGameState.waveStartTime = tick(); // Reset for inter-wave timer
			this.gameStateAtom(newGameState);
		}

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

		// ServerNetwork.TowerDefense.EnemyReachedEnd.fireAll({ enemyId: enemy.id });
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

				// Also fire a network event to update the client
				const gameState = this.gameStateAtom();
				ServerNetwork.TowerDefense.GameStateUpdated.fire(player, {
					currentWave: gameState.currentWave,
					isWaveActive: gameState.isWaveActive,
					enemiesRemaining: gameState.enemiesRemaining,
					playerGold: resources.gold,
					playerLives: resources.lives,
				});
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

	public destroy(): void {
		this.onGameOver.clear();
		this.janitor.Cleanup();
		// Also destroy all entities
		for (const [id, entity] of this.towerEntities) {
			TDWorld.world.delete(entity);
		}
		this.towerEntities.clear();
		for (const [id, entity] of this.enemyEntities) {
			TDWorld.world.delete(entity);
		}
		this.enemyEntities.clear();
		for (const [id, entity] of this.projectileEntities) {
			TDWorld.world.delete(entity);
		}
		this.projectileEntities.clear();
		if (this.gameStateEntity) {
			TDWorld.world.delete(this.gameStateEntity);
		}
	}
}
