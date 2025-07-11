--------------------------------------------------------------------------------
-- Hell Tower Service Tests
-- Tests the Hell Tower service functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Mock dependencies
local Players = game:GetService("Players")

-- Create a mock player instance
local MockPlayer = (
	{
		UserId = 12345,
		Name = "TestPlayer",
		DisplayName = "TestPlayer",
		Parent = Players,
		CharacterAdded = {
			Connect = function(self, callback)
				return { Disconnect = function() end }
			end,
		},
		GetAttribute = function(self, name)
			return false
		end,
		SetAttribute = function(self, name, value) end,
		Kick = function(self, reason) end,
	} :: any
) :: Player

-- Create a minimal mock Person that satisfies the interface
local MockPerson = {
	player = MockPlayer,
} :: any -- Using any to bypass strict typing for test

describe("Hell Tower Service", function()
	local hellTowerService

	beforeEach(function()
		-- Import the service to test
		hellTowerService = require("@server/hell_tower_service")
	end)

	describe("Service Functions", function()
		it("should have required functions", function()
			expect(hellTowerService.completeRoom).toBeDefined()
			expect(hellTowerService.claimMilestone).toBeDefined()
			expect(hellTowerService.getTowerData).toBeDefined()
			expect(hellTowerService.startTowerTeleport).toBeDefined()
			expect(hellTowerService.resetForNewSeason).toBeDefined()
		end)
	end)

	describe("completeRoom", function()
		it("should complete a room successfully", function()
			local result = hellTowerService.completeRoom(MockPerson, 1, 100)

			expect(result).toBeDefined()
			expect(result.Success).toBe(true)
		end)

		it("should handle invalid room completion", function()
			local result = hellTowerService.completeRoom(MockPerson, 0, 100)

			expect(result.Success).toBe(false)
			expect(result.Message).toBeDefined()
		end)
	end)

	describe("getTowerData", function()
		it("should return tower data", function()
			local data = hellTowerService.getTowerData(MockPerson)

			expect(data).toBeDefined()
			expect(data.HighestRoom).toBeGreaterThanOrEqual(0)
			expect(data.Season).toBeGreaterThanOrEqual(1)
			expect(data.RoomCompletionData).toBeDefined()
			expect(data.ClaimData).toBeDefined()
		end)
	end)

	describe("startTowerTeleport", function()
		it("should handle teleportation requests", function()
			local result = hellTowerService.startTowerTeleport(MockPerson, 1, "Normal")

			expect(result).toBeDefined()
			expect(result.Success).toBe(true)
		end)

		it("should reject invalid difficulty", function()
			local result = hellTowerService.startTowerTeleport(MockPerson, 1, "Invalid")

			expect(result.Success).toBe(false)
			expect(result.Message).toBeDefined()
		end)
	end)

	describe("milestone functions", function()
		it("should check if milestone can be claimed", function()
			local canClaim = hellTowerService.canClaimMilestone(MockPerson, 1)

			expect(typeof(canClaim)).toBe("boolean")
		end)

		it("should get available milestones", function()
			local milestones = hellTowerService.getAvailableMilestones(MockPerson)

			expect(milestones).toBeDefined()
			expect(typeof(milestones)).toBe("table")
		end)

		it("should get claimed milestones", function()
			local claimed = hellTowerService.getClaimedMilestones(MockPerson)

			expect(claimed).toBeDefined()
			expect(typeof(claimed)).toBe("table")
		end)
	end)

	describe("utility functions", function()
		it("should get highest room", function()
			local highestRoom = hellTowerService.getHighestRoom(MockPerson)

			expect(typeof(highestRoom)).toBe("number")
			expect(highestRoom).toBeGreaterThanOrEqual(0)
		end)

		it("should get current season", function()
			local season = hellTowerService.getCurrentSeason()

			expect(typeof(season)).toBe("number")
			expect(season).toBeGreaterThanOrEqual(1)
		end)
	end)
end)
