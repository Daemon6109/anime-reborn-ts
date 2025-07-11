local module = {}

local Maid = require(game.ReplicatedStorage.Maid).new()
local QuestLib = require(game.ReplicatedStorage.Libs.QuestLib)
local SyncedTime = require(game.ReplicatedStorage.Libs.SyncedTime)

local HTTP = game:GetService("HttpService")

local Events = game.ReplicatedStorage.Events
local GameVariables = game.ReplicatedStorage.GameVariables

local Registry = _G.Registry.registry
local questRegistry = Registry.Quests
local mapOrderInfo = Registry.MapOrder.InfoForQuests

local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local QuestTypesTable = {
	Daily = {},
	Weekly = {},
	Infinite = {},
	Story = {},
	Event = {},
	Special = {},
}

--==========================================================================================================================================

local QuestFunctions = {}

function QuestFunctions:ClaimQuest(Player, QuestName)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	local QuestInRegistry = questRegistry[QuestName]

	if not QuestInRegistry then
		return
	end
	if not QuestData.ActiveQuests[QuestName] then
		return
	end

	if QuestData.ActiveQuests[QuestName] >= QuestInRegistry.configuration.PointsNeeded then
		module:FinishQuest(Player, QuestName)
		module:RemoveQuest(Player, QuestName)

		if QuestInRegistry.configuration.QuestToGiveAfter then
			if type(QuestInRegistry.configuration.QuestToGiveAfter) == "table" then
				for i, v in pairs(QuestInRegistry.configuration.QuestToGiveAfter) do
					module:GiveQuest(Player, v)
				end
			else
				module:GiveQuest(Player, QuestInRegistry.configuration.QuestToGiveAfter)
			end
		end

		QuestInRegistry:Complete(Player)

		return {
			Message = `You successfuly claimed reward for the quest "{QuestInRegistry.configuration.DisplayName}"!`,
			Result = true,
		}
	end

	return { Message = `Finish the quest before claiming the reward!`, Result = false }
end

--==========================================================================================================================================

function module:FinishQuest(Player, QuestName)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	local QuestInRegistry = questRegistry[QuestName]

	if not QuestInRegistry then
		return
	end

	if QuestInRegistry.configuration.QuestType == "Daily" then
		self:GivePoints(Player, "AllDaily", 1)
	elseif QuestInRegistry.configuration.QuestType == "Weekly" then
		self:GivePoints(Player, "AllWeekly", 1)
	elseif QuestInRegistry.configuration.QuestType == "Event" then
		--print(`{QuestInRegistry.configuration.EventType}EventAll`)
		self:GivePoints(Player, `{QuestInRegistry.configuration.EventType}EventAll`, 1)
	elseif QuestInRegistry.configuration.QuestType == "Special" then
		--print(`{QuestInRegistry.configuration.EventType}EventAll`)
		self:GivePoints(Player, `{QuestInRegistry.configuration.EventType}SpecialAll`, 1)
	end

	if
		QuestInRegistry.configuration.QuestType ~= "Story"
		and QuestInRegistry.configuration.QuestType ~= "Event"
		and QuestInRegistry.configuration.QuestType ~= "Special"
	then
		return
	end

	QuestData = PlayerProfileClass:GetField("Quests")

	QuestData.FinishedQuests[QuestName] = true

	PlayerProfileClass:WriteField("Quests", QuestData, true)

	self:CheckStoryQuests(Player)
end

function module:GiveQuest(Player, QuestName)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	if type(QuestName) == "table" then
		for i, Name in QuestName do
			--print(Name)
			local QuestInRegistry = questRegistry[Name]

			if not QuestInRegistry then
				return
			end
			--if QuestData.ActiveQuests[QuestName] then return end
			if QuestData.FinishedQuests[Name] then
				return
			end

			QuestData.ActiveQuests[Name] = 0
		end
	else
		local QuestInRegistry = questRegistry[QuestName]

		if not QuestInRegistry then
			return
		end
		--if QuestData.ActiveQuests[QuestName] then return end
		if QuestData.FinishedQuests[QuestName] then
			return
		end

		QuestData.ActiveQuests[QuestName] = 0
	end

	PlayerProfileClass:WriteField("Quests", QuestData, true)
end

function module:RemoveQuest(Player, QuestName)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	QuestData.ActiveQuests[QuestName] = nil

	PlayerProfileClass:WriteField("Quests", QuestData, true)
