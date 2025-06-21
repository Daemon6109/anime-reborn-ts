--// By @ThatOneTusk & @Nahid

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local PlaceWhitelist = require(ServerScripts.ServerLibs.PlaceWhitelist)
local ProfileService = require(ServerScripts.ServerLibs.ProfileStore)
local ProfileTemplate = require(ServerScripts.ServerLibs.ProfileTemplate)
local WebhookLib = require(ServerScripts.ServerLibs.WebhookLib)

local DataAPI = DataAccess:GetAPI()

local PlaceDatastoreWhitelist = {
	["5844593548"] = ServerScripts.DatastoreName,
	["6717025335"] = ServerScripts.TestPlaceDatastoreName,
}

local dataStoreName = PlaceDatastoreWhitelist[tostring(game.GameId)]

local GiftInboxDataStore = DataStoreService:GetDataStore(ServerScripts.GiftInboxDatastoreName.Value)
local ProfileStore = ProfileService.New(dataStoreName.Value, ProfileTemplate)

local NotifyPlayer
local UiCommunication

if table.find(PlaceWhitelist.LobbyPlaces, game.PlaceId) then
	NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer_2
	UiCommunication = ReplicatedStorage.Events.UiCommunication
end

local MonetizationHandler = {}
MonetizationHandler.Products = require(ReplicatedStorage.Registry.Products)
MonetizationHandler.StoredGiftData = {} :: { [Player]: StoredGiftDataType }

local Products = MonetizationHandler.Products
local StoredGiftData = MonetizationHandler.StoredGiftData
local GameName

