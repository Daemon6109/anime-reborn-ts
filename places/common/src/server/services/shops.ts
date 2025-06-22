// shops
--------------------------------------------------------------------------------

import { Network } from "@network/server";
import { Person } from "@commonserver/person";
import Shingo from "@pkgs/shingo";
import { Players } from "@rbxts/services";

const version = { major: 1, minor: 0, patch: 0 };

// Shop constants
const SHOP_TYPES = ["DungeonShop", "EventShop", "RaidShop"] as const;
type ShopType = (typeof SHOP_TYPES)[number];

interface ShopItemConfig {
	cost: { [currency: string]: number };
	stock: number; // -1 for unlimited
}

interface ShopConfig {
	items: { [itemId: string]: ShopItemConfig };
	resetType: "daily" | "weekly" | "never";
}

// Shop configurations
const shopConfigs: { [shopType: string]: ShopConfig } = {};

// Create signals for shop events
const itemPurchasedEvent = new Shingo<{
	player: Player;
	shopType: ShopType;
	itemId: string;
	amount: number;
	cost: { [currency: string]: number };
}>();

interface ShopData {
	[itemId: string]: { stock: number } | undefined;
}

interface PlayerShopDataCache {
	Currencies: { [key: string]: number };
	Inventory: { Items: { Name: string; Count: number }[] };
	[shopDataKey: string]: ShopData | any; // Allow other properties like Currencies, Inventory
}

