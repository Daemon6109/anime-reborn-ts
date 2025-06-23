import { OnStart, Service } from "@flamework/core";
import { Players, MarketplaceService, HttpService } from "@rbxts/services";
import Signal from "@rbxts/signal";

// Placeholder types and interfaces (to be properly defined later)
interface DataCache {
	Currencies: Record<string, number>;
	XP: number;
	Level: number;
	Inventory: {
		Items: Record<string, number>;
	};
	RobuxSpent: number;
	ReceiptHistory: Record<
		string,
		{
			ProductId: number;
			PlayerId: number;
			PurchaseId: string;
			CurrencySpent: number;
			Timestamp: number;
		}
	>;
}

interface Person {
	player: Player;
	dataCache: (fn?: (data: DataCache) => DataCache) => DataCache;
}

// Mock Person module
const Person = {
	getForPlayer: (player: Player): Person | undefined => {
		// Mock implementation - would be replaced with actual Person module
		return undefined;
	},
};

// Mock Products registry
const Products: Record<number, ProductData> = {};

// Mock WebhookLib
const WebhookLib = {
	send: (data: unknown): void => {
		// Mock implementation
		print("Would send webhook:", data);
	},
};

interface ProductData {
	Id: number;
	Name: string;
	Price: number;
	Rewards: Record<string, unknown>;
	Type: string;
}

interface ReceiptInfo {
	PlayerId: number;
	PlaceIdWherePurchased: number;
	ProductId: number;
	PurchaseId: string;
	CurrencySpent: number;
	CurrencyType: Enum.CurrencyType;
}

interface StoredGiftData {
	Recipient: string;
	Gift: string;
	Amount: number;
}

/**
 * Handler for monetization events including developer products, gamepasses, and gifts.
 */
@Service({})
export class MonetizationService implements OnStart {
	public readonly version = { major: 1, minor: 0, patch: 0 };
	public readonly products = Products;
	private readonly storedGiftData = new Map<Player, StoredGiftData>();

	// Place whitelist for different datastores
	private readonly PLACE_DATASTORE_WHITELIST = new Map([
		["5844593548", "MainDatastore"],
		["6717025335", "TestDatastore"],
	]);

	// Events
	public readonly purchaseProcessed = new Signal<(player: Player, productInfo: ProductData) => void>();
	public readonly gamepassOwned = new Signal<(player: Player, gamepassId: number) => void>();

	onStart(): void {
		// Set up marketplace service callbacks
		MarketplaceService.ProcessReceipt = (receiptInfo) => this.processProductPurchase(receiptInfo);
		print("💰 MonetizationService started");
	}

	/**
	 * Gets the appropriate datastore name for the current place
	 */
	private getDatastoreName(): string | undefined {
		return this.PLACE_DATASTORE_WHITELIST.get(tostring(game.GameId));
	}