pcall(function()
	GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

--local GamepassProduct= {
--	[887686872] = 0, -- vip
--	[931598388] = 0,
--	[931258600] = 0,
--	[931436143] = 0,
--}

export type StoredGiftDataType = {
	GiftedPlayerId: number, -- User Id
	ProductId: number,
}

local Hook =
	"https://webhook.newstargeted.com/api/webhooks/1304856701471821854/v5cuIkAvyBl0KPtoTNdksdljiiMBqhJduMVfBFbIekn4H9pjfS5vRnZMzpR7WEgVGjLK"

--//
function MonetizationHandler:IsProductBoughtOut(player: Player, ProductId: number): boolean?
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	local BuyLimit = Products[tonumber(ProductId)].BuyLimit
	local ProductsBought = PlayerProfile:GetField("ProductsBought")
	local IsBought = ProductsBought[tostring(ProductId)]

	if not BuyLimit or not IsBought then
		return false
	end

	return IsBought >= BuyLimit
end

--//
function MonetizationHandler:StoreProduct(player: Player, ProductId: number | string)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	local ProductsBought = PlayerProfile:GetField("ProductsBought")
	local StoredProduct = ProductsBought[tostring(ProductId)]

	ProductsBought[tostring(ProductId)] = StoredProduct and StoredProduct + 1 or 1

	local FoundProduct = Products[tonumber(ProductId)]
	if FoundProduct then
		warn("found product in registry")
		if FoundProduct.AlsoAward then
			warn("adding gifting id aswell to datastore")
			local AlsoStoredProduct = ProductsBought[tostring(FoundProduct.AlsoAward)]
			ProductsBought[tostring(FoundProduct.AlsoAward)] = AlsoStoredProduct and AlsoStoredProduct + 1 or 1
		end
	end

	PlayerProfile:WriteField("ProductsBought", ProductsBought, true)
end

--// Returns whether the given player can be gifted the given product, also returns a message of what failed to notify the player
function MonetizationHandler:CanPlayerBeGifted(UserId: string, ProductId: number | string): (boolean, string?)
	local player = PlayerService:GetPlayerByUserId(UserId)
	local FoundProduct = Products[tonumber(ProductId)]
	local Data

	if not FoundProduct then
		return false, "Product doesn't exist!"
	end

	if not FoundProduct.Giftable then
		return false, "Product cannot be gifted!"
	end

	if not player then
		local success, profile = pcall(function()
			return ProfileStore:GetAsync("Player_" .. UserId)
		end)

		if success then
			if not profile then
				return false, "This player hasn't played the game!"
			end

			Data = profile.Data
		else
			warn(`Error occured while reading data for User Id {UserId}. Error: {profile}`)
			return false, "Internal error occured!"
		end
	else
		Data = DataAPI:GetActivePlayerProfileClass(player)

		if not Data then
			return false, "This player is still loading!"
		end
	end

	local success, GiftInbox = pcall(function()
		return GiftInboxDataStore:GetAsync("Player_" .. UserId)
	end)

	if not (success and GiftInbox) then
		return false, "Internal error occured!"
	end

	if FoundProduct.BuyLimit and not FoundProduct.ItemName then
		local TotalFound = 0
		local ProductsBought = player and Data:GetField("ProductsBought") or Data.ProductsBought

		for _, gift in GiftInbox do
			if tonumber(gift.ProductId) == tonumber(ProductId) then
				TotalFound += 1
			end
		end

		if ProductsBought[tostring(ProductId)] then
			TotalFound += ProductsBought[tostring(ProductId)]
		end

		if TotalFound >= FoundProduct.BuyLimit then
			return false, "This player already has the maximum amount of this product!"
		end
	end

	return true
end

--// Attempts to gift the player a product
-- player: The player gifting
function MonetizationHandler:AttemptGiftPlayer(player: Player, GiftedPlayerId: number, ProductId: number)
	assert(player.UserId ~= GiftedPlayerId, "Player and GiftedPlayer are the same")

	ProductId = tonumber(ProductId)

	local success, message = MonetizationHandler:CanPlayerBeGifted(GiftedPlayerId, ProductId)

	if not success then
		if NotifyPlayer then
			NotifyPlayer:FireClient(player, "Error", message)
		end

		return
	end

	StoredGiftData[player] = {
		GiftedPlayerId = GiftedPlayerId,
		ProductId = ProductId,
	}

	MarketplaceService:PromptProductPurchase(player, ProductId)
	return true
end

--// Gives the player what they purchased, returning whether it errored or not
-- Called only when the player claims a gift or buys a product
function MonetizationHandler:GiveProduct(player: Player, ProductId: number, Bought): (boolean, string?)
	ProductId = tonumber(ProductId)

	local FoundProduct = Products[ProductId]
	--warn('finding product',player.Name)

	if not FoundProduct then
		--warn(`Product {ProductId} doesn't exist!`)
		return
	end

	local success, err = pcall(function()
		if FoundProduct then
			--warn('found product',player.Name)

			if Bought and FoundProduct.ItemName then
				warn("Has Item Name")
				self.RewardLibrary = self.RewardLibrary or require(game.ReplicatedStorage.Libs.RewardLibrary)
				self.RewardLibrary:RewardPlayer(player, {
					Items = {
						[FoundProduct.ItemName] = 1,
					},
				})
			else
				if FoundProduct.BuyLimit then
					--warn('attempt to give',player.Name)
					if MonetizationHandler:IsProductBoughtOut(player, ProductId) then
						warn("returning already bought out", player.Name)
						return
					end
					--warn('Storing in',player.Name)

					MonetizationHandler:StoreProduct(player, ProductId)
				end

				if FoundProduct.Callback then
					--warn('calling',player.Name)
					FoundProduct.Callback(player)
				end

				if FoundProduct.RunOnceCallback then
					FoundProduct.RunOnceCallback(player)
				end
			end

			local SaveResult = DataAPI:SaveProfile(player)

			warn("Product has been succesffully given", ProductId)
		end
	end)

	if not success then
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local FailedPurchases = PlayerProfile:GetField("FailedPurchases")

		table.insert(FailedPurchases, {
			Time = os.time(),
			Product = ProductId,
			Error = err,
		})

		PlayerProfile:WriteField("FailedPurchases", FailedPurchases)

		warn(`Product {ProductId} bought by {player} has errored. Error: {err}`)
	end

	return success, err
end

--warn(Products)
--//
function MonetizationHandler:PlayerLoaded(player)
	if player:GetAttribute("MonetizationHandlerDeployed") then
		return
	end
	player:SetAttribute("MonetizationHandlerDeployed", true)
	--warn('Cycling through gamepasses')
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local ProductsBought = PlayerProfile:GetField("ProductsBought")

	for Id, Data in Products do
		if not tonumber(Id) or typeof(Data) ~= "table" then
			continue
		end
		if Data.Type == "Gamepass" then
			local StoredProduct = ProductsBought[tostring(Id)]
			if StoredProduct then
				continue
			end

			local Success, Owned = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, tonumber(Id))
			end)

			if not Success or not Owned then
				continue
			end
			MonetizationHandler:GiveProduct(player, tonumber(Id), true)
		end
	end
	--warn('Cycle success')
end

