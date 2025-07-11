// Packages
import { Signal } from "@rbxts/lemon-signal";
import { Players } from "@rbxts/services";
import { Service, OnInit } from "@flamework/core";

// Types
import type { PlayerData } from "@shared/atoms/player-data";
import type { PlayerDataCurrencies } from "@shared/data/currencies-data";
import type { ShopItems } from "@shared/data/shop-data";

// Dependencies
import { DataStore } from "./player-data";
import ServerNetwork from "@network/server";
import { safePlayerAdded } from "../../shared/utils/safe-player-added.util";

// Shop Types - matches the network definition (note: contains typo in network definition)
type ShopType = "DunegonShop" | "EventShop" | "RaidShop";

interface ShopItemConfig {
	cost: Partial<PlayerDataCurrencies>;
	stock: number; // -1 = unlimited
}

interface ShopConfig {
	items: Record<string, ShopItemConfig>;
	resetType: "daily" | "weekly" | "never";
}

interface ShopItemStock {
	stock: number;
}

interface ShopPurchaseData {
	player: Player;
	shopType: ShopType;
	itemId: string;
	amount: number;
	cost: Partial<PlayerDataCurrencies>;
}

@Service()
export class ShopService implements OnInit {
	private static readonly SHOP_TYPES: ShopType[] = ["DunegonShop", "EventShop", "RaidShop"];

	// Shop configurations
	private shopConfigs: Record<string, ShopConfig> = {};

	// Events
	public itemPurchased = new Signal<[ShopPurchaseData]>();

	constructor(private readonly dataStore: DataStore) {}

	/**
	 * Loads default shop configurations
	 */
	private loadDefaultShopConfigs(): void {
		// Basic shop configs - in a real implementation this would come from external data
		this.shopConfigs["DunegonShop"] = {
			items: {
				"Health Potion": { cost: { gold: 100 }, stock: -1 }, // -1 = unlimited
				"Mana Potion": { cost: { gold: 150 }, stock: -1 },
				"Rare Gem": { cost: { gold: 1000 }, stock: 5 },
			},
			resetType: "daily",
		};

		this.shopConfigs["EventShop"] = {
			items: {
				"Event Token": { cost: { gems: 50 }, stock: 10 },
				"Special Mount": { cost: { gems: 500 }, stock: 1 },
			},
			resetType: "weekly",
		};

		this.shopConfigs["RaidShop"] = {
			items: {
				"Raid Key": { cost: { gold: 500 }, stock: 3 },
				"Epic Equipment": { cost: { gold: 2000 }, stock: 1 },
			},
			resetType: "weekly",
		};
	}

	/**
	 * Initializes shop data for a player
	 */
	private async initializeShopData(player: Player, shopType: ShopType): Promise<void> {
		const config = this.shopConfigs[shopType];
		if (!config) {
			return;
		}

		try {
			const store = this.dataStore.getPlayerStore();
			await store.updateAsync(player, (oldData) => {
				// Ensure shop data exists
				const shopDataKey = `${shopType}Data` as keyof PlayerData;
				if (!oldData[shopDataKey]) {
					(oldData as any)[shopDataKey] = {};
				}

				const shopData = (oldData as any)[shopDataKey] as Record<string, ShopItemStock>;
				let hasChanges = false;

				// Initialize stock for items that have limited stock
				for (const itemId in config.items) {
					const itemConfig = config.items[itemId];
					if (itemConfig.stock > 0 && !shopData[itemId]) {
						shopData[itemId] = { stock: itemConfig.stock };
						hasChanges = true;
					}
				}

				return hasChanges;
			});
		} catch (error) {
			warn(`Failed to initialize shop data for player ${player.Name}: ${error}`);
		}
	}

	/**
	 * Checks for shop resets (daily/weekly)
	 * This function should be called periodically (e.g., every hour) to check if any shops need to be reset.
	 */
	private checkShopResets(): void {
		const currentTime = os.time();
		const currentDay = math.floor(currentTime / 86400);
		const currentWeek = math.floor(currentTime / (86400 * 7));

		for (const shopType in this.shopConfigs) {
			const config = this.shopConfigs[shopType];
			let shouldReset = false;
			if (config.resetType === "daily") {
				// Check if it's a new day - placeholder logic
				shouldReset = currentDay > 0; // This would need proper last reset tracking
			} else if (config.resetType === "weekly") {
				// Check if it's a new week - placeholder logic
				shouldReset = currentWeek > 0; // This would need proper last reset tracking
			}

			if (shouldReset) {
				this.resetShop(shopType as ShopType);
			}
		}
	}

	/**
	 * Resets a shop's stock for all players
	 */
	private resetShop(shopType: ShopType): void {
		const config = this.shopConfigs[shopType];
		if (!config) {
			return;
		}

		// Reset for all players
		for (const player of Players.GetPlayers()) {
			this.resetShopForPlayer(player, shopType);
		}
	}

	/**
	 * Resets shop stock for a specific player
	 */
	private async resetShopForPlayer(player: Player, shopType: ShopType): Promise<void> {
		const config = this.shopConfigs[shopType];
		if (!config) {
			return;
		}

		try {
			const store = this.dataStore.getPlayerStore();
			await store.updateAsync(player, (oldData) => {
				const shopDataKey = `${shopType}Data` as keyof PlayerData;
				const shopData = ((oldData as any)[shopDataKey] as Record<string, ShopItemStock>) || {};

				for (const itemId in config.items) {
					const itemConfig = config.items[itemId];
					if (itemConfig.stock > 0) {
						shopData[itemId] = { stock: itemConfig.stock };
					}
				}

				(oldData as any)[shopDataKey] = shopData;
				return true;
			});
		} catch (error) {
			warn(`Failed to reset shop for player ${player.Name}: ${error}`);
		}
	}

