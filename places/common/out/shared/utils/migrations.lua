-- Compiled with roblox-ts v2.3.0
-- Data migration utilities for handling version upgrades
local DataMigrations
do
	DataMigrations = setmetatable({}, {
		__tostring = function()
			return "DataMigrations"
		end,
	})
	DataMigrations.__index = DataMigrations
	function DataMigrations.new(...)
		local self = setmetatable({}, DataMigrations)
		return self:constructor(...) or self
	end
	function DataMigrations:constructor()
		self.migrations = {}
		self.CurrentVersion = 6
	end
	function DataMigrations:registerMigration(fromVersion, migrationFunction, description)
		local _migrations = self.migrations
		local _fromVersion = fromVersion
		local _arg1 = {
			fromVersion = fromVersion,
			toVersion = fromVersion + 1,
			migrationFunction = migrationFunction,
			description = description,
		}
		_migrations[_fromVersion] = _arg1
	end
	function DataMigrations:migrateData(data, currentVersion)
		local _object = table.clone(data)
		setmetatable(_object, nil)
		local migratedData = _object
		local version = currentVersion
		while version < self.CurrentVersion do
			local _migrations = self.migrations
			local _version = version
			local migration = _migrations[_version]
			if not migration then
				warn(`No migration found for version {version} to {version + 1}`)
				break
			end
			print(`Migrating data from version {version} to {version + 1}: {migration.description}`)
			migratedData = migration.migrationFunction(migratedData)
			version = migration.toVersion
		end
		return { migratedData, version }
	end
	function DataMigrations:getRegisteredMigrations()
		local result = {}
		local _exp = self.migrations
		-- ▼ ReadonlyMap.forEach ▼
		local _callback = function(migration)
			local _migration = migration
			table.insert(result, _migration)
		end
		for _k, _v in _exp do
			_callback(_v, _k, _exp)
		end
		-- ▲ ReadonlyMap.forEach ▲
		return result
	end
end
local migrations = DataMigrations.new()
return {
	migrations = migrations,
}
