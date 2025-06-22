// receipt_processor
--------------------------------------------------------------------------------

import { Data } from "@commonserver/data";
import { Person } from "@commonserver/person";
import { data_constants } from "@commonserver/data/data_constants";
import { waitForFirstAsync } from "@commonutils/waitForFirstAsync";
import { MarketplaceService, Players } from "@rbxts/services";

const version = { major: 1, minor: 0, patch: 0 };

const MAX_RECEIPT_HISTORY = data_constants.MAX_RECEIPT_HISTORY; // The maximum number of receipts to store in the player data

type ProductCallback = (player: Player, productId: number) => void;

interface ReceiptInfo {
	PlayerId: number;
	ProductId: number;
	PurchaseId: string;
	// Add other fields from ReceiptInfo if necessary, e.g. PlaceIdWherePurchased, CurrencySpent, CurrencyType
}

interface PlayerDataCache {
	ReceiptHistory: string[];
	// Add other fields that might be in the dataCache
}

//[=[
//   This module handles the receipt processing for in-game purchases and developer products.
//
//   @class ReceiptProcessor
//]=]
const ReceiptProcessor = {
	_productCallbacks: new Map<number, ProductCallback>(),

	//[=[
	//   Registers a callback for a developer product. The callback will be invoked when the product is purchased.
	//
	//   @within ReceiptProcessor
	//
	//   @param developerProductId number -- The ID of the developer product
	//   @param productCallback ProductCallback -- The callback function to invoke when the product is purchased
	//
	//   ```ts
	//   ReceiptProcessor.registerProductCallback(developerProductId, productCallback);
	//   ```
	//]=]
	registerProductCallback(developerProductId: number, productCallback: ProductCallback): void {
		assert(
			!ReceiptProcessor._productCallbacks.has(developerProductId),
			`Developer product ${developerProductId} already has a callback assigned`,
		);
		ReceiptProcessor._productCallbacks.set(developerProductId, productCallback);
	},

	//[=[
	//   Processes a receipt for a player. This function is called by the Roblox platform when a player purchases a product.
	//
	//   @within ReceiptProcessor
	//
	//   @param playerId number -- The ID of the player who made the purchase
	//   @param productId number -- The ID of the product that was purchased
	//   @param purchaseId string -- The unique ID of the purchase
	//
	//   @return Enum.ProductPurchaseDecision -- The decision on how to handle the purchase
	//
	//   ```ts
	//   const decision = await ReceiptProcessor._processReceiptAsync(playerId, productId, purchaseId);
	//   if (decision === Enum.ProductPurchaseDecision.PurchaseGranted) {
	//   // The purchase was successfully processed
	//   } else if (decision === Enum.ProductPurchaseDecision.NotProcessedYet) {
	//   // The purchase is still being processed or could not be processed
	//   // Handle this case as needed
	//   }
	//   ```
	//]=]
	async _processReceiptAsync(
		playerId: number,
		productId: number,
		purchaseId: string,
	): Promise<Enum.ProductPurchaseDecision> {
		// We do not want to save player data if the player is not currently in the server
		const player = Players.GetPlayerByUserId(playerId);
		if (!player) {
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		// Because ProcessReceipt can be invoked when the player joins the server, we want to make sure that we've
		// given the player's data time to load before continuing
		if (Person.isLoading(player)) {
			// Here, we are waiting for the player's data to load OR for the player to leave the server (whichever happens first)
			// We are including the player leaving the server here as if we instead yielded indefinitely when the player left the server
			// prior to their data load, ProcessReceipt would be blocked from being invoked again on this server for this purchase
			// even if the player rejoined.
			await waitForFirstAsync(
				() => Person.waitForPersonLoadAsync(player),
				() => {
					// TODO: Replace with player.Destroying:Wait() when that fires on player leave
					return new Promise<void>((resolve) => {
						let playerParent: Instance | undefined = player.Parent;
						const connection = player.AncestryChanged.Connect((_, newParent) => {
							playerParent = newParent;
							if (playerParent === undefined) {
								connection.Disconnect();
								resolve();
							}
						});
						if (playerParent === undefined) { // Check if already nil
							connection.Disconnect();
							resolve();
						}
					});
				},
			);
		}

		// We do not want to save player data if it is currently loading, has errored or saving is otherwise disabled
		// This check will also capture if the player has left without their data loading
		const person = await Person.getForPlayer(player);
		if (!person || !person.dataCache()) {
			warn(`Player data not loaded for player ${player.Name}`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		// Because the PlayerData system uses session locking, we can guarantee that the player data in memory
		// on the server by PlayerDataServer is the most up to date version available. Therefore, we do not
		// need to check to see if a more recent Data Store value exists where the receipt is handled.
		const dataCache = person.dataCache() as PlayerDataCache;
		const receiptsProcessed = dataCache.ReceiptHistory || [];
		if (receiptsProcessed.includes(purchaseId)) {
			// As the purchaseId is already stored in our session data, and reflected in the Datastore, we know the purchase has
			// been handled in this or a previous session. It's important we return PurchaseGranted here to capture cases where the
			// purchase has finished processing, but ProcessReceipt failed to be recorded in the backend service.
			return Enum.ProductPurchaseDecision.PurchaseGranted;
		}

		// If no product callback has been set, we are unable to process this purchase
		const productCallback = ReceiptProcessor._productCallbacks.get(productId);
		if (!productCallback) {
			warn(`Product ${productId} has no callback set`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		// The purchase is processed in the user's session data inside the product callback
		const [productSuccess, productResult] = pcall(productCallback, player, productId);

		// If the product callback errored, we are unable to process the purchase
		if (!productSuccess) {
			warn(`Error when calling product callback: ${productResult}`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		// We need to store the receiptId in the player data history so we do not award this purchase twice
		person.dataCache((currentDataCache) => {
			const cache = currentDataCache as PlayerDataCache;
			const receiptHistory = cache.ReceiptHistory || [];
			if (!receiptHistory.includes(purchaseId)) {
				receiptHistory.push(purchaseId);
			}

			// Trim the receipt history to the maximum length
			while (receiptHistory.size() > MAX_RECEIPT_HISTORY) {
				receiptHistory.shift(); // remove the oldest receipt
			}

			cache.ReceiptHistory = receiptHistory;
			return cache;
		});

		// Yields until the person's session data has been updated to reflect the purchase
		await Data.waitForPersonSessionEndedAsync(player);

		// We now know the purchase has been correctly handled in the current session, and the changes
		// have been saved to the DataStore so we are free to mark this purchase as finalized
		return Enum.ProductPurchaseDecision.PurchaseGranted;
	},
};

//[=[
//   This function is used for initialization. It should be called before `start()` to set up the provider.
//
//   ```ts
//   init();
//   ```
//]=]
function init(): void {
	MarketplaceService.ProcessReceipt = async (receiptInfo: ReceiptInfo): Promise<Enum.ProductPurchaseDecision> => {
		const playerId = receiptInfo.PlayerId;
		const productId = receiptInfo.ProductId;
		const purchaseId = receiptInfo.PurchaseId;

		const result = await ReceiptProcessor._processReceiptAsync(playerId, productId, purchaseId);

		return result;
	};
}

export default {
	version: version,

	// Functions
	init: init,
	registerProductCallback: ReceiptProcessor.registerProductCallback, // Expose for use by other modules
};
