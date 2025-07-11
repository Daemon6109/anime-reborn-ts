local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UiCommunication = ReplicatedStorage.Events.UiCommunication

local AnalyticsService = game:GetService("AnalyticsService")
local ServerScriptService = game:GetService("ServerScriptService")

local DataAccess = require(ServerScriptService.ServerLibs.DataAccessAPI)

local DataAPI = DataAccess:GetAPI()

local function Length(dict: table)
	local counter = 0
	for _ in dict do
		counter += 1
	end
	return counter
end

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local RNG = require(ReplicatedStorage.Libs.RNG)

local function Merge(Table1, Table2, Single)
	for Type, TypeTable in Table2 do
		for ItemName, ItemQuantity in TypeTable do
			Table1[Type] = Table1[Type] or {}
			if Single then
				Table1[Type][ItemName] = Table1[Type][ItemName] or 0
				Table1[Type][ItemName] += ItemQuantity
			else
				Table1[Type][ItemName] = Table1[Type][ItemName] or {}
				table.insert(Table1[Type][ItemName], ItemQuantity)
			end
		end
	end
end

local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)

local function Open(Player, PoolName, Amount, WindowData)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(Player)
	local PlayerPoolData = PlayerProfile:GetField("PoolData")
	local AutoSell = PlayerPoolData[PoolName] and PlayerPoolData[PoolName].AutoSell or {}

	local PoolData = require(ReplicatedStorage.Registry.Pools[PoolName])
	local SellInfo = PoolData.SellInfo

	local InstantCrateOpen = PlayerProfile:GetField("Settings").InstantCrateOpen

	local RewardTable = {}

	local PlayerPityTable = PlayerPoolData[PoolName] and PlayerPoolData[PoolName].Pity or {}
	for PityType in PlayerPityTable do
		PlayerPityTable[PityType] += Amount
		PlayerProfile:WriteDirectory(`PoolData/{PoolName}/Pity/{PityType}`, PlayerPityTable[PityType], true)
	end
	--warn('Pity',PlayerProfile:GetField('PoolData')[PoolName].Pity)

	local PityTable = PoolData.Pity

	local PlayerPoolData = PlayerProfile:GetField("PoolData")
	local PlayerPityTable = PlayerPoolData[PoolName] and PlayerPoolData[PoolName].Pity or {}

	if PityTable then
		for PityType in PityTable do
			PlayerPityTable[PityType] = PlayerPityTable[PityType] or 0
			PlayerProfile:WriteDirectory(`PoolData/{PoolName}/Pity/{PityType}`, PlayerPityTable[PityType], true)
		end
	end

	for i = 1, Amount do
		--// RNG & Merge
		local Table = _G.serverServices.PoolService:GivePool(Player, PoolName, true)
		if Table == nil then
			continue
		end

		--warn('This is Table',Table)

		if Table.Units then
			for UnitName, UnitQuantity in Table.Units do
				local UnitData = _G.Registry.registry.Units[UnitName]
				if UnitData then
					local ChosenRarity = UnitData.configuration.Rarity
					--warn('This is a',UnitData.configuration.Rarity)
					local Rarity = UnitData.configuration.Rarity
					if table.find(AutoSell, Rarity) then
						--print('Gotta sell this unit gango')
						local Count = UnitQuantity
						Table.Units[UnitName] = 0
						if SellInfo then
							task.delay(
								InstantCrateOpen and (Amount > 1 and 2 or 0) or Amount > 1 and 14.4 or 9,
								function()
									_G.serverServices.PlayerService:GiveCurrency(
										Player,
										SellInfo[1],
										SellInfo[2] * Count
									)
								end
							)
						end
					end

					--// Add Pity here
					if PityTable then
						local PlayerPoolData = PlayerProfile:GetField("PoolData")
						local PlayerPityTable = PlayerPoolData[PoolName] and PlayerPoolData[PoolName].Pity
						if PlayerPityTable then
							local ReachedPityTable
							for PityType, PityAmount in PlayerPityTable do
								if PityTable[PityType] and PityAmount >= PityTable[PityType].Cost then
									--warn('PITY HAS BEEN REACHED')
									ReachedPityTable = PityType

									PlayerProfile:WriteDirectory(
										`PoolData/{PoolName}/Pity/{PityType}`,
										PlayerPityTable[PityType] - PityTable[PityType].Cost,
										true
									)
									break
								end
							end

							if ReachedPityTable then
								--warn('ReachedPityTable',ReachedPityTable)

								local RNGTable = PityTable[ReachedPityTable].Get()
								local PityUnitName = RNG(RNGTable)
								Table.Units[UnitName] = nil
								Table.Units[PityUnitName] = 1

								local PityUnitData = _G.Registry.registry.Units[PityUnitName]
								ChosenRarity = PityUnitData.configuration.Rarity
								if table.find(AutoSell, PityUnitData.configuration.Rarity) then
									local Count = 1
									Table.Units[PityUnitName] = 0
									if SellInfo then
										task.delay(
											InstantCrateOpen and (Amount > 1 and 2 or 0) or Amount > 1 and 14.4 or 9,
											function()
												_G.serverServices.PlayerService:GiveCurrency(
													Player,
													SellInfo[1],
													SellInfo[2] * Count
												)
											end
										)
									end
								end
							end

							if PlayerPoolData[PoolName].Pity[ChosenRarity .. "Pity"] then
								--	warn('Pity Found! Must Reset')
								PlayerProfile:WriteDirectory(
									`PoolData/{PoolName}/Pity/{ChosenRarity .. "Pity"}`,
									0,
									true
								)
							else
								--	warn('This pity dont exist!')
							end

							if math.random(1, 10) <= 1 then
								Table.ShinyUnits = Table.Units
								Table.Units = nil
							end
						end
					end
				end
			end
		end

		--warn('This is Table Now',Table)

		task.spawn(function()
			if Table.Units then
				for UnitName in Table.Units do
					_G.serverServices.SummonHandler:Chat(Player, UnitName, false)
				end
			end
			if Table.ShinyUnits then
				for UnitName in Table.ShinyUnits do
					_G.serverServices.SummonHandler:Chat(Player, UnitName, true)
				end
			end
		end)

		task.delay(InstantCrateOpen and (Amount > 1 and 2 or 0) or Amount > 1 and 14.4 or 9, function()
			RewardLibrary:RewardPlayer(Player, Table)
			task.wait(2)
			--// Cleanup
			table.clear(Table)
			Table = nil
		end)
		Merge(RewardTable, Table, Amount <= 1)
	end
	--warn('RewardTable',RewardTable)

	trackEngagement(Player, "Crates")

	UiCommunication:FireClient(
		Player,
		"WindowManager/OpenWindow",
		{ WindowName = "Unboxing", Darken = true, BarsHidden = true, HideSlotBar = true },
		PoolName,
		RewardTable,
		WindowData
	)
