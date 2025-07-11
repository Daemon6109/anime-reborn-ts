local TradeTemplate = {
	Player1 = nil :: Player,
	Player2 = nil :: Player,
	Processing = false,
	CoreProcessing = false,
	ProcessThread = nil :: thread,
}
export type TradeType = typeof(TradeTemplate)

local RunService = game:GetService("RunService")

local IsStudio = RunService:IsStudio()
local DEBUG_TRADING_STUDIO = true

local OnGoingTrades: { [string]: TradeType } = {}
local Cooldowns = {}
local HTTP = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer
local Maid = require(ReplicatedStorage.Maid).new()

local DataAccess = require(game.ServerScriptService.ServerLibs.DataAccessAPI)

local DataAPI = DataAccess:GetAPI()

local Registry = _G.Registry.registry
local ItemRegistry = Registry.Items
local UnitRegistry = Registry.Units

local UICommunication = ReplicatedStorage.Events.UiCommunication

local Tax = {
	["Rare"] = 0,
	["Epic"] = 100,
	["Legendary"] = 1000,
	["Mythical"] = 4000,
	["MythicalEvolved"] = 6000,

	["Exclusive"] = 6000,
	["ExclusiveEvolved"] = 6000,

	["Secret"] = 6000,
	["SecretEvolved"] = 8000,
}

local function _DisposeTrade(TradeIdentifier: string, IsClosed)
	local Trade = OnGoingTrades[TradeIdentifier]

	if Trade.Player1:IsDescendantOf(game.Players) then
		Trade.Player1:SetAttribute("TradingWith", nil)
		Trade.Player1:SetAttribute("TradeIdentifier", nil)
		Trade.Player1:SetAttribute("Worth", nil)
		Trade.Player1:SetAttribute("Countdown", nil)
		Trade.Player1:SetAttribute("Accepted", nil)

		if Trade.Player1:FindFirstChild("TradeItems") then
			Trade.Player1.TradeItems:Destroy()
		end
		UICommunication:FireClient(Trade.Player1, "WindowManager/CloseWindow", "Trading")
		if not IsClosed then
			UICommunication:FireClient(Trade.Player2, "WindowManager/CloseWindow", "Trading")
		end
	end

	if Trade.Player2:IsDescendantOf(game.Players) then
		Trade.Player2:SetAttribute("TradingWith", nil)
		Trade.Player2:SetAttribute("TradeIdentifier", nil)
		Trade.Player2:SetAttribute("Countdown", nil)
		Trade.Player2:SetAttribute("Accepted", nil)
		Trade.Player2:SetAttribute("Worth", nil)

		if Trade.Player2:FindFirstChild("TradeItems") then
			Trade.Player2.TradeItems:Destroy()
		end
		if not IsClosed then
			UICommunication:FireClient(Trade.Player2, "WindowManager/CloseWindow", "Trading")
		end
	end

	OnGoingTrades[TradeIdentifier] = nil
	Maid:EndTree(TradeIdentifier)
end

local function _IsInTrading(Player: Player, TradeIdentifier: string): "Player1" | "Player2"
	local Trade = OnGoingTrades[TradeIdentifier]
	if Trade then
		local Bool = table.find({ Trade.Player1.UserId, Trade.Player2.UserId }, Player.UserId)
		if Bool then
			return Player.UserId == Trade.Player1.UserId and "Player1" or "Player2"
		end
	end
end

local function GetCounterpart(Player: Player, TradeIdentfier: string): Player
	local Plr = _IsInTrading(Player, TradeIdentfier)

	return OnGoingTrades[TradeIdentfier][Plr == "Player1" and "Player2" or "Player1"]
end

local function FindTrade(Player: Player): (string, TradeType)
	for Identifier, Trade in OnGoingTrades do
		if _IsInTrading(Player, Identifier) then
			return Identifier, Trade
		end
	end
end

local function GetTradeByIdentifier(Identifier: string): TradeType
	return OnGoingTrades[Identifier]
end

local function CalculateTax(PlayerID: number, Identifier: string)
	local Trade = GetTradeByIdentifier(Identifier)
	local Worth1 = Trade.Player1:GetAttribute("Worth")
	local Worth2 = Trade.Player2:GetAttribute("Worth")
	local Tax = 0
	if Trade.Player1.UserId == PlayerID and Worth1 < Worth2 then
		Tax = Worth2 - Worth1
	end

	if Trade.Player2.UserId == PlayerID and Worth2 < Worth1 then
		Tax = Worth1 - Worth2
	end
	return Tax
