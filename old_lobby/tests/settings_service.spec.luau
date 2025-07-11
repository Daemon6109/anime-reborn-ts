--------------------------------------------------------------------------------
--!nocheck
-- SettingsService Tests
-- Tests the settings service functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Data = require("@commonserver/data")
local SettingsService = require("@server/settings_service")

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
	dataCache = function()
		return {
			Settings = {
				SoundMasterVolume = 0.5,
				UnitSFXVolume = 1,
				BGMVolume = 1,
				GeneralSFXVolume = 1,
				UnitVFX = true,
				StatusEffectVFX = true,
				AutoSkip = false,
				DamageIndicator = true,
				ShowMaxRangeOnPlace = true,
				AutoSell = {},
				DragonCapsuleAutoSell = {},
				SummonAnimation = true,
				TraitRerollCooldown = 0.5,
				LowGFX = false,
				ReducedColorIntensity = false,
				ReducedBloomntensity = false,
				PerformantWindows = false,
				AutoLockMythicals = true,
				AutoLockSecrets = true,
				InstantCrateOpen = false,
			},
		}
	end,
	updateData = function(self, key, value) end,
	sessionData = {},
	Dispose = function(self) end,
}

describe("SettingsService", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	it("should have correct version", function()
		expect(SettingsService.version).toEqual({ major = 1, minor = 0, patch = 0 })
	end)

	it("should validate numeric settings", function()
		local result = SettingsService.validateSetting(0.5, 0.8)
		expect(result).toBe(0.8)
	end)

	it("should clamp numeric settings to valid range", function()
		local result = SettingsService.validateSetting(0.5, 2.0)
		expect(result).toBe(1.0)

		result = SettingsService.validateSetting(0.5, -1.0)
		expect(result).toBe(0.0)
	end)

	it("should handle NaN values", function()
		local result = SettingsService.validateSetting(0.5, 0 / 0) -- NaN
		expect(result).toBe(0)
	end)

	it("should validate boolean settings", function()
		local result = SettingsService.validateSetting(true, false)
		expect(result).toBe(false)
	end)
	it("should reject invalid setting types", function()
		local result = SettingsService.validateSetting(0.5, "invalid")
		expect(result).toBe(nil)
	end)
	it("should update valid settings", function()
		local updateCalled = false
		local getCalled = false

		-- Mock the dataCache function with proper parameter detection
		MockPerson.dataCache = function(updateFunction)
			print("DEBUG: dataCache called, updateFunction type:", type(updateFunction))
			if type(updateFunction) == "function" then
				-- Call the update function with mock data cache
				print("DEBUG: dataCache called with updateFunction")
				local mockCache = {
					Settings = {
						SoundMasterVolume = 0.5,
						UnitSFXVolume = 1,
						BGMVolume = 1,
						GeneralSFXVolume = 1,
						UnitVFX = true,
						StatusEffectVFX = true,
						AutoSkip = false,
						DamageIndicator = true,
						ShowMaxRangeOnPlace = true,
						AutoSell = {},
						DragonCapsuleAutoSell = {},
						SummonAnimation = true,
						TraitRerollCooldown = 0.5,
						LowGFX = false,
						ReducedColorIntensity = false,
						ReducedBloomntensity = false,
						PerformantWindows = false,
						AutoLockMythicals = true,
						AutoLockSecrets = true,
						InstantCrateOpen = false,
					},
				}
				local result = updateFunction(mockCache)
				updateCalled = true
				expect(result.Settings.SoundMasterVolume).toBe(0.7)
				return result
			else
				-- Return mock data cache (this is called first to read current settings)
				print("DEBUG: dataCache called without updateFunction")
				getCalled = true
				return {
					Settings = {
						SoundMasterVolume = 0.5,
						UnitSFXVolume = 1,
						BGMVolume = 1,
						GeneralSFXVolume = 1,
						UnitVFX = true,
						StatusEffectVFX = true,
						AutoSkip = false,
						DamageIndicator = true,
						ShowMaxRangeOnPlace = true,
						AutoSell = {},
						DragonCapsuleAutoSell = {},
						SummonAnimation = true,
						TraitRerollCooldown = 0.5,
						LowGFX = false,
						ReducedColorIntensity = false,
						ReducedBloomntensity = false,
						PerformantWindows = false,
						AutoLockMythicals = true,
						AutoLockSecrets = true,
						InstantCrateOpen = false,
					},
				}
			end
		end
		print("DEBUG: About to call updateSettings")
		print("DEBUG: Testing with SoundMasterVolume = 0.7")
		print("DEBUG: validateSetting(0.5, 0.7) =", SettingsService.validateSetting(0.5, 0.7))

		-- Debug the currentSettings issue
		local testCache = MockPerson.dataCache()
		print("DEBUG: testCache.Settings =", testCache.Settings)
		print("DEBUG: testCache.Settings.SoundMasterVolume =", testCache.Settings.SoundMasterVolume)

		local result = SettingsService.updateSettings(MockPerson, { SoundMasterVolume = 0.7 })
		print("DEBUG: updateSettings returned:", result)
		print("DEBUG: getCalled:", getCalled, "updateCalled:", updateCalled)
		expect(updateCalled).toBe(true)
	end)
	it("should ignore unknown settings", function()
		local updateCalled = false
		MockPerson.dataCache = function(updateFunction)
			if type(updateFunction) == "function" then
				updateCalled = true
				return nil
			else
				return {
					Settings = {
						SoundMasterVolume = 0.5,
						UnitSFXVolume = 1,
						BGMVolume = 1,
						GeneralSFXVolume = 1,
						UnitVFX = true,
						StatusEffectVFX = true,
						AutoSkip = false,
						DamageIndicator = true,
						ShowMaxRangeOnPlace = true,
						AutoSell = {},
						DragonCapsuleAutoSell = {},
						SummonAnimation = true,
						TraitRerollCooldown = 0.5,
						LowGFX = false,
						ReducedColorIntensity = false,
						ReducedBloomntensity = false,
						PerformantWindows = false,
						AutoLockMythicals = true,
						AutoLockSecrets = true,
						InstantCrateOpen = false,
					},
				}
			end
		end

		SettingsService.updateSettings(MockPerson, { unknownSetting = 123 })
		expect(updateCalled).toBe(false)
	end)
end)
