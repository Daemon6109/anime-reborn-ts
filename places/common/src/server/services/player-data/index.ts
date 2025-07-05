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

	/**
	 * Get player data when it's available
	 * Returns a promise that resolves with the player data once it's loaded
	 */
	getPlayerDataWhenReady(player: Player): Promise<PlayerData> {
		return this.getPlayerDataWhenReadyById(player.UserId);
	}

	/**
	 * Get player data when it's available (by user ID)
	 * Returns a promise that resolves with the player data once it's loaded
	 */
	getPlayerDataWhenReadyById(userId: number): Promise<PlayerData> {
		const playerId = tostring(userId);

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

		// Create new promise
		const promise = new Promise<PlayerData>((resolve) => {
			this.playerDataResolvers.set(playerId, resolve);
		});

		this.playerDataPromises.set(playerId, promise);
		return promise;
	}

	onInit(): void {
		this.setupAtomSyncs();

		safePlayerAdded((player) => {
			this.onPlayerAdded(player);

			// Example of using the new promise-based approach
			task.delay(5, () => {
				this.getPlayerDataWhenReady(player).then((playerData) => {
					updatePlayerData(tostring(player.UserId), (data) => {
						return {
							...data,
							units: data.units.map((unit, i) => {
								if (i === 0) {
									return {
										...unit,
										level: {
											...unit.level,
											value: 100,
										},
									};
								}
								return unit;
							}),
						};
					});
				});
			});
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

			print(
				`[DEBUG] Syncer connect: ${player.Name}, type: ${payload.type}, dataReady: ${isDataReady}, syncComplete: ${isInitialSyncComplete}`,
			);

			// Don't send anything until player data is ready
			if (!isDataReady) {
				print(`[DEBUG] Player data not ready, skipping sync for ${player.Name}`);
				return;
			}

			// Skip the first patch after init to prevent double initialization
			if (payload.type === "patch" && !isInitialSyncComplete) {
				playersInitialSyncComplete.set(playerId, true);
				print(`[DEBUG] Skipping first patch for ${player.Name}`);
				return;
			}

			const filteredPayload = filterPayload(player, payload as SyncPayload<GlobalAtoms>);
			print(`[DEBUG] Sending ${payload.type} payload to ${player.Name}`);
			ServerNetwork.playerData.Atoms.sync.fire(player, filteredPayload);
		});

		ServerNetwork.playerData.Atoms.init.on((player) => {
			const playerId = tostring(player.UserId);
			const isDataReady = playersDataReady.get(playerId) ?? false;

			print(`[DEBUG] Init requested for ${player.Name}, dataReady: ${isDataReady}`);

			if (isDataReady) {
				print(`[DEBUG] Data ready, hydrating ${player.Name}`);
				syncer.hydrate(player);
			} else {
				print(`[DEBUG] Data not ready, waiting for ${player.Name}`);
				// Use promise-based approach to avoid yielding in event callback
				task.spawn(() => {
					this.getPlayerDataWhenReady(player)
						.then(() => {
							print(`[DEBUG] Data now ready, hydrating ${player.Name}`);
							syncer.hydrate(player);
						})
						.catch((err) => {
							warn(`[DEBUG] Failed to get player data for ${player.Name}: ${err}`);
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
		this.store.loadAsync(player);
		const session = await this.store.get(player);

		if (!player.IsDescendantOf(Players)) {
			this.store.unloadAsync(player);
			return;
		}

		// Set the player data first
		setPlayerData(tostring(player.UserId), session);

		// Resolve any waiting promises
		const playerId = tostring(player.UserId);
		const resolver = this.playerDataResolvers.get(playerId);
		if (resolver) {
			resolver(session);
			this.playerDataResolvers.delete(playerId);
		}

		// Mark the player data as ready so init can proceed
		print(`[DEBUG] Marking player data as ready for ${player.Name}`);
		this.markPlayerDataReady(player);

		const unsubscribe = effect(() => {
			const playerData = getPlayerData(tostring(player.UserId));

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
	}

	onPlayerAdded(player: Player) {
		this.loadPlayerData(player).catch((err) => {
			warn(`Failed to load document for player ${player.Name}: ${err}`);
			const playerId = tostring(player.UserId);

			// Set template data
			setPlayerData(playerId, template);

			// Resolve any waiting promises with template data
			const resolver = this.playerDataResolvers.get(playerId);
			if (resolver) {
				resolver(template);
				this.playerDataResolvers.delete(playerId);
			}

			// Mark data as ready
			this.markPlayerDataReady(player);
		});
	}
	onPlayerRemoving(player: Player) {
		const playerId = tostring(player.UserId);

		// Clean up promises
		this.playerDataPromises.delete(playerId);
		this.playerDataResolvers.delete(playerId);

		deletePlayerData(playerId);
	}
}