end

function module:GivePointsByPointType(Player, PointTypeName, Points)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	for name, points in QuestData.ActiveQuests do
		local QuestInRegistry = questRegistry[name]

		if not QuestInRegistry then
			continue
		end
		if QuestInRegistry.configuration.QuestPointType then
			if QuestInRegistry.configuration.QuestPointType == PointTypeName then
				QuestData.ActiveQuests[name] += Points
			end
		end
	end

	PlayerProfileClass:WriteField("Quests", QuestData, true)
end

function module:SetPointsByPointType(Player, PointTypeName, Points, TrueSet: boolean)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	for name, points in QuestData.ActiveQuests do
		local QuestInRegistry = questRegistry[name]

		if not QuestInRegistry then
			continue
		end
		if QuestInRegistry.configuration.QuestPointType then
			if QuestInRegistry.configuration.QuestPointType == PointTypeName then
				if TrueSet then
					QuestData.ActiveQuests[name] = Points
				elseif QuestData.ActiveQuests[name] < Points then
					QuestData.ActiveQuests[name] = Points
				end
			end
		end
	end

	PlayerProfileClass:WriteField("Quests", QuestData, true)
end

--local ReconcileSungJinWoo = {
--	"Special1NPC",
--	"Special2Unit",
--	"Special3Unit",
--	"Special4Unit",
--	"Special5Unit",
--	"Special6Tier6Dungeon",
--	"Special7SecretPortal",
--	"Special8DreamKey",
--	"Special9NPC",
--	"Special10NPC",
--}

function module:GivePoints(Player, QuestName, Points)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	print(QuestName, Points)

	if type(QuestName) == "table" then
		for i, v in QuestName do
			local QuestInRegistry = questRegistry[QuestName]

			if not QuestInRegistry then
				continue
			end
			if not QuestData.ActiveQuests[QuestName] then
				continue
			end

			QuestData.ActiveQuests[v] += Points
		end
	else
		local QuestInRegistry = questRegistry[QuestName]

		if not QuestInRegistry then
			print(QuestName, "not in registry")
			return
		end
		if not QuestData.ActiveQuests[QuestName] then
			print(QuestName, "not in quests")
			return
		end

		QuestData.ActiveQuests[QuestName] += Points
	end

	--if QuestName == 'Special10NPC' and Points > 0 then
	--	if QuestData.FinishedQuests["Special10NPC"]  then
	--		for _,QuestName in ReconcileSungJinWoo do
	--			QuestData.FinishedQuests[QuestName] = nil
	--			QuestData.ActiveQuests[QuestName] = 0
	--		end
	--	end
	--end

	PlayerProfileClass:WriteField("Quests", QuestData, true)
end

function module:SetPoints(Player, QuestName, Points)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	if type(QuestName) == "table" then
		for i, v in QuestName do
			local QuestInRegistry = questRegistry[QuestName]

			if not QuestInRegistry then
				continue
			end
			if not QuestData.ActiveQuests[QuestName] then
				continue
			end

			QuestData.ActiveQuests[v] = Points
		end
	else
		local QuestInRegistry = questRegistry[QuestName]

		if not QuestInRegistry then
			return
		end
		if not QuestData.ActiveQuests[QuestName] then
			return
		end

		QuestData.ActiveQuests[QuestName] = Points
	end

	PlayerProfileClass:WriteField("Quests", QuestData, true)
end