	/**
	 * Processes a developer product purchase
	 */
	public processProductPurchase(receiptInfo: ReceiptInfo): Enum.ProductPurchaseDecision {
		const player = Players.GetPlayerByUserId(receiptInfo.PlayerId);
		if (!player) {
			// Player left before purchase could be processed
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		const person = Person.getForPlayer(player);
		if (!person) {
			warn(`Person not found for player ${player.Name} during purchase processing`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		const productInfo = this.products[receiptInfo.ProductId];
		if (!productInfo) {
			warn(`Unknown product ID: ${receiptInfo.ProductId}`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		// Check if this purchase was already processed
		if (this.isPurchaseProcessed(person, receiptInfo.PurchaseId)) {
			return Enum.ProductPurchaseDecision.PurchaseGranted;
		}

		// Process the purchase
		const success = this.grantProductRewards(person, productInfo);

		if (success) {
			// Record the purchase
			this.recordPurchase(person, receiptInfo);

			// Send webhook notification
			this.sendPurchaseWebhook(player, productInfo, receiptInfo);

			// Fire purchase processed event
			this.purchaseProcessed.Fire(player, productInfo);

			return Enum.ProductPurchaseDecision.PurchaseGranted;
		} else {
			warn(`Failed to grant rewards for product ${productInfo.Name} to player ${player.Name}`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}
	}

	/**
	 * Grants rewards for a purchased product
	 */
	private grantProductRewards(person: Person, productInfo: ProductData): boolean {
		try {
			person.dataCache((dataCache) => {
				const newCache = { ...dataCache };

				// Process rewards based on product type
				for (const [rewardType, amount] of pairs(productInfo.Rewards)) {
					if (rewardType === "Currencies" && typeIs(amount, "table")) {
						for (const [currencyType, currencyAmount] of pairs(amount as Record<string, number>)) {
							if (newCache.Currencies[currencyType] !== undefined) {
								newCache.Currencies[currencyType] = newCache.Currencies[currencyType] + currencyAmount;
							}
						}
					} else if (rewardType === "XP" && typeIs(amount, "number")) {
						newCache.XP = newCache.XP + amount;
					} else if (rewardType === "Level" && typeIs(amount, "number")) {
						newCache.Level = newCache.Level + amount;
					} else if (rewardType === "Items" && typeIs(amount, "table")) {
						// Handle item rewards
						for (const [itemId, itemAmount] of pairs(amount as Record<string, number>)) {
							if (newCache.Inventory.Items[itemId] === undefined) {
								newCache.Inventory.Items[itemId] = 0;
							}
							newCache.Inventory.Items[itemId] = newCache.Inventory.Items[itemId] + itemAmount;
						}
					}
				}

				// Update robux spent tracking
				newCache.RobuxSpent = newCache.RobuxSpent + productInfo.Price;

				return newCache;
			});

			return true;
		} catch (error) {
			warn(`Error granting product rewards: ${error}`);
			return false;
		}
	}

	/**
	 * Checks if a purchase has already been processed
	 */
	private isPurchaseProcessed(person: Person, purchaseId: string): boolean {
		const dataCache = person.dataCache();
		const receiptHistory = dataCache.ReceiptHistory;

		return receiptHistory[purchaseId] !== undefined;
	}

	/**
	 * Records a purchase in the player's receipt history
	 */
	private recordPurchase(person: Person, receiptInfo: ReceiptInfo): void {
		person.dataCache((dataCache) => {
			const newCache = { ...dataCache };

			newCache.ReceiptHistory[receiptInfo.PurchaseId] = {
				ProductId: receiptInfo.ProductId,
				PlayerId: receiptInfo.PlayerId,
				PurchaseId: receiptInfo.PurchaseId,
				CurrencySpent: receiptInfo.CurrencySpent,
				Timestamp: os.time(),
			};

			return newCache;
		});
	}

	/**
	 * Sends a webhook notification for a purchase
	 */
	private sendPurchaseWebhook(player: Player, productInfo: ProductData, receiptInfo: ReceiptInfo): void {
		const [success, result] = pcall(() => {
			const webhookData = {
				content: "",
				embeds: [
					{
						title: "💰 Product Purchase",
						description: `${player.Name} purchased ${productInfo.Name}`,
						color: 0x00ff00,
						fields: [
							{
								name: "Player",
								value: `${player.Name} (${player.UserId})`,
								inline: true,
							},
							{
								name: "Product",
								value: `${productInfo.Name} (ID: ${productInfo.Id})`,
								inline: true,
							},
							{
								name: "Price",
								value: `${productInfo.Price} Robux`,
								inline: true,
							},
							{
								name: "Purchase ID",
								value: receiptInfo.PurchaseId,
								inline: false,
							},
						],
						timestamp: os.date("!%Y-%m-%dT%H:%M:%S.000Z"),
					},
				],
			};

			WebhookLib.send(webhookData);
		});

		if (!success) {
			warn(`Failed to send purchase webhook: ${result}`);
		}
	}

	/**
	 * Handles gamepass ownership checks and rewards
	 */
	public handleGamepass(person: Person, gamepassId: number): boolean {
		const player = person.player;
		const [success, ownsGamepass] = pcall(() => {
			return MarketplaceService.UserOwnsGamePassAsync(player.UserId, gamepassId);
		});

		if (success && ownsGamepass) {
			// Apply gamepass benefits
			// This would be specific to each gamepass
			this.gamepassOwned.Fire(player, gamepassId);
			return true;
		}

		return false;
	}

	/**
	 * Stores gift data for a player
	 */
	public storeGiftData(player: Player, giftData: StoredGiftData): void {
		this.storedGiftData.set(player, giftData);
	}

	/**
	 * Retrieves stored gift data for a player
	 */
	public getStoredGiftData(player: Player): StoredGiftData | undefined {
		return this.storedGiftData.get(player);
	}

	/**
	 * Clears stored gift data for a player (called when player leaves)
	 */
	public clearStoredGiftData(player: Player): void {
		this.storedGiftData.delete(player);
	}

	/**
	 * Gets the total robux spent by a player
	 */
	public getPlayerRobuxSpent(person: Person): number {
		const dataCache = person.dataCache();
		return dataCache.RobuxSpent ?? 0;
	}
}
