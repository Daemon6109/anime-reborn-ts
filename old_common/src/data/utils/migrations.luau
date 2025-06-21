--------------------------------------------------------------------------------
-- Data Migration System

-- This module provides tools for safely migrating player data between different
-- versions of the data structure as the game evolves.
--------------------------------------------------------------------------------

export type MigrationFunction = (oldData: any) -> any

export type Migration = {
	Version: number,
	Migrate: MigrationFunction,
	Description: string,
}

local Migrations = {
	CurrentVersion = 7, -- Updated to include AdventCalendar Claimed field migration
	MigrationTable = {} :: { [number]: Migration },
}

-- Register a new migration from one version to the next
function Migrations.registerMigration(fromVersion: number, migration: MigrationFunction, description: string)
	Migrations.MigrationTable[fromVersion] = {
		Version = fromVersion + 1, -- The version we're migrating to
		Migrate = migration,
		Description = description,
	}

	-- Update current version if needed
	Migrations.CurrentVersion = math.max(Migrations.CurrentVersion, fromVersion + 1)
end

-- Migrate data from an old version to the current version
function Migrations.migrateData(data: any, fromVersion: number): (any, number)
	if fromVersion >= Migrations.CurrentVersion then
		return data, fromVersion -- Already at or beyond current version
	end

	local currentData = data
	local currentVersion = fromVersion

	-- Apply migrations sequentially
	while currentVersion < Migrations.CurrentVersion do
		local migration = Migrations.MigrationTable[currentVersion]
		if not migration then
			warn(string.format("No migration path from version %d to %d", currentVersion, currentVersion + 1))
			break
		end

		print(
			string.format(
				"Migrating data from v%d to v%d: %s",
				currentVersion,
				migration.Version,
				migration.Description
			)
		)

		currentData = migration.Migrate(currentData)
		currentVersion = migration.Version
	end

	return currentData, currentVersion
end

-- Check if data needs migration
function Migrations.needsMigration(dataVersion: number): boolean
	return dataVersion < Migrations.CurrentVersion
end

-- -- Example migrations (these would be filled in as the data structure evolves)
-- local exampleMigrations = {
-- 	-- Migration from v1 to v2
-- 	[1] = function(data: { [string]: any }): { [string]: any }
-- 		-- Example: Add a new field with a default value
-- 		local newData = table.clone(data)
-- 		newData.SlotsApplicable = data.SlotsApplicable or 3
-- 		return newData
-- 	end,

-- 	-- Migration from v2 to v3
-- 	[2] = function(data: { [string]: any }): { [string]: any }
-- 		-- Example: Rename a field
-- 		local newData = table.clone(data)
-- 		if data.RobuxSpent ~= nil then
-- 			newData.PremiumCurrencySpent = data.RobuxSpent
-- 			newData.RobuxSpent = nil
-- 		end
-- 		return newData
-- 	end,
-- }

-- -- Register example migrations
-- for version, migrationFunc in pairs(exampleMigrations) do
-- 	Migrations.registerMigration(version, migrationFunc, "Example migration")
-- end

-- Actual migrations
-- Migration from v6 to v7: Convert AdventCalendar Claimed from boolean map to number array
Migrations.registerMigration(6, function(data: any): any
	local newData = table.clone(data)

	if newData.AdventCalendarData and newData.AdventCalendarData.Claimed then
		local oldClaimed = newData.AdventCalendarData.Claimed
		local newClaimed = {}

		-- Convert { [number]: boolean } to { number }
		if typeof(oldClaimed) == "table" then
			for day, isClaimed in pairs(oldClaimed) do
				if isClaimed == true and typeof(day) == "number" then
					table.insert(newClaimed, day)
				end
			end
		end

		newData.AdventCalendarData.Claimed = newClaimed
	end

	return newData
end, "Convert AdventCalendar Claimed from boolean map to number array")

return Migrations
