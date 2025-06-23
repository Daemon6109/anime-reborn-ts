import { Service, OnInit } from "@flamework/core";
import { Players } from "@rbxts/services";
import { DataService } from "./data.service";
import {
	DungeonShopData,
	EventShopData,
	RaidShopData,
	createDungeonShopData,
	createEventShopData,
	createRaidShopData,
} from "../../shared/data/factories/misc-factories";

const version = { major: 1, minor: 0, patch: 0 };

export interface ShopItemConfig {
	cost: Record<string, number>;
	stock: number; // -1 = unlimited
}

export interface ShopConfig {
	items: Record<string, ShopItemConfig>;
	resetType: "daily" | "weekly" | "never";
}

export interface ShopPurchaseEvent {
	player: Player;
	shopType: string;
	itemId: string;
	amount: number;
	cost: Record<string, number>;
}

export type ShopType = "DungeonShop" | "EventShop" | "RaidShop";

/**
 * Shop system for managing different types of shops with stock management and reset cycles.
 */
@Service()
export class ShopService implements OnInit {
	public readonly version = version;

	// Shop types
	private readonly SHOP_TYPES: ShopType[] = ["DungeonShop", "EventShop", "RaidShop"];

	// Shop configurations
	private shopConfigs: Record<string, ShopConfig> = {};

	// Events - using simple callback arrays for now
	private itemPurchasedCallbacks: Array<(event: ShopPurchaseEvent) => void> = [];

	// Reset tracking
	private lastResetCheck = 0;

	constructor(private readonly dataService: DataService) {}

	public onInit(): void {
		this.loadDefaultShopConfigs();
		this.setupPlayerJoinedHandler();
		this.setupPeriodicResetCheck();

		print("ShopService initialized");
	}

	/**
	 * Subscribe to item purchased events
	 */
	public onItemPurchased(callback: (event: ShopPurchaseEvent) => void): void {
		this.itemPurchasedCallbacks.push(callback);
	}

	/**
	 * Fire item purchased event
	 */
	private fireItemPurchased(event: ShopPurchaseEvent): void {
		for (const callback of this.itemPurchasedCallbacks) {
			try {
				callback(event);
			} catch (error) {
				warn(`Error in shop item purchased callback: ${error}`);
			}
		}
	}

	/**
	 * Loads default shop configurations
	 */
	public loadDefaultShopConfigs(): void {
		// Dungeon Shop - resets daily
		this.shopConfigs["DungeonShop"] = {
			items: {
				["Health Potion"]: { cost: { Gold: 100 }, stock: -1 }, // -1 = unlimited
				["Mana Potion"]: { cost: { Gold: 150 }, stock: -1 },
				["Rare Gem"]: { cost: { Gold: 1000 }, stock: 5 },
				["Magic Scroll"]: { cost: { Gold: 300 }, stock: 10 },
				["Elixir"]: { cost: { Gold: 500 }, stock: 3 },
			},
			resetType: "daily",
		};

		// Event Shop - resets weekly
		this.shopConfigs["EventShop"] = {
			items: {
				["Event Token"]: { cost: { Gems: 50 }, stock: 10 },
				["Special Mount"]: { cost: { Gems: 500 }, stock: 1 },
				["Event Weapon"]: { cost: { Gems: 300 }, stock: 2 },
				["Seasonal Armor"]: { cost: { Gems: 400 }, stock: 1 },
			},
			resetType: "weekly",
		};

		// Raid Shop - resets weekly
		this.shopConfigs["RaidShop"] = {
			items: {
				["Raid Key"]: { cost: { Gold: 500 }, stock: 3 },
				["Epic Equipment"]: { cost: { Gold: 2000 }, stock: 1 },
				["Legendary Crystal"]: { cost: { Gold: 1500 }, stock: 2 },
				["Raid Scroll"]: { cost: { Gold: 800 }, stock: 5 },
			},
			resetType: "weekly",
		};
	}

	/**
	 * Initializes shop data for a player
	 */
	public async initializeShopData(player: Player, shopType: ShopType): Promise<void> {
		if (!this.shopConfigs[shopType]) {
			return;
		}

		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return;
		}

