// Services
import { Players, RunService } from "@rbxts/services";

// Packages
import { MockDataStoreService, MockMemoryStoreService, createPlayerStore } from "@rbxts/lyra";
import { Service, OnInit } from "@flamework/core";
import ServerNetwork from "@network/server";

// Types
import type { PlayerData } from "@shared/atoms/player-data";

// Dependencies
import template from "./template";
import schema from "./schema";
import { safePlayerAdded } from "@shared/utils/safe-player-added.util";

@Service()
export class DataStore implements OnInit {
	// Track which players have requested initialization
	private playersRequestedInit = new Set<Player>();
	// Track which players have been sent their initial data
	private playersSentInitialData = new Set<Player>();
	// Track which players are currently sending initial data to prevent race conditions
	private playersSendingInitialData = new Set<Player>();

	/**
	 * Creates a logger function that shows all logs in Studio and only errors in production
	 */
	private createLogger() {
		if (RunService.IsStudio() === true) {
			// Show all logs in Studio
			return (message: { level: string; message: string; context?: unknown }) => {
				print(`[Lyra][${message.level}] ${message.message}`);
				if (message.context !== undefined) {
					print("Context:", message.context);
				}
			};
		} else {
			// Only show errors in production
			return (message: { level: string; message: string; context?: unknown }) => {
				if (message.level === "error" || message.level === "fatal") {
					warn(`[Lyra] ${message.message}`);
				}
			};
		}
	}

	private store = createPlayerStore<PlayerData>({
		name: "PlayerData",
		template: template,
		schema: schema,
		dataStoreService: new MockDataStoreService(),
		memoryStoreService: new MockMemoryStoreService(),

		// Lyra's built-in networking callbacks
		changedCallbacks: [
			(key: string, newData: PlayerData, oldData?: PlayerData) => {
				this.syncPlayerDataWithClient(key, newData, oldData);
			},
		],

		// Lyra's built-in logging for debugging
		logCallback: this.createLogger(),

		// Add migration steps if needed
		/**
		 * Example of how to add Lyra migrations when needed:
		 *
		 * migrationSteps: [
		 *     Lyra.MigrationStep.addFields("addGems", { gems: 0 }),
		 *     Lyra.MigrationStep.transform("renameInventory", (data) => {
		 *         data.items = data.inventory;
		 *         data.inventory = undefined;
		 *         return data;
		 *     }),
		 * ],
		 *
		 * importLegacyData: (key: string) => {
		 *     // Import data from old DataStore if needed
		 *     return undefined; // or legacy data
		 * },
		 */

		// Legacy data import if needed
		// importLegacyData: (key: string) => { /* ... */ },
	});

	/**
	 * Lyra's network sync callback - called when player data changes
	 * Only sends updates AFTER the client has been initialized
	 */
	private syncPlayerDataWithClient(key: string, newData: PlayerData, oldData?: PlayerData): void {
		try {
			const userId = tonumber(key);
			if (userId === undefined) {
				warn(`[DataStore] Invalid userId from key: ${key}`);
				return;
			}

			const player = Players.GetPlayerByUserId(userId);
			if (player === undefined) {
				// Player may have left - this is normal
				return;
			}

			// Only send sync updates if we've already sent the initial data
			if (this.playersSentInitialData.has(player) !== true) {
				return;
			}

			// Send patch update to client
			const playersMap = new Map<string, unknown>();
			playersMap.set(tostring(player.UserId), newData);

			ServerNetwork.playerData.sync.fire(player, {
				type: "patch",
				data: {
					players: playersMap,
				},
			} as Parameters<typeof ServerNetwork.playerData.sync.fire>[1]);

			print(`[DataStore] Synced patch data for player ${player.Name}`);
		} catch (error) {
			warn(`[DataStore] Error syncing player data: ${error}`);
		}
	}

	/**
	 * Sends initial player data to client
	 */
	private async sendInitialPlayerData(player: Player): Promise<void> {
		try {
			const playerData = await this.store.get(player);

			// Send initial data to client
			const playersMap = new Map<string, unknown>();
			playersMap.set(tostring(player.UserId), playerData);

			ServerNetwork.playerData.sync.fire(player, {
				type: "init",
				data: {
					players: playersMap,
				},
			} as Parameters<typeof ServerNetwork.playerData.sync.fire>[1]);

			this.playersSentInitialData.add(player);
			print(`[DataStore] Sent initial data for player ${player.Name}`);
		} catch (error) {
			warn(`[DataStore] Failed to send initial data for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Expose the Lyra store directly for other services to use
	 * This allows direct access to all Lyra methods: get, updateAsync, txAsync, etc.
	 */
	public getPlayerStore() {
		return this.store;
	}

	onInit(): void {
		this.setupNetworking();

		safePlayerAdded((player) => {
			try {
				this.store.loadAsync(player);
				// Set up automatic cleanup when player leaves
				Promise.fromEvent(Players.PlayerRemoving, (left) => player === left).then(() => {
					// Clean up tracking
					this.playersRequestedInit.delete(player);
					this.playersSentInitialData.delete(player);
					this.playersSendingInitialData.delete(player);

					// Lyra handles unloading automatically
					this.store.unloadAsync(player);
				});
				print(`[DataStore] Player data loaded for ${player.Name}`);
				// Try to send initial data if client has already requested it
				this.tryToSendInitialData(player);
			} catch (error) {
				this.handlePlayerDataError(player, error);
			}
		});

		// Bind to close for proper Lyra shutdown
		game.BindToClose(() => {
			this.store.closeAsync();
		});
	}

	private setupNetworking(): void {
		// Handle client init requests
		ServerNetwork.playerData.init.on((player: Player) => {
			this.playersRequestedInit.add(player);
			print(`[DataStore] Player ${player.Name} requested initialization`);

			// Try to send initial data immediately if player data is already loaded
			// Use task.spawn since tryToSendInitialData is async and may yield
			task.spawn(() => {
				this.tryToSendInitialData(player);
			});
		});

		print("[DataStore] Networking setup complete - listening for client init requests");
	}

	/**
	 * Attempts to send initial data if both conditions are met:
	 * 1. Client has requested init
	 * 2. Player data is loaded
	 * 3. Not already sending data (prevents race condition)
	 */
	private async tryToSendInitialData(player: Player): Promise<void> {
		// Check if client has requested init and we haven't sent data yet and we're not already sending
		if (
			this.playersRequestedInit.has(player) !== true ||
			this.playersSentInitialData.has(player) === true ||
			this.playersSendingInitialData.has(player) === true
		) {
			return;
		}

		try {
			// Mark that we're sending initial data to prevent race condition
			this.playersSendingInitialData.add(player);

			// Check if player data is loaded by attempting to get it
			const playerData = await this.store.get(player);
			await this.sendInitialPlayerData(player);
		} catch (error) {
			// Player data not loaded yet, will be handled when it loads
			print(`[DataStore] Player data not ready yet for ${player.Name}, will send when loaded`);
		} finally {
			// Always clean up the sending flag
			this.playersSendingInitialData.delete(player);
		}
	}

	private handlePlayerDataError(player: Player, err: unknown) {
		const errorMessage = typeIs(err, "string") === true ? err : tostring(err);
		warn(`Failed to load document for player ${player.Name}: ${errorMessage}`);

		// Kick the player to prevent data loss
		player.Kick(`Your data failed to load. Please rejoin the game.\n\nError: ${errorMessage}`);
	}
}