function module:GetRandomQuest(Player, Type)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")
	local QuestName = "Nothing"
	local tries = 0

	while tries < 300 do
		tries += 1
		QuestName = QuestTypesTable[Type][math.random(1, #QuestTypesTable[Type])]
		if not QuestData.ActiveQuests[QuestName] then
			break
		end
		--task.wait()
	end

	return QuestName
end

function module:CheckDailyQuests(Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	if not QuestData.Day then
		self:ResetDailyQuests(Player)
		return
	end

	local TimeTable = QuestLib:GetTimeDay()

	--warn("Quest Data", QuestData, TimeTable)

	if QuestData.Day ~= TimeTable.Time then
		self:ResetDailyQuests(Player)
	end
end

function module:ResetDailyQuests(Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	if QuestData.ActiveQuests then
		for QuestName, QuestPoints in QuestData.ActiveQuests do
			local QuestInRegistry = questRegistry[QuestName]

			if not QuestInRegistry then
				QuestData.ActiveQuests[QuestName] = nil
				continue
			end

			if
				QuestInRegistry.configuration.QuestType == "Daily"
				or QuestInRegistry.configuration.QuestType == "Infinite"
			then
				QuestData.ActiveQuests[QuestName] = nil
			end
		end
	end

	QuestData.Day = QuestLib:GetTimeDay().Time

	PlayerProfileClass:WriteField("Quests", QuestData, true)

	local PointTypes = {}
	local QuestNames = { "AllDaily" }

	for a = 1, 3 do
		local DailyName = self:GetRandomQuest(Player, "Daily")
		local DailyRegistry = questRegistry[DailyName]

		if not DailyRegistry then
			repeat
				--print("repeat not found")
				DailyName = self:GetRandomQuest(Player, "Daily")
				DailyRegistry = questRegistry[DailyName]
			--task.wait(.05)
			until DailyRegistry
		end

		if PointTypes[DailyRegistry.configuration.QuestPointType] or QuestData.ActiveQuests[DailyName] then
			repeat
				--print("repeat quest repeat")
				DailyName = self:GetRandomQuest(Player, "Daily")
				DailyRegistry = questRegistry[DailyName]
			--task.wait(.05)
			until DailyRegistry
				and not PointTypes[DailyRegistry.configuration.QuestPointType]
				and not QuestData.ActiveQuests[DailyName]
		end

		PointTypes[DailyRegistry.configuration.QuestPointType] = true

		table.insert(QuestNames, DailyName)

		--print(DailyName)
	end

	local Maps = {}

	for b = 1, 2 do
		local MapTable = {}

		for i, v in pairs(mapOrderInfo) do
			MapTable[v] = i
		end

		local RNGMap = MapTable[math.random(1, #MapTable)]

		if table.find(Maps, RNGMap) then
			repeat
				RNGMap = MapTable[math.random(1, #MapTable)]
			until not table.find(Maps, RNGMap)
		end

		for c = 1, 3 do
			table.insert(QuestNames, `{RNGMap} {c} Infinite`)
		end

		table.insert(Maps, RNGMap)
	end

	--print(QuestNames)
	self:GiveQuest(Player, QuestNames)
	self:GivePointsByPointType(Player, "Login", 1)
end

function module:CheckWeeklyQuests(Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	if not QuestData.Week then
		self:ResetWeeklyQuests(Player)
		return
	end

	local TimeTable = QuestLib:GetTimeWeek()

	if QuestData.Week ~= TimeTable.Time then
		self:ResetWeeklyQuests(Player)
	end
end

function module:FixQuests(Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	local QuestTable = {
		Daily = 0,
		Weekly = 0,
		Infinite = 0,
		Story = 0,
		Event = 0,
		Special = 0,
	}

	for questName, points in pairs(QuestData.ActiveQuests) do
		local QuestReg = questRegistry[questName]

		if not QuestReg then
			QuestData.ActiveQuests[questName] = nil
			continue
		end

		QuestTable[QuestReg.configuration.QuestType] += 1
	end

	local DailyPoints = 4 - QuestTable.Daily
	local WeeklyPoints = 4 - QuestTable.Weekly

	if QuestData.ActiveQuests["AllDaily"] and QuestData.ActiveQuests["AllDaily"] ~= DailyPoints then
		module:SetPoints(Player, "AllDaily", DailyPoints)
	end

	if QuestData.ActiveQuests["AllWeekly"] and QuestData.ActiveQuests["AllWeekly"] ~= WeeklyPoints then
		module:SetPoints(Player, "AllWeekly", WeeklyPoints)
	end
end

function module:ResetWeeklyQuests(Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	if QuestData.ActiveQuests then
		for QuestName, QuestPoints in QuestData.ActiveQuests do
			local QuestInRegistry = questRegistry[QuestName]

			if not QuestInRegistry then
				QuestData.ActiveQuests[QuestName] = nil
				continue
			end

			if QuestInRegistry.configuration.QuestType == "Weekly" then
				QuestData.ActiveQuests[QuestName] = nil
			end
		end
	end

	QuestData.Week = QuestLib:GetTimeWeek().Time

	PlayerProfileClass:WriteField("Quests", QuestData, true)

	--for a=1, 3 do
	--	self:GiveQuest(Player, self:GetRandomQuest(Player, "Weekly"))
	--end

	local PointTypes = {}
	local QuestNames = { "AllWeekly" }

	for a = 1, 3 do
		local WeeklyName = self:GetRandomQuest(Player, "Weekly")
		local WeeklyRegistry = questRegistry[WeeklyName]

		if not WeeklyRegistry then
			repeat
				--print("repeat not found")
				WeeklyName = self:GetRandomQuest(Player, "Weekly")
				WeeklyRegistry = questRegistry[WeeklyName]
			--task.wait(.05)
			until WeeklyRegistry
		end

		if PointTypes[WeeklyRegistry.configuration.QuestPointType] or QuestData.ActiveQuests[WeeklyName] then
			repeat
				--print("repeat quest repeat")
				WeeklyName = self:GetRandomQuest(Player, "Weekly")
				WeeklyRegistry = questRegistry[WeeklyName]
			--task.wait(.05)
			until WeeklyRegistry
				and not PointTypes[WeeklyRegistry.configuration.QuestPointType]
				and not QuestData.ActiveQuests[WeeklyName]
		end

		PointTypes[WeeklyRegistry.configuration.QuestPointType] = true

		table.insert(QuestNames, WeeklyName)
		--print(WeeklyName)
	end

	self:GiveQuest(Player, QuestNames)
end

function module:CheckStoryQuests(Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")
	local CompletionData = PlayerProfileClass:GetField("MissionCompletionData")

	local MapTable = {}

	for i, v in pairs(mapOrderInfo) do
		MapTable[v] = i
	end

	local fixed = {}
	for i, map in pairs(MapTable) do
		for act = 1, 6 do
			if fixed[act] then
				continue
			end
			if not QuestData.FinishedQuests[`{map} {act}`] and not QuestData.ActiveQuests[`{map} {act}`] then
				self:GiveQuest(Player, `{map} {act}`)
				fixed[act] = true
			elseif QuestData.ActiveQuests[`{map} {act}`] then
				fixed[act] = true
			end

			if CompletionData.Story[map] and QuestData.ActiveQuests[`{map} {act}`] then
				local CompleteAmount = CompletionData.Story[map][act].CompletedTimes.Normal
					+ CompletionData.Story[map][act].CompletedTimes.Nightmare
				if CompleteAmount > 0 and QuestData.ActiveQuests[`{map} {act}`] == 0 then
					self:GivePoints(Player, `{map} {act}`, 1)
				end
			end
		end

		if fixed[1] and fixed[2] and fixed[3] and fixed[4] and fixed[5] and fixed[6] then
			break
		end
	end
end

function module:CheckDataState(Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	if QuestData.ActiveQuests == nil then
		QuestData.ActiveQuests = {}
	end

	if QuestData.FinishedQuests == nil then
		QuestData.FinishedQuests = {}
	end

	PlayerProfileClass:WriteField("Quests", QuestData, true)
end

function module:UpdateDailyTime()
	local TimeValue = game.ReplicatedStorage.GameVariables:WaitForChild("QuestDailyTime")

	if TimeValue then
		TimeValue.Value = QuestLib:FormatTimeToText(QuestLib:GetTimeDay().TimeLeft)
	end
end

function module:UpdateWeeklyTime()
	local TimeValue = game.ReplicatedStorage.GameVariables:WaitForChild("QuestWeeklyTime")

	if TimeValue then
		TimeValue.Value = QuestLib:FormatTimeToTextWithDays(QuestLib:GetTimeWeek().TimeLeft)
	end
end

local CurrentEvent = ""
local CurrentSpecial = "SoloLevelling"

local EventQuestTable = {
	["Gohan"] = {
		"GohanEvent10Runs",
		"GohanEvent5RunsDebuffs",
		"GohanEventAll",
		"GohanEventCapsule",
		"GohanEventEliminate",
		"GohanEventMultiplayer",
		"GohanEventWaves",
	},

	["Winter"] = {
		"WinterPortals",
		"WinterEliminations",
		"WinterKeys",
		"WinterMultiplayer",
		"WinterPlayMayhem",
		"WinterAll",
		"WinterSummon",
		"WinterEndlessMode",
	},
}

local SpecialQuestTable = {
	["SoloLevelling"] = {
		"Special1NPC",
		"Special2Unit",
		"Special3Unit",
		"Special4Unit",
		"Special5Unit",
		"Special6Tier6Dungeon",
		"Special7SecretPortal",
		"Special8DreamKey",
		"Special9NPC",
		"Special10NPC",
	},
	["HallowKing"] = {
		"HallowSpecial1",
		"HallowSpecial2",
		"HallowSpecial3",
		"HallowSpecial4",
		"HallowSpecial5",
	},
}

function module:UpdateEventQuests(Player)
	--warn('Updating Event Quests')
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	if CurrentEvent == "" then
		local cleared = false

		for questName, points in pairs(QuestData.ActiveQuests) do
			local QuestInRegistry = questRegistry[questName]
			if QuestInRegistry then
				if QuestInRegistry.configuration.QuestType == "Event" then
					QuestData.ActiveQuests[questName] = nil
					cleared = true
				end
			end
		end

		if cleared then
			PlayerProfileClass:WriteField("Quests", QuestData, true)
		end

		return
	end

	local FinalList = {}
	local Points = 0

	for i, questName in pairs(EventQuestTable[CurrentEvent]) do
		if not QuestData.ActiveQuests[questName] and not QuestData.FinishedQuests[questName] then
			table.insert(FinalList, questName)
		end

		--if QuestData.FinishedQuests[questName] and questName ~= "Special9NPC" then
		--	Points += 1
		--end
	end

	if #FinalList ~= 0 then
		module:GiveQuest(Player, FinalList)
	end

	if QuestData.ActiveQuests["Special9NPC"] and QuestData.ActiveQuests["Special9NPC"] ~= Points then
		module:SetPoints(Player, "Special9NPC", Points)
	end
end

function module:UpdateSpecialQuests(Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	local QuestData = PlayerProfileClass:GetField("Quests")

	if CurrentSpecial == "" then
		local cleared = false

		for questName, points in pairs(QuestData.ActiveQuests) do
			local QuestInRegistry = questRegistry[questName]
			if QuestInRegistry then
				if QuestInRegistry.configuration.QuestType == "Special" then
					QuestData.ActiveQuests[questName] = nil
					cleared = true
				end
			end
		end

		if cleared then
			PlayerProfileClass:WriteField("Quests", QuestData, true)
		end

		return
	end

	local FinalList = {}
	local Points = 0

	for i, questName in pairs(SpecialQuestTable[CurrentSpecial]) do
		if not QuestData.ActiveQuests[questName] and not QuestData.FinishedQuests[questName] then
			table.insert(FinalList, questName)
		end

		--if QuestData.FinishedQuests[questName] and questName ~= "Special9NPC" then
		--Points += 1
		--end
	end

	if #FinalList ~= 0 then
		module:GiveQuest(Player, FinalList)
	end
	module:CompleteSpecialQuests(Player)

	--if QuestData.ActiveQuests["Special9NPC"] and QuestData.ActiveQuests["Special9NPC"] ~= Points then
	--	module:SetPoints(Player, "Special9NPC", Points)
	--end
end

local a = 0
function module:CompleteSpecialQuests(Player: Player)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
	local UnlockedUnits = PlayerProfileClass:GetField("IndexData").UnlockedUnits
	local QuestData = PlayerProfileClass:GetField("Quests")
	local itemService = _G.serverServices.ItemManager

	if not QuestData then
		return
	end
	if not itemService then
		return
	end
	if not UnlockedUnits then
		return
	end

	--if a == 0 then
	--	a = 1
	--	--if game.PlaceId == 87542414930759 then
	--		--if QuestData.FinishedQuests["HallowSpecial5"] then
	--			for _,QuestName in SpecialQuestTable.HallowKing do
	--				QuestData.FinishedQuests[QuestName] = nil
	--				--QuestData.ActiveQuests[QuestName] = 1
	--			end

	--			--QuestData.ActiveQuests["HallowSpecial4"] = 0
	--			QuestData.FinishedQuests["HallowSpecial4"] = nil
	--			--QuestData.ActiveQuests["HallowSpecial5"] = 0
	--			QuestData.FinishedQuests["HallowSpecial5"] = nil

	--			PlayerProfileClass:WriteField("Quests", QuestData, true)
	--		--end
	--	--end
	--end
	--warn("Completing Quests if any!")

	--if a == 0 then
	--	a = 1
	--for _,QuestName in SpecialQuestTable.SoloLevelling do
	--	QuestData.FinishedQuests[QuestName] = true
	--	QuestData.ActiveQuests[QuestName] = 25
	--end

	--PlayerProfileClass:WriteField("Quests", QuestData, true)
	--end
	--warn("Completing Quests if any!")

	if
		QuestData.FinishedQuests.Special8DreamKey
		and QuestData.FinishedQuests.Special1NPC
		and QuestData.FinishedQuests.Special2Unit
		and QuestData.FinishedQuests.Special3Unit
		and QuestData.FinishedQuests.Special4Unit
		and QuestData.FinishedQuests.Special5Unit
		and QuestData.FinishedQuests.Special6Tier6Dungeon
		and QuestData.FinishedQuests.Special7SecretPortal
	then
		if not QuestData.FinishedQuests.Special9NPC then
			self:SetPoints(Player, "Special9NPC", 1)
		end
		if not QuestData.FinishedQuests.Special10NPC then
			self:SetPoints(Player, "Special10NPC", 1)
		end
	end

	if
		QuestData.ActiveQuests["Special8DreamKey"]
		and QuestData.ActiveQuests["Special8DreamKey"] ~= 1
		and not QuestData.FinishedQuests["Special8DreamKey"]
	then
		local hasItem = itemService:HasItem(Player, "DreamKey", 1)
		if hasItem then
			itemService:GiveItems(Player, { ["DreamKey"] = -1 }, nil, true)
			self:SetPoints(Player, "Special8DreamKey", 1)
		end
	end

	if
		QuestData.ActiveQuests["Special5Unit"]
		and QuestData.ActiveQuests["Special5Unit"] ~= 1
		and not QuestData.FinishedQuests["Special5Unit"]
	then
		local hasUnit = UnlockedUnits["Kargalgan [Evo2]"]
		if hasUnit then
			self:SetPoints(Player, "Special5Unit", 1)
		end
	end

	if
		QuestData.ActiveQuests["Special4Unit"]
		and QuestData.ActiveQuests["Special4Unit"] ~= 1
		and not QuestData.FinishedQuests["Special4Unit"]
	then
		local hasUnit = UnlockedUnits["Igris [Evo2]"]
		if hasUnit then
			self:SetPoints(Player, "Special4Unit", 1)
		end
	end

	if
		QuestData.ActiveQuests["Special3Unit"]
		and QuestData.ActiveQuests["Special3Unit"] ~= 1
		and not QuestData.FinishedQuests["Special3Unit"]
	then
		local hasUnit = UnlockedUnits["Beru [Evo2]"]
		if hasUnit then
			self:SetPoints(Player, "Special3Unit", 1)
		end
	end

	if
		QuestData.ActiveQuests["Special2Unit"]
		and QuestData.ActiveQuests["Special2Unit"] ~= 1
		and not QuestData.FinishedQuests["Special2Unit"]
	then
		local hasUnit = UnlockedUnits["Iron [Evo2]"]
		if hasUnit then
			self:SetPoints(Player, "Special2Unit", 1)
		end
	end

	if
		QuestData.ActiveQuests["RebornQuest1"]
		and QuestData.ActiveQuests["RebornQuest1"] ~= 1
		and not QuestData.FinishedQuests["RebornQuest1"]
	then
		local hasUnit = UnlockedUnits["Vegeta [Evo]"]
		if hasUnit then
			self:SetPoints(Player, "RebornQuest1", 1)
		end
	end

	if
		QuestData.ActiveQuests["RebornQuest2"]
		and QuestData.ActiveQuests["RebornQuest2"] ~= 1
		and not QuestData.FinishedQuests["RebornQuest2"]
	then
		local hasUnit = UnlockedUnits["Jiren [Evo]"]
		if hasUnit then
			self:SetPoints(Player, "RebornQuest2", 1)
		end
	end

	if
		QuestData.ActiveQuests["RebornQuest3"]
		and QuestData.ActiveQuests["RebornQuest3"] ~= 1
		and not QuestData.FinishedQuests["RebornQuest3"]
	then
		local hasUnit = UnlockedUnits["Freiza [Evo]"]
		if hasUnit then
			self:SetPoints(Player, "RebornQuest3", 1)
		end
	end

	if
		QuestData.ActiveQuests["RebornQuest4"]
		and QuestData.ActiveQuests["RebornQuest4"] ~= 1
		and not QuestData.FinishedQuests["RebornQuest4"]
	then
		local hasUnit = UnlockedUnits["Whis [Evo]"]
		if hasUnit then
			self:SetPoints(Player, "RebornQuest4", 1)
		end
	end

	--for i, name in pairs(SpecialQuestTable.SoloLevelling) do

	--	local InActive = QuestData.ActiveQuests[name]
	--	local InRegistry = questRegistry[name]
	--	local InFinish = QuestData.FinishedQuests[name]
	--	if InActive and InRegistry and not InFinish then
	--		--warn("Exists as Active", InActive, InRegistry, InFinish)
	--		local RequiredUnit = InRegistry["RequiredUnit"]
	--		local RequiredItem = InRegistry["RequiredItem"]
	--		if RequiredUnit then
	--			warn("Required Unit", RequiredUnit, UnlockedUnits[RequiredUnit])
	--		end
	--		if RequiredUnit and UnlockedUnits and UnlockedUnits[RequiredUnit] then
	--			warn("Quest Complete!")
	--			self:SetPoints(Player, name, 1)
	--		end
	--		if RequiredItem then
	--			warn("Required Item Exists!")
	--			local hasItem = itemService:HasItem(Player, RequiredItem, 1)
	--			if hasItem then
	--				itemService:GiveItems(Player, {[RequiredItem] = -1}, nil, true)
	--			end
	--			self:SetPoints(Player, name, 1)
	--		end
	--	end

	--end
end

function module:start()
	for Name, Data in questRegistry do
		if Data.configuration.Available then
			table.insert(QuestTypesTable[Data.configuration.QuestType], Name)
		end
	end

	game.Players.PlayerAdded:Connect(function(player)
		self:CheckWeeklyQuests(player)
		self:CheckDailyQuests(player)
		self:CheckStoryQuests(player)
		self:CheckDataState(player)
		module:FixQuests(player)
		module:UpdateEventQuests(player)
		module:UpdateSpecialQuests(player)
	end)

	for i, player in pairs(game.Players:GetChildren()) do
		self:CheckWeeklyQuests(player)
		self:CheckDailyQuests(player)
		self:CheckStoryQuests(player)
		self:CheckDataState(player)
		module:UpdateEventQuests(player)
		module:UpdateSpecialQuests(player)
	end

	task.spawn(function()
		while task.wait(3) do
			for i, player in pairs(game.Players:GetChildren()) do
				local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
				local succ, err = pcall(function()
					self:CheckWeeklyQuests(player)
					--local QuestData = PlayerProfileClass:GetField("Quests")
					--print(QuestData.ActiveQuests)
					--print("Check week")
					--task.wait(1)

					self:CheckDailyQuests(player)
					--local QuestData = PlayerProfileClass:GetField("Quests")
					--print(QuestData.ActiveQuests)
					--print("Check day")
					--task.wait(1)

					self:CheckStoryQuests(player)
					--local QuestData = PlayerProfileClass:GetField("Quests")
					--print(QuestData.ActiveQuests)
					--print("Check story")
					--task.wait(1)

					module:FixQuests(player)
					--local QuestData = PlayerProfileClass:GetField("Quests")
					--print(QuestData.ActiveQuests)
					--print("fix")
					--task.wait(1)

					module:UpdateEventQuests(player)
					--local QuestData = PlayerProfileClass:GetField("Quests")
					--print(QuestData.ActiveQuests)
					--print("Check event")
					--task.wait(1)
					module:UpdateSpecialQuests(player)
				end)

				if not succ then
					warn(err, debug.traceback())
				end
			end
		end
	end)

	task.spawn(function()
		while task.wait(0.5) do
			self:UpdateDailyTime()
			self:UpdateWeeklyTime()
		end
	end)

	--task.spawn(function()
	--	while task.wait(3) do
	--		for i,player in pairs(game.Players:GetChildren()) do
	--			local succ, err = pcall(function()
	--				module:FixQuests(player)
	--				module:UpdateEventQuests(player)
	--			end)

	--			if not succ then
	--				warn(err, debug.traceback())
	--			end
	--		end
	--	end
	--end)

	Events.Quests.OnServerInvoke = function(Player, action, ...)
		local Function = QuestFunctions[action]
		if not Function then
			warn(`No such quests function {action}`)
			return nil
		end
		local ToReturn = Function(QuestFunctions, Player, ...)
		return ToReturn
	end
end

return module
