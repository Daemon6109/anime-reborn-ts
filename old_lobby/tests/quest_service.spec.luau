--------------------------------------------------------------------------------
-- quest_service.spec
-- Tests the quest service functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local jest = JestGlobals.jest

-- Import modules to test
local QuestService = require("@server/quest_service")

-- Mock dependencies
local Players = game:GetService("Players")

local MockPlayer = {
	UserId = 12345,
	Name = "TestPlayer",
	Parent = Players,
}

local MockPerson = {
	getPlayer = function()
		return MockPlayer
	end,
}

-- Mock quest registry
local MockQuestRegistry = {
	["DailyWin5Games"] = {
		configuration = {
			DisplayName = "Win 5 Games",
			QuestType = "Daily",
			PointsNeeded = 5,
			QuestPointType = "GameWin",
		},
		Complete = function(self, player)
			-- Mock completion callback
		end,
	},
	["StoryQuest1"] = {
		configuration = {
			DisplayName = "Story Quest 1",
			QuestType = "Story",
			PointsNeeded = 1,
			QuestToGiveAfter = "StoryQuest2",
		},
		Complete = function(self, player)
			-- Mock completion callback
		end,
	},
	["WeeklyChallenge"] = {
		configuration = {
			DisplayName = "Weekly Challenge",
			QuestType = "Weekly",
			PointsNeeded = 10,
		},
		Complete = function(self, player)
			-- Mock completion callback
		end,
	},
}

-- Setup mock global registry
_G.Registry = {
	registry = {
		Quests = MockQuestRegistry,
	},
}

