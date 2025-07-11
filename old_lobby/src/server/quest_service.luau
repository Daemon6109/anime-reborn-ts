--------------------------------------------------------------------------------
-- quest_service
-- Manages player quest progression, completion, and rewards
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Quest types enumeration
export type QuestType = "Daily" | "Weekly" | "Infinite" | "Story" | "Event" | "Special"

-- Quest data structures
export type QuestProgress = {
	[string]: number,
}

export type QuestData = {
	ActiveQuests: QuestProgress,
	FinishedQuests: { [string]: boolean },
	LastDailyReset: number,
	LastWeeklyReset: number,
}

export type QuestConfig = {
	DisplayName: string,
	QuestType: QuestType,
	PointsNeeded: number,
	QuestPointType: string?,
	QuestToGiveAfter: string | { string }?,
	EventType: string?,
}

export type QuestClaimResult = {
	Message: string,
	Result: boolean,
}

--- @class QuestService
--- Quest management service for handling player quest progression
---
--- ```luau
--- local QuestService = require("quest_service")
---
--- -- Claim a quest reward
--- local result = QuestService:claimQuest(person, "DailyWin5Games")
---
--- -- Give quest progress
--- QuestService:givePoints(person, "DailyWin5Games", 1)
--- ```
local QuestService = {}
QuestService.__index = QuestService

-- Events
local questCompleted = Shingo.createSignal() :: Shingo.Signal<Person.Person, string>
local questClaimed = Shingo.createSignal() :: Shingo.Signal<Person.Person, string, QuestClaimResult>
local questProgressUpdated = Shingo.createSignal() :: Shingo.Signal<Person.Person, string, number>

-- Internal state
local questRegistry = {}
local activeQuests: { [Player]: QuestData } = {}

-- Constants
local DAILY_RESET_HOUR = 0 -- UTC hour for daily reset
local WEEKLY_RESET_DAY = 1 -- Monday (1) for weekly reset
local UPDATE_INTERVAL = 0.5