end

local function ProcessTrade(TradeIdentifier: string)
	local Trade = GetTradeByIdentifier(TradeIdentifier)
	local UnitManager = _G.serverServices.UnitManager
	local ItemManager = _G.serverServices.ItemManager

	if Trade then
		local Player1ProfileClass = DataAPI:GetActivePlayerProfileClass(Trade.Player1)
		local Player2ProfileClass = DataAPI:GetActivePlayerProfileClass(Trade.Player2)
		Trade.Processing = true

		Trade.ProcessThread = task.spawn(function()
			local Countdown = 5
			Trade.Player1:SetAttribute("Countdown", Countdown)
			Trade.Player2:SetAttribute("Countdown", Countdown)

			while task.wait(1) do
				Countdown -= 1
				if not Trade.Player1:GetAttribute("Accepted") and not Trade.Player2:GetAttribute("Accepted") then
					return
				end

				if Countdown < 0 then
					Trade.Player1:SetAttribute("Countdown", nil)
					Trade.Player2:SetAttribute("Countdown", nil)
					Trade.CoreProcessing = true
					break
				else
					Trade.Player1:SetAttribute("Countdown", Countdown)
					Trade.Player2:SetAttribute("Countdown", Countdown)
				end
			end

			for _, Item: ValueBase in Trade.Player1.TradeItems:GetChildren() do
				if Item:IsA("ValueBase") then
					local ItemData = HTTP:JSONDecode(Item.Value)
					warn("ItemType", ItemData.ItemType)
					if ItemData.ItemType == "Unit" then
						UnitManager:removeUnits(Trade.Player1, { Item.Name })
						UnitManager:giveUnit(
							Trade.Player2,
							ItemData.UnitName,
							1,
							{ Shiny = ItemData.Shiny, StatsPotential = ItemData.StatsPotential },
							true,
							true
						)
					elseif ItemData.ItemType == "Item" then
						local count = Item:GetAttribute("count") or 0

						ItemManager:GiveItems(Trade.Player1, {
							[ItemData.Name] = -count,
						})
						ItemManager:GiveItems(Trade.Player2, {
							[Item.Name] = count,
						})
					end

					Item:Destroy()
				end
			end
			local _tax = CalculateTax(Trade.Player1.UserId, TradeIdentifier)
			if _tax > 0 then
				_G.serverServices.PlayerService:GiveCurrency(Trade.Player1, "Gems", -_tax)
			end

			local data = {
				color = "Green",
				text = "Trade was successful!",
			}
			NotifyPlayer:FireClient(Trade.Player1, data)

			for _, Item: ValueBase in Trade.Player2.TradeItems:GetChildren() do
				if Item:IsA("ValueBase") then
					local ItemData = HTTP:JSONDecode(Item.Value)
					if ItemData.ItemType == "Unit" then
						UnitManager:removeUnits(Trade.Player2, { Item.Name })
						UnitManager:giveUnit(
							Trade.Player1,
							ItemData.UnitName,
							1,
							{ Shiny = ItemData.Shiny, StatsPotential = ItemData.StatsPotential },
							true,
							true
						)
						Item:Destroy()
					elseif ItemData.ItemType == "Item" then
						local count = Item:GetAttribute("count") or 0

						ItemManager:GiveItems(Trade.Player2, {
							[ItemData.Name] = -count,
						})
						ItemManager:GiveItems(Trade.Player1, {
							[Item.Name] = count,
						})
					end
				end
			end
			NotifyPlayer:FireClient(Trade.Player2, data)
			_tax = CalculateTax(Trade.Player2.UserId, TradeIdentifier)
			if _tax > 0 then
				_G.serverServices.PlayerService:GiveCurrency(Trade.Player2, "Gems", -_tax)
			end
			_DisposeTrade(TradeIdentifier)
		end)
	end
end

local function CancelTrade(TradeIdentfier)
	local Trade = GetTradeByIdentifier(TradeIdentfier)

	Trade.Player1:SetAttribute("Accepted", false)
	Trade.Player2:SetAttribute("Accepted", false)
	Trade.Player1:SetAttribute("Countdown", nil)
	Trade.Player2:SetAttribute("Countdown", nil)
	if Trade.Processing then
		task.cancel(Trade.ProcessThread)
		Trade.Processing = false
	end
end

local function deepCopy(original): {}
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end
local function Length(t: {})
	local c = 0
	for _, _ in t do
		c += 1
	end
	return c
end

