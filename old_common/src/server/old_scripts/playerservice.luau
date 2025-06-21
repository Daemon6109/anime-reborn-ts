local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DailyLibrary = require(ReplicatedStorage.Libs.DailyRewardsLibrary)
local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local EffectsData = require(ReplicatedStorage.Registry.EffectsData)
local GameFunctions = require(ReplicatedStorage.Libs.GameFunctions)
local IndexRegistry = require(ReplicatedStorage.Registry.IndexData)
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)
local ItemGivenEvent = ReplicatedStorage.Events.Visuals.ItemReceived
local BattlepassData = require(ReplicatedStorage.Registry.BattlePassData)
local LeaderboardData = require(ReplicatedStorage.Registry.LeaderboardData)
local SyncedTime = require(ReplicatedStorage.Libs.SyncedTime)

local DataAPI = DataAccess:GetAPI()

local NotifyRemote = ReplicatedStorage.Events.NotifyPlayer
local UiCommunication = ReplicatedStorage.Events.UiCommunication
local UpdateTitleEvent = ReplicatedStorage.Events.UpdateTitleEvent
local PlayerService = {}
--// By @ThatOneTusk
--// Handles player related things such as levels and giving currency

--//
function PlayerService:start() end

local slotsApplicable = {
	[1] = {
		["Level"] = 5,
		["SlotsApplicable"] = 4,
	},
	[2] = {
		["Level"] = 15,
		["SlotsApplicable"] = 5,
	},
	[3] = {
		["Level"] = 30,
		["SlotsApplicable"] = 6,
	},
}

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

local BundlesToReset = {
	1932432089,
	1932432091,
	1932432090,
	2660696154,
	2660696155,
	2660696157,
	2660696156,
	2658905525,
	2658299206,
	2658299207,
	2658299208,
	2678261822,
	2678261823,
	2678261824,
	2678261826,
	2678261825,
	2694029538,
	2694029539,
	2694029541,
	2694029543,
}
local BundlesResetCount = 5
local RaidShopResetCount = 2
local DungeonShopResetCount = 2
local EventShopResetCount = 1
local ResetBPXPCount = 2
local LeaderboardResetCount = 1

local BPProductsToReset = { 2658740900, 2660028654, 2660028653 }
local Teams = { "Aliens", "Spirits" }
--// Advent Calendar
local ACData = require(ReplicatedStorage.Registry.AdventCalendarData)

function GetFirstDay()
	local now = os.time()
	local currentDate = os.date("!*t", now)
	currentDate.year = ACData.StartYear
	currentDate.month = ACData.StartMonth
	currentDate.day = ACData.StartDay
	currentDate.hour = ACData.TargetHour
	currentDate.min = ACData.TargetMin
	currentDate.sec = 0
	return currentDate
end

function GetDay()
	local now = os.time()
	local currentDate = os.date("!*t", now)

	local ActualCurrentDate = currentDate.day
	local ActualCurrentHour = currentDate.hour
	local ActualCurrentMin = currentDate.min

	currentDate.day = currentDate.day + 1
	currentDate.hour = ACData.TargetHour
	currentDate.min = ACData.TargetMin
	currentDate.sec = 0

	if (ActualCurrentHour * 60) + ActualCurrentMin < (ACData.TargetHour * 60) + ACData.TargetMin then
		currentDate.day -= 1
	end

	local FirstDay = GetFirstDay()
	local UnixDifference = os.difftime(os.time(currentDate), os.time(FirstDay))

	local DayDifference = os.date("!*t", UnixDifference)

	return DayDifference and DayDifference.day or 0
end

local RND = Random.new()

local ResetTeam = 5

local DSS = game:GetService("DataStoreService")
local DataStore = DSS:GetDataStore("TeamBalancing")
local TeamValue

local function GetTeamValue(AddValue)
	local Value = 50_000
	AddValue = AddValue or 0
	local S, E = pcall(function()
		DataStore:UpdateAsync("Value", function(NewValue)
			NewValue = NewValue or Value
			TeamValue = NewValue
			TeamValue += AddValue
			return TeamValue
		end)
	end)
	TeamValue = TeamValue or Value
	--warn('TeamValue is:',TeamValue)
	return TeamValue
end

GetTeamValue()

