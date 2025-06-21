--------------------------------------------------------------------------------
-- monetization_handler
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Person = require("@commonserver/person")
local Products = require("@registry/Products")
local WebhookLib = require("@commonutils/WebhookLib")
local createReceiptHistoryData = require("@data/factories/receipthistorydata")

export type ProductData = {
	Id: number,
	Name: string,
	Price: number,
	Rewards: { [string]: any },
	Type: string,
}

export type ReceiptInfo = {
	PlayerId: number,
	PlaceIdWherePurchased: number,
	ProductId: number,
	PurchaseId: string,
	CurrencySpent: number,
	CurrencyType: Enum.CurrencyType,
}

export type StoredGiftData = {
	Recipient: string,
	Gift: string,
	Amount: number,
}

--[=[
   Handler for monetization events including developer products, gamepasses, and gifts.
   
   @class MonetizationHandler
]=]
local MonetizationHandler = {
	version = version,
	products = Products,
	storedGiftData = {} :: { [Player]: StoredGiftData },
}

-- Place whitelist for different datastores
local PLACE_DATASTORE_WHITELIST = {
	["5844593548"] = "MainDatastore",
	["6717025335"] = "TestDatastore",
}

-- Network events
local NotifyPlayerRemote: RemoteEvent?
local UiCommunicationRemote: RemoteEvent?

-- Initialize network events based on place type
if ReplicatedStorage:FindFirstChild("Events") then
	NotifyPlayerRemote = ReplicatedStorage.Events:FindFirstChild("NotifyPlayer_2")
	UiCommunicationRemote = ReplicatedStorage.Events:FindFirstChild("UiCommunication")
end

--[=[
   Gets the appropriate datastore name for the current place
   
   @within MonetizationHandler
   
   @return string? -- The datastore name or nil if not whitelisted
   
   @private
]=]
local function getDatastoreName(): string?
	return PLACE_DATASTORE_WHITELIST[tostring(game.GameId)]
end

--[=[
   Processes a developer product purchase
   
   @within MonetizationHandler
   
   @param receiptInfo ReceiptInfo -- The purchase receipt information
   
   @return Enum.ProductPurchaseDecision -- The purchase decision
]=]
function MonetizationHandler.processProductPurchase(receiptInfo: ReceiptInfo): Enum.ProductPurchaseDecision
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		-- Player left before purchase could be processed
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local person = Person.getForPlayer(player)
	if not person then
		warn(`Person not found for player {player.Name} during purchase processing`)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local productInfo = Products[receiptInfo.ProductId]
	if not productInfo then
		warn(`Unknown product ID: {receiptInfo.ProductId}`)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Check if this purchase was already processed
	if MonetizationHandler.isPurchaseProcessed(person, receiptInfo.PurchaseId) then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	-- Process the purchase
	local success = MonetizationHandler.grantProductRewards(person, productInfo)

	if success then
		-- Record the purchase
		MonetizationHandler.recordPurchase(person, receiptInfo)

		-- Send webhook notification
		MonetizationHandler.sendPurchaseWebhook(player, productInfo, receiptInfo)

		-- Notify player
		if NotifyPlayerRemote then
			NotifyPlayerRemote:FireClient(player, {
				Type = "PurchaseSuccess",
				Product = productInfo.Name,
			})
		end

		return Enum.ProductPurchaseDecision.PurchaseGranted
	else
		warn(`Failed to grant rewards for product {productInfo.Name} to player {player.Name}`)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end

--[=[
   Grants rewards for a purchased product
   
   @within MonetizationHandler
   
   @param person Person -- The person to grant rewards to
   @param productInfo ProductData -- The product information
   
   @return boolean -- Whether the rewards were successfully granted
   
   @private
]=]
function MonetizationHandler.grantProductRewards(person: Person.Person, productInfo: ProductData): boolean
	local dataCache = person.dataCache()
	local newCache = table.clone(dataCache)

	-- Process rewards based on product type
	for rewardType, amount in pairs(productInfo.Rewards) do
		if rewardType == "Currencies" then
			for currencyType, currencyAmount in pairs(amount) do
				if newCache.Currencies[currencyType] then
					newCache.Currencies[currencyType] = newCache.Currencies[currencyType] + currencyAmount
				end
			end
		elseif rewardType == "XP" then
			newCache.XP = newCache.XP + amount
		elseif rewardType == "Level" then
			newCache.Level = newCache.Level + amount
		elseif rewardType == "Items" then
			-- Handle item rewards
			for itemId, itemAmount in pairs(amount) do
				if not newCache.Inventory.Items[itemId] then
					newCache.Inventory.Items[itemId] = 0
				end
				newCache.Inventory.Items[itemId] = newCache.Inventory.Items[itemId] + itemAmount
			end
		end
	end

	-- Update robux spent tracking
	newCache.RobuxSpent = newCache.RobuxSpent + productInfo.Price

	-- Apply the changes
	person.dataCache(newCache)

	return true
