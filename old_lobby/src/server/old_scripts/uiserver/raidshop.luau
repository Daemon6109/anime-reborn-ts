local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local shopCurrencies = require(ReplicatedStorage.Registry.RaidShopCurrencies)
local RaidShopFolder = ReplicatedStorage.Registry.RaidShopItems

local ItemRegistry = _G.Registry.registry.Items

local RaidShopItems = {}
for _, shopFolder in RaidShopFolder:GetChildren() do
	RaidShopItems[shopFolder.Name] = {}
	for _, itemModule in shopFolder:GetChildren() do
		if itemModule:IsA("ModuleScript") then
			RaidShopItems[shopFolder.Name][itemModule.Name] = require(itemModule)
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

local RaidShop = {
	BuyItem = function(player, shop, item)
		if
			not RaidShopItems[shop]
			or not RaidShopItems[shop][item]
			or not shopCurrencies[shop]
			or not ItemRegistry[item]
		then
			return
		end
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local RaidShopBought = PlayerProfile:GetField("RaidShopData").Bought
		local ItemRegistryData = ItemRegistry[item]
		local ItemData = RaidShopItems[shop][item]
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
			local BoughtAmount = RaidShopBought[`{shop}-{item}`] or 0

			if (BoughtAmount + 1) > ItemData.Quantity then
				return
			end

			PlayerProfile:WriteDirectory(`RaidShopData/Bought/{shop}-{item}`, BoughtAmount + 1, true)
		end

		_G.serverServices.ItemManager:GiveItems(player, {
			[Currency] = -ItemData.Price,
			[item] = 1,
		})
		--[[local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local RaidShopBought = PlayerProfile:GetField("RaidShopData").Bought
		local ItemData = RaidShopItems[item]

		if not ItemData then return end
		if not _G.serverServices.ItemManager:HasItem(player, "GrimoirePages", ItemData.Price) then return end

		if ItemData.Quantity then
			local BoughtAmount = RaidShopBought[item] or 0

			if (BoughtAmount + 1) > ItemData.Quantity then return end

			PlayerProfile:WriteDirectory(`RaidShopData/Bought/{item}`, BoughtAmount + 1, true)
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
		local RaidShopResetUnix = GetResetTime()
		if _PatchData.RaidShopResetUnix ~= RaidShopResetUnix then
			warn("Resetting Raid Shop")
			local _RaidShopBoughtData = PlayerProfile:GetField("RaidShopData")
			if _RaidShopBoughtData then
				_RaidShopBoughtData = _RaidShopBoughtData.Bought
				if _RaidShopBoughtData then
					for ItemName in _RaidShopBoughtData do
						PlayerProfile:WriteDirectory(`RaidShopData/Bought/{ItemName}`, nil, true)
					end
				end
			end
			PlayerProfile:WriteDirectory("PatchData/RaidShopResetUnix", RaidShopResetUnix, true)
			DataAPI:SaveProfile()
		else
			warn("Keeping Raid Shop")
		end
	end,
}

return RaidShop