//[=[
//   Shop system for managing different types of shops.
//
//   @class Shops
//]=]
const Shops = {
	version: version,

	// Events
	itemPurchased: itemPurchasedEvent,

	//[=[
	//   Loads default shop configurations
	//
	//   @within Shops
	//
	//   ```ts
	//   Shops.loadDefaultShopConfigs();
	//   ```
	//]=]
	loadDefaultShopConfigs(): void {
		// Basic shop configs - in a real implementation this would come from external data
		shopConfigs["DungeonShop"] = {
			items: {
				"Health Potion": { cost: { Gold: 100 }, stock: -1 }, // -1 = unlimited
				"Mana Potion": { cost: { Gold: 150 }, stock: -1 },
				"Rare Gem": { cost: { Gold: 1000 }, stock: 5 },
			},
			resetType: "daily", // daily, weekly, never
		};

		shopConfigs["EventShop"] = {
			items: {
				"Event Token": { cost: { Gems: 50 }, stock: 10 },
				"Special Mount": { cost: { Gems: 500 }, stock: 1 },
			},
			resetType: "weekly",
		};

		shopConfigs["RaidShop"] = {
			items: {
				"Raid Key": { cost: { Gold: 500 }, stock: 3 },
				"Epic Equipment": { cost: { Gold: 2000 }, stock: 1 },
			},
			resetType: "weekly",
		};
	},

	//[=[
	//   Initializes shop data for a person
	//
	//   @within Shops
	//
	//   @param person Person -- The person for whom to initialize shop data
	//   @param shopType ShopType -- The type of shop to initialize data for
	//
	//   ```ts
	//   Shops.initializeShopData(person, "DungeonShop");
	//   ```
	//]=]
	initializeShopData(person: Person, shopType: ShopType): void {
		if (!shopConfigs[shopType]) {
			return;
		}

		person.dataCache((cache) => {
			const newCache = { ...cache } as PlayerShopDataCache;
			const shopDataKey = `${shopType}Data`;

			// Ensure shop data exists
			if (!newCache[shopDataKey]) {
				newCache[shopDataKey] = {};
			}

			const shopData = newCache[shopDataKey] as ShopData;
			const config = shopConfigs[shopType];

			for (const [itemId, itemConfig] of pairs(config.items)) {
				if (itemConfig.stock > 0 && !shopData[itemId as string]) {
					shopData[itemId as string] = { stock: itemConfig.stock };
				}
			}
			newCache[shopDataKey] = shopData;
			return newCache;
		});
	},

	//[=[
	//   Checks for shop resets (daily/weekly)
	//   This function should be called periodically (e.g., every hour) to check if any shops need to be reset.
	//
	//   @within Shops
	//
	//   ```ts
	//   Shops.checkShopResets();
	//   ```
	//]=]
	checkShopResets(): void {
		const currentTime = os.time();
		// const _currentDay = Math.floor(currentTime / 86400); // unused
		// const _currentWeek = Math.floor(currentTime / (86400 * 7)); // unused

		for (const [shopType, config] of pairs(shopConfigs)) {
			let shouldReset = false;
			if (config.resetType === "daily") {
				const daysSinceEpoch = Math.floor(currentTime / 86400);
				// This is a placeholder. A robust implementation would store the last reset day.
				shouldReset = daysSinceEpoch > (person.dataCache() as any)[`${shopType}LastResetDay`] || 0;
			} else if (config.resetType === "weekly") {
				const weeksSinceEpoch = Math.floor(currentTime / (86400 * 7));
				// This is a placeholder. A robust implementation would store the last reset week.
				shouldReset = weeksSinceEpoch > (person.dataCache() as any)[`${shopType}LastResetWeek`] || 0;
			}

			if (shouldReset) {
				Shops.resetShop(shopType as ShopType);
				// Update last reset time in player data for all players or a global store
			}
		}
	},

	//[=[
	//   Resets a shop's stock
	//
	//   @within Shops
	//
	//   @param shopType ShopType -- The type of shop to reset
	//
	//   ```ts
	//   Shops.resetShop("DungeonShop");
	//   ```
	//]=]
	async resetShop(shopType: ShopType): Promise<void> {
		if (!shopConfigs[shopType]) {
			return;
		}

		// Reset for all players
		for (const player of Players.GetPlayers()) {
			const person = await Person.getForPlayer(player);
			if (person) {
				Shops.resetShopForPlayer(person, shopType);
				// Additionally, update a field like `${shopType}LastResetDay` or `${shopType}LastResetWeek` in their data
				person.dataCache(cache => {
					const newCache = {...cache} as any;
					if (shopConfigs[shopType].resetType === "daily") {
						newCache[`${shopType}LastResetDay`] = Math.floor(os.time() / 86400);
					} else if (shopConfigs[shopType].resetType === "weekly") {
						newCache[`${shopType}LastResetWeek`] = Math.floor(os.time() / (86400 * 7));
					}
					return newCache;
				})
			}
		}
	},

	//[=[
	//   Resets shop stock for a specific player
	//
	//   @within Shops
	//
	//   @param person Person -- The person whose shop stock to reset
	//   @param shopType ShopType -- The type of shop to reset for the player
	//
	//   ```ts
	//   Shops.resetShopForPlayer(person, "DungeonShop");
	//   ```
	//]=]
	resetShopForPlayer(person: Person, shopType: ShopType): void {
		if (!shopConfigs[shopType]) {
			return;
		}

		person.dataCache((cache) => {
			const newCache = { ...cache } as PlayerShopDataCache;
			const shopDataKey = `${shopType}Data`;
			const shopData = (newCache[shopDataKey] || {}) as ShopData;
			const config = shopConfigs[shopType];

			for (const [itemId, itemConfig] of pairs(config.items)) {
				if (itemConfig.stock > 0) {
					shopData[itemId as string] = { stock: itemConfig.stock };
				}
			}

			newCache[shopDataKey] = shopData;
			return newCache;
		});
	},

	//[=[
	//   Purchases an item from a shop
	//
	//   @within Shops
	//
	//   @param person Person -- The person making the purchase
	//   @param shopType ShopType -- The type of shop to purchase from
	//   @param itemId string -- The ID of the item to purchase
	//   @param amount number -- The amount of the item to purchase
	//
	//   @return boolean -- Returns true if the purchase was successful, false otherwise
	//
	//   ```ts
	//   const success = Shops.purchaseShopItem(person, "DungeonShop", "Health Potion", 2);
	//   if (success) {
	// 	   print("Purchase successful!");
	//   } else {
	// 	   print("Purchase failed.");
	//   }
	//   ```
	//]=]
	purchaseShopItem(person: Person, shopType: ShopType, itemId: string, amount: number): boolean {
		if (!shopConfigs[shopType]) {
			return false;
		}

		const config = shopConfigs[shopType];
		const itemConfig = config.items[itemId];

		if (!itemConfig) {
			return false;
		}

		const cache = person.dataCache() as PlayerShopDataCache;
		const shopDataKey = `${shopType}Data`;
		const shopData = (cache[shopDataKey] || {}) as ShopData;

		// Check stock
		if (itemConfig.stock > 0) {
			const currentStock = shopData[itemId]?.stock ?? itemConfig.stock;
			if (currentStock < amount) {
				return false;
			}
		}

		// Check if player can afford the item
		const totalCost: { [currency: string]: number } = {};
		for (const [currency, cost] of pairs(itemConfig.cost)) {
			totalCost[currency as string] = cost * amount;
		}

		const currencies = cache.Currencies;
		for (const [currency, cost] of pairs(totalCost)) {
			if ((currencies[currency as string] || 0) < cost) {
				return false;
			}
		}

		// Process the purchase
		person.dataCache((oldCache) => {
			const newCache = { ...oldCache } as PlayerShopDataCache;

			// Deduct cost
			for (const [currency, cost] of pairs(totalCost)) {
				newCache.Currencies[currency as string] = (newCache.Currencies[currency as string] || 0) - cost;
			}

			// Add item to inventory
			const inventory = newCache.Inventory.Items;
			let itemIndex = -1;

			for (let i = 0; i < inventory.size(); i++) {
				if (inventory[i].Name === itemId) {
					itemIndex = i;
					break;
				}
			}

			if (itemIndex !== -1) {
				// Item exists, increase count
				inventory[itemIndex].Count += amount;
			} else {
				// Item doesn't exist, add new entry
				inventory.push({ Name: itemId, Count: amount });
			}

			// Update shop stock
			const shopDataKeyUpdate = `${shopType}Data`;
			if (!newCache[shopDataKeyUpdate]) {
				newCache[shopDataKeyUpdate] = {};
			}
			const shopDataUpdate = newCache[shopDataKeyUpdate] as ShopData;

			if (itemConfig.stock > 0) {
				if (!shopDataUpdate[itemId]) {
					shopDataUpdate[itemId] = { stock: itemConfig.stock };
				}
				shopDataUpdate[itemId]!.stock -= amount;
			}
			newCache[shopDataKeyUpdate] = shopDataUpdate;
			return newCache;
		});

		// Fire event
		itemPurchasedEvent.fire({
			player: person.player,
			shopType: shopType,
			itemId: itemId,
			amount: amount,
			cost: totalCost,
		});

		return true;
	},

	//[=[
	//   Gets available items for a shop type
	//
	//   @within Shops
	//
	//   @param shopType ShopType -- The type of shop to get items for
	//
	//   @return { [itemId: string]: ShopItemConfig } | undefined -- Returns a table of items if the shop type exists, undefined otherwise
	//
	//   ```ts
	//   const items = Shops.getShopItems("DungeonShop");
	//   if (items) {
	// 	   for (const [itemId, itemConfig] of pairs(items)) {
	// 		   print(itemId, itemConfig.cost, itemConfig.stock);
	// 	   }
	//   } else {
	// 	   print("Shop type not found.");
	//   }
	//   ```
	//]=]
	getShopItems(shopType: ShopType): { [itemId: string]: ShopItemConfig } | undefined {
		return shopConfigs[shopType]?.items;
	},

	//[=[
	//   Gets shop stock for a person
	//
	//   @within Shops
	//
	//   @param person Person -- The person whose shop stock to get
	//   @param shopType ShopType -- The type of shop to get stock for
	//
	//   @return { [itemId: string]: number } -- Returns a table of item IDs and their stock counts
	//
	//   ```ts
	//   const stock = Shops.getShopStock(person, "DungeonShop");
	//   for (const [itemId, stockCount] of pairs(stock)) {
	// 	   print(itemId, stockCount);
	//   }
	//   ```
	//]=]
	getShopStock(person: Person, shopType: ShopType): { [itemId: string]: number } {
		const cache = person.dataCache() as PlayerShopDataCache;
		const shopDataKey = `${shopType}Data`;
		const shopData = (cache[shopDataKey] || {}) as ShopData;
		const stock: { [itemId: string]: number } = {};
		const config = shopConfigs[shopType];

		if (config) {
			for (const [itemId, itemConfig] of pairs(config.items)) {
				if (itemConfig.stock > 0) {
					stock[itemId as string] = shopData[itemId as string]?.stock ?? itemConfig.stock;
				} else {
					stock[itemId as string] = -1; // Unlimited
				}
			}
		}
		return stock;
	},
};

