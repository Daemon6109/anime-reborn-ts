// Services
import { Players } from "@rbxts/services";

// Packages
import { MockDataStoreService, MockMemoryStoreService } from "@rbxts/lyra";
import { server, SyncPayload } from "@rbxts/charm-sync";
import { Service, OnInit } from "@flamework/core";
import { createPlayerStore } from "@rbxts/lyra";
import ServerNetwork from "@network/server";
import { effect } from "@rbxts/charm";

// Types
import type { PlayerData } from "@shared/atoms/player-data";

// Utility
import { filterPayload } from "@shared/atoms/utility/filter-payload";
import { safePlayerAdded } from "@shared/utils/safe-player-added.util";

// Dependencies
import { setPlayerData, getPlayerData, updatePlayerData, deletePlayerData } from "@shared/atoms/player-data";
import atoms, { GlobalAtoms } from "@shared/atoms";
import template from "./template";
import schema from "./schema";

@Service()
export class DataStore implements OnInit {
	private store = createPlayerStore<PlayerData>({
		name: "PlayerData",
		template: template,
		schema: schema,
		dataStoreService: new MockDataStoreService(),
		memoryStoreService: new MockMemoryStoreService(),
	});

	// Function to mark player data as ready
	private markPlayerDataReady!: (player: Player) => void;

	// Promise system for tracking when player data is ready
	private playerDataPromises = new Map<string, Promise<PlayerData>>();
	private playerDataResolvers = new Map<string, (data: PlayerData) => void>();
	private playerDataRejectors = new Map<string, (reason: string) => void>();
	private playerDataTimeouts = new Map<string, thread>();

	/**
	 * Helper method to clean up all promise-related data for a player
	 */
	private cleanupPlayerPromise(playerId: string): void {
		// Cancel timeout if it exists
		const timeoutThread = this.playerDataTimeouts.get(playerId);
		if (timeoutThread) {
			task.cancel(timeoutThread);
			this.playerDataTimeouts.delete(playerId);
		}

		// Clean up all promise-related maps
		this.playerDataPromises.delete(playerId);
		this.playerDataResolvers.delete(playerId);
		this.playerDataRejectors.delete(playerId);
	}

	/**
	 * Helper method to resolve player data promises
	 */
	private resolvePlayerDataPromise(playerId: string, data: PlayerData): void {
		const resolver = this.playerDataResolvers.get(playerId);
		if (resolver) {
			resolver(data);
			this.cleanupPlayerPromise(playerId);
		}
	}

	/**
	 * Helper method to reject player data promises
	 */
	private rejectPlayerDataPromise(playerId: string, reason: string): void {
		const rejector = this.playerDataRejectors.get(playerId);
		if (rejector) {
			rejector(reason);
			this.cleanupPlayerPromise(playerId);
		}
	}

	/**
	 * Internal method to create a player data promise with timeout management
	 */
	private createPlayerDataPromise(playerId: string): Promise<PlayerData> {
		// Check if data is already available
		const existingData = getPlayerData(playerId);
		if (existingData) {
			return Promise.resolve(existingData);
		}

		// Return existing promise if one exists
		const existingPromise = this.playerDataPromises.get(playerId);
		if (existingPromise) {
			return existingPromise;
		}

		// Create new promise with timeout
		const promise = new Promise<PlayerData>((resolve, reject) => {
			this.playerDataResolvers.set(playerId, resolve);
			this.playerDataRejectors.set(playerId, reject);

			// Add timeout to prevent hanging promises
			const timeoutThread = task.delay(30, () => {
				if (this.playerDataResolvers.has(playerId)) {
					this.rejectPlayerDataPromise(playerId, "Player data loading timeout");
				}
			});

			this.playerDataTimeouts.set(playerId, timeoutThread);
		});

		this.playerDataPromises.set(playerId, promise);
		return promise;
	}

	/**
	 * Get player data when it's available
	 * Returns a promise that resolves with the player data once it's loaded
	 */
	getPlayerDataWhenReady(player: Player): Promise<PlayerData> {
		return this.createPlayerDataPromise(tostring(player.UserId));
	}

	/**
	 * Get player data when it's available (by user ID)
	 * Returns a promise that resolves with the player data once it's loaded
	 */
	getPlayerDataWhenReadyById(userId: number): Promise<PlayerData> {
		return this.createPlayerDataPromise(tostring(userId));
	}

