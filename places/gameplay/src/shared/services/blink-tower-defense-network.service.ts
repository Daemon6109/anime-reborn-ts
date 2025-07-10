import { Service } from "@flamework/core";
import Signal from "@rbxts/lemon-signal";
import { RunService } from "@rbxts/services";

// Import the network modules directly using relative paths
import * as ServerNetwork from "../../../remotes/network/server";
import * as ClientNetwork from "../../../remotes/network/client";

// Define types based on the Blink-generated definitions
export namespace TowerDefenseNetwork {
	export type TowerType = "BasicTower" | "ArcherTower" | "MageTower" | "CannonTower";
	export type EnemyType = "BasicEnemy" | "FastEnemy" | "TankEnemy" | "FlyingEnemy";

	export interface TowerPlacement {
		position: Vector3;
		towerType: TowerType;
		playerId: string;
	}

	export interface Enemy {
		id: string;
		enemyType: EnemyType;
		position: Vector3;
		health: number;
		maxHealth: number;
		speed: number;
		pathProgress: number;
	}

	export interface Tower {
		id: string;
		towerType: TowerType;
		position: Vector3;
		level: number;
		damage: number;
		range: number;
		attackSpeed: number;
		playerId: string;
	}

	export interface Projectile {
		id: string;
		position: Vector3;
		targetPosition: Vector3;
		damage: number;
		speed: number;
	}

	export interface GameState {
		currentWave: number;
		isWaveActive: boolean;
		enemiesRemaining: number;
		playerGold: number;
		playerLives: number;
	}

	export interface PathPoint {
		position: Vector3;
		nextIndex?: number;
	}

	export interface EnemyDeathData {
		enemyId: string;
		goldReward: number;
	}
}

/**
 * Blink-powered Tower Defense Networking Service
 * Handles all network communication for the tower defense game
 */
@Service()
export class BlinkTowerDefenseNetworkService {
	// Client-side event listeners
	public readonly onTowerPlaced = new Signal<[tower: TowerDefenseNetwork.Tower]>();
	public readonly onEnemySpawned = new Signal<[enemy: TowerDefenseNetwork.Enemy]>();
	public readonly onEnemyUpdated = new Signal<[enemy: TowerDefenseNetwork.Enemy]>();
	public readonly onEnemyDied = new Signal<[data: TowerDefenseNetwork.EnemyDeathData]>();
	public readonly onProjectileCreated = new Signal<[projectile: TowerDefenseNetwork.Projectile]>();
	public readonly onGameStateUpdated = new Signal<[gameState: TowerDefenseNetwork.GameState]>();
	public readonly onPathDataReceived = new Signal<[pathData: TowerDefenseNetwork.PathPoint[]]>();

	// Server-side event listeners
	public readonly onPlaceTowerRequest = new Signal<[player: Player, placement: TowerDefenseNetwork.TowerPlacement]>();
	public readonly onStartWaveRequest = new Signal<[player: Player]>();

	constructor() {
		this.setupNetworking();
	}

	private setupNetworking(): void {
		// Setup appropriate listeners
		if (RunService.IsServer()) {
			this.setupServerListeners();
		} else {
			this.setupClientListeners();
		}
	}

	private setupServerListeners(): void {
		// Server listens for client requests
		ServerNetwork.TowerDefense.PlaceTower.on((player: Player, placement: TowerDefenseNetwork.TowerPlacement) => {
			this.onPlaceTowerRequest.Fire(player, placement);
		});

		ServerNetwork.TowerDefense.StartWave.on((player: Player) => {
			this.onStartWaveRequest.Fire(player);
		});
	}