return {

	StartTrade = function(Player1: Player, Player2UserID: number)
		local Player2 = game.Players:GetPlayerByUserId(Player2UserID)

		if not IsStudio or not DEBUG_TRADING_STUDIO then
			if Player1.UserId == Player2.UserId then
				return
			end
		end

		if not Player2 then
			return
		end

		if Player1:GetAttribute("TradingWith") then
			NotifyPlayer:FireClient(Player1, {
				color = "Red",
				text = "You are already trading!",
			})
			return
		end

		if Player2:GetAttribute("TradingWith") then
			NotifyPlayer:FireClient(Player1, {
				color = "Red",
				text = `The player you are trying to trade is already trading!`,
			})
			return
		end
		if not Player1:GetAttribute("TradingRequests") then
			return
		end
		local Requests = HTTP:JSONDecode(Player1:GetAttribute("TradingRequests"))
		if not table.find(Requests, tostring(Player2.UserId)) then
			return
		end
		table.remove(Requests, table.find(Requests, tostring(Player2.UserId)))
		Player1:SetAttribute("TradingRequests", HTTP:JSONEncode(Requests))

		local TradingIdentifier = HTTP:GenerateGUID(false)
		local TradeInfo = deepCopy(TradeTemplate) :: TradeType

		TradeInfo.Player1 = Player1
		TradeInfo.Player2 = Player2

		OnGoingTrades[TradingIdentifier] = TradeInfo

		Player1:SetAttribute("TradingWith", Player2.UserId)
		Player1:SetAttribute("TradeIdentifier", TradingIdentifier)
		Player1:SetAttribute("Worth", 0)

		Player2:SetAttribute("TradingWith", Player1.UserId)
		Player2:SetAttribute("TradeIdentifier", TradingIdentifier)
		Player2:SetAttribute("Worth", 0)

		local TradeFolder = Instance.new("Folder")
		TradeFolder.Name = "TradeItems"
		TradeFolder.Parent = Player1
		local TradeFolder2 = TradeFolder:Clone()
		TradeFolder2.Parent = Player2

		Maid:GiveTreeTask(TradingIdentifier, "PlayerLeft", game.Players.PlayerRemoving, function(_Player: Player)
			local IsInTrade = _IsInTrading(_Player)
			if IsInTrade then
				_DisposeTrade(TradingIdentifier)
			end
		end)
		UICommunication:FireClient(Player1, "WindowManager/OpenWindow", { WindowName = "Trading" })
		UICommunication:FireClient(Player2, "WindowManager/OpenWindow", { WindowName = "Trading" })
	end,

	AddItemToTrade = function(Player: Player, ItemType: string, Item: any, Count: any)
		if Player:GetAttribute("Accepted") then
			return
		end
		local TradeIdentifier = Player:GetAttribute("TradeIdentifier")
		if not TradeIdentifier then
			return
		end
		local Trade = GetTradeByIdentifier(TradeIdentifier)
		if not Trade or Trade.Processing or Trade.CoreProcessing then
			return
		end
		local _PlayerString = _IsInTrading(Player, TradeIdentifier) :: "Player1" | "Player2"
		if Trade and _PlayerString then
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local PlayerInventory = PlayerProfileClass:GetField("Inventory")
			local CounterPart = GetCounterpart(Player, TradeIdentifier)
			local CounterPlayerProfileClass = DataAPI:GetActivePlayerProfileClass(CounterPart)
			local CounterPlayerInventory = CounterPlayerProfileClass:GetField("Inventory")

			if not Count then
				Count = 1
			end
			if ItemType == "Unit" then
				if Length(CounterPlayerInventory.Units) + 1 > CounterPlayerInventory.MaxUnitStorage then
					NotifyPlayer:FireClient(Player, {
						color = "Red",
						text = "The other player has full unit inventory!",
					})
					return
				end

				local TradeFolder = Player:FindFirstChild("TradeItems")

				if PlayerInventory.Units[Item] and TradeFolder then
					local UnitData = PlayerInventory.Units[Item]

					local _FoundInReg = UnitRegistry[UnitData.UnitName]
					if not _FoundInReg.Tradable and not _FoundInReg.ShinyTradable then
						return
					end
					if not _FoundInReg.Tradable and _FoundInReg.ShinyTradable and not UnitData.Shiny then
						return
					end
					if not TradeFolder:FindFirstChild(Item) then
						local ItemInstance = Instance.new("StringValue")
						ItemInstance.Name = Item

						UnitData.ItemType = "Unit"
						ItemInstance.Value = HTTP:JSONEncode(UnitData)

						ItemInstance.Parent = TradeFolder

						CounterPart:SetAttribute("Accepted", false)
						local RarityString = _FoundInReg.configuration.Rarity
						if _FoundInReg.Evolved then
							RarityString = RarityString .. "Evolved"
						end

						local P1Tax = Player:GetAttribute("Worth") + Tax[RarityString]

						Player:SetAttribute("Worth", P1Tax)
					end
				end
			end

			if ItemType == "Item" then
				local TradeFolder = Player:FindFirstChild("TradeItems")

				if PlayerInventory.Items[Item] and TradeFolder then
					local ItemData = PlayerInventory.Items[Item]
					local _FoundInReg = ItemRegistry[ItemData.Name]
					if not table.find(_FoundInReg.configuration.Sort, "Bundle") then
						return
					end

					warn("has item")

					local ItemInstance = TradeFolder:FindFirstChild(Item) or Instance.new("StringValue")

					local count = ItemInstance:GetAttribute("count") or 0

					local itemService = _G.serverServices.ItemManager
					local hasItem = itemService:HasItem(Player, Item, count + 1)
					if not hasItem then
						NotifyPlayer:FireClient(Player, {
							color = "Red",
							text = `You only have {ItemData.Count} {_FoundInReg.configuration.DisplayName}!`,
						})
						return
					end

					ItemInstance:SetAttribute("count", count + 1)

					ItemInstance.Name = Item

					ItemData.ItemType = "Item"
					warn("ItemData", ItemData)
					ItemInstance.Value = HTTP:JSONEncode(ItemData)

					ItemInstance.Parent = TradeFolder
					local CounterPart = GetCounterpart(Player, TradeIdentifier)

					CounterPart:SetAttribute("Accepted", false)
				end
			end
		end
	end,
	RemoveItemFromTrade = function(Player: Player, ItemType: string, Item: any)
		if Player:GetAttribute("Accepted") then
			return
		end
		local TradeIdentifier = Player:GetAttribute("TradeIdentifier")
		if not TradeIdentifier then
			return
		end
		local Trade = GetTradeByIdentifier(TradeIdentifier)
		if not Trade or Trade.Processing or Trade.CoreProcessing then
			return
		end
		local _PlayerString = _IsInTrading(Player, TradeIdentifier) :: "Player1" | "Player2"

		if Trade and _PlayerString then
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local PlayerInventory = PlayerProfileClass:GetField("Inventory")
			if ItemType == "Unit" then
				local TradeFolder = Player:FindFirstChild("TradeItems")
				if PlayerInventory.Units[Item] and TradeFolder then
					if PlayerInventory.Units[Item].Locked then
						NotifyPlayer:FireClient(Player, {
							color = "Red",
							text = "Unit is locked!",
						})
						return
					end
					if TradeFolder:FindFirstChild(Item) then
						local CounterPart = GetCounterpart(Player, TradeIdentifier)
						CounterPart:SetAttribute("Accepted", false)
						local UnitData = HTTP:JSONDecode(TradeFolder:FindFirstChild(Item).Value)
						local _FoundInReg = UnitRegistry[UnitData.UnitName]
						local RarityString = _FoundInReg.configuration.Rarity
						if _FoundInReg.Evolved then
							RarityString = RarityString .. "Evolved"
						end
						local P1Tax = Player:GetAttribute("Worth") - Tax[RarityString]

						Player:SetAttribute("Worth", P1Tax)
						TradeFolder:FindFirstChild(Item):Destroy()
					end
				end
			elseif ItemType == "Item" then
				local TradeFolder = Player:FindFirstChild("TradeItems")
				if PlayerInventory.Items[Item] and TradeFolder then
					if TradeFolder:FindFirstChild(Item) then
						local CounterPart = GetCounterpart(Player, TradeIdentifier)
						CounterPart:SetAttribute("Accepted", false)

						TradeFolder:FindFirstChild(Item):Destroy()
					end
				end
			end
		end
	end,

	ConfirmTrade = function(Player: Player)
		local TradeIdentifier = Player:GetAttribute("TradeIdentifier")
		if not TradeIdentifier then
			return
		end
		local Trade = GetTradeByIdentifier(TradeIdentifier)
		if not Trade or Trade.Processing or Trade.CoreProcessing then
			return
		end
		local _PlayerString = _IsInTrading(Player, TradeIdentifier)
		if _PlayerString then
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Gems = PlayerProfileClass:GetField("Currencies").Gems
			if Gems < CalculateTax(Player.UserId, TradeIdentifier) then
				return
			end
			if not Player:GetAttribute("Accepted") then
				Player:SetAttribute("Accepted", true)
				if GetCounterpart(Player, TradeIdentifier):GetAttribute("Accepted") then
					ProcessTrade(TradeIdentifier)
				end
			end
		end
	end,

	CancelTrade = function(Player: Player)
		local TradeIdentifier = Player:GetAttribute("TradeIdentifier")
		if not TradeIdentifier then
			return
		end
		local Trade = GetTradeByIdentifier(TradeIdentifier)
		if not Trade then
			return
		end
		if not Trade.Processing then
			return
		end
		if Trade.CoreProcessing then
			NotifyPlayer:FireClient(Player, {
				color = "Red",
				text = "Unable to cancel",
			})
			return
		end
		local _PlayerString = _IsInTrading(Player, TradeIdentifier)
		if _PlayerString then
			if Trade.Processing then
				CancelTrade(TradeIdentifier)
			elseif Player:GetAttribute("Accepted") then
				Player:SetAttribute("Accepted", false)
			else
				_DisposeTrade(TradeIdentifier)
			end
		end
	end,

	EndTrade = function(Player: Player, isClosed)
		local TradeIdentifier = Player:GetAttribute("TradeIdentifier")
		if not TradeIdentifier then
			return
		end
		local Trade = GetTradeByIdentifier(TradeIdentifier)
		if not Trade or Trade.Processing or Trade.CoreProcessing then
			return
		end
		local _PlayerString = _IsInTrading(Player, TradeIdentifier)
		if _PlayerString then
			local data = {
				color = "Red",
				text = "Trade cancelled!",
			}
			_DisposeTrade(TradeIdentifier, isClosed)
			NotifyPlayer:FireClient(Trade.Player1, data)
			NotifyPlayer:FireClient(Trade.Player2, data)
		end
	end,

	RequestTrade = function(Player: Player, TradeWith: number)
		local TradePlayer = game.Players:GetPlayerByUserId(TradeWith)

		if TradePlayer then
			if not IsStudio or not DEBUG_TRADING_STUDIO then
				if TradePlayer.UserId == Player.UserId then
					return
				end
			end
			local class = DataAPI:GetActivePlayerProfileClass(Player)
			local class2 = DataAPI:GetActivePlayerProfileClass(TradePlayer)

			local level = class:GetField("Level")
			local level2 = class2:GetField("Level")
			if level < 35 then
				NotifyPlayer:FireClient(Player, {
					color = "Red",
					text = "You need to be level 35+ to trade",
				})
				return
			end
			if level2 < 35 then
				NotifyPlayer:FireClient(Player, {
					color = "Red",
					text = "The player needs to be level 35+ to trade",
				})
				return
			end

			if TradePlayer:GetAttribute("TradeIdentifier") then
				NotifyPlayer:FireClient(Player, {
					color = "Red",
					text = "The player is already trading with someone! Please wait.",
				})
				return
			end

			if Player:GetAttribute("TradeIdentifier") then
				NotifyPlayer:FireClient(Player, {
					color = "Red",
					text = "You are already trading with someone!",
				})
				return
			end

			if Cooldowns[`{Player.UserId} REQUEST`] then
				NotifyPlayer:FireClient(Player, {
					color = "Red",
					text = "You are on cooldown",
				})
				return
			end

			Cooldowns[`{Player.UserId} REQUEST`] = true
			task.delay(10, function()
				Cooldowns[`{Player.UserId} REQUEST`] = nil
			end)

			local TradingRequests = TradePlayer:GetAttribute("TradingRequests")
			if not TradingRequests then
				local t = {}
				table.insert(t, tostring(Player.UserId))
				TradePlayer:SetAttribute("TradingRequests", HTTP:JSONEncode(t))
			else
				local AllRequests = HTTP:JSONDecode(TradingRequests)
				if table.find(AllRequests, tostring(Player.UserId)) then
					NotifyPlayer:FireClient(Player, {
						color = "Red",
						text = "Request already sent!",
					})
					return
				end

				table.insert(AllRequests, tostring(Player.UserId))
				TradePlayer:SetAttribute("TradingRequests", HTTP:JSONEncode(AllRequests))
			end

			NotifyPlayer:FireClient(Player, {
				color = "Green",
				text = "Request sent!",
			})
			NotifyPlayer:FireClient(TradePlayer, {
				color = "Blue",
				text = `{Player.DisplayName} (@{Player.Name}) has sent you a trade request!`,
			})
		end
	end,
}
