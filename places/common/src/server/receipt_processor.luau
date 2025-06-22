--------------------------------------------------------------------------------
-- receipt_processor
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Data = require("@commonserver/data")
local Person = require("@commonserver/person")

local data_constants = require("@commonserver/data/data_constants")

local waitForFirstAsync = require("@commonutils/waitForFirstAsync")

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local MAX_RECEIPT_HISTORY = data_constants.MAX_RECEIPT_HISTORY -- The maximum number of receipts to store in the player data

--[=[
   This module handles the receipt processing for in-game purchases and developer products.

   @class ReceiptProcessor
]=]
local ReceiptProcessor = {}
ReceiptProcessor._productCallbacks = {} :: { [number]: ProductCallback }

--[=[
   Registers a callback for a developer product. The callback will be invoked when the product is purchased.

   @within ReceiptProcessor

   @param developerProductId number -- The ID of the developer product
   @param productCallback ProductCallback -- The callback function to invoke when the product is purchased

   ```lua
   ReceiptProcessor.registerProductCallback(developerProductId, productCallback)
   ```
]=]
function ReceiptProcessor.registerProductCallback(developerProductId: number, productCallback: ProductCallback): ()
	assert(
		not ReceiptProcessor._productCallbacks[developerProductId],
		string.format("Developer product %d already has a callback assigned", developerProductId)
	)
	ReceiptProcessor._productCallbacks[developerProductId] = productCallback
end

--[=[
   Processes a receipt for a player. This function is called by the Roblox platform when a player purchases a product.

   @within ReceiptProcessor

   @param playerId number -- The ID of the player who made the purchase
   @param productId number -- The ID of the product that was purchased
   @param purchaseId string -- The unique ID of the purchase

   @return Enum.ProductPurchaseDecision -- The decision on how to handle the purchase

   ```lua
   local decision = ReceiptProcessor._processReceiptAsync(playerId, productId, purchaseId)
   if decision == Enum.ProductPurchaseDecision.PurchaseGranted then
   -- The purchase was successfully processed
   elseif decision == Enum.ProductPurchaseDecision.NotProcessedYet then
   -- The purchase is still being processed or could not be processed
   -- Handle this case as needed
   end
   ```
]=]
function ReceiptProcessor._processReceiptAsync(
	playerId: number,
	productId: number,
	purchaseId: string
): Enum.ProductPurchaseDecision
	-- We do not want to save player data if the player is not currently in the server
	local player = Players:GetPlayerByUserId(playerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Because ProcessReceipt can be invoked when the player joins the server, we want to make sure that we've
	-- given the player's data time to load before continuing
	if Person.isLoading(player) then
		-- Here, we are waiting for the player's data to load OR for the player to leave the server (whichever happens first)
		-- We are including the player leaving the server here as if we instead yielded indefinitely when the player left the server
		-- prior to their data load, ProcessReceipt would be blocked from being invoked again on this server for this purchase
		-- even if the player rejoined.
		waitForFirstAsync(function(): ...any
			Person.waitForPersonLoadAsync(player)
		end, function()
			-- TODO: Replace with player.Destroying:Wait() when that fires on player leave
			local _, playerParent
			repeat
				_, playerParent = player.AncestryChanged:Wait()
			until playerParent == nil
		end)
	end

	-- We do not want to save player data if it is currently loading, has errored or saving is otherwise disabled
	-- This check will also capture if the player has left without their data loading
	local person = Person.getForPlayer(player):Await()
	if not person or not person.dataCache() then
		warn("Player data not loaded for player " .. player.Name)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Because the PlayerData system uses session locking, we can guarantee that the player data in memory
	-- on the server by PlayerDataServer is the most up to date version available. Therefore, we do not
	-- need to check to see if a more recent Data Store value exists where the receipt is handled.
	local receiptsProcessed = person.dataCache().ReceiptHistory or {}
	if table.find(receiptsProcessed, purchaseId) then
		-- As the purchaseId is already stored in our session data, and reflected in the Datastore, we know the purchase has
		-- been handled in this or a previous session. It's important we return PurchaseGranted here to capture cases where the
		-- purchase has finished processing, but ProcessReceipt failed to be recorded in the backend service.
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	-- If no product callback has been set, we are unable to process this purchase
	local productCallback = ReceiptProcessor._productCallbacks[productId]
	if not productCallback then
		warn(string.format("Product %d has no callback set", productId))
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- The purchase is processed in the user's session data inside the product callback
	local productSuccess, productResult = pcall(productCallback, player, productId)

	-- If the product callback errored, we are unable to process the purchase
	if not productSuccess then
		warn("Error when calling product callback: " .. tostring(productResult))
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- We need to store the receiptId in the player data history so we do not award this purchase twice
	person.dataCache(function(dataCache)
		local receiptHistory = dataCache.ReceiptHistory
		if not table.find(receiptHistory, purchaseId) then
			table.insert(receiptHistory, purchaseId)
		end

		-- Trim the receipt history to the maximum length
		while #receiptHistory > MAX_RECEIPT_HISTORY do
			table.remove(receiptHistory, 1) -- remove the oldest receipt
		end

		dataCache.ReceiptHistory = receiptHistory
		return dataCache
	end)

	-- Yields until the person's session data has been updated to reflect the purchase
	Data.waitForPersonSessionEndedAsync(player)

	-- We now know the purchase has been correctly handled in the current session, and the changes
	-- have been saved to the DataStore so we are free to mark this purchase as finalized
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

--[=[
   This function is used for initialization. It should be called before `start()` to set up the provider.

   ```lua
   receipt_processor.init()
   ```
]=]
local function init(): ()
	MarketplaceService.ProcessReceipt = function(receiptInfo: ReceiptInfo): Enum.ProductPurchaseDecision
		local playerId = receiptInfo.PlayerId
		local productId = receiptInfo.ProductId
		local purchaseId = receiptInfo.PurchaseId

		local result = ReceiptProcessor._processReceiptAsync(playerId, productId, purchaseId)

		return result
	end
end

return {
	version = version,

	-- Functions
	init = init,
}
