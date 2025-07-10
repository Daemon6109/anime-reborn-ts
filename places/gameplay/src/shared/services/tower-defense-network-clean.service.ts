import { Service, OnStart } from "@flamework/core";
import Signal from "@rbxts/lemon-signal";
import { RunService, ReplicatedStorage } from "@rbxts/services";
import { Janitor } from "@rbxts/janitor";

// Define types based on the Blink-generated definitions
export namespace TowerDefenseNetwork {
	export type TowerType = "BasicTower" | "ArcherTower" | "MageTower" | "CannonTower";
	export type EnemyType = "BasicEnemy" | "FastEnemy" | "TankEnemy" | "FlyingEnemy";

	export interface TowerPlacement {
		position: Vector3;
		towerType: TowerType;
		playerId: string;
	}

	export interface TowerUpgradeRequest {
		towerId: string;
	}

	export interface TowerSellRequest {
		towerId: string;
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
 * Tower Defense Networking Service using RemoteEvents
 * Provides clean signal-based networking for the tower defense game
 */
@Service()
export class TowerDefenseNetworkService implements OnStart {
	private readonly janitor = new Janitor();

	// RemoteEvents for networking
	private placeTowerRemote!: RemoteEvent;
	private upgradeTowerRemote!: RemoteEvent;
	private sellTowerRemote!: RemoteEvent;
	private startWaveRemote!: RemoteEvent;
	private towerPlacedRemote!: RemoteEvent;
	private enemySpawnedRemote!: RemoteEvent;
	private enemyUpdatedRemote!: RemoteEvent;
	private enemyDiedRemote!: RemoteEvent;
	private projectileCreatedRemote!: RemoteEvent;
	private gameStateUpdatedRemote!: RemoteEvent;
	private pathDataSentRemote!: RemoteEvent;

	// Server-side signals
	public readonly onPlaceTowerRequest = new Signal<
		(player: Player, placement: TowerDefenseNetwork.TowerPlacement) => void
	>();
	public readonly onUpgradeTowerRequest = new Signal<(player: Player, towerId: string) => void>();
	public readonly onSellTowerRequest = new Signal<(player: Player, towerId: string) => void>();
	public readonly onStartWaveRequest = new Signal<(player: Player) => void>();

	// Client-side signals
	public readonly onTowerPlaced = new Signal<(tower: TowerDefenseNetwork.Tower) => void>();
	public readonly onEnemySpawned = new Signal<(enemy: TowerDefenseNetwork.Enemy) => void>();
	public readonly onEnemyUpdated = new Signal<(enemy: TowerDefenseNetwork.Enemy) => void>();
	public readonly onEnemyDied = new Signal<(data: TowerDefenseNetwork.EnemyDeathData) => void>();
	public readonly onProjectileCreated = new Signal<(projectile: TowerDefenseNetwork.Projectile) => void>();
	public readonly onGameStateUpdated = new Signal<(gameState: TowerDefenseNetwork.GameState) => void>();
	public readonly onPathDataReceived = new Signal<(pathData: TowerDefenseNetwork.PathPoint[]) => void>();

	onStart() {
		this.setupRemoteEvents();
		this.setupNetworking();
	}

	private setupRemoteEvents(): void {
		const remotesFolder = this.getOrCreateRemotesFolder();

		// Create or find RemoteEvents
		this.placeTowerRemote = this.getOrCreateRemoteEvent(remotesFolder, "PlaceTower");
		this.upgradeTowerRemote = this.getOrCreateRemoteEvent(remotesFolder, "UpgradeTower");
		this.sellTowerRemote = this.getOrCreateRemoteEvent(remotesFolder, "SellTower");
		this.startWaveRemote = this.getOrCreateRemoteEvent(remotesFolder, "StartWave");
		this.towerPlacedRemote = this.getOrCreateRemoteEvent(remotesFolder, "TowerPlaced");
		this.enemySpawnedRemote = this.getOrCreateRemoteEvent(remotesFolder, "EnemySpawned");
		this.enemyUpdatedRemote = this.getOrCreateRemoteEvent(remotesFolder, "EnemyUpdated");
		this.enemyDiedRemote = this.getOrCreateRemoteEvent(remotesFolder, "EnemyDied");
		this.projectileCreatedRemote = this.getOrCreateRemoteEvent(remotesFolder, "ProjectileCreated");
		this.gameStateUpdatedRemote = this.getOrCreateRemoteEvent(remotesFolder, "GameStateUpdated");
		this.pathDataSentRemote = this.getOrCreateRemoteEvent(remotesFolder, "PathDataSent");
	}

	private getOrCreateRemotesFolder(): Folder {
		let remotesFolder = ReplicatedStorage.FindFirstChild("TowerDefenseRemotes") as Folder;
		if (!remotesFolder) {
			remotesFolder = new Instance("Folder");
			remotesFolder.Name = "TowerDefenseRemotes";
			remotesFolder.Parent = ReplicatedStorage;
		}
		return remotesFolder;
	}

	private getOrCreateRemoteEvent(parent: Folder, name: string): RemoteEvent {
		let remoteEvent = parent.FindFirstChild(name) as RemoteEvent;
		if (!remoteEvent) {
			remoteEvent = new Instance("RemoteEvent");
			remoteEvent.Name = name;
			remoteEvent.Parent = parent;
		}
		return remoteEvent;
	}