describe("QuestService", function()
	local questService

	beforeEach(function()
		-- Reset the service before each test
		questService = require("@server/quest_service")
	end)

	describe("claimQuest", function()
		it("should successfully claim a completed quest", function()
			-- Give the player a quest and complete it
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 5)

			local result = questService:claimQuest(MockPerson, "DailyWin5Games")

			expect(result.Result).toBe(true)
			expect(result.Message).toContain("Win 5 Games")
		end)

		it("should fail to claim an incomplete quest", function()
			-- Give the player a quest but don't complete it
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 3)

			local result = questService:claimQuest(MockPerson, "DailyWin5Games")

			expect(result.Result).toBe(false)
			expect(result.Message).toBe("Finish the quest before claiming the reward!")
		end)

		it("should fail to claim a non-existent quest", function()
			local result = questService:claimQuest(MockPerson, "NonExistentQuest")

			expect(result.Result).toBe(false)
			expect(result.Message).toBe("Quest not found")
		end)

		it("should fail to claim a quest that is not active", function()
			local result = questService:claimQuest(MockPerson, "DailyWin5Games")

			expect(result.Result).toBe(false)
			expect(result.Message).toBe("Quest not active")
		end)

		it("should give follow-up quest after claiming", function()
			-- Mock the giveQuest method to track calls
			local giveQuestCalled = false
			local originalGiveQuest = questService.giveQuest
			questService.giveQuest = function(self, person, questName)
				if questName == "StoryQuest2" then
					giveQuestCalled = true
				end
				return originalGiveQuest(self, person, questName)
			end

			questService:giveQuest(MockPerson, "StoryQuest1")
			questService:givePoints(MockPerson, "StoryQuest1", 1)
			questService:claimQuest(MockPerson, "StoryQuest1")

			expect(giveQuestCalled).toBe(true)

			-- Restore original method
			questService.giveQuest = originalGiveQuest
		end)
	end)

	describe("giveQuest", function()
		it("should give a quest to a player", function()
			questService:giveQuest(MockPerson, "DailyWin5Games")

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["DailyWin5Games"]).toBe(0)
		end)

		it("should not give a quest that doesn't exist", function()
			-- This should not error, just warn
			questService:giveQuest(MockPerson, "NonExistentQuest")

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["NonExistentQuest"]).toBeNil()
		end)

		it("should not give a quest that is already active", function()
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:giveQuest(MockPerson, "DailyWin5Games") -- Try to give again

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["DailyWin5Games"]).toBe(0)
		end)
	end)

	describe("givePoints", function()
		it("should add points to an active quest", function()
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 3)

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["DailyWin5Games"]).toBe(3)
		end)

		it("should add more points to an existing quest", function()
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 2)
			questService:givePoints(MockPerson, "DailyWin5Games", 1)

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["DailyWin5Games"]).toBe(3)
		end)

		it("should not add points to a non-existent quest", function()
			questService:givePoints(MockPerson, "NonExistentQuest", 5)

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["NonExistentQuest"]).toBeNil()
		end)

		it("should not add points to an inactive quest", function()
			questService:givePoints(MockPerson, "DailyWin5Games", 5)

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["DailyWin5Games"]).toBeNil()
		end)
	end)

	describe("givePointsByType", function()
		it("should add points to quests matching the point type", function()
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePointsByType(MockPerson, "GameWin", 2)

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["DailyWin5Games"]).toBe(2)
		end)

		it("should not add points to quests with different point types", function()
			questService:giveQuest(MockPerson, "WeeklyChallenge")
			questService:givePointsByType(MockPerson, "GameWin", 2)

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["WeeklyChallenge"]).toBe(0)
		end)
	end)

	describe("setPoints", function()
		it("should set quest points to a specific value", function()
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 3)
			questService:setPoints(MockPerson, "DailyWin5Games", 1)

			local questData = questService:getQuestData(MockPerson)
			expect(questData.ActiveQuests["DailyWin5Games"]).toBe(1)
		end)
	end)

	describe("isQuestCompleted", function()
		it("should return true for completed quests", function()
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 5)

			local isCompleted = questService:isQuestCompleted(MockPerson, "DailyWin5Games")
			expect(isCompleted).toBe(true)
		end)

		it("should return false for incomplete quests", function()
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 3)

			local isCompleted = questService:isQuestCompleted(MockPerson, "DailyWin5Games")
			expect(isCompleted).toBe(false)
		end)

		it("should return false for non-existent quests", function()
			local isCompleted = questService:isQuestCompleted(MockPerson, "NonExistentQuest")
			expect(isCompleted).toBe(false)
		end)
	end)

	describe("getActiveQuests", function()
		it("should return all active quests for a player", function()
			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:giveQuest(MockPerson, "WeeklyChallenge")
			questService:givePoints(MockPerson, "DailyWin5Games", 2)

			local activeQuests = questService:getActiveQuests(MockPerson)

			expect(activeQuests["DailyWin5Games"]).toBe(2)
			expect(activeQuests["WeeklyChallenge"]).toBe(0)
		end)

		it("should return empty table for player with no active quests", function()
			local activeQuests = questService:getActiveQuests(MockPerson)

			expect(next(activeQuests)).toBeNil()
		end)
	end)

	describe("events", function()
		it("should fire questProgressUpdated when points are given", function()
			local eventFired = false
			local connection = questService.questProgressUpdated:connect(function(person, questName, progress)
				if questName == "DailyWin5Games" and progress == 3 then
					eventFired = true
				end
			end)

			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 3)

			expect(eventFired).toBe(true)
			connection:disconnect()
		end)

		it("should fire questCompleted when quest is claimed", function()
			local eventFired = false
			local connection = questService.questCompleted:connect(function(person, questName)
				if questName == "DailyWin5Games" then
					eventFired = true
				end
			end)

			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 5)
			questService:claimQuest(MockPerson, "DailyWin5Games")

			expect(eventFired).toBe(true)
			connection:disconnect()
		end)

		it("should fire questClaimed when quest claim is attempted", function()
			local eventFired = false
			local connection = questService.questClaimed:connect(function(person, questName, result)
				if questName == "DailyWin5Games" and result.Result == false then
					eventFired = true
				end
			end)

			questService:giveQuest(MockPerson, "DailyWin5Games")
			questService:givePoints(MockPerson, "DailyWin5Games", 3) -- Not enough to complete
			questService:claimQuest(MockPerson, "DailyWin5Games")

			expect(eventFired).toBe(true)
			connection:disconnect()
		end)
	end)
end)
