--------------------------------------------------------------------------------
-- TeleportHandler Tests
-- Tests the teleport handler functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Data = require("@commonserver/data")
local TeleportHandler = require("@server/teleport_handler")

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
	GetAttribute = function(self, name)
		return false
	end,
	SetAttribute = function(self, name, value) end,
	Kick = function(self, reason) end,
} :: Player

local MockPerson = {
	player = MockPlayer,
	dataCache = function()
		return {
			MissionCompletionData = {
				Story = {
					Tutorial = {
						[1] = true, -- First scenario completed
					},
				},
			},
		}
	end,
	sessionData = {},
	Dispose = function(self) end,
}

describe("TeleportHandler", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	it("should have correct version", function()
		expect(TeleportHandler.version).toEqual({ major = 1, minor = 0, patch = 0 })
	end)

	it("should allow access to first scenario", function()
		local canAccess = TeleportHandler.canAccessMission(MockPerson, "Story", "AnyMap", 1)
		expect(canAccess).toBe(true)
	end)

	it("should allow access to unlocked scenarios", function()
		local canAccess = TeleportHandler.canAccessMission(MockPerson, "Story", "Tutorial", 2)
		expect(canAccess).toBe(true)
	end)

	it("should deny access to locked scenarios", function()
		local canAccess = TeleportHandler.canAccessMission(MockPerson, "Story", "Tutorial", 3)
		expect(canAccess).toBe(false)
	end)

	it("should deny access to non-existent map progress", function()
		local canAccess = TeleportHandler.canAccessMission(MockPerson, "Story", "NonExistentMap", 2)
		expect(canAccess).toBe(false)
	end)

	it("should handle teleport requests gracefully", function()
		-- Mock player already teleporting
		MockPlayer.GetAttribute = function(self, name)
			if name == "Teleporting" then
				return true
			end
			return false
		end

		expect(function()
			TeleportHandler.teleportPlayer(MockPerson, "Story", "Tutorial", 1)
		end).never.toThrow()
	end)

	it("should initialize without errors", function()
		expect(function()
			TeleportHandler.init()
		end).never.toThrow()
	end)
end)