--- Initialize the quest service
--- @return QuestService
function QuestService.init(): typeof(QuestService)
	local self = setmetatable({}, QuestService)

	-- Load quest registry
	if _G.Registry and _G.Registry.registry and _G.Registry.registry.Quests then
		questRegistry = _G.Registry.registry.Quests
	end

	-- Setup network handlers
	self:_setupNetworking()

	-- Start background tasks
	self:_startBackgroundTasks()

	-- Handle player connections
	Players.PlayerAdded:Connect(function(player)
		self:_setupPlayerQuests(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		activeQuests[player] = nil
	end)

	return self
end

--- Claim a completed quest reward
--- @param person Person.Person -- The player claiming the quest
--- @param questName string -- Name of the quest to claim
--- @return QuestClaimResult -- Result of the claim attempt
--- @error "Quest not found" -- If quest doesn't exist in registry
--- @error "Quest not active" -- If quest is not in player's active quests
function QuestService:claimQuest(person: Person.Person, questName: string): QuestClaimResult
	local player = person:getPlayer()
	local questData = self:_getQuestData(player)
	local questConfig = questRegistry[questName]

	if not questConfig then
		local result = { Message = "Quest not found", Result = false }
		questClaimed:fire(person, questName, result)
		return result
	end

	if not questData.ActiveQuests[questName] then
		local result = { Message = "Quest not active", Result = false }
		questClaimed:fire(person, questName, result)
		return result
	end

	local currentProgress = questData.ActiveQuests[questName]
	local pointsNeeded = questConfig.configuration and questConfig.configuration.PointsNeeded or 1

	if currentProgress >= pointsNeeded then
		-- Complete the quest
		self:_finishQuest(player, questName)
		self:_removeQuest(player, questName)

		-- Give follow-up quests if configured
		if questConfig.configuration and questConfig.configuration.QuestToGiveAfter then
			local followUps = questConfig.configuration.QuestToGiveAfter
			if type(followUps) == "table" then
				for _, questToGive in pairs(followUps) do
					self:giveQuest(person, questToGive)
				end
			else
				self:giveQuest(person, followUps)
			end
		end

		-- Call quest completion callback
		if questConfig.Complete then
			questConfig:Complete(player)
		end

		local displayName = questConfig.configuration and questConfig.configuration.DisplayName or questName
		local result = {
			Message = `You successfully claimed reward for the quest "{displayName}"!`,
			Result = true,
		}

		questClaimed:fire(person, questName, result)
		questCompleted:fire(person, questName)
		return result
	end

	local result = { Message = "Finish the quest before claiming the reward!", Result = false }
	questClaimed:fire(person, questName, result)
	return result
end

--- Give a quest to a player
--- @param person Person.Person -- The player to give the quest to
--- @param questName string -- Name of the quest to give
--- @error "Quest not found" -- If quest doesn't exist in registry
function QuestService:giveQuest(person: Person.Person, questName: string): ()
	local player = person:getPlayer()
	local questData = self:_getQuestData(player)
	local questConfig = questRegistry[questName]

	if not questConfig then
		warn(`[QuestService] Quest {questName} not found in registry`)
		return
	end

	-- Don't give quest if already completed or active
	if questData.FinishedQuests[questName] or questData.ActiveQuests[questName] then
		return
	end

	questData.ActiveQuests[questName] = 0
	self:_saveQuestData(player, questData)
end

--- Add progress points to a quest
--- @param person Person.Person -- The player to update
--- @param questName string -- Name of the quest or quest type
--- @param points number -- Number of points to add
function QuestService:givePoints(person: Person.Person, questName: string, points: number): ()
	local player = person:getPlayer()
	local questData = self:_getQuestData(player)

	if type(questName) == "table" then
		-- Handle multiple quests
		for _, name in questName do
			if questData.ActiveQuests[name] and questRegistry[name] then
				questData.ActiveQuests[name] += points
				questProgressUpdated:fire(person, name, questData.ActiveQuests[name])
			end
		end
	else
		-- Handle single quest
		if not questRegistry[questName] then
			return
		end

		if not questData.ActiveQuests[questName] then
			return
		end

		questData.ActiveQuests[questName] += points
		questProgressUpdated:fire(person, questName, questData.ActiveQuests[questName])
	end

	self:_saveQuestData(player, questData)
end

--- Give points to quests by their point type
--- @param person Person.Person -- The player to update
--- @param pointType string -- The quest point type to match
--- @param points number -- Number of points to add
function QuestService:givePointsByType(person: Person.Person, pointType: string, points: number): ()
	local player = person:getPlayer()
	local questData = self:_getQuestData(player)

	for questName, _ in questData.ActiveQuests do
		local questConfig = questRegistry[questName]
		if questConfig and questConfig.configuration and questConfig.configuration.QuestPointType == pointType then
			questData.ActiveQuests[questName] += points
			questProgressUpdated:fire(person, questName, questData.ActiveQuests[questName])
		end
	end

	self:_saveQuestData(player, questData)
end

--- Set quest progress to a specific value
--- @param person Person.Person -- The player to update
--- @param questName string -- Name of the quest
--- @param points number -- Points to set
function QuestService:setPoints(person: Person.Person, questName: string, points: number): ()
	local player = person:getPlayer()
	local questData = self:_getQuestData(player)

	if not questRegistry[questName] or not questData.ActiveQuests[questName] then
		return
	end

	questData.ActiveQuests[questName] = points
	questProgressUpdated:fire(person, questName, points)
	self:_saveQuestData(player, questData)
end

--- Get player's quest data
--- @param person Person.Person -- The player
--- @return QuestData -- The player's quest data
function QuestService:getQuestData(person: Person.Person): QuestData
	return self:_getQuestData(person:getPlayer())
end

--- Check if a quest is completed
--- @param person Person.Person -- The player
--- @param questName string -- Name of the quest
--- @return boolean -- True if quest is completed
function QuestService:isQuestCompleted(person: Person.Person, questName: string): boolean
	local questData = self:_getQuestData(person:getPlayer())
	local questConfig = questRegistry[questName]

	if not questConfig or not questData.ActiveQuests[questName] then
		return false
	end

	local pointsNeeded = questConfig.configuration and questConfig.configuration.PointsNeeded or 1
	return questData.ActiveQuests[questName] >= pointsNeeded
end

--- Get all active quests for a player
--- @param person Person.Person -- The player
--- @return QuestProgress -- Dictionary of active quest progress
function QuestService:getActiveQuests(person: Person.Person): QuestProgress
	local questData = self:_getQuestData(person:getPlayer())
	return table.clone(questData.ActiveQuests)
end

-- Private methods

function QuestService:_setupNetworking(): ()
	Network.server.quests.claimQuest:connect(function(person: Person.Person, questName: string)
		return self:claimQuest(person, questName)
	end)

	Network.server.quests.getQuestData:connect(function(person: Person.Person)
		return self:getQuestData(person)
	end)
end

function QuestService:_getQuestData(player: Player): QuestData
	if not activeQuests[player] then
		-- Load from data store or create default
		activeQuests[player] = {
			ActiveQuests = {},
			FinishedQuests = {},
			LastDailyReset = 0,
			LastWeeklyReset = 0,
		}
	end

	return activeQuests[player]
end

function QuestService:_saveQuestData(player: Player, questData: QuestData): ()
	activeQuests[player] = questData
	-- In production, this would save to DataStore
end

function QuestService:_setupPlayerQuests(player: Player): ()
	-- Initialize quest data for new player
	self:_getQuestData(player)

	-- Check for daily/weekly resets
	self:_checkResets(player)

	-- Give initial quests
	self:_giveInitialQuests(player)
end

function QuestService:_finishQuest(player: Player, questName: string): ()
	local questData = self:_getQuestData(player)
	local questConfig = questRegistry[questName]

	if not questConfig then
		return
	end

	-- Mark as finished
	questData.FinishedQuests[questName] = true

	-- Give points for quest type completion
	if questConfig.configuration then
		local questType = questConfig.configuration.QuestType
		if questType == "Daily" then
			self:givePoints(Person.fromPlayer(player), "AllDaily", 1)
		elseif questType == "Weekly" then
			self:givePoints(Person.fromPlayer(player), "AllWeekly", 1)
		elseif questType == "Event" and questConfig.configuration.EventType then
			self:givePoints(Person.fromPlayer(player), `{questConfig.configuration.EventType}EventAll`, 1)
		elseif questType == "Special" and questConfig.configuration.EventType then
			self:givePoints(Person.fromPlayer(player), `{questConfig.configuration.EventType}SpecialAll`, 1)
		end
	end

	self:_saveQuestData(player, questData)
end

function QuestService:_removeQuest(player: Player, questName: string): ()
	local questData = self:_getQuestData(player)
	questData.ActiveQuests[questName] = nil
	self:_saveQuestData(player, questData)
end

function QuestService:_giveInitialQuests(player: Player): ()
	-- Give story quests, daily quests, etc.
	-- This would be based on player level, progress, etc.
end

function QuestService:_checkResets(player: Player): ()
	local questData = self:_getQuestData(player)
	local currentTime = os.time()

	-- Check daily reset
	local lastDailyReset = questData.LastDailyReset
	local currentDate = os.date("*t", currentTime)
	local todayMidnight = os.time({
		year = currentDate.year,
		month = currentDate.month,
		day = currentDate.day,
		hour = DAILY_RESET_HOUR,
		min = 0,
		sec = 0,
	})

	if lastDailyReset < todayMidnight then
		self:_resetDailyQuests(player)
		questData.LastDailyReset = todayMidnight
	end

	-- Check weekly reset
	local lastWeeklyReset = questData.LastWeeklyReset
	local weekStart = todayMidnight - ((currentDate.wday - WEEKLY_RESET_DAY) % 7) * 24 * 60 * 60

	if lastWeeklyReset < weekStart then
		self:_resetWeeklyQuests(player)
		questData.LastWeeklyReset = weekStart
	end

	self:_saveQuestData(player, questData)
end

function QuestService:_resetDailyQuests(player: Player): ()
	local questData = self:_getQuestData(player)

	-- Remove daily quests from active and finished
	for questName, _ in pairs(questData.ActiveQuests) do
		local questConfig = questRegistry[questName]
		if questConfig and questConfig.configuration and questConfig.configuration.QuestType == "Daily" then
			questData.ActiveQuests[questName] = nil
		end
	end

	for questName, _ in pairs(questData.FinishedQuests) do
		local questConfig = questRegistry[questName]
		if questConfig and questConfig.configuration and questConfig.configuration.QuestType == "Daily" then
			questData.FinishedQuests[questName] = nil
		end
	end

	-- Give new daily quests
	-- This would be implemented based on the game's quest system
end

function QuestService:_resetWeeklyQuests(player: Player): ()
	local questData = self:_getQuestData(player)

	-- Remove weekly quests from active and finished
	for questName, _ in pairs(questData.ActiveQuests) do
		local questConfig = questRegistry[questName]
		if questConfig and questConfig.configuration and questConfig.configuration.QuestType == "Weekly" then
			questData.ActiveQuests[questName] = nil
		end
	end

	for questName, _ in pairs(questData.FinishedQuests) do
		local questConfig = questRegistry[questName]
		if questConfig and questConfig.configuration and questConfig.configuration.QuestType == "Weekly" then
			questData.FinishedQuests[questName] = nil
		end
	end

	-- Give new weekly quests
	-- This would be implemented based on the game's quest system
end

function QuestService:_startBackgroundTasks(): ()
	-- Update daily/weekly timers
	task.spawn(function()
		while true do
			task.wait(UPDATE_INTERVAL)
			for player, _ in pairs(activeQuests) do
				if player.Parent then
					self:_checkResets(player)
				end
			end
		end
	end)
end

-- Events
QuestService.questCompleted = questCompleted
QuestService.questClaimed = questClaimed
QuestService.questProgressUpdated = questProgressUpdated

-- Version
QuestService.version = version

return QuestService.init()