		const newData = { ...playerData };
		const shopDataKey = this.getShopDataKey(shopType);
		const dataAsRecord = newData as unknown as Record<string, unknown>;

		// Ensure shop data exists
		if (dataAsRecord[shopDataKey] === undefined) {
			switch (shopType) {
				case "DungeonShop":
					dataAsRecord.DungeonShopData = createDungeonShopData();
					break;
				case "EventShop":
					dataAsRecord.EventShopData = createEventShopData();
					break;
				case "RaidShop":
					dataAsRecord.RaidShopData = createRaidShopData();
					break;
			}
		}

		const shopData = dataAsRecord[shopDataKey] as Record<string, unknown>;
		const config = this.shopConfigs[shopType];

		// Initialize stock for items that have limited stock
		for (const [itemId, itemConfig] of pairs(config.items)) {
			if (itemConfig.stock > 0 && shopData[itemId] === undefined) {
				shopData[itemId] = { stock: itemConfig.stock };
			}
		}

		this.dataService.setCache(player, newData);
	}

	/**
	 * Checks for shop resets (daily/weekly)
	 */
	public checkShopResets(): void {
		const currentTime = os.time();
		const currentDay = math.floor(currentTime / 86400);
		const currentWeek = math.floor(currentTime / (86400 * 7));

		for (const [shopType, config] of pairs(this.shopConfigs)) {
			let shouldReset = false;

			if (config.resetType === "daily") {
				// Check if it's a new day since last reset
				const lastResetDay = math.floor(this.lastResetCheck / 86400);
				shouldReset = currentDay > lastResetDay;
			} else if (config.resetType === "weekly") {
				// Check if it's a new week since last reset
				const lastResetWeek = math.floor(this.lastResetCheck / (86400 * 7));
				shouldReset = currentWeek > lastResetWeek;
			}

			if (shouldReset) {
				this.resetShop(shopType as ShopType);
			}
		}

		this.lastResetCheck = currentTime;
	}

	/**
	 * Resets a shop's stock for all players
	 */
	public async resetShop(shopType: ShopType): Promise<void> {
		if (!this.shopConfigs[shopType]) {
			return;
		}

		print(`Resetting shop: ${shopType}`);

		// Reset for all players
		const players = Players.GetPlayers();
		for (const player of players) {
			await this.resetShopForPlayer(player, shopType);
		}
	}

	/**
	 * Resets shop stock for a specific player
	 */
	public async resetShopForPlayer(player: Player, shopType: ShopType): Promise<void> {
		if (!this.shopConfigs[shopType]) {
			return;
		}

		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return;
		}

		const newData = { ...playerData };
		const shopDataKey = this.getShopDataKey(shopType);
		const dataAsRecord = newData as unknown as Record<string, unknown>;
		const shopData = (dataAsRecord[shopDataKey] as Record<string, unknown>) ?? {};

		const config = this.shopConfigs[shopType];
		for (const [itemId, itemConfig] of pairs(config.items)) {
			if (itemConfig.stock > 0) {
				shopData[itemId] = { stock: itemConfig.stock };
			}
		}

		this.dataService.setCache(player, newData);
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
		if (!this.shopConfigs[shopType]) {
			warn(`Invalid shop type: ${shopType}`);
			return false;
		}

		const config = this.shopConfigs[shopType];
		const itemConfig = config.items[itemId];

		if (!itemConfig) {
			warn(`Item not found in shop: ${itemId}`);
			return false;
		}

		if (amount <= 0) {
			warn(`Invalid purchase amount: ${amount}`);
			return false;
		}

		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get player data for ${player.Name}`);
			return false;
		}

		const shopDataKey = this.getShopDataKey(shopType);
		const dataAsRecord = playerData as unknown as Record<string, unknown>;
		const shopData = (dataAsRecord[shopDataKey] as Record<string, unknown>) ?? {};

		// Check stock
		if (itemConfig.stock > 0) {
			const itemData = shopData[itemId] as { stock: number } | undefined;
			const currentStock = itemData?.stock ?? itemConfig.stock;
			if (currentStock < amount) {
				warn(`Insufficient stock for ${itemId}. Available: ${currentStock}, Requested: ${amount}`);
				return false;
			}
		}

		// Calculate total cost
		const totalCost: Record<string, number> = {};
		for (const [currency, cost] of pairs(itemConfig.cost)) {
			totalCost[currency] = cost * amount;
		}

		// Check if player can afford the item
		const currencies = playerData.Currencies as unknown as Record<string, number>;
		for (const [currency, cost] of pairs(totalCost)) {
			const playerAmount = currencies[currency] ?? 0;
			if (playerAmount < cost) {
				warn(`Insufficient ${currency}. Required: ${cost}, Available: ${playerAmount}`);
				return false;
			}
		}

		// Process the purchase
		const newData = { ...playerData };

		// Deduct cost
		const newCurrencies = newData.Currencies as unknown as Record<string, number>;
		for (const [currency, cost] of pairs(totalCost)) {
			newCurrencies[currency] = (newCurrencies[currency] ?? 0) - cost;
		}

		// Add item to inventory - items are stored by itemId directly
		const inventory = newData.Inventory.Items;
		if (inventory[itemId]) {
			// Item exists, increase count
			inventory[itemId].Count += amount;
		} else {
			// Item doesn't exist, add new entry
			inventory[itemId] = {
				Count: amount,
				Cost: 0, // Items purchased from shop don't have individual cost tracking
			};
		}

		// Update shop stock
		const newDataAsRecord = newData as unknown as Record<string, unknown>;
		const newShopData = newDataAsRecord[shopDataKey] as Record<string, unknown>;
		if (itemConfig.stock > 0) {
			if (newShopData[itemId] === undefined) {
				newShopData[itemId] = { stock: itemConfig.stock };
			}
			const itemData = newShopData[itemId] as { stock: number };
			itemData.stock -= amount;
		}

		this.dataService.setCache(player, newData);

		// Fire event
		this.fireItemPurchased({
			player: player,
			shopType: shopType,
			itemId: itemId,
			amount: amount,
			cost: totalCost,
		});

		print(`${player.DisplayName} purchased ${amount}x ${itemId} from ${shopType}`);
		return true;
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
		const stock: Record<string, number> = {};

		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return stock;
		}

		const shopDataKey = this.getShopDataKey(shopType);
		const dataAsRecord = playerData as unknown as Record<string, unknown>;
		const shopData = (dataAsRecord[shopDataKey] as Record<string, unknown>) ?? {};

		const config = this.shopConfigs[shopType];
		if (config) {
			for (const [itemId, itemConfig] of pairs(config.items)) {
				if (itemConfig.stock > 0) {
					const itemData = shopData[itemId] as { stock: number } | undefined;
					stock[itemId] = itemData?.stock ?? itemConfig.stock;
				} else {
					stock[itemId] = -1; // Unlimited
				}
			}
		}

		return stock;
	}

	/**
	 * Gets shop configuration for a shop type
	 */
	public getShopConfig(shopType: ShopType): ShopConfig | undefined {
		return this.shopConfigs[shopType];
	}

	/**
	 * Sets shop configuration for a shop type
	 */
	public setShopConfig(shopType: ShopType, config: ShopConfig): void {
		this.shopConfigs[shopType] = config;
	}

	/**
	 * Gets the data key for a shop type
	 */
	private getShopDataKey(shopType: ShopType): string {
		switch (shopType) {
			case "DungeonShop":
				return "DungeonShopData";
			case "EventShop":
				return "EventShopData";
			case "RaidShop":
				return "RaidShopData";
		}
	}

	/**
	 * Setup player joined handler
	 */
	private setupPlayerJoinedHandler(): void {
		Players.PlayerAdded.Connect((player) => {
			// Wait a bit for data to load
			task.wait(1);

			// Initialize shop data for all shop types
			for (const shopType of this.SHOP_TYPES) {
				this.initializeShopData(player, shopType);
			}
		});
	}

	/**
	 * Setup periodic reset check
	 */
	private setupPeriodicResetCheck(): void {
		// Check for resets every hour
		task.spawn(() => {
			// eslint-disable-next-line no-constant-condition
			while (true) {
				task.wait(3600); // 1 hour
				this.checkShopResets();
			}
		});

		// Also check on service initialization
		this.checkShopResets();
	}
}