--// Player Loaded
function PlayerService:playerLoaded(player: Player)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	local _ProductsBought = PlayerProfile:GetField("ProductsBought")
	local _PatchData = PlayerProfile:GetField("PatchData")
	local _BpData = PlayerProfile:GetField("BattlepassData")
	local _ACData = PlayerProfile:GetField("AdventCalendarData")
	local _TeamEventData = PlayerProfile:GetField("TeamEventData")
	local _Inventory = PlayerProfile:GetField("Inventory")

	local ResetExp = _BpData.ResetExp
	local DayNumber = GetDay()

	--// Advent Calendar
	if player.Name == "DrDarkMatter" then
		_ACData.OnlineDays = 8
		_ACData.DayNumber = 8
		_ACData.Patched = nil
		_ACData.Claimed = { 1, 2, 3, 4, 5, 6, 7, 8 }
	end

	if not _ACData.Patched then
		_ACData.Patched = true
		_ACData.OnlineDays += 3
	end
	if not _ACData.OnlineDays or _ACData.DayNumber ~= DayNumber then
		_ACData.DayNumber = DayNumber
		_ACData.OnlineDays = _ACData.OnlineDays or 0
		_ACData.OnlineDays += 1
		--warn('MISSED DAYS:',_ACData.DayNumber-_ACData.OnlineDays)
		PlayerProfile:WriteField("AdventCalendarData", _ACData, true)
	end

	-- // One piece dungeon cap

	if
		_Inventory.Items
		and _Inventory.Items.OnePieceDungeonToken
		and _Inventory.Items.OnePieceDungeonToken.Name
		and _Inventory.Items.OnePieceDungeonToken.Count
		and _Inventory.Items.OnePieceDungeonToken.Count > 1_000_001
	then
		local newdata = {
			["Name"] = _Inventory.Items.OnePieceDungeonToken.Name,
			["Count"] = 15_000,
		}

		PlayerProfile:WriteDirectory("Inventory/Items/OnePieceDungeonToken", newdata, true)

		warn("Had too much tokens")
	end

	--[[if _BpData.Level and _BpData.Level >= 25 then
		PlayerProfile:WriteDirectory("BattlepassData/Exp", 0, true)
	end]]

	if not _TeamEventData.Team or _TeamEventData.ResetTeam ~= ResetTeam then
		if TeamValue == 50_000 then
			_TeamEventData.Team = Teams[RND:NextInteger(1, 2)]
			if _TeamEventData.Team == "Spirits" then
				GetTeamValue(5)
			else
				GetTeamValue(-5)
			end
		else
			if TeamValue < 50_000 then
				_TeamEventData.Team = "Spirits"
				GetTeamValue(5)
			elseif TeamValue > 50_000 then
				_TeamEventData.Team = "Aliens"
				GetTeamValue(-5)
			else
				_TeamEventData.Team = Teams[RND:NextInteger(1, 2)]
			end
		end
		_TeamEventData.ResetTeam = ResetTeam
		PlayerProfile:WriteField("TeamEventData", _TeamEventData, true)
		warn("Team Assigned:", _TeamEventData.Team)
	end
	player:SetAttribute("TeamAssigned", true)

	--// Battlepass XP
	if ResetExp ~= ResetBPXPCount then
		warn("RESETTING BP XP")
		PlayerProfile:WriteDirectory("BattlepassData/ResetExp", ResetBPXPCount, true)
		if _BpData.Level and _BpData.Level >= 25 then
			PlayerProfile:WriteDirectory("BattlepassData/Exp", 0, true)
		end
	end

	if _BpData.BattlepassName ~= BattlepassData.BattlepassName then
		--warn('NEW BATTLEPASS NAME DETECTED')
		for Id, Product in _ProductsBought do
			if table.find(BPProductsToReset, tonumber(Id)) then
				PlayerProfile:WriteDirectory(`ProductsBought/{Id}`, nil, true)
			end
		end
		PlayerProfile:WriteDirectory(`BattlepassData/HasPremium`, false, true)
	end

	--// Raid Shop
	if _PatchData.RaidShopReset ~= RaidShopResetCount then
		local _RaidShopBoughtData = PlayerProfile:GetField("RaidShopData")
		if _RaidShopBoughtData then
			_RaidShopBoughtData = _RaidShopBoughtData.Bought
			if _RaidShopBoughtData then
				for ItemName in _RaidShopBoughtData do
					PlayerProfile:WriteDirectory(`RaidShopData/Bought/{ItemName}`, nil, true)
				end
			end
		end
		PlayerProfile:WriteDirectory("PatchData/RaidShopReset", RaidShopResetCount, true)
		DataAPI:SaveProfile()
	end

	local RaidShopResetUnix = GetResetTime()
	if _PatchData.RaidShopResetUnix ~= RaidShopResetUnix then
		warn("RaidShopResetUnix IS NOT THE SAME RESETTING:", _PatchData.RaidShopResetUnix, RaidShopResetUnix)
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
	end

	--// Dungeon Shop
	if _PatchData.DungeonShopReset ~= DungeonShopResetCount then
		local _DungeonShopBoughtData = PlayerProfile:GetField("DungeonShopData")
		if _DungeonShopBoughtData then
			_DungeonShopBoughtData = _DungeonShopBoughtData.Bought
			if _DungeonShopBoughtData then
				for ItemName in _DungeonShopBoughtData do
					PlayerProfile:WriteDirectory(`DungeonShopData/Bought/{ItemName}`, nil, true)
				end
			end
		end
		PlayerProfile:WriteDirectory("PatchData/DungeonShopReset", DungeonShopResetCount, true)
		DataAPI:SaveProfile()
	end

	local DungeonShopResetUnix = GetResetTime()
	if _PatchData.DungeonShopResetUnix ~= DungeonShopResetUnix then
		warn("DungeonShopResetUnix IS NOT THE SAME RESETTING:", _PatchData.DungeonShopResetUnix, DungeonShopResetUnix)
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
	end

	--// Event Shop
	if _PatchData.EventShopReset ~= EventShopResetCount then
		local _EventShopData = PlayerProfile:GetField("EventShopData")

		if _EventShopData then
			_EventShopData = _EventShopData.Bought

			if _EventShopData then
				for ItemName in _EventShopData do
					PlayerProfile:WriteDirectory(`EventShopData/Bought/{ItemName}`, nil, true)
				end
			end
		end

		PlayerProfile:WriteDirectory("PatchData/EventShopReset", EventShopResetCount, true)
		DataAPI:SaveProfile()
	end

	--// Lb

	if _PatchData.LeaderboardReset ~= LeaderboardResetCount then
		for i, info in LeaderboardData.Info do
			if info.IsSeasonal and info.OnSeasonChanged then
				local run, _e = pcall(info.OnSeasonChanged, player, PlayerProfile)

				if not run then
					warn(`Failed to update leaderboard data for {i}, plr: {player}. {_e}`)
				end
			end
		end

		PlayerProfile:WriteDirectory("PatchData/LeaderboardReset", LeaderboardResetCount, true)
		DataAPI:SaveProfile()
	end

	if _PatchData.BundleUseReset ~= BundlesResetCount then
		for Id, Product in _ProductsBought do
			if table.find(BundlesToReset, tonumber(Id)) then
				PlayerProfile:WriteDirectory(`ProductsBought/{Id}`, nil, true)
			end
		end
		PlayerProfile:WriteDirectory("PatchData/BundleUseReset", BundlesResetCount, true)
		DataAPI:SaveProfile()
	end

	--Battlepass Fix
	if _ProductsBought["2658740900"] and _BpData.BattlepassName == "Rocket Pass" and not _BpData.HasPremium then
		PlayerProfile:WriteDirectory("BattlepassData/HasPremium", true, true)
	end

	--// Gem  UI
	local DaysNow = SyncedTime.time() // 86400

	if PlayerProfile:GetField("CurrencyExchangerData").Day ~= DaysNow then
		PlayerProfile:WriteDirectory("CurrencyExchangerData/Exchanged", 0, true)
		PlayerProfile:WriteDirectory("CurrencyExchangerData/Day", DaysNow)
	end

	local LastLevel = PlayerProfile:GetField("Level")
	local HasVip = false
	PlayerProfile:GetFieldChangedSignal("Level"):Connect(function(NewValue)
		local NameDisplay = player.Character.Head:FindFirstChild("NameDisplay")
		local _applicable = PlayerProfile:GetField("SlotsApplicable")
		if NameDisplay then
			NameDisplay.Label.Text = `Lvl {NewValue} | {player.Name}`
		end

		for i = 1, #slotsApplicable do
			local slotData = slotsApplicable[i]
			if NewValue >= slotData.Level and _applicable < slotData.SlotsApplicable then
				_applicable = slotData.SlotsApplicable
			end
		end
		PlayerProfile:WriteField("SlotsApplicable", _applicable, true)

		LastLevel = NewValue
	end)

	PlayerProfile:GetFieldChangedSignal("CurrentTitle"):Connect(function(NewValue)
		if not HasVip then
			local ProductsBought = PlayerProfile:GetField("ProductsBought")
			HasVip = ProductsBought["887686872"]
		end

		UpdateTitleEvent:FireAllClients(player.Name, NewValue, HasVip)
	end)

	DailyLibrary:UpdatePlayerDays(player)

	--// Handle XP and Level changes
	PlayerProfile:GetFieldChangedSignal("XP"):Connect(function(value)
		if self:CanLevelUp(player) then
			self:LevelUp(player)
		else
			PlayerProfile:ReplicateField("XP")
			PlayerProfile:ReplicateField("Level")
		end
	end)

	PlayerProfile:GetFieldChangedSignal("BattlepassData/Exp"):Connect(function(value)
		if self:CanLevelUpBattlepass(player) then
			self:LevelUpBattlepass(player)
		else
			local bpData = PlayerProfile:GetField("BattlepassData")
			if bpData.Level >= #BattlepassData.LevelData then
				PlayerProfile:WriteDirectory("BattlepassData/Exp", 0, true)
				PlayerProfile:WriteDirectory("BattlepassData/Level", #BattlepassData.LevelData, true)
			else
				PlayerProfile:WriteDirectory("BattlepassData/Exp", bpData.Exp, true)
				PlayerProfile:WriteDirectory("BattlepassData/Level", bpData.Level, true)
			end
		end
	end)
	local PlayerBPData = PlayerProfile:GetField("BattlepassData")
	if PlayerBPData.BattlepassName ~= BattlepassData.BattlepassName then
		PlayerProfile:WriteField("BattlepassData", {
			Level = 0,
			Exp = 0,
			BattlepassName = BattlepassData.BattlepassName,
			ClaimedFree = 0,
			ClaimedPremium = 0,
			HasPremium = false,
		}, true)
	end

	local IndexXP = PlayerProfile:GetField("IndexData").IndexXP

	PlayerProfile:GetFieldChangedSignal("IndexData"):Connect(function()
		if IndexXP ~= PlayerProfile:GetField("IndexData").IndexXP then
			IndexXP = PlayerProfile:GetField("IndexData").IndexXP
			if self:CanLevelUpIndex(player) then
				self:LevelUpIndex(player)
			end
		end
	end)

	local AppliedEffects = PlayerProfile:GetField("Effects")

	if PlayerProfile:GetField("XP") > 0 then
		if self:CanLevelUp(player) then
			self:LevelUp(player)
		end
	end
	if PlayerProfile:GetField("BattlepassData").Exp > 0 then
		if self:CanLevelUpBattlepass(player) then
			self:LevelUpBattlepass(player)
		end
	end
	if PlayerProfile:GetField("IndexData").IndexXP > 0 then
		--task.spawn(function()
		--	while self:CanLevelUpIndex(player) do
		--		self:LevelUpIndex(player)
		--	end
		--end)

		if self:CanLevelUpIndex(player) then
			self:LevelUpIndex(player)
		end
	end

	AnalyticsService:LogOnboardingFunnelStepEvent(player, 2, "Player Loaded")
end

--//
function PlayerService:characterAdded(player: Player, character: Model)
	--// Setup the name display

	--warn("Added Name display for player", debug.traceback())
	character:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local NameDisplay = ReplicatedStorage.Other.NameDisplay:Clone()
	NameDisplay:SetAttribute("UserId", player.UserId)

	NameDisplay.Label.Text = `Lvl {PlayerProfile:GetField("Level")} | {player.Name}`
	NameDisplay.Parent = character.Head

	local PlayerLevel = PlayerProfile:GetField("Level")
	local _applicable = PlayerProfile:GetField("SlotsApplicable")

	for i = 1, #slotsApplicable do
		local slotData = slotsApplicable[i]
		if PlayerLevel >= slotData.Level and _applicable < slotData.SlotsApplicable then
			_applicable = slotData.SlotsApplicable
		end
	end
	PlayerProfile:WriteField("SlotsApplicable", _applicable, true)
end

--//
function PlayerService:playerRemoved(player: Player)
	_G.serverServices.UiServer:RunComponentMethod(player, "Trading/CancelTrade")
	_G.serverServices.UiServer:RunComponentMethod(player, "Trading/EndTrade")
end

--// Returns whether the given player can level up or not
function PlayerService:CanLevelUp(player: Player): boolean?
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	return PlayerProfile:GetField("XP") >= GameFunctions:CalculateEXPFromLevel(PlayerProfile:GetField("Level"))
end

--// Returns whether the given player can level up index or not
function PlayerService:CanLevelUpIndex(player: Player): boolean?
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local IndexData = PlayerProfile:GetField("IndexData")

	return IndexData.IndexXP >= GameFunctions:CalculateIndexEXPFromLevel(IndexData.IndexLevel)
end

--// Attempts to level up the given player
function PlayerService:LevelUp(player: Player): boolean?
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	if not PlayerService:CanLevelUp(player) then
		return
	end

	local NewLevel = PlayerProfile:GetField("Level") + 1

	PlayerProfile:WriteField("Level", NewLevel, true)
	PlayerProfile:WriteField(
		"XP",
		PlayerProfile:GetField("XP") - GameFunctions:CalculateEXPFromLevel(PlayerProfile:GetField("Level"))
	)

	if NewLevel % 5 == 0 then
		AnalyticsService:LogOnboardingFunnelStepEvent(player, 8 + (NewLevel / 5), `Reached Level {tostring(NewLevel)}`)
	end

	return true
end

function PlayerService:CanLevelUpBattlepass(player: Player): boolean?
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local bpData = PlayerProfile:GetField("BattlepassData")
	if bpData.Level >= #BattlepassData.LevelData then
		return false
	end
	return bpData.Exp >= BattlepassData:CalculateExp(bpData.Level + 1)
end

function PlayerService:LevelUpBattlepass(player: Player): boolean?
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	if not PlayerService:CanLevelUpBattlepass(player) then
		return
	end
	local bpData = PlayerProfile:GetField("BattlepassData")
	PlayerProfile:WriteDirectory("BattlepassData/Level", bpData.Level + 1, true)
	PlayerProfile:WriteDirectory("BattlepassData/Exp", bpData.Exp - BattlepassData:CalculateExp(bpData.Level + 1))

	return true
end

--// Attempts to level up the index for the given player
function PlayerService:LevelUpIndex(player: Player): boolean?
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	if not PlayerService:CanLevelUpIndex(player) then
		return
	end

	local IndexData = PlayerProfile:GetField("IndexData")
	local IndexLevel = IndexData.IndexLevel
	local IndexXP = IndexData.IndexXP

	PlayerProfile:WriteDirectory("IndexData/IndexLevel", IndexLevel + 1, true)
	PlayerProfile:WriteDirectory(
		"IndexData/IndexXP",
		IndexXP - GameFunctions:CalculateIndexEXPFromLevel(IndexLevel),
		true
	)

	NotifyRemote:FireClient(player, {
		text = "INDEX LEVEL UP! Go to your Unit Index to claim your prizes!",
		color = "Yellow",
	})

	return true
end

--// Gives the player currency.
-- @ amount: number? - Defaults to 1. Can be negative.
function PlayerService:GiveCurrency(player: Player, currency: string, amount: number?, supressNotifier: boolean?)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	local FoundCurrency = PlayerProfile:GetField("Currencies")[currency] or 0
	amount = amount or 1

	if amount ~= amount then
		return
	end

	if not supressNotifier then
		ItemGivenEvent:FireClient(player, { [currency] = amount })
	end
	assert(game.ReplicatedStorage.Registry.Currency:FindFirstChild(currency), `Currency {currency} doesn't exist`)

	PlayerProfile:WriteDirectory(`Currencies/{currency}`, FoundCurrency + amount, true)
end

--// Gives the player Battlepass Exp.
-- @ amount: number? - Defaults to 1. Can be negative.
function PlayerService:GiveBattlepassExp(player: Player, amount: number?, suppressNotifier: boolean?)
	if BattlepassData.EndsIn <= os.time() then
		return false
	end

	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local BpData = PlayerProfile:GetField("BattlepassData")
	local BpExp = BpData.Exp
	local BpLevel = BpData.Level
	amount = amount or 1

	if amount ~= amount then
		return
	end

	if not suppressNotifier then
		ItemGivenEvent:FireClient(player, { ["BattlepassExp"] = amount })
	end

	PlayerProfile:WriteDirectory(`BattlepassData/Exp`, BpExp + amount, true)
end

return PlayerService
