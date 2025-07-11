/**
 * Shops service
 */

import { Service, OnInit } from "@flamework/core";
import Signal from "@rbxts/lemon-signal";
import { Players } from "@rbxts/services";
import { DataStore } from "./player-data";
import { observe } from "@rbxts/charm";
import { Object } from "@rbxts/ui-labs";

interface ShopItemConfig {
	cost: { [currency: string]: number };
	stock: number;
}

interface ShopConfig {
	items: { [id: string]: ShopItemConfig };
	resetType: ShopResetType;
}

enum ShopTypes {
	// Add as needed
	"DungeonShop",
	"EventShop",
	"RaidShop",
}

enum ShopResetType {
	"Daily",
	"Weekly",
	"Never",
}

@Service()
export class ShopService implements OnInit {
	onInit(): void | Promise<void> {}

	constructor(private readonly dataservice: DataStore) {}

	private shopConfigs: { [key in ShopTypes]?: ShopConfig } = {};
	public itemPurchasedEvent = new Signal<(player: Player, shopType: ShopTypes, itemId: string) => void>();

	public LoadDefaultShopConfigs() {
		// TODO: make this external data
		this.shopConfigs[ShopTypes.DungeonShop] = {
			items: {
				["Health Potion"]: { cost: { Gold: 100 }, stock: -1 }, // -1 = unlimited
			},

			resetType: ShopResetType.Daily,
		};

		this.shopConfigs[ShopTypes.EventShop] = {
			items: {
				["Special Mount"]: { cost: { Gold: 500 }, stock: 1 },
			},

			resetType: ShopResetType.Weekly,
		};

		this.shopConfigs[ShopTypes.RaidShop] = {
			items: {
				["Epic Equipment"]: { cost: { Gold: 500 }, stock: 1 },
			},

			resetType: ShopResetType.Weekly,
		};
	}

	public InitializeShopData(player: Player, shopType: ShopTypes) {
		if (this.shopConfigs[shopType] === undefined) {
			warn(`shopType ${shopType} is invalid.`);
			return;
		}

		const playerStore = this.dataservice.getPlayerStore();

		playerStore.updateAsync(player, (playerData) => {
			const config = this.shopConfigs[shopType];

			if (!config?.items) {
				return false;
			}

			// Initialize shop items if they don't exist
			for (const [itemId, itemConfig] of pairs(config.items)) {
				// TODO: Implement shop item initialization logic
				// This should add items to the shop and set their initial stock based on itemConfig.stock

				const existingItem = playerData.shop.find((item) => item.productId() === itemId);

				if (itemConfig.stock > 0 && !existingItem) {
					// Add new item to shop if it doesn't exist
					// TODO: Create and add the new shop item
				}
			}

			return true;
		});
	}
}
