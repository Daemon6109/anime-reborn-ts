--------------------------------------------------------------------------------
-- Collision Tests
-- Tests the collision system functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Collision = require("@server/collision")

-- Mock dependencies
local PhysicsService = game:GetService("PhysicsService")

describe("Collision", function()
	beforeEach(function()
		-- Clean up any existing collision groups for testing
		pcall(function()
			PhysicsService:UnregisterCollisionGroup("GeneralCollisions")
		end)
	end)

	it("should have correct version", function()
		expect(Collision.version).toEqual({ major = 1, minor = 0, patch = 0 })
	end)

	it("should initialize collision system", function()
		expect(function()
			Collision.init()
		end).never.toThrow()
	end)

	it("should handle character collision setup", function()
		local mockCharacter = Instance.new("Model")
		mockCharacter.Name = "TestCharacter"

		local mockPart = Instance.new("Part")
		mockPart.Name = "TestPart"
		mockPart.Parent = mockCharacter

		local mockPlayer = {
			Name = "TestPlayer",
			UserId = 12345,
		} :: Player

		expect(function()
			Collision.onCharacterAdded(mockPlayer, mockCharacter)
		end).never.toThrow()

		expect(mockPart.CollisionGroup).toBe("GeneralCollisions")

		-- Cleanup
		mockCharacter:Destroy()
	end)
end)