end

--[=[
   Checks if a purchase has already been processed
   
   @within MonetizationHandler
   
   @param person Person -- The person to check
   @param purchaseId string -- The purchase ID to check
   
   @return boolean -- Whether the purchase was already processed
   
   @private
]=]
function MonetizationHandler.isPurchaseProcessed(person: Person.Person, purchaseId: string): boolean
	local dataCache = person.dataCache()
	local receiptHistory = dataCache.ReceiptHistory

	return receiptHistory[purchaseId] ~= nil
end

--[=[
   Records a purchase in the player's receipt history
   
   @within MonetizationHandler
   
   @param person Person -- The person to record for
   @param receiptInfo ReceiptInfo -- The receipt information
   
   @private
]=]
function MonetizationHandler.recordPurchase(person: Person.Person, receiptInfo: ReceiptInfo): ()
	local dataCache = person.dataCache()
	local newCache = table.clone(dataCache)

	newCache.ReceiptHistory[receiptInfo.PurchaseId] = {
		ProductId = receiptInfo.ProductId,
		PlayerId = receiptInfo.PlayerId,
		PurchaseId = receiptInfo.PurchaseId,
		CurrencySpent = receiptInfo.CurrencySpent,
		Timestamp = os.time(),
	}

	person.dataCache(newCache)
end

--[=[
   Sends a webhook notification for a purchase
   
   @within MonetizationHandler
   
   @param player Player -- The player who made the purchase
   @param productInfo ProductData -- The product information
   @param receiptInfo ReceiptInfo -- The receipt information
   
   @private
]=]
function MonetizationHandler.sendPurchaseWebhook(player: Player, productInfo: ProductData, receiptInfo: ReceiptInfo): ()
	local success, result = pcall(function()
		local webhookData = {
			content = "",
			embeds = {
				{
					title = "💰 Product Purchase",
					description = `{player.Name} purchased {productInfo.Name}`,
					color = 0x00ff00,
					fields = {
						{
							name = "Player",
							value = `{player.Name} ({player.UserId})`,
							inline = true,
						},
						{
							name = "Product",
							value = `{productInfo.Name} (ID: {productInfo.Id})`,
							inline = true,
						},
						{
							name = "Price",
							value = `{productInfo.Price} Robux`,
							inline = true,
						},
						{
							name = "Purchase ID",
							value = receiptInfo.PurchaseId,
							inline = false,
						},
					},
					timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z"),
				},
			},
		}

		WebhookLib.send(webhookData)
	end)

	if not success then
		warn(`Failed to send purchase webhook: {result}`)
	end
end

--[=[
   Handles gamepass ownership checks and rewards
   
   @within MonetizationHandler
   
   @param person Person -- The person to check
   @param gamepassId number -- The gamepass ID to check
   
   @return boolean -- Whether the player owns the gamepass
]=]
function MonetizationHandler.handleGamepass(person: Person.Person, gamepassId: number): boolean
	local player = person.player
	local success, ownsGamepass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId)
	end)

	if success and ownsGamepass then
		-- Apply gamepass benefits
		-- This would be specific to each gamepass
		return true
	end

	return false
end

--[=[
   Stores gift data for a player
   
   @within MonetizationHandler
   
   @param player Player -- The player to store gift data for
   @param giftData StoredGiftData -- The gift data to store
]=]
function MonetizationHandler.storeGiftData(player: Player, giftData: StoredGiftData): ()
	MonetizationHandler.storedGiftData[player] = giftData
end

--[=[
   Retrieves stored gift data for a player
   
   @within MonetizationHandler
   
   @param player Player -- The player to get gift data for
   
   @return StoredGiftData? -- The stored gift data or nil
]=]
function MonetizationHandler.getStoredGiftData(player: Player): StoredGiftData?
	return MonetizationHandler.storedGiftData[player]
end

--[=[
   Initializes the MonetizationHandler
   
   @within MonetizationHandler
]=]
function MonetizationHandler.start(): ()
	-- Set up marketplace service callbacks
	MarketplaceService.ProcessReceipt = MonetizationHandler.processProductPurchase

	print("MonetizationHandler started")
end

return MonetizationHandler