	private setupNetworking(): void {
		if (RunService.IsServer()) {
			this.setupServerListeners();
		} else {
			this.setupClientListeners();
		}
	}

	private setupServerListeners(): void {
		// Server listens for client requests
		this.janitor.Add(
			this.placeTowerRemote.OnServerEvent.Connect((player, ...args) => {
				const placement = args[0] as TowerDefenseNetwork.TowerPlacement;
				this.onPlaceTowerRequest.Fire(player, placement);
			}),
		);

		this.janitor.Add(
			this.upgradeTowerRemote.OnServerEvent.Connect((player, ...args) => {
				const towerId = args[0] as string;
				this.onUpgradeTowerRequest.Fire(player, towerId);
			}),
		);

		this.janitor.Add(
			this.sellTowerRemote.OnServerEvent.Connect((player, ...args) => {
				const towerId = args[0] as string;
				this.onSellTowerRequest.Fire(player, towerId);
			}),
		);

		this.janitor.Add(
			this.startWaveRemote.OnServerEvent.Connect((player) => {
				this.onStartWaveRequest.Fire(player);
			}),
		);
	}

	private setupClientListeners(): void {
		// Client listens for server updates
		this.janitor.Add(
			this.towerPlacedRemote.OnClientEvent.Connect((tower: TowerDefenseNetwork.Tower) => {
				this.onTowerPlaced.Fire(tower);
			}),
		);

		this.janitor.Add(
			this.enemySpawnedRemote.OnClientEvent.Connect((enemy: TowerDefenseNetwork.Enemy) => {
				this.onEnemySpawned.Fire(enemy);
			}),
		);

		this.janitor.Add(
			this.enemyUpdatedRemote.OnClientEvent.Connect((enemy: TowerDefenseNetwork.Enemy) => {
				this.onEnemyUpdated.Fire(enemy);
			}),
		);

		this.janitor.Add(
			this.enemyDiedRemote.OnClientEvent.Connect((data: TowerDefenseNetwork.EnemyDeathData) => {
				this.onEnemyDied.Fire(data);
			}),
		);

		this.janitor.Add(
			this.projectileCreatedRemote.OnClientEvent.Connect((projectile: TowerDefenseNetwork.Projectile) => {
				this.onProjectileCreated.Fire(projectile);
			}),
		);

		this.janitor.Add(
			this.gameStateUpdatedRemote.OnClientEvent.Connect((gameState: TowerDefenseNetwork.GameState) => {
				this.onGameStateUpdated.Fire(gameState);
			}),
		);

		this.janitor.Add(
			this.pathDataSentRemote.OnClientEvent.Connect((pathData: TowerDefenseNetwork.PathPoint[]) => {
				this.onPathDataReceived.Fire(pathData);
			}),
		);
	}

	// Client-side methods to send requests to server
	public placeTower(placement: TowerDefenseNetwork.TowerPlacement): void {
		this.placeTowerRemote.FireServer(placement);
	}

	public upgradeTower(towerId: string): void {
		this.upgradeTowerRemote.FireServer(towerId);
	}

	public sellTower(towerId: string): void {
		this.sellTowerRemote.FireServer(towerId);
	}

	public startWave(): void {
		this.startWaveRemote.FireServer();
	}

	// Server-side methods to send updates to clients
	public broadcastTowerPlaced(tower: TowerDefenseNetwork.Tower): void {
		if (RunService.IsServer()) {
			this.towerPlacedRemote.FireAllClients(tower);
		}
	}

	public broadcastEnemySpawned(enemy: TowerDefenseNetwork.Enemy): void {
		if (RunService.IsServer()) {
			this.enemySpawnedRemote.FireAllClients(enemy);
		}
	}

	public broadcastEnemyUpdated(enemy: TowerDefenseNetwork.Enemy): void {
		if (RunService.IsServer()) {
			this.enemyUpdatedRemote.FireAllClients(enemy);
		}
	}

	public broadcastEnemyDied(data: TowerDefenseNetwork.EnemyDeathData): void {
		if (RunService.IsServer()) {
			this.enemyDiedRemote.FireAllClients(data);
		}
	}

	public broadcastProjectileCreated(projectile: TowerDefenseNetwork.Projectile): void {
		if (RunService.IsServer()) {
			this.projectileCreatedRemote.FireAllClients(projectile);
		}
	}

	public broadcastGameStateUpdated(gameState: TowerDefenseNetwork.GameState): void {
		if (RunService.IsServer()) {
			this.gameStateUpdatedRemote.FireAllClients(gameState);
		}
	}

	public sendPathData(pathData: TowerDefenseNetwork.PathPoint[]): void {
		if (RunService.IsServer()) {
			this.pathDataSentRemote.FireAllClients(pathData);
		}
	}

	// Utility methods for server targeting specific players
	public sendTowerPlacedToPlayer(player: Player, tower: TowerDefenseNetwork.Tower): void {
		if (RunService.IsServer()) {
			this.towerPlacedRemote.FireClient(player, tower);
		}
	}

	public sendGameStateToPlayer(player: Player, gameState: TowerDefenseNetwork.GameState): void {
		if (RunService.IsServer()) {
			this.gameStateUpdatedRemote.FireClient(player, gameState);
		}
	}

	// Cleanup
	public destroy(): void {
		this.janitor.Cleanup();
	}
}