	onInit(): void {
		this.setupAtomSyncs();

		safePlayerAdded((player) => {
			this.onPlayerAdded(player);
		});
		Players.PlayerRemoving.Connect((player) => this.onPlayerRemoving(player));
	}

	private setupAtomSyncs() {
		const syncer = server({ atoms, autoSerialize: false });
		const playersInitialSyncComplete = new Map<string, boolean>();
		const playersDataReady = new Map<string, boolean>();

		syncer.connect((player, payload) => {
			const playerId = tostring(player.UserId);
			const isInitialSyncComplete = playersInitialSyncComplete.get(playerId) ?? false;
			const isDataReady = playersDataReady.get(playerId) ?? false;

			// Don't send anything until player data is ready
			if (!isDataReady) {
				return;
			}

			// Skip the first patch after init to prevent double initialization
			if (payload.type === "patch" && !isInitialSyncComplete) {
				playersInitialSyncComplete.set(playerId, true);
				return;
			}

			const filteredPayload = filterPayload(player, payload as SyncPayload<GlobalAtoms>);
			ServerNetwork.playerData.Atoms.sync.fire(player, filteredPayload);
		});

		ServerNetwork.playerData.Atoms.init.on((player) => {
			const playerId = tostring(player.UserId);
			const isDataReady = playersDataReady.get(playerId) ?? false;

			if (isDataReady) {
				syncer.hydrate(player);
			} else {
				// Use promise-based approach to avoid yielding in event callback
				task.spawn(() => {
					this.getPlayerDataWhenReady(player)
						.then(() => {
							syncer.hydrate(player);
						})
						.catch((err) => {
							warn(`Failed to get player data for ${player.Name}: ${err}`);
						});
				});
			}
		});

		// Clean up when player leaves
		Players.PlayerRemoving.Connect((player) => {
			const playerId = tostring(player.UserId);
			playersInitialSyncComplete.delete(playerId);
			playersDataReady.delete(playerId);
		});

		// Expose method to mark player data as ready
		this.markPlayerDataReady = (player: Player) => {
			playersDataReady.set(tostring(player.UserId), true);
		};
	}

	async loadPlayerData(player: Player) {
		const playerId = tostring(player.UserId);

		try {
			this.store.loadAsync(player);
			const session = await this.store.get(player);

			// Check if player is still valid before proceeding
			if (!player.IsDescendantOf(Players)) {
				this.store.unloadAsync(player);
				this.rejectPlayerDataPromise(playerId, "Player left during loading");
				return;
			}

			// Set the player data first
			setPlayerData(playerId, session);

			// Resolve any waiting promises
			this.resolvePlayerDataPromise(playerId, session);

			// Mark the player data as ready so init can proceed
			this.markPlayerDataReady(player);

			const unsubscribe = effect(() => {
				const playerData = getPlayerData(playerId);

				if (playerData) {
					this.store.updateAsync(player, (data) => {
						data.units = playerData.units;
						data.items = playerData.items;
						data.team = playerData.team;
						return true;
					});
				}
			});

			Promise.fromEvent(Players.PlayerRemoving, (left) => player === left)
				.then(() => unsubscribe())
				.then(() => this.store.unloadAsync(player));
		} catch (error) {
			// Handle any errors that occur during loading
			this.handlePlayerDataError(player, error);
		}
	}

	private handlePlayerDataError(player: Player, error: unknown) {
		const errorMessage = typeIs(error, "string") ? error : tostring(error);
		warn(`Failed to load document for player ${player.Name}: ${errorMessage}`);
		const playerId = tostring(player.UserId);

		// Set template data
		setPlayerData(playerId, template);

		// Resolve any waiting promises with template data
		this.resolvePlayerDataPromise(playerId, template);

		// Mark data as ready
		this.markPlayerDataReady(player);
	}

	onPlayerAdded(player: Player) {
		this.loadPlayerData(player).catch((err) => {
			this.handlePlayerDataError(player, err);
		});
	}
	onPlayerRemoving(player: Player) {
		const playerId = tostring(player.UserId);

		// Clean up all promise-related data
		this.cleanupPlayerPromise(playerId);

		deletePlayerData(playerId);
	}
}