--//
function MonetizationHandler:start()
	PlayerService.PlayerRemoving:Connect(function(player)
		StoredGiftData[player] = nil
	end)
	PlayerService.PlayerAdded:Connect(function(player)
		--warn('Player added Player added')
		local success, _err = pcall(MonetizationHandler.PlayerLoaded, MonetizationHandler, player)
		if not success then
			warn(_err)
		end
		--MonetizationHandler:PlayerLoaded(player)
	end)
	for _, player in PlayerService:GetPlayers() do
		--warn('Player added Player added')
		local success, _err = pcall(MonetizationHandler.PlayerLoaded, MonetizationHandler, player)
		if not success then
			warn(_err)
		end
		--MonetizationHandler:PlayerLoaded(player)
	end

	MarketplaceService.PromptProductPurchaseFinished:Connect(function(PlayerId, ProductId, Bought: boolean)
		local player = PlayerService:GetPlayerByUserId(PlayerId)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		warn(Bought, ProductId)
		if Bought then -- ProcessReceipt will reset StoredGiftData
		else
			if StoredGiftData[player] and StoredGiftData[player].ProductId == ProductId then
				StoredGiftData[player] = nil
			end
		end
	end)

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, ProductId, Bought: boolean)
		if not Bought then
			return
		end

		if UiCommunication then
			UiCommunication:FireClient(player, "Shop/PurchaseSuccess")
		end

		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local given = MonetizationHandler:GiveProduct(player, ProductId, true)

		local success, _err = pcall(function()
			local ProductInfo = MarketplaceService:GetProductInfo(ProductId, Enum.InfoType.GamePass)

			PlayerProfile:WriteField(
				"RobuxSpent",
				PlayerProfile:GetField("RobuxSpent") + ProductInfo.PriceInRobux,
				true
			)
		end)

		if not success then
			warn(`Failed to add RobuxSpent for player {player} and product {ProductId}. Error: {_err}`)
		end
	end)

	MarketplaceService.ProcessReceipt = function(receiptInfo)
		local PlayerId = receiptInfo.PlayerId
		local ProductId = receiptInfo.ProductId
		local player = PlayerService:GetPlayerByUserId(PlayerId)

		ProductId = tonumber(ProductId)

		if player then
			local GiftData = StoredGiftData[player]

			if UiCommunication then
				UiCommunication:FireClient(player, "Shop/PurchaseSuccess")
			end

			task.spawn(function()
				local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

				local GivenRobux, RobuxError = pcall(function()
					local ProductInfoRequest = MarketplaceService:GetProductInfo(ProductId, Enum.InfoType.Product)

					PlayerProfile:WriteField(
						"RobuxSpent",
						PlayerProfile:GetField("RobuxSpent") + ProductInfoRequest.PriceInRobux,
						true
					)
				end)

				if not GivenRobux then
					warn(`Failed to add RobuxSpent for player {player} and product {ProductId}. Error: {RobuxError}`)
				end
			end)

			if GiftData and GiftData.ProductId == ProductId then --// Can process gifting
				StoredGiftData[player] = nil

				local CanBeGifted, message = MonetizationHandler:CanPlayerBeGifted(GiftData.GiftedPlayerId, ProductId)

				if not CanBeGifted then
					if NotifyPlayer then
						NotifyPlayer:FireClient(player, "Error", message)
					end
				else
					local GiftedPlayer = PlayerService:GetPlayerByUserId(GiftData.GiftedPlayerId)
					local Su, Er = pcall(
						MonetizationHandler.Chat,
						MonetizationHandler,
						player,
						GiftData.GiftedPlayerId,
						Products[ProductId].Name
					)
					if not Su then
						warn(Er)
					end

					if GiftedPlayer then --// Is in the server. No need for inbox
						-- Chat here

						local given = MonetizationHandler:GiveProduct(GiftedPlayer, ProductId, true)
						if given then
							if NotifyPlayer then
								NotifyPlayer:FireClient(
									GiftedPlayer,
									"Success",
									`{player} has gifted you {Products[ProductId].Name}!`
								)
							end

							return Enum.ProductPurchaseDecision.PurchaseGranted
						end
					else --// Isn't in the server, give it to them via inbox
						local RetryDelay = 2

						for i = 1, 10 do
							RetryDelay *= 2

							local success, err = pcall(function()
								local GiftInbox = GiftInboxDataStore:GetAsync("Player_" .. GiftData.GiftedPlayerId)
								local UUID = HttpService:GenerateGUID(false)

								for _, gift in GiftInbox do
									if gift.UUID == UUID then
										while gift.UUID == UUID do
											task.wait()
											UUID = HttpService:GenerateGUID(false)
										end
									end
								end

								table.insert(GiftInbox, {
									GiftedBy = player.UserId,
									ProductId = ProductId,
									UUID = UUID,
								})

								GiftInboxDataStore:SetAsync("Player_" .. GiftData.GiftedPlayerId, GiftInbox)
							end)

							if success then
								return Enum.ProductPurchaseDecision.PurchaseGranted
							end

							warn(
								`Attempting to give {GiftedPlayer} a gift in their inbox from {player} failed. Retrying.`
							)
							task.wait(RetryDelay)
						end
					end
				end
			else
				local given = MonetizationHandler:GiveProduct(player, ProductId, true)
				warn("given")
				if given then
					warn("granting")
					return Enum.ProductPurchaseDecision.PurchaseGranted
				end
			end
		end

		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end

local MessagingService = game:GetService("MessagingService")
local UserService = game:GetService("UserService")
local http = game:GetService("HttpService")

function MonetizationHandler:Chat(player, otherplayerId, name)
	local otherplayer = PlayerService:GetPlayerByUserId(otherplayerId)
	pcall(function()
		if not otherplayer then
			local otherplayerTable = UserService:GetUserInfosByUserIdsAsync({ otherplayerId })
			otherplayer = otherplayerTable[1]
			warn("otherplayer", otherplayer)
			otherplayer.Name = otherplayer.Username
		end
	end)

	local String =
		`{player.DisplayName} (@{player.Name}) has gifted a {name} to {otherplayer.DisplayName} (@{otherplayer.Name})`

	ReplicatedStorage.Events.Chat:FireAllClients(String)
end

return MonetizationHandler