	/**
	 * Purchases an item from a shop
	 */
	public async purchaseShopItem(
		player: Player,
		shopType: ShopType,
		itemId: string,
		amount: number,
	): Promise<boolean> {
		const config = this.shopConfigs[shopType];
		const itemConfig = config?.items[itemId];

		if (!config || !itemConfig) {
			return false;
		}

		try {
			const store = this.dataStore.getPlayerStore();
			let purchaseSuccessful = false;
			let totalCost: Partial<PlayerDataCurrencies> = {};

			await store.updateAsync(player, (cache) => {
				const shopDataKey = `${shopType}Data` as keyof PlayerData;
				const shopData = ((cache as any)[shopDataKey] as Record<string, ShopItemStock>) || {};

				// Check stock
				if (itemConfig.stock > 0) {
					const currentStock = shopData[itemId]?.stock ?? itemConfig.stock;
					if (currentStock < amount) {
						return false; // Not enough stock
					}
				}

				// Calculate total cost
				for (const currency in itemConfig.cost) {
					const currencyKey = currency as keyof PlayerDataCurrencies;
					const cost = itemConfig.cost[currencyKey] as number;
					(totalCost as any)[currencyKey] = cost * amount;
				}

				// Check if player can afford the item
				const currencies = cache.currencies;
				for (const currency in totalCost) {
					const playerAmount = currencies[currency as keyof PlayerDataCurrencies] ?? 0;
					const cost = totalCost[currency as keyof PlayerDataCurrencies] ?? 0;
					if (playerAmount < cost) {
						return false; // Can't afford
					}
				}

				// Process the purchase - deduct cost
				for (const currency in totalCost) {
					const currentAmount = cache.currencies[currency as keyof PlayerDataCurrencies] ?? 0;
					const cost = totalCost[currency as keyof PlayerDataCurrencies] ?? 0;
					(cache.currencies as any)[currency] = currentAmount - cost;
				}

				// Add item to inventory
				const existingItemIndex = cache.items.findIndex((item) => item.id === itemId);

				if (existingItemIndex !== -1) {
					// Item exists, increase amount
					cache.items[existingItemIndex] = {
						...cache.items[existingItemIndex],
						amount: cache.items[existingItemIndex].amount + amount,
					};
				} else {
					// Item doesn't exist, add new entry
					cache.items.push({
						id: itemId,
						uuid: `item-${os.time()}-${math.random(1, 10000)}`,
						amount: amount,
						locked: false,
					});
				}

				// Update shop stock
				if (itemConfig.stock > 0) {
					if (!shopData[itemId]) {
						shopData[itemId] = { stock: itemConfig.stock };
					}
					shopData[itemId].stock = shopData[itemId].stock - amount;
					(cache as any)[shopDataKey] = shopData;
				}

				purchaseSuccessful = true;
				return true; // Commit the changes
			});

			if (purchaseSuccessful) {
				// Fire event
				this.itemPurchased.Fire({
					player,
					shopType,
					itemId,
					amount,
					cost: totalCost,
				});
			}

			return purchaseSuccessful;
		} catch (error) {
			warn(`Failed to purchase shop item for player ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Gets available items for a shop type
	 */
	public getShopItems(shopType: ShopType): Record<string, ShopItemConfig> | undefined {
		return this.shopConfigs[shopType]?.items;
	}

	/**
	 * Gets shop stock for a player
	 */
	public async getShopStock(player: Player, shopType: ShopType): Promise<Record<string, number>> {
		const config = this.shopConfigs[shopType];
		if (!config) {
			return {};
		}

		try {
			const store = this.dataStore.getPlayerStore();
			const playerData = await store.get(player);
			const shopDataKey = `${shopType}Data` as keyof PlayerData;
			const shopData = ((playerData as any)[shopDataKey] as Record<string, ShopItemStock>) || {};

			const stock: Record<string, number> = {};
			for (const itemId in config.items) {
				const itemConfig = config.items[itemId];
				if (itemConfig.stock > 0) {
					stock[itemId] = shopData[itemId]?.stock ?? itemConfig.stock;
				} else {
					stock[itemId] = -1; // Unlimited
				}
			}

			return stock;
		} catch (error) {
			warn(`Failed to get shop stock for player ${player.Name}: ${error}`);
			return {};
		}
	}

	/**
	 * Initializes the ShopService.
	 * Sets up network events and periodic shop reset checks.
	 */
	onInit(): void {
		// Load shop configurations
		this.loadDefaultShopConfigs();

		// Set up network event handling
		ServerNetwork.shop.PurchaseShopItem.on((player, data) => {
			this.purchaseShopItem(player, data.shopType, data.itemId, data.amount);
		});

		// Initialize shop data for new players
		safePlayerAdded((player) => {
			// Wait a bit for player data to load, then initialize shop data
			task.wait(1);
			for (const shopType of ShopService.SHOP_TYPES) {
				this.initializeShopData(player, shopType);
			}
		});

		// Set up periodic shop reset checks (every hour)
		task.spawn(() => {
			do {
				task.wait(3600); // Check every hour
				this.checkShopResets();
				// eslint-disable-next-line no-constant-condition
			} while (true);
		});
	}
}