//[=[
//   This function is used to start the provider and initialize any necessary systems.
//
//   ```ts
//   start();
//   ```
//]=]
async function start(): Promise<void> {
	// Set up Blink network event handling
	// Purchase shop item event
	Network.PurchaseShopItem.on(async (player, data: { shopType: ShopType; itemId: string; amount: number }) => {
		const person = await Person.getForPlayer(player);
		if (!person) {
			return;
		}
		Shops.purchaseShopItem(person, data.shopType, data.itemId, data.amount);
	});
}

//[=[
//   This function is used for initialization. It should be called before `start()` to set up the provider.
//
//   ```ts
//   init();
//   ```
//]=]
function init(): void {
	// Load shop configurations
	Shops.loadDefaultShopConfigs();

	// Initialize shop data for new players
	Person.personAdded.Connect(async (person: Person) => {
		task.wait(1); // Wait for data to load
		for (const shopType of SHOP_TYPES) {
			Shops.initializeShopData(person, shopType);
		}
	});

	// Set up periodic shop reset checks (every hour)
	task.spawn(() => {
		while (true) {
			task.wait(3600); // Check every hour
			Shops.checkShopResets();
		}
	});
}

export default {
	version: version,

	// Functions
	start: start,
	init: init,
	loadDefaultShopConfigs: Shops.loadDefaultShopConfigs,
	initializeShopData: Shops.initializeShopData,
	checkShopResets: Shops.checkShopResets,
	resetShop: Shops.resetShop,
	resetShopForPlayer: Shops.resetShopForPlayer,
	purchaseShopItem: Shops.purchaseShopItem,
	getShopItems: Shops.getShopItems,
	getShopStock: Shops.getShopStock,

	// Events
	itemPurchased: Shops.itemPurchased,
};