	private setupClientListeners(): void {
		// Client listens for server updates
		ClientNetwork.TowerDefense.TowerPlaced.on((tower: TowerDefenseNetwork.Tower) => {
			this.onTowerPlaced.Fire(tower);
		});

		ClientNetwork.TowerDefense.EnemySpawned.on((enemy: TowerDefenseNetwork.Enemy) => {
			this.onEnemySpawned.Fire(enemy);
		});

		ClientNetwork.TowerDefense.EnemyUpdated.on((enemy: TowerDefenseNetwork.Enemy) => {
			this.onEnemyUpdated.Fire(enemy);
		});

		ClientNetwork.TowerDefense.EnemyDied.on((data: TowerDefenseNetwork.EnemyDeathData) => {
			this.onEnemyDied.Fire(data);
		});

		ClientNetwork.TowerDefense.ProjectileCreated.on((projectile: TowerDefenseNetwork.Projectile) => {
			this.onProjectileCreated.Fire(projectile);
		});

		ClientNetwork.TowerDefense.GameStateUpdated.on((gameState: TowerDefenseNetwork.GameState) => {
			this.onGameStateUpdated.Fire(gameState);
		});

		ClientNetwork.TowerDefense.PathDataSent.on((pathData: TowerDefenseNetwork.PathPoint[]) => {
			this.onPathDataReceived.Fire(pathData);
		});
	}

	// Client-side methods to send requests to server
	public placeTower(placement: TowerDefenseNetwork.TowerPlacement): void {
		if (RunService.IsClient() && ClientNetwork) {
			ClientNetwork.TowerDefense.PlaceTower.fire(placement);
		}
	}

	public startWave(): void {
		if (RunService.IsClient() && ClientNetwork) {
			ClientNetwork.TowerDefense.StartWave.fire();
		}
	}

	// Server-side methods to send updates to clients
	public broadcastTowerPlaced(tower: TowerDefenseNetwork.Tower): void {
		if (RunService.IsServer() && ServerNetwork) {
			ServerNetwork.TowerDefense.TowerPlaced.fireAll(tower);
		}
	}

	public broadcastEnemySpawned(enemy: TowerDefenseNetwork.Enemy): void {
		if (RunService.IsServer() && ServerNetwork) {
			ServerNetwork.TowerDefense.EnemySpawned.fireAll(enemy);
		}
	}

	public broadcastEnemyUpdated(enemy: TowerDefenseNetwork.Enemy): void {
		if (RunService.IsServer() && ServerNetwork) {
			ServerNetwork.TowerDefense.EnemyUpdated.fireAll(enemy);
		}
	}

	public broadcastEnemyDied(data: TowerDefenseNetwork.EnemyDeathData): void {
		if (RunService.IsServer() && ServerNetwork) {
			ServerNetwork.TowerDefense.EnemyDied.fireAll(data);
		}
	}

	public broadcastProjectileCreated(projectile: TowerDefenseNetwork.Projectile): void {
		if (RunService.IsServer() && ServerNetwork) {
			ServerNetwork.TowerDefense.ProjectileCreated.fireAll(projectile);
		}
	}

	public broadcastGameStateUpdated(gameState: TowerDefenseNetwork.GameState): void {
		if (RunService.IsServer() && ServerNetwork) {
			ServerNetwork.TowerDefense.GameStateUpdated.fireAll(gameState);
		}
	}

	public sendPathData(pathData: TowerDefenseNetwork.PathPoint[]): void {
		if (RunService.IsServer() && ServerNetwork) {
			ServerNetwork.TowerDefense.PathDataSent.fireAll(pathData);
		}
	}

	// Utility methods for server targeting specific players
	public sendTowerPlacedToPlayer(player: Player, tower: TowerDefenseNetwork.Tower): void {
		if (RunService.IsServer() && ServerNetwork) {
			ServerNetwork.TowerDefense.TowerPlaced.fire(player, tower);
		}
	}

	public sendGameStateToPlayer(player: Player, gameState: TowerDefenseNetwork.GameState): void {
		if (RunService.IsServer() && ServerNetwork) {
			ServerNetwork.TowerDefense.GameStateUpdated.fire(player, gameState);
		}
	}
}
