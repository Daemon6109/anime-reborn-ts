local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local GiftInboxDataStore = DataStoreService:GetDataStore(ServerScripts.GiftInboxDatastoreName.Value)

local MonetizationHandler = require(ServerScripts.Services.MonetizationHandler)

local UiCommunication = ReplicatedStorage.Events.UiCommunication
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer

local GiftInbox = {
	ClaimGift = function(player: Player, Identifier: string)
		if player:GetAttribute("ClaimGiftCooldown") then
			return
		end -- Avoid too many requests

		player:SetAttribute("ClaimGiftCooldown", true)

		local RetryDelay = 2

		for i = 1, 10 do
			if not player.Parent then
				return
			end

			RetryDelay *= 2

			local Loaded, GiftInbox = pcall(function()
				return GiftInboxDataStore:GetAsync("Player_" .. player.UserId)
			end)

			if Loaded and player.Parent then
				for _, gift in GiftInbox do
					if gift.UUID == Identifier then
						local SaveData = {}

						for _, _gift in GiftInbox do
							if _gift.UUID ~= Identifier then
								table.insert(SaveData, _gift)
							end
						end

						local Saved = pcall(function()
							GiftInboxDataStore:SetAsync("Player_" .. player.UserId, SaveData)
						end)

						if Saved and MonetizationHandler:GiveProduct(player, gift.ProductId, true) then
							NotifyPlayer:FireClient(player, {
								text = "Gift Claimed!",
								color = "Success",
							})

							UiCommunication:FireClient(player, "GiftInbox/DestroyGift", Identifier)
						else
							NotifyPlayer:FireClient(player, {
								text = "An error occured!",
								color = "Error",
							})
						end

						break
					end
				end

				break
			end

			warn(`Failed to get Gift Inbox. Retrying. Error: {GiftInbox}`)
			task.wait(RetryDelay)
		end

		task.delay(1.5, function()
			if player.Parent then
				player:SetAttribute("ClaimGiftCooldown", nil)
			end
		end)
	end,
}

return GiftInbox
