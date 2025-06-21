--------------------------------------------------------------------------------
-- Performance Optimizer Tests
-- Tests the performance optimizer system functionality
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Data = require("@commonserver/data")
local PerformanceOptimizer = require("@commonserver/performance_optimizer")

-- Mock dependencies
local Players = game:GetService("Players")

local MockPlayer = {
	UserId = 12345,
	Name = "TestPlayer",
	DisplayName = "TestPlayer",
	Parent = Players,
	CharacterAdded = {
		Connect = function(self, callback)
			return { Disconnect = function() end }
		end,
	},
} :: Player

local MockPerson = {
	player = MockPlayer,
	dataCache = Charm.atom(Data.template),
	sessionData = {
		Kills = {
			Value = Charm.atom(0),
			Leaderboard = true,
			Name = "Kills 🗡️",
		},
	},
	Dispose = function(self) end,
}

describe("PerformanceOptimizer", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(PerformanceOptimizer).toBeDefined()
			expect(PerformanceOptimizer.version).toBeDefined()
			expect(typeof(PerformanceOptimizer.version)).toBe("table")
		end)

		it("should have required functions", function()
			expect(PerformanceOptimizer.getPerformanceMetrics).toBeDefined()
			expect(PerformanceOptimizer.printPerformanceReport).toBeDefined()
			expect(PerformanceOptimizer.queueDataUpdate).toBeDefined()
			expect(PerformanceOptimizer.queueAnalyticsEvent).toBeDefined()
			expect(PerformanceOptimizer.queueEffectUpdate).toBeDefined()
			expect(typeof(PerformanceOptimizer.getPerformanceMetrics)).toBe("function")
			expect(typeof(PerformanceOptimizer.printPerformanceReport)).toBe("function")
			expect(typeof(PerformanceOptimizer.queueDataUpdate)).toBe("function")
			expect(typeof(PerformanceOptimizer.queueAnalyticsEvent)).toBe("function")
		end)
	end)

	describe("Performance Functionality", function()
		it("should get performance metrics", function()
			expect(function()
				local metrics = PerformanceOptimizer.getPerformanceMetrics()
				expect(typeof(metrics)).toBe("table")
			end).never.toThrow()
		end)

		it("should print performance report without errors", function()
			expect(function()
				PerformanceOptimizer.printPerformanceReport()
			end).never.toThrow()
		end)

		it("should queue operations without errors", function()
			expect(function()
				PerformanceOptimizer.queueDataUpdate(MockPerson, "test", "data")
			end).never.toThrow()

			expect(function()
				PerformanceOptimizer.queueAnalyticsEvent(MockPlayer, "test_event", {})
			end).never.toThrow()

			expect(function()
				PerformanceOptimizer.queueEffectUpdate(MockPerson, "Exp", 100)
			end).never.toThrow()
		end)
	end)

	describe("Data Validation", function()
		it("should work with current data template", function()
			local template = Data.template
			expect(template).toBeDefined()
			expect(typeof(template)).toBe("table")
		end)
	end)
end)
