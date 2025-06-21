local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll

local Data = require("@commonserver/data/init")
local createDailyRewardsData = require("@data/factories/dailyrewardsdata")
local migrations = require("@data/utils/migrations")

describe("Data Migration System", function()
	beforeAll(function()
		-- Initialize the Data module to register all migrations
		Data.init()
	end)

	describe("Migration version 1 → 2", function()
		it("should add missing SlotsApplicable field", function()
			local testData = {
				Level = 5,
				XP = 1000,
				RobuxSpent = 0,
				Currencies = { Gold = 5000, Gems = 100 },
				_version = 1,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(2)
			expect(migratedData.SlotsApplicable).toBe(3)
			expect(migratedData.Level).toBe(5)
			expect(migratedData.XP).toBe(1000)
		end)
	end)

	describe("Migration version 2 → 3", function()
		it("should transform old DailyRewardData to new DailyRewardsData structure", function()
			local testData = {
				Level = 10,
				XP = 2500,
				RobuxSpent = 0,
				SlotsApplicable = 3,
				Currencies = { Gold = 10000, Gems = 250 },
				DailyRewardData = {
					LastClaimTime = 1672531200, -- Jan 1, 2023
					StreakDays = 7,
				},
				_version = 2,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(3)
			expect(migratedData.DailyRewardData).toBeNil()
			expect(migratedData.DailyRewardsData).toBeDefined()
			expect(migratedData.DailyRewardsData.LastClaimedDay).toBe(math.floor(1672531200 / 86400))
			expect(migratedData.DailyRewardsData.CurrentStreak).toBe(7)
			expect(migratedData.DailyRewardsData.CanClaim).toBe(true)
			expect(migratedData.DailyRewardsData.TotalClaimed).toBe(0)
		end)

		it("should handle receipt history migration", function()
			local testData = {
				Level = 10,
				SlotsApplicable = 3,
				ProductsBought = { "purchase1", "purchase2" },
				FailedPurchases = { "failed1" },
				_version = 2,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(3)
			expect(migratedData.FailedPurchases).toBeNil()
			expect(migratedData.ReceiptHistory).toBeDefined()
			expect(migratedData.ReceiptHistory[1]).toBe("purchase1")
			expect(migratedData.ReceiptHistory[2]).toBe("purchase2")
		end)

		it("should create default DailyRewardsData if none exists", function()
			local testData = {
				Level = 10,
				SlotsApplicable = 3,
				_version = 2,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(3)
			expect(migratedData.DailyRewardsData).toBeDefined()
			expect(migratedData.DailyRewardsData.LastClaimedDay).toBeNil()
			expect(migratedData.DailyRewardsData.CurrentStreak).toBe(0)
			expect(migratedData.DailyRewardsData.CanClaim).toBe(true)
			expect(migratedData.DailyRewardsData.TotalClaimed).toBe(0)
		end)
	end)

	describe("Migration version 3 → 4", function()
		it("should fix old factory daily rewards structure", function()
			local testData = {
				Level = 15,
				XP = 5000,
				RobuxSpent = 100,
				SlotsApplicable = 3,
				Currencies = { Gold = 25000, Gems = 500 },
				DailyRewardsData = {
					LastDay = 15,
					CurrentDay = 16,
					ClaimedDays = { [1] = true, [2] = true, [3] = false, [4] = true },
				},
				_version = 3,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(4)
			expect(migratedData.DailyRewardsData.LastDay).toBeNil()
			expect(migratedData.DailyRewardsData.CurrentDay).toBeNil()
			expect(migratedData.DailyRewardsData.ClaimedDays).toBeNil()

			-- Should have new structure
			expect(migratedData.DailyRewardsData.LastClaimedDay).toBe(15)
			expect(migratedData.DailyRewardsData.CurrentStreak).toBe(15) -- CurrentDay - 1
			expect(migratedData.DailyRewardsData.CanClaim).toBe(true)
			expect(migratedData.DailyRewardsData.TotalClaimed).toBe(3) -- Count of true values in ClaimedDays
		end)

		it("should preserve valid DailyRewardsData structure", function()
			local testData = {
				Level = 15,
				SlotsApplicable = 3,
				DailyRewardsData = {
					LastClaimedDay = 10,
					CurrentStreak = 5,
					CanClaim = false,
					TotalClaimed = 8,
				},
				_version = 3,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(4)
			-- Should remain unchanged since it's already in correct format
			expect(migratedData.DailyRewardsData.LastClaimedDay).toBe(10)
			expect(migratedData.DailyRewardsData.CurrentStreak).toBe(5)
			expect(migratedData.DailyRewardsData.CanClaim).toBe(false)
			expect(migratedData.DailyRewardsData.TotalClaimed).toBe(8)
		end)
	end)

	describe("Migration version 4 → 5", function()
		it("should fix battlepass data structure", function()
			local testData = {
				Level = 20,
				SlotsApplicable = 3,
				DailyRewardsData = {
					LastClaimedDay = 20,
					CurrentStreak = 5,
					CanClaim = false,
					TotalClaimed = 10,
				},
				BattlepassData = {
					Level = -1, -- Invalid level that needs fixing
					HasPremium = false,
				},
				_version = 4,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(5)
			expect(migratedData.BattlepassData.Level).toBe(0) -- Fixed from -1
			expect(migratedData.BattlepassData.Exp).toBe(0)
			expect(migratedData.BattlepassData.HasPremium).toBe(false)
			expect(migratedData.BattlepassData.ResetExp).toBe(false)
			expect(migratedData.BattlepassData.ClaimedFree).toBe(0)
			expect(migratedData.BattlepassData.ClaimedPremium).toBe(0)
			expect(migratedData.BattlepassData.BattlepassName).toBe("")
		end)

		it("should preserve valid battlepass data", function()
			local testData = {
				Level = 20,
				SlotsApplicable = 3,
				BattlepassData = {
					Level = 5,
					Exp = 1000,
					HasPremium = true,
					ResetExp = true,
					ClaimedFree = 3,
					ClaimedPremium = 2,
					BattlepassName = "Season1",
				},
				_version = 4,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(5)
			-- Should remain unchanged since it's already valid
			expect(migratedData.BattlepassData.Level).toBe(5)
			expect(migratedData.BattlepassData.Exp).toBe(1000)
			expect(migratedData.BattlepassData.HasPremium).toBe(true)
			expect(migratedData.BattlepassData.ResetExp).toBe(true)
			expect(migratedData.BattlepassData.ClaimedFree).toBe(3)
			expect(migratedData.BattlepassData.ClaimedPremium).toBe(2)
			expect(migratedData.BattlepassData.BattlepassName).toBe("Season1")
		end)
	end)

	describe("Migration version 5 → 6", function()
		it("should add DayNumber field to AdventCalendarData", function()
			local testData = {
				Level = 20,
				SlotsApplicable = 3,
				AdventCalendarData = {
					Name = "Christmas2024",
					Claimed = { [1] = true, [2] = true },
					OnlineDays = 5,
					-- Missing DayNumber field
				},
				_version = 5,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(6)
			expect(migratedData.AdventCalendarData.DayNumber).toBe(0)
			expect(migratedData.AdventCalendarData.Name).toBe("Christmas2024")
			expect(migratedData.AdventCalendarData.OnlineDays).toBe(5)
		end)

		it("should preserve existing DayNumber field if it exists", function()
			local testData = {
				Level = 20,
				SlotsApplicable = 3,
				AdventCalendarData = {
					Name = "Christmas2024",
					Claimed = { [1] = true, [2] = true },
					OnlineDays = 5,
					DayNumber = 3,
				},
				_version = 5,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(6)
			expect(migratedData.AdventCalendarData.DayNumber).toBe(3) -- Should remain unchanged
		end)

		it("should handle missing AdventCalendarData", function()
			local testData = {
				Level = 20,
				SlotsApplicable = 3,
				-- Missing AdventCalendarData
				_version = 5,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(6)
			-- Should not crash and should preserve other data
			expect(migratedData.Level).toBe(20)
		end)
	end)

	describe("Full migration chain", function()
		it("should migrate from version 1 to current version", function()
			local testData = {
				Level = 5,
				XP = 1000,
				RobuxSpent = 0,
				Currencies = { Gold = 5000, Gems = 100 },
				DailyRewardData = {
					LastClaimTime = 1640995200, -- Jan 1, 2022
					StreakDays = 3,
				},
				_version = 1,
			}

			local migratedData, newVersion = migrations.migrateData(testData, testData._version)

			expect(newVersion).toBe(migrations.CurrentVersion)
			expect(migratedData.SlotsApplicable).toBe(3)
			expect(migratedData.DailyRewardData).toBeNil()
			expect(migratedData.DailyRewardsData).toBeDefined()
			expect(migratedData.DailyRewardsData.LastClaimedDay).toBe(math.floor(1640995200 / 86400))
			expect(migratedData.DailyRewardsData.CurrentStreak).toBe(3)
		end)

		it("should not modify data already at current version", function()
			local currentData = {
				Level = 25,
				SlotsApplicable = 3,
				DailyRewardsData = createDailyRewardsData(),
				_version = migrations.CurrentVersion,
			}

			local migratedData, newVersion = migrations.migrateData(currentData, currentData._version)

			expect(newVersion).toBe(migrations.CurrentVersion)
			expect(migratedData.Level).toBe(25)
			expect(migratedData.SlotsApplicable).toBe(3)
		end)
	end)

	describe("Data validation integration", function()
		it("should properly validate migrated data", function()
			local testData = {
				Level = 5,
				XP = 1000,
				_version = 1,
			}

			-- Use the Data module's dataCheck which includes migration
			local validatedData = Data.dataCheck(testData)

			expect(validatedData._version).toBe(migrations.CurrentVersion)
			expect(validatedData.SlotsApplicable).toBe(3)
			expect(validatedData.DailyRewardsData).toBeDefined()
		end)

		it("should handle data with no version field", function()
			local testData = {
				Level = 5,
				XP = 1000,
				-- No _version field
			}

			local validatedData = Data.dataCheck(testData)

			expect(validatedData._version).toBe(migrations.CurrentVersion)
			expect(validatedData.SlotsApplicable).toBe(3)
		end)
	end)
end)
