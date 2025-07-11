local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local shopCurrencies = require(ReplicatedStorage.Registry.DungeonShopCurrencies)
local DungeonShopFolder = ReplicatedStorage.Registry.DungeonShopItems

local ItemRegistry = _G.Registry.registry.Items

local DungeonShopItems = {}
for _, shopFolder in DungeonShopFolder:GetChildren() do
	DungeonShopItems[shopFolder.Name] = {}
	for _, itemModule in shopFolder:GetChildren() do
		if itemModule:IsA("ModuleScript") then
			DungeonShopItems[shopFolder.Name][itemModule.Name] = require(itemModule)
		end
	end
end

local DataAPI = DataAccess:GetAPI()

function GetResetTime()
	local now = os.time()
	local currentDate = os.date("!*t", now)
	local daysToSunday = (7 - currentDate.wday) % 7
	local targetHour = 18

	currentDate.day = currentDate.day + daysToSunday
	currentDate.hour = targetHour
	currentDate.min = 0
	currentDate.sec = 0

	local targetTime = os.time(currentDate)

	if targetTime <= now then
		currentDate.day = currentDate.day + 7
		targetTime = os.time(currentDate)
	end

	return targetTime
end

local DungeonShop = {
	BuyItem = function(player, shop, item)
		if
			not DungeonShopItems[shop]
			or not DungeonShopItems[shop][item]
			or not shopCurrencies[shop]
			or not ItemRegistry[item]
		then
			return
		end
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local DungeonShopBought = PlayerProfile:GetField("DungeonShopData").Bought
		local ItemRegistryData = ItemRegistry[item]
		local ItemData = DungeonShopItems[shop][item]
		local Currency = shopCurrencies[shop]

		if not _G.serverServices.ItemManager:HasItem(player, Currency, ItemData.Price) then
			return
		end
		if
			_G.serverServices.ItemManager:HasItem(
				player,
				item,
				ItemRegistryData.Limit == "inf" and math.huge or (ItemRegistryData.Limit or 100)
			)
		then
			return
		end

		if ItemData.Quantity then
			local BoughtAmount = DungeonShopBought[`{shop}-{item}`] or 0

			if (BoughtAmount + 1) > ItemData.Quantity then
				return
			end

			PlayerProfile:WriteDirectory(`DungeonShopData/Bought/{shop}-{item}`, BoughtAmount + 1, true)
		end

		_G.serverServices.ItemManager:GiveItems(player, {
			[Currency] = -ItemData.Price,
			[item] = 1,
		})
		--[[local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local DungeonShopBought = PlayerProfile:GetField("DungeonShopData").Bought
		local ItemData = DungeonShopItems[item]

		if not ItemData then return end
		if not _G.serverServices.ItemManager:HasItem(player, "GrimoirePages", ItemData.Price) then return end

		if ItemData.Quantity then
			local BoughtAmount = DungeonShopBought[item] or 0

			if (BoughtAmount + 1) > ItemData.Quantity then return end

			PlayerProfile:WriteDirectory(`DungeonShopData/Bought/{item}`, BoughtAmount + 1, true)
		end

		_G.serverServices.ItemManager:GiveItems(player, {
			["GrimoirePages"] = -ItemData.Price;
			[item] = 1;
		})]]
	end,
	ResetQuantity = function(player)
		warn("Attempting to reset")
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local _PatchData = PlayerProfile:GetField("PatchData")
		local DungeonShopResetUnix = GetResetTime()
		if _PatchData.DungeonShopResetUnix ~= DungeonShopResetUnix then
			warn("Resetting Dungeon Shop")
			local _DungeonShopBoughtData = PlayerProfile:GetField("DungeonShopData")
			if _DungeonShopBoughtData then
				_DungeonShopBoughtData = _DungeonShopBoughtData.Bought
				if _DungeonShopBoughtData then
					for ItemName in _DungeonShopBoughtData do
						PlayerProfile:WriteDirectory(`DungeonShopData/Bought/{ItemName}`, nil, true)
					end
				end
			end
			PlayerProfile:WriteDirectory("PatchData/DungeonShopResetUnix", DungeonShopResetUnix, true)
			DataAPI:SaveProfile()
		else
			warn("Keeping Dungeon Shop")
		end
	end,
}

return DungeonShop
