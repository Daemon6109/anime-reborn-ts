--// By @ThatOneTusk & @Nahid

local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local EventShopItems = _G.Registry.registry.EventShopItems

local DataAPI = DataAccess:GetAPI()

local EventShop = {
	BuyItem = function(player, data)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		local Item = data.Item
		local Amount = data.Amount

		if not EventShopItems[Item] then
			return
		end
		if Amount ~= Amount or not tonumber(Amount) then
			return
		end

		local ItemData = EventShopItems[Item]

		Amount = math.floor(math.abs(Amount))
		Amount = math.clamp(Amount, 1, math.huge)

		local Price = Amount * ItemData.Price
		local Quantity = ItemData.Quantity

		local EventShopData = PlayerProfile:GetField("EventShopData")

		if Quantity and EventShopData then
			local BoughtQuantity = EventShopData.Bought[Item] or 0

			if BoughtQuantity + Amount > Quantity then
				game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
					player,
					"Error",
					`This item has {Quantity - BoughtQuantity} stock left!`
				)
				return
			else
				PlayerProfile:WriteDirectory(`EventShopData/Bought/{Item}`, BoughtQuantity + Amount, true)
			end
		end

		if PlayerProfile:GetField("Currencies")["Candy Cane"] >= Price then
			PlayerProfile:WriteDirectory(
				"Currencies/Candy Cane",
				PlayerProfile:GetField("Currencies")["Candy Cane"] - Price,
				true
			)
			print(Item)
			_G.serverServices.ItemManager:GiveItems(player, { [Item] = Amount })
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
				player,
				"Success",
				`You bought x{tonumber(Amount)} {Item}!`
			)
		end
	end,
}

return EventShop
