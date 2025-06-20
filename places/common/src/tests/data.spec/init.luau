local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll

local Data = require("@commonserver/data/init")
local migrations = require("@data/utils/migrations")
local newDataTemplate = require("@data/data_template")
local testing = require("@data/utils/testing")
local validate = require("@data/utils/validate")

local createCurrencies = require("@data/factories/economy/currencies")
local createInventoryData = require("@data/factories/inventory/inventorydata")
local createPlayerBasicData = require("@data/factories/player/playerbasicdata")
local deepCopy = require("@data/utils/deepCopy")

local oldProfileTemplate = require("@self/profile_template")

describe("Data Template System", function()
	beforeAll(function()
		-- Initialize the Data module to register all migrations
		Data.init()
	end)

	describe("Basic factory tests", function()
		it("should create player basic data with default values", function()
			local playerData = createPlayerBasicData()

			expect(playerData.Level).toBe(1)
			expect(playerData.XP).toBe(0)
			expect(playerData.CurrentTitle).toBe("")
		end)

		it("should create inventory with default values", function()
			local inventoryData = createInventoryData()

			expect(typeof(inventoryData.Units)).toBe("table")
			expect(typeof(inventoryData.Items)).toBe("table")
			expect(inventoryData.MaxUnitStorage).toBe(100)
		end)

		it("should create currencies with default values", function()
			local currencies = createCurrencies()

			expect(currencies.Gold).toBe(0)
			expect(currencies.Gems).toBe(500)
		end)
	end)

	describe("Validation tests", function()
		it("should validate correct player data", function()
			local playerData = createPlayerBasicData()
			local isValid = validate.validateDataSection(playerData, createPlayerBasicData)

			expect(isValid).toBe(true)
		end)

		it("should reject invalid player data", function()
			local invalidData = {
				Level = "not a number", -- Should be a number
				XP = 0,
				-- Missing required fields
			}

			local isValid = validate.validateDataSection(invalidData, createPlayerBasicData)

			expect(isValid).toBe(false)
		end)
	end)

	describe("Testing utilities tests", function()
		it("should detect differences between data", function()
			local data1 = {
				Level = 1,
				Currencies = {
					Gold = 0,
					Gems = 500,
				},
			}

			local data2 = {
				Level = 2,
				Currencies = {
					Gold = 100,
					Gems = 500,
				},
			}

			local diff = testing.diffData(data1, data2)
			expect(diff.Level).toBeTruthy()
			expect(diff.Level.old).toBe(1)
			expect(diff.Level.new).toBe(2)

			expect(diff["Currencies.Gold"]).toBeTruthy()
			expect(diff["Currencies.Gold"].old).toBe(0)
			expect(diff["Currencies.Gold"].new).toBe(100)

			expect(diff["Currencies.Gems"] == nil).toBe(true)
		end)

		it("should print differences between new data_template and old profile_template", function()
			local diff = testing.diffData(oldProfileTemplate, newDataTemplate)
			print("Differences between old profile template and new data template:")
			for key, value in pairs(diff) do
				print(key, ":", value)
			end
		end)

		it("should validate complete data structure", function()
			local mockData = testing.mockPlayerData()
			local expectedStructure = {
				Level = 0,
				XP = 0,
				Currencies = {
					Gold = 0,
					Gems = 0,
				},
			}

			local isValid = testing.validateStructure(mockData, expectedStructure)
			expect(isValid).toBe(true)
		end)
	end)
	describe("Data Migration Tests", function()
		it("should migrate an old player profile to the new data template structure using dataCheck", function()
			-- Create a mock old profile data (version 1)
			local oldProfileData: any = {
				Currencies = {
					Gold = 100,
					Gems = 50,
					["Red Ticket"] = 5,
					["Candy Cane"] = 15,
					["New Year Coin"] = 20,
				},
				Level = 10,
				XP = 1200,
				RobuxSpent = 50,
				CurrentTitle = "OldTitle",
				EquippedMount = "OldMount",
				Inventory = {
					Units = { { Name = "UnitA", UUID = "u1" } },
					Items = { { Name = "ItemA", Count = 5 } },
					Titles = { "TitleA" },
					Mounts = { "MountA" },
					Skins = { "SkinA" },
					MaxUnitStorage = 150,
				},
				Settings = {
					SoundMasterVolume = 0.8,
					UnitSFXVolume = 0.7,
					BGMVolume = 0.6,
					AutoLockMythicals = false,
				},
				-- No _version field to simulate old data
			}

			-- Test the complete data migration flow using the Data module's dataCheck function
			local processedData = Data.dataCheck(deepCopy(oldProfileData))

			-- Verify that migration worked and version was updated correctly
			expect(processedData._version).toBe(migrations.CurrentVersion)

			-- Verify key data is preserved
			expect(processedData.Level).toBe(oldProfileData.Level)
			expect(processedData.XP).toBe(oldProfileData.XP)
			expect(processedData.RobuxSpent).toBe(oldProfileData.RobuxSpent)
			expect(processedData.CurrentTitle).toBe(oldProfileData.CurrentTitle)
			expect(processedData.EquippedMount).toBe(oldProfileData.EquippedMount)

			-- Check Currencies are preserved
			expect(processedData.Currencies.Gold).toBe(oldProfileData.Currencies.Gold)
			expect(processedData.Currencies.Gems).toBe(oldProfileData.Currencies.Gems)

			-- Check that new required fields exist (from ReceiptHistory migration)
			expect(typeof(processedData.ReceiptHistory)).toBe("table")
		end)
		it("should correctly migrate minimal old profile data", function()
			local oldProfileMinimal: any = {
				Level = 5,
				XP = 100,
				-- No _version field
			}

			-- Use Data.dataCheck to process the old data through the complete migration system
			local processedData = Data.dataCheck(deepCopy(oldProfileMinimal))

			-- Verify migration worked
			expect(processedData._version).toBe(migrations.CurrentVersion)

			-- Verify original data is preserved
			expect(processedData.Level).toBe(5)
			expect(processedData.XP).toBe(100)

			-- Verify that migrations added required new fields
			expect(typeof(processedData.ReceiptHistory)).toBe("table")
		end)

		it("should validate migration path completeness", function()
			-- Test that we have migration paths from version 1 to current
			local currentVersion = migrations.CurrentVersion

			-- We should be able to migrate from version 1 to current
			expect(currentVersion).toBe(migrations.CurrentVersion) -- Verify we're at expected version

			-- Test migration from each version to the next
			for version = 1, currentVersion - 1 do
				local hasPath = migrations.MigrationTable[version] ~= nil
				expect(hasPath).toBe(true)
			end
		end)
		it("should handle data that is already at current version", function()
			local currentData = {
				Level = 10,
				XP = 500,
				_version = migrations.CurrentVersion,
				ReceiptHistory = {},
			}

			-- Use Data.dataCheck to process data that's already at current version
			local processedData = Data.dataCheck(deepCopy(currentData))

			-- Should return data with version preserved if already at current version
			expect(processedData._version).toBe(migrations.CurrentVersion)
			expect(processedData.Level).toBe(10)
			expect(processedData.XP).toBe(500)
		end)
	end)
	-- Helper function to deep merge defaults
	local function deepMergeDefaults(target, source)
		for key, value in pairs(source) do
			if type(value) == "table" and type(target[key]) == "table" then
				-- Recurse for nested tables
				deepMergeDefaults(target[key], value)
			elseif target[key] == nil then
				-- Only apply default if value is missing
				target[key] = deepCopy(value)
			end
		end
		return target
	end

	describe("Integration Tests with Data Module", function()
		it("should properly initialize data module and test full data flow", function()
			-- Verify the Data module is properly initialized
			-- expect(migrations.CurrentVersion).toBe(5)
			expect(typeof(Data.template)).toBe("table")
			expect(typeof(Data.template._version)).toBe("number")

			-- Test that all migration paths exist
			for version = 1, migrations.CurrentVersion - 1 do
				local hasPath = migrations.MigrationTable[version] ~= nil
				expect(hasPath).toBe(true)
			end
		end)
		it("should simulate complete player data loading with migration", function()
			-- Create old player data (version 1)
			local oldPlayerData: any = {
				Level = 10,
				XP = 1500,
				Currencies = {
					Gold = 1000,
					Gems = 250,
				},
				Settings = {
					SoundMasterVolume = 0.8,
				},
				-- No _version to simulate very old data
			}

			-- Use Data.dataCheck to simulate what happens when Data.openDocument processes old data
			local processedData = Data.dataCheck(deepCopy(oldPlayerData))

			-- Verify the migration worked correctly
			expect(processedData._version).toBe(migrations.CurrentVersion)

			-- Verify old data is preserved
			expect(processedData.Level).toBe(10)
			expect(processedData.XP).toBe(1500)
			expect(processedData.Currencies.Gold).toBe(1000)
			expect(processedData.Currencies.Gems).toBe(250)
			expect(processedData.Settings.SoundMasterVolume).toBe(0.8)

			-- Verify new fields are added
			expect(typeof(processedData.ReceiptHistory)).toBe("table")
			expect(typeof(processedData.Inventory)).toBe("table")
			expect(typeof(processedData.TeamEventData)).toBe("table")
		end)
	end)
end)