end

local Rarities = { "Rare", "Epic", "Legendary" }
ReplicatedStorage.Events.TogglePoolAutoSell.OnServerInvoke = function(Player, PoolName, Rarity)
	if not table.find(Rarities, Rarity) then
		return
	end
	if not ReplicatedStorage.Registry.Pools[PoolName] then
		return
	end

	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(Player)
	local PoolData = PlayerProfile:GetField("PoolData")
	PoolData[PoolName] = PoolData[PoolName] or {}

	PoolData[PoolName].AutoSell = PoolData[PoolName].AutoSell or {}

	if table.find(PoolData[PoolName].AutoSell, Rarity) then
		table.remove(PoolData[PoolName].AutoSell, table.find(PoolData[PoolName].AutoSell, Rarity))
	else
		table.insert(PoolData[PoolName].AutoSell, Rarity)
	end

	PlayerProfile:WriteField("PoolData", PoolData, true)
	return table.find(PoolData[PoolName].AutoSell, Rarity)
end

local SpinPrice = 100
local OpenCount = 0
local Crates = {
	Open1 = function(Player: Player, PoolName, WindowData)
		if WindowData.PoolName ~= "ValentineCrate" and WindowData.PoolName ~= "SpecialCrate" then
			return
		end

		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(Player)
		local inventory = PlayerProfile:GetField("Inventory")
		if Length(inventory.Units) + 1 > inventory.MaxUnitStorage then
			return warn("Error", "Your unit storage is full!")
		end
		if Length(inventory.Skins) + 1 > 250 then
			return warn("Error", "Your skin storage is full!")
		end

		if Player:GetAttribute("Crates_Opening") then
			return
		else
			Player:SetAttribute("Crates_Opening", true)
		end

		warn(inventory.Items)
		if WindowData.PoolName == "SpecialCrate" then
			warn("Is Special Crate")
			local HasCurrency = _G.serverServices.ItemManager:HasItem(Player, "Crystals", 100)
			warn("HasCurrency", HasCurrency)
			if not HasCurrency then
				Player:SetAttribute("Crates_Opening", false)
				return
			end
			_G.serverServices.ItemManager:GiveItems(Player, { Crystals = -100 })
		else
			local OwnedCurrency = PlayerProfile:GetField("Currencies")["Gems"] or 0
			if OwnedCurrency < (SpinPrice / (WindowData.PoolName == "SpecialCrate" and 2 or 1)) then
				Player:SetAttribute("Crates_Opening", false)
				return
			else
				_G.serverServices.PlayerService:GiveCurrency(
					Player,
					"Gems",
					-(SpinPrice / (WindowData.PoolName == "SpecialCrate" and 2 or 1))
				)
			end
		end

		OpenCount += 1
		local CurrentCount = OpenCount
		PoolName = WindowData.PoolName
		Open(Player, PoolName, 1, WindowData)
		if CurrentCount ~= OpenCount then
			return
		end
		Player:SetAttribute("Crates_Opening", false)
	end,
	Open10 = function(Player, PoolName, WindowData)
		if WindowData.PoolName ~= "ValentineCrate" and WindowData.PoolName ~= "SpecialCrate" then
			return
		end

		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(Player)
		local inventory = PlayerProfile:GetField("Inventory")
		if Length(inventory.Units) + 10 > inventory.MaxUnitStorage then
			return warn("Error", "Your unit storage is full!")
		end
		if Length(inventory.Skins) + 10 > 250 then
			return warn("Error", "Your skin storage is full!")
		end

		if Player:GetAttribute("Crates_Opening") then
			return
		else
			Player:SetAttribute("Crates_Opening", true)
		end

		warn(inventory.Items)
		if WindowData.PoolName == "SpecialCrate" then
			warn("Is Special Crate")
			local HasCurrency = _G.serverServices.ItemManager:HasItem(Player, "Crystals", 1000)
			warn("HasCurrency", HasCurrency)
			if not HasCurrency then
				Player:SetAttribute("Crates_Opening", false)
				return
			end
			_G.serverServices.ItemManager:GiveItems(Player, { Crystals = -1000 })
		else
			local OwnedCurrency = PlayerProfile:GetField("Currencies")["Gems"] or 0
			if OwnedCurrency < (SpinPrice * 10 / (WindowData.PoolName == "SpecialCrate" and 2 or 1)) then
				Player:SetAttribute("Crates_Opening", false)
				return
			else
				_G.serverServices.PlayerService:GiveCurrency(
					Player,
					"Gems",
					-(SpinPrice * 10 / (WindowData.PoolName == "SpecialCrate" and 2 or 1))
				)
			end
		end

		OpenCount += 1
		local CurrentCount = OpenCount
		PoolName = WindowData.PoolName
		Open(Player, PoolName, 10, WindowData)
		if CurrentCount ~= OpenCount then
			return
		end
		Player:SetAttribute("Crates_Opening", false)
	end,
	Open1Chest = function(Player, PoolName, WindowData)
		if WindowData.PoolName ~= "ValentineCrate" and WindowData.PoolName ~= "SpecialCrate" then
			return
		end

		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(Player)
		local inventory = PlayerProfile:GetField("Inventory")

		if Length(inventory.Units) + 1 > inventory.MaxUnitStorage then
			return warn("Error", "Your unit storage is full!")
		end
		if Length(inventory.Skins) + 1 > 250 then
			return warn("Error", "Your skin storage is full!")
		end

		if Player:GetAttribute("Crates_Opening") then
			return
		else
			Player:SetAttribute("Crates_Opening", true)
		end
		local itemService = _G.serverServices.ItemManager

		local OwnedCurrency = PlayerProfile:GetField("Inventory").Items[WindowData.PoolName]
				and PlayerProfile:GetField("Inventory").Items[WindowData.PoolName].Count
			or 0
		if OwnedCurrency < 1 then
			Player:SetAttribute("Crates_Opening", false)
			return
		else
			itemService:GiveItems(Player, { [WindowData.PoolName] = -1 }, nil, true)
		end
		PoolName = WindowData.PoolName
		OpenCount += 1
		local CurrentCount = OpenCount
		Open(Player, PoolName, 1, WindowData)
		if CurrentCount ~= OpenCount then
			return
		end
		Player:SetAttribute("Crates_Opening", false)
	end,
	Open10Chest = function(Player, PoolName, WindowData)
		if WindowData.PoolName ~= "ValentineCrate" and WindowData.PoolName ~= "SpecialCrate" then
			return
		end

		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(Player)
		local inventory = PlayerProfile:GetField("Inventory")

		if Length(inventory.Units) + 10 > inventory.MaxUnitStorage then
			return warn("Error", "Your unit storage is full!")
		end
		if Length(inventory.Skins) + 10 > 250 then
			return warn("Error", "Your skin storage is full!")
		end

		if Player:GetAttribute("Crates_Opening") then
			return
		else
			Player:SetAttribute("Crates_Opening", true)
		end
		local itemService = _G.serverServices.ItemManager

		local OwnedCurrency = PlayerProfile:GetField("Inventory").Items[WindowData.PoolName]
				and PlayerProfile:GetField("Inventory").Items[WindowData.PoolName].Count
			or 0
		if OwnedCurrency < 10 then
			Player:SetAttribute("Crates_Opening", false)
			return
		else
			itemService:GiveItems(Player, { [WindowData.PoolName] = -10 }, nil, true)
		end
		PoolName = WindowData.PoolName
		OpenCount += 1
		local CurrentCount = OpenCount
		Open(Player, PoolName, 10, WindowData)
		if CurrentCount ~= OpenCount then
			return
		end
		Player:SetAttribute("Crates_Opening", false)
	end,
}

return Crates
