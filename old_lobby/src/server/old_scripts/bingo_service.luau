local module = {}
local AnalyticsService = game:GetService("AnalyticsService")
local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()
local Registry = _G.Registry.registry
local BingoRegistry = Registry.BingoQuests
local BingoRegistryData = require(game.ReplicatedStorage.Registry.BingoRegistryData)
local Maid = require(game.ReplicatedStorage.Maid).new()
local RewardLibrary = require(game.ReplicatedStorage.Libs.RewardLibrary)
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
local Refresh = 604800
local function List(tbl)
	local Keys = {}
	for Key, _ in tbl do
		table.insert(Keys, Key)
	end
	return Keys
end

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local RowRewards = BingoRegistryData.RowRewards
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

local function Open(Player, PoolName, Amount, WindowData)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(Player)
	local PlayerPoolData = PlayerProfile:GetField("PoolData")
	local AutoSell = PlayerPoolData[PoolName] and PlayerPoolData[PoolName].AutoSell or {}

	local PoolData = require(game.ReplicatedStorage.Registry.Pools[PoolName])
	local SellInfo = PoolData.SellInfo

	local InstantCrateOpen = PlayerProfile:GetField("Settings").InstantCrateOpen

	local RewardTable = {}
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
					--warn('This is a',UnitData.configuration.Rarity)
					if table.find(AutoSell, UnitData.configuration.Rarity) then
						--print('Gotta sell this unit gango')
						local Count = UnitQuantity
						Table.Units[UnitName] = 0
						if SellInfo then
							task.delay(
								InstantCrateOpen and (Amount > 1 and 5 or 2) or Amount > 1 and 14.4 or 9,
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
			end
		end

		--warn('This is Table Now',Table)

		task.delay(InstantCrateOpen and (Amount > 1 and 5 or 2) or Amount > 1 and 14.4 or 9, function()
			RewardLibrary:RewardPlayer(Player, Table)
			--// Cleanup
			table.clear(Table)
			Table = nil
		end)
		Merge(RewardTable, Table, Amount <= 1)
	end
	--warn('RewardTable',RewardTable)

	game.ReplicatedStorage.Events.UiCommunication:FireClient(
		Player,
		"WindowManager/OpenWindow",
		{ WindowName = "Unboxing", Darken = true, BarsHidden = true, HideSlotBar = true },
		PoolName,
		RewardTable,
		WindowData
	)
end

function module:AddProgress(player: Player, QuestName: string, Count: number)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local BingoData = PlayerProfileClass:GetField("BingoData")

	for Location, Data in BingoData.Quests do
		if Data.QuestName == QuestName then
			local _FoundInRegistry = BingoRegistry[QuestName]
			PlayerProfileClass:WriteDirectory(
				`BingoData/Quests/{Location}/Progress`,
				math.clamp(Data.Progress + Count, _FoundInRegistry.MinProgress, _FoundInRegistry.MaxProgress),
				true
			)

			break
		end
	end
end

function module:ClaimSquare(player: Player, SquareLocation: string)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local BingoData = PlayerProfileClass:GetField("BingoData")
	local FoundQuest = BingoData.Quests[SquareLocation]
	if FoundQuest and not FoundQuest.Claimed then
		local _FoundInRegistry = BingoRegistry[FoundQuest.QuestName]
		if FoundQuest.Progress >= _FoundInRegistry.MaxProgress then
			PlayerProfileClass:WriteDirectory(`BingoData/Quests/{SquareLocation}/Claimed`, true, true)
			Open(player, "SpecialCrate", 1, {
				BarsHidden = true,
				HideSlotBar = true,
				WindowName = "Bingo",
			})
			--RewardLibrary:RewardPlayer(player, SquareRewards[SquareLocation])
			-- do a roulette thing
		end
	else
		return false
	end
end

--function module:RerollBlock(player: Player, SquareLocation: string)
--	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
--	local BingoData = PlayerProfileClass:GetField("BingoData")

--	local AllQuests = List(deepCopy(BingoRegistry))
--	if BingoData.Quests[SquareLocation] and not BingoData.Quests[SquareLocation].Claimed then return end
--	for Location,Data in BingoData.Quests do
--		table.remove(AllQuests, table.find(AllQuests, Data.QuestName))

--	end
--	local NewQuest = {
--		QuestName = AllQuests[math.random(1,#AllQuests)],
--		Progress = 0,
--		Claimed = false
--	}
--	PlayerProfileClass:WriteDirectory(`BingoData/Quests/{SquareLocation}`, NewQuest, true)
--end
local function Length(t)
	local counter = 0
	for _, _ in t do
		counter += 1
	end
	return counter
end
local function CheckStorage(player: Player, Rewards)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	if Rewards.Unit or Rewards.Units then
		if
			Length(PlayerProfileClass:GetField("Inventory").Units) + Length(Rewards.Unit or Rewards.Units)
			> PlayerProfileClass:GetField("Inventory").MaxUnitStorage
		then
			game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, {
				color = "Red",
				text = "You do not have enough unit storage",
			})
			return false
		end
	end
	return true
end
function module:ClaimRow(player: Player, RowData)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local BingoData = PlayerProfileClass:GetField("BingoData")
	if BingoData.TotalClaimedRows >= 9 then
		return
	end
	for _, i in RowData do
		i = string.split(i, "_")
		local RowType = i[1]
		local RowNumber = tonumber(i[2])
		if not RowNumber then
			return
		end

		if not CheckStorage(player, RowRewards[BingoData.TotalClaimedRows + 1]) then
			PlayerProfileClass:WriteField("BingoData", BingoData, true)
			return
		end

		--warn(BingoData.Claimed)

		if RowType == "H" then
			if not table.find(BingoData.Claimed, "H_" .. RowNumber) then
				local ClaimedSquares = 0
				for Location, Data in BingoData.Quests do
					local Split = string.split(Location, ",")
					if Split[1] == tostring(RowNumber) and Data.Claimed then
						ClaimedSquares += 1
					end
				end
				if ClaimedSquares == 3 then
					if not CheckStorage(player, RowRewards[BingoData.TotalClaimedRows + 1]) then
						--warn(1)
						PlayerProfileClass:WriteField("BingoData", BingoData, true)
						return
					end
					table.insert(BingoData.Claimed, "H_" .. RowNumber)
					BingoData.TotalClaimedRows += 1
					RewardLibrary:RewardPlayer(player, RowRewards[BingoData.TotalClaimedRows])
				end
			end
		elseif RowType == "V" then
			if not table.find(BingoData.Claimed, "V_" .. RowNumber) then
				local ClaimedSquares = 0
				for Location, Data in BingoData.Quests do
					local Split = string.split(Location, ",")
					if Split[2] == tostring(RowNumber) and Data.Claimed then
						ClaimedSquares += 1
					end
				end
				if ClaimedSquares == 3 then
					if not CheckStorage(player, RowRewards[BingoData.TotalClaimedRows + 1]) then
						--warn(2)
						PlayerProfileClass:WriteField("BingoData", BingoData, true)
						return
					end
					table.insert(BingoData.Claimed, "V_" .. RowNumber)
					BingoData.TotalClaimedRows += 1
					RewardLibrary:RewardPlayer(player, RowRewards[BingoData.TotalClaimedRows])
				end
			end
		elseif RowType == "D" then
			if not table.find(BingoData.Claimed, "D_" .. RowNumber) then
				if RowNumber == 1 then
					if
						not (
							BingoData.Quests["1,1"].Claimed
							and BingoData.Quests["2,2"].Claimed
							and BingoData.Quests["3,3"].Claimed
						)
					then
						return
					end
				elseif RowNumber == 2 then
					if
						not (
							BingoData.Quests["3,1"].Claimed
							and BingoData.Quests["2,2"].Claimed
							and BingoData.Quests["1,3"].Claimed
						)
					then
						return
					end
				else
					return
				end
				if RowRewards[BingoData.TotalClaimedRows + 1] then
					if BingoData.TotalClaimedRows == 7 then
						if not CheckStorage(player, RowRewards[BingoData.TotalClaimedRows + 2]) then
							--warn(3)
							PlayerProfileClass:WriteField("BingoData", BingoData, true)
							return
						end
					end

					if not CheckStorage(player, RowRewards[BingoData.TotalClaimedRows + 1]) then
						--warn(3)
						PlayerProfileClass:WriteField("BingoData", BingoData, true)
						return
					end
					table.insert(BingoData.Claimed, "D_" .. RowNumber)
					BingoData.TotalClaimedRows += 1
					RewardLibrary:RewardPlayer(player, RowRewards[BingoData.TotalClaimedRows])
				end
			end
		end
	end
	if BingoData.TotalClaimedRows == 8 then
		if not CheckStorage(player, RowRewards[BingoData.TotalClaimedRows + 1]) then
			--warn(4, BingoData.Claimed)
			--warn(4)
			PlayerProfileClass:WriteField("BingoData", BingoData, true)
			return
		end

		--	warn(5)

		BingoData.TotalClaimedRows = 9

		RewardLibrary:RewardPlayer(player, RowRewards[BingoData.TotalClaimedRows])
	end

	trackEngagement(player, "BingoClaim")

	--warn(6)

	PlayerProfileClass:WriteField("BingoData", BingoData, true)
end

function module:LoadBingo(player: Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local BingoData = PlayerProfileClass:GetField("BingoData")
	BingoData.NextBingoIn = DateTime.now().UnixTimestamp + Refresh
	local AllQuests = List(deepCopy(BingoRegistry))
	for Row = 1, 3 do
		for Colum = 1, 3 do
			local Quest = AllQuests[math.random(1, #AllQuests)]
			BingoData.Quests[`{Row},{Colum}`] = {
				QuestName = Quest,
				Progress = 0,
				Claimed = false,
			}
			table.remove(AllQuests, table.find(AllQuests, Quest))
		end
	end
	BingoData.Claimed = {}
	BingoData.TotalClaimedRows = 0
	PlayerProfileClass:WriteField("BingoData", BingoData, true)
end

function module:playerLoaded(player: Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local BingoData = PlayerProfileClass:GetField("BingoData")
	if BingoData.NextBingoIn - DateTime.now().UnixTimestamp < 0 then
		self:LoadBingo(player)
	end

	Maid:GiveTask(tostring(player.UserId), game["Run Service"].Heartbeat, function(dt)
		if BingoData.NextBingoIn - DateTime.now().UnixTimestamp < 0 then
			BingoData.NextBingoIn = DateTime.now().UnixTimestamp + Refresh
			self:LoadBingo(player)
		end
	end)
end

function module:Start()
	game.Players.PlayerRemoving:Connect(function(player)
		Maid:KillTask(tostring(player.UserId))
	end)
end

return module
