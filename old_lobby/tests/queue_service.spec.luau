--------------------------------------------------------------------------------
-- queue_service.spec
-- Tests the queue service functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local jest = JestGlobals.jest

-- Import modules to test
local QueueService = require("@server/queue_service")

-- Mock dependencies
local Players = game:GetService("Players")

local MockPlayer = {
	UserId = 12345,
	Name = "TestPlayer",
	DisplayName = "TestPlayer",
	Parent = Players,
} :: Player

local MockPerson = {
	player = MockPlayer,
	dataCache = function()
		return {}
	end,
}

local TestQueueConfig = {
	mode = "Dungeon",
	mapName = "TestMap",
	difficulty = "Normal",
	minPlayers = 1,
	maxPlayers = 4,
	waitTime = 5, -- Short for testing
}

describe("QueueService", function()
	beforeEach(function()
		-- Reset any state before each test
		-- Note: In a real test environment, you'd want to clean up active queues
	end)

	describe("createQueue", function()
		it("should create a new queue with valid configuration", function()
			local queue = QueueService.createQueue("test_queue_1", TestQueueConfig)

			expect(queue).toBeDefined()
			expect(queue.id).toBe("test_queue_1")
			expect(queue.config).toEqual(TestQueueConfig)
			expect(#queue.players).toBe(0)
			expect(queue.startTime).toBeNil()
		end)

		it("should throw error for duplicate queue IDs", function()
			QueueService.createQueue("duplicate_queue", TestQueueConfig)

			expect(function()
				QueueService.createQueue("duplicate_queue", TestQueueConfig)
			end).toThrow()
		end)
	end)

	describe("joinQueue", function()
		it("should add player to queue successfully", function()
			QueueService.createQueue("join_test_queue", TestQueueConfig)
			local success = QueueService.joinQueue(MockPerson, "join_test_queue")

			expect(success).toBe(true)
		end)

		it("should fail to join non-existent queue", function()
			local success = QueueService.joinQueue(MockPerson, "non_existent_queue")
			expect(success).toBe(false)
		end)

		it("should not allow player to join multiple queues", function()
			QueueService.createQueue("multi_queue_1", TestQueueConfig)
			QueueService.createQueue("multi_queue_2", TestQueueConfig)

			QueueService.joinQueue(MockPerson, "multi_queue_1")
			local success = QueueService.joinQueue(MockPerson, "multi_queue_2")

			expect(success).toBe(false)
		end)
	end)

	describe("leaveQueue", function()
		it("should remove player from queue", function()
			QueueService.createQueue("leave_test_queue", TestQueueConfig)
			QueueService.joinQueue(MockPerson, "leave_test_queue")

			local success = QueueService.leaveQueue(MockPerson)
			expect(success).toBe(true)
		end)

		it("should fail when player is not in queue", function()
			local success = QueueService.leaveQueue(MockPerson)
			expect(success).toBe(false)
		end)
	end)

	describe("getPlayerQueue", function()
		it("should return queue data when player is in queue", function()
			QueueService.createQueue("player_queue_test", TestQueueConfig)
			QueueService.joinQueue(MockPerson, "player_queue_test")

			local queueData = QueueService.getPlayerQueue(MockPerson)
			expect(queueData).toBeDefined()
			expect(queueData.id).toBe("player_queue_test")
		end)

		it("should return nil when player is not in queue", function()
			local queueData = QueueService.getPlayerQueue(MockPerson)
			expect(queueData).toBeNil()
		end)
	end)

	describe("checkQueueStart", function()
		it("should execute without errors", function()
			QueueService.createQueue("start_check_queue", TestQueueConfig)

			expect(function()
				QueueService.checkQueueStart("start_check_queue")
			end).never.toThrow()
		end)

		it("should handle non-existent queue gracefully", function()
			expect(function()
				QueueService.checkQueueStart("non_existent_queue")
			end).never.toThrow()
		end)
	end)

	describe("cancelQueue", function()
		it("should cancel queue and clean up", function()
			QueueService.createQueue("cancel_test_queue", TestQueueConfig)
			QueueService.joinQueue(MockPerson, "cancel_test_queue")

			expect(function()
				QueueService.cancelQueue("cancel_test_queue")
			end).never.toThrow()

			-- Player should no longer be in queue
			local queueData = QueueService.getPlayerQueue(MockPerson)
			expect(queueData).toBeNil()
		end)

		it("should handle non-existent queue gracefully", function()
			expect(function()
				QueueService.cancelQueue("non_existent_queue")
			end).never.toThrow()
		end)
	end)

	describe("destroyQueue", function()
		it("should clean up queue resources", function()
			QueueService.createQueue("destroy_test_queue", TestQueueConfig)
			QueueService.joinQueue(MockPerson, "destroy_test_queue")

			expect(function()
				QueueService.destroyQueue("destroy_test_queue")
			end).never.toThrow()

			-- Player should no longer be in queue
			local queueData = QueueService.getPlayerQueue(MockPerson)
			expect(queueData).toBeNil()
		end)

		it("should handle non-existent queue gracefully", function()
			expect(function()
				QueueService.destroyQueue("non_existent_queue")
			end).never.toThrow()
		end)
	end)

	describe("version", function()
		it("should have a valid version", function()
			expect(QueueService.version).toBeDefined()
			expect(QueueService.version.major).toBe(1)
			expect(QueueService.version.minor).toBe(0)
			expect(QueueService.version.patch).toBe(0)
		end)
	end)

	describe("events", function()
		it("should have queue events", function()
			expect(QueueService.playerJoinedQueue).toBeDefined()
			expect(QueueService.playerLeftQueue).toBeDefined()
			expect(QueueService.queueStarted).toBeDefined()
			expect(QueueService.queueCancelled).toBeDefined()
		end)
	end)
end)
