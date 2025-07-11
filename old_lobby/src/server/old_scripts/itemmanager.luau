local module = {}
module.ItemTemplate = {
	["Name"] = "",
	["Count"] = 0,
}
local registry = _G.Registry.registry
local itemRegistry = registry.Items
local potionRegistry = registry.Potions
local mapRegistry = registry.Maps
local challengeRegistry = registry.Challenges
local modifierRegistry = registry.ElementalModifiers
local http = game:GetService("HttpService")
local Events = game.ReplicatedStorage.Events
local GameFunctions = require(game.ReplicatedStorage.Libs.GameFunctions)
local visualEvent = game.ReplicatedStorage.Events.Visuals.ItemReceived
local itemUseEvent = game.ReplicatedStorage.Events.UseItem
local usableItemModules = {}
local bundleUsages = require(game.ReplicatedStorage.Registry.BundleUsages)
local notify = game.ReplicatedStorage.Events.NotifyPlayer_2

local AnalyticsService = game:GetService("AnalyticsService")
local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

for _, ItemModule in script:GetChildren() do
	if ItemModule:IsA("ModuleScript") then
		task.spawn(function()
			usableItemModules[ItemModule.Name] = require(ItemModule)
		end)
	end
end

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local function deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

function module:HasItem(plr, name, count)
	if not count then
		count = 1
	end
	if not _G.Registry.registry.Items[name] then
		return
	end
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)
	local inventory = PlayerProfileClass:GetField("Inventory").Items
	if _G.Registry.registry.Items[name].NotStackable then
		count = 1
	end
	for itemName, data in inventory do
		if data.Name == name then
			if data.Count >= count then
				return true
			end
		end
	end
	return false
end

function module:GetCount(plr, name)
	if not _G.Registry.registry.Items[name] then
		return
	end

	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)
	local inventory = PlayerProfileClass:GetField("Inventory").Items
	for name, data in inventory do
		if data.Name == name then
			return data.Count
		end
	end
	return 0
end

local function GetKeys(t)
	local newT = {}
	for key, _ in t do
		table.insert(newT, key)
	end
	return newT
end

