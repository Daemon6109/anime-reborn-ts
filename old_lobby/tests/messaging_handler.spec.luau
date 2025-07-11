--------------------------------------------------------------------------------
-- MessagingHandler Tests
-- Tests the messaging handler functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local MessagingHandler = require("@server/messaging_handler")

describe("MessagingHandler", function()
	beforeEach(function()
		-- Initialize for testing
		MessagingHandler.init()
	end)

	it("should have correct version", function()
		expect(MessagingHandler.version).toEqual({ major = 1, minor = 0, patch = 0 })
	end)

	it("should calculate messaging limits correctly", function()
		local limit = MessagingHandler.getMessagesLimit()
		expect(type(limit)).toBe("number")
		expect(limit).toBeGreaterThan(0)
	end)

	it("should get current minute timestamp", function()
		local minute = MessagingHandler.getCurrentMinute()
		expect(type(minute)).toBe("number")
		expect(minute).toBeGreaterThan(0)
	end)

	it("should refresh counter properly", function()
		expect(function()
			MessagingHandler.refreshCounter()
		end).never.toThrow()
	end)

	it("should check publish capability", function()
		local canPublish = MessagingHandler.canPublish()
		expect(type(canPublish)).toBe("boolean")
	end)

	it("should process string values", function()
		local result = MessagingHandler.processValue("test string")
		expect(result).toBe("test string")
	end)

	it("should process table values to JSON", function()
		local testData = { test = "value", number = 123 }
		local result = MessagingHandler.processValue(testData)
		expect(type(result)).toBe("string")
		expect(result).toContain("test")
		expect(result).toContain("value")
	end)

	it("should handle invalid values gracefully", function()
		-- Functions can't be JSON encoded
		local result = MessagingHandler.processValue(function() end)
		expect(result).toBe(nil)
	end)

	it("should manage delayed messages", function()
		MessagingHandler.addDelayedMessage("test", "message1")
		MessagingHandler.addDelayedMessage("test", "message2")

		-- Should not add duplicates
		MessagingHandler.addDelayedMessage("test", "message1")

		MessagingHandler.removeDelayedMessage("test", "message1")

		expect(function()
			MessagingHandler.processDelayedMessages()
		end).never.toThrow()
	end)

	it("should publish messages", function()
		-- This will likely fail in test environment due to MessagingService restrictions
		-- but should not throw errors
		expect(function()
			MessagingHandler.publishAsync("test", { data = "test" })
		end).never.toThrow()
	end)
end)