local function GenerateRandomPortalData()
	--local AllMaps = GetKeys(mapRegistry)
	--if table.find(AllMaps,'Namek') then
	--	table.remove(AllMaps,table.find(AllMaps,'Namek'))
	--end

	local AllMaps = {}

	for i, v in pairs(registry.MapOrder.Info) do
		if i ~= "raw" then
			AllMaps[v] = i
		end
	end

	local AllChallenges = {}
	for i, v in pairs(_G.Registry.registry.Challenges) do
		if i ~= "Traits Disabled" then
			table.insert(AllChallenges, i)
		end
	end
	local AllModifiers = GetKeys(modifierRegistry)
	local Challenge = AllChallenges[math.random(1, #AllChallenges)]
	local Map = AllMaps[math.random(1, #AllMaps)]

	while not mapRegistry[Map].Root:FindFirstChild("Portal") do
		table.remove(AllMaps, table.find(AllMaps, Map))
		Map = AllMaps[math.random(1, #AllMaps)]
	end
	local AllActs = #mapRegistry[Map].Root:FindFirstChild("Portal"):GetChildren()

	local Act = math.random(1, AllActs)

	local Debuff = AllModifiers[math.random(1, #AllModifiers)]
	table.remove(AllModifiers, table.find(AllModifiers, Debuff))
	local Buff = AllModifiers[math.random(1, #AllModifiers)]

	return {
		Map = Map,
		Act = Act,
		Challenge = Challenge,
		Buff = Buff,
		Debuff = Debuff,
		ForcedElements = {
			[Buff] = {
				Min = 0,
				Max = 25,
			},
			[Debuff] = {
				Min = -50,
				Max = 0,
			},
		},
	}
end

--Count can be negative
function module:GiveItems(plr, tab, replicateInstantly: boolean?, visualsDisabled: boolean?, ExtraData: table?)
	if not replicateInstantly then
		replicateInstantly = true
	end
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)
	local Invetory = PlayerProfileClass:GetField("Inventory")
	local ItemsInventory = Invetory.Items
	tab = deepCopy(tab)
	for name, count in tab do
		if not count then
			count = 1
		end
		local _reg = itemRegistry[name]
		if not _reg and ItemsInventory[name] then
			_reg = itemRegistry[ItemsInventory[name].Name]
			if not _reg then
				continue
			end
		end

		_G.serverServices.QuestHandler:GivePointsByPointType(plr, `GetItem{name}`, count)
		if _reg.NotStackable then
			if count < 0 then
				local newC = 0
				for _id, data in ItemsInventory do
					if newC == math.abs(count) then
						break
					end
					if _id == name then
						PlayerProfileClass:WriteDirectory(`Inventory/Items/{_id}`, nil, replicateInstantly)
						newC += 1
						visualEvent:FireClient(plr, {
							[data.Name] = -1,
						})
					end
				end
			elseif count > 0 then
				local limit = _reg.Limit == "inf" and math.huge or (_reg.Limit or 100)
				local totalItems = 0
				for id, _data in ItemsInventory do
					if _data.Name == name then
						totalItems += 1
					end
				end
				if totalItems >= limit then
					return
				end
				for n = 1, count do
					local _ExtraData
					if ExtraData then
						_ExtraData = deepCopy(ExtraData)
					elseif _reg.GetCustomData then
						_ExtraData = _reg.GetCustomData()
					elseif table.find(_reg.configuration.Sort, "Portal") then
						_ExtraData = GenerateRandomPortalData()
					elseif table.find(_reg.configuration.Sort, "Relic") then
						_ExtraData = _G.serverServices.RelicsServer:GetNewRelicData(plr, name)
					end
					PlayerProfileClass:WriteDirectory(`Inventory/Items/{http:GenerateGUID(false)}`, {
						["Name"] = name,
						["Count"] = 1,
						["ExtraData"] = _ExtraData or {},
					}, replicateInstantly)
				end
				visualEvent:FireClient(plr, {
					[name] = count,
				})
			end

			return
		end
		if ItemsInventory[name] then
			local itemLimit
			if _reg.Limit then
				itemLimit = _reg.Limit == "inf" and math.huge or _reg.Limit
			else
				itemLimit = 100
			end
			if ItemsInventory[name]["Count"] + count > itemLimit then
				local oldCount = count
				count = itemLimit - ItemsInventory[name]["Count"]
				tab[name] = count ~= 0 and count or nil
				notify:FireClient(
					plr,
					"Error",
					`You have already exceeded the limit for {_reg.configuration.DisplayName}. (MAX {_reg.Limit or 100})`
				)
			end
			if count == 0 then
				continue
			end
			if ItemsInventory[name]["Count"] + count > 0 then
				ItemsInventory[name]["Count"] += count
			else
				ItemsInventory[name] = nil
			end
			PlayerProfileClass:WriteDirectory(`Inventory/Items/{name}`, ItemsInventory[name], replicateInstantly)
		elseif count > 0 then
			if _reg.Limit ~= "inf" then
				if count > (_reg.Limit or 100) then
					count = _reg.Limit or 100
				end
			end
			PlayerProfileClass:WriteDirectory(`Inventory/Items/{name}`, {
				["Name"] = name,
				["Count"] = count,
			}, replicateInstantly)

			tab[name] = count
		end
	end
	if not visualsDisabled then
		visualEvent:FireClient(plr, tab)
	end
end

---------------------------------

local itemActions = {}

function itemActions:Delete(plr, itemName, count)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)
	local Inventory = PlayerProfileClass:GetField("Inventory")
	local ItemsInventory = Inventory.Items
	count = math.floor(math.abs(count))
	if ItemsInventory[itemName] and ItemsInventory[itemName].Count >= count then
		module:GiveItems(plr, {
			[itemName] = count * -1,
		})
	end
end

function itemActions:MultiDelete(plr, items)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)
	local Inventory = PlayerProfileClass:GetField("Inventory")
	local ItemsInventory = Inventory.Items
	warn(items)
	for _, itemName in items do
		if ItemsInventory[itemName] and ItemsInventory[itemName].Count then
			local Count = ItemsInventory[itemName].Count
			module:GiveItems(plr, {
				[itemName] = -Count,
			})
		end
	end
end

function module:RegisterItemActions()
	Events.ItemActionEvent.OnServerEvent:Connect(function(plr, action, ...)
		local func = itemActions[action]
		if not func then
			error("No such event function")
			return
		end
		func(itemActions, plr, ...)
	end)
end

local Bundles_Mod
---------------------------------
local RedeemableTypeHandler = {

	Mount = function(player, item, amount)
		_G.serverServices.MountsManager:GiveMount(player, item, amount)
	end,

	Bundle = function(player, item, amount)
		warn("Giving Bundle", item, amount)
		local MonetizationHandler = require(script.Parent.MonetizationHandler)
		MonetizationHandler:GiveProduct(player, item)
		Bundles_Mod = Bundles_Mod or require(game.ReplicatedStorage.Registry.Products.Bundles)
		local BundleName = Bundles_Mod[item].Name
		notify:FireClient(player, "Success", `You have successfully claimed the {BundleName}!`)
	end,
} :: { [string]: (Player, Item: string, number) -> () }

local CheckTypeHandler = {

	Bundle = function(player, item, amount)
		warn("Giving Bundle", item, amount)
		local MonetizationHandler = require(script.Parent.MonetizationHandler)
		local Result = not MonetizationHandler:IsProductBoughtOut(player, item)
		if not Result then
			Bundles_Mod = Bundles_Mod or require(game.ReplicatedStorage.Registry.Products.Bundles)
			local BundleName = Bundles_Mod[item].Name
			notify:FireClient(player, "Error", `Maximum uses reached for the {BundleName}!`)
		end
		return Result
	end,
} :: { [string]: (Player, Item: string, number) -> () }

function module:RegisterItemUsages()
	itemUseEvent.OnServerEvent:Connect(function(plr, item, UseAmount)
		local effectService = _G.serverServices.EffectService
		local Profile = DataAPI:GetActivePlayerProfileClass(plr)
		local Items = Profile:GetField("Inventory").Items

		local _foundInRegistry = itemRegistry[item]
		local id
		if not _foundInRegistry then
			_foundInRegistry = itemRegistry[Items[item].Name]
			id = item
			item = Items[item].Name
		end
		if not _foundInRegistry then
			return
		end

		local _foundInItemModules = usableItemModules[item]
		local potionInfo = potionRegistry[item]

		if not _foundInRegistry.configuration.RequestAmountOnUsage or not UseAmount then
			UseAmount = 1
		end

		if UseAmount ~= UseAmount then
			return
		end

		UseAmount = math.floor(math.abs(UseAmount))
		UseAmount = math.clamp(UseAmount, 1, math.huge)

		if not module:HasItem(plr, item, UseAmount) then
			return
		end

		if _foundInRegistry then
			if table.find(_foundInRegistry.configuration.Sort, "Potions") and potionInfo then
				effectService:ApplyEffect(plr, potionInfo.configuration.ApplyEffect, potionInfo.configuration.Duration)
				module:GiveItems(plr, {
					[item] = -1, -- Potions should always be 1, and never have RequestAmountOnUsage on
				}, true)
				--elseif table.find(_foundInRegistry.configuration.Sort, "Bundle")  then
				--	print("mr sigma boy")

				--	local Bundles = Profile:GetField("Bundles")
				--	local _found = Bundles[tostring(_foundInRegistry.configuration.ProductId)]
				--	if _found then
				--		if _found < 3 then
				--			Bundles[tostring(_foundInRegistry.configuration.ProductId)] += 1
				--		else
				--			notify:FireClient(plr, "Error", "You have max uses of this bundle!")
				--			return
				--		end
				--	else
				--		Bundles[tostring(_foundInRegistry.configuration.ProductId)] = 1
				--	end
				--	Profile:WriteDirectory(`Bundles/{_foundInRegistry.configuration.ProductId}`, Bundles[tostring(_foundInRegistry.configuration.ProductId)], true)

				--	local bundleUse = bundleUsages[_foundInRegistry.configuration.ProductId]

				--	bundleUse.Callback(plr)
				--	module:GiveItems(plr, {
				--		[id]	= -1
				--	}, true)
			elseif table.find(_foundInRegistry.configuration.Sort, "Redeemable") then
				if
					not _foundInRegistry.configuration.RedeemItem or not _foundInRegistry.configuration.RedeemItemType
				then
					warn(
						`No RedeemItem or no RedeemItemType for item {item}`,
						_foundInRegistry.configuration.RedeemItem,
						_foundInRegistry.configuration.RedeemItemType
					)

					return
				end

				if not RedeemableTypeHandler[_foundInRegistry.configuration.RedeemItemType] then
					return
				end

				if CheckTypeHandler[_foundInRegistry.configuration.RedeemItemType] then
					if
						not CheckTypeHandler[_foundInRegistry.configuration.RedeemItemType](
							plr,
							_foundInRegistry.configuration.RedeemItem,
							UseAmount
						)
					then
						warn("Returning cant claim!")
						return
					end
				end

				module:GiveItems(plr, {
					[item] = -UseAmount,
				}, true)

				RedeemableTypeHandler[_foundInRegistry.configuration.RedeemItemType](
					plr,
					_foundInRegistry.configuration.RedeemItem,
					UseAmount
				)
			elseif _foundInItemModules then
				if _foundInItemModules.Check then
					if not _foundInItemModules.Check(plr, UseAmount) then
						return
					end
				end

				module:GiveItems(plr, {
					[item] = -UseAmount,
				}, true)

				_foundInItemModules.Callback(plr, UseAmount)
			end

			local Engagement = `Item:{item};UseAmount:{UseAmount}`
			trackEngagement(plr, Engagement)
		end
	end)
end

local Maid = require(game.ReplicatedStorage.Maid).new()

function module:playerLoaded(player)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	Maid:GiveTask(`Data {player.UserId}`, PlayerProfile:GetFieldChangedSignal("Inventory/Items"), function(value)
		for id, data in PlayerProfile:GetField("Inventory").Units do
			if data.Relic ~= "" and not value[data.Relic] then
				_G.serverServices.RelicsServer:UnequipRelic(player, id)
			end
		end
	end)
end

function module:playerRemoved(player)
	Maid:KillTask(`Data {player.UserId}`)
end

function module:start()
	self:RegisterItemUsages()
	self:RegisterItemActions()
end

return module
