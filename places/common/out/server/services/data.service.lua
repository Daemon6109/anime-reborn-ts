-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
-- Data service for managing player data using ProfileStore and Promises
-- Converted from Luau to TypeScript with Flamework service architecture
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local RunService = _services.RunService
local ProfileStore = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "profile-store", "src")
local DATA_TEMPLATE = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "data-template").DATA_TEMPLATE
local DATA_CONSTANTS = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "constants", "data-constants").DATA_CONSTANTS
local migrations = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "utils", "migrations").migrations
local performance = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "utils", "performance").performance
local validateDataSection = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "utils", "validate").validateDataSection
local deepCopy = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "utils", "deep-copy").deepCopy
-- Let TypeScript infer the types from the actual ProfileStore calls
--[[
	*
	 * Flamework service for managing player data operations.
	 * Handles data loading, saving, validation, and migrations.
	 
]]
local DataService
do
	DataService = setmetatable({}, {
		__tostring = function()
			return "DataService"
		end,
	})
	DataService.__index = DataService
	function DataService.new(...)
		local self = setmetatable({}, DataService)
		return self:constructor(...) or self
	end
	function DataService:constructor()
		self.CONSTANTS = DATA_CONSTANTS
		self.template = DATA_TEMPLATE
		self.version = {
			major = 1,
			minor = 0,
			patch = 0,
		}
		self.CURRENT_DATA_VERSION = migrations.CurrentVersion
		self.profiles = {}
		self.threadsPendingSessionEndedLoad = {}
		-- Initialize ProfileStore based on environment
		self.playerStore = if RunService:IsStudio() then ProfileStore.New(DATA_CONSTANTS.DATASTORE_NAME, DATA_TEMPLATE).Mock else ProfileStore.New(DATA_CONSTANTS.DATASTORE_NAME, DATA_TEMPLATE)
	end
	function DataService:onInit()
		self:initializeMigrations()
		print("DataService initialized")
	end
	function DataService:isLoading(player)
		local _profiles = self.profiles
		local _player = player
		return not (_profiles[_player] ~= nil)
	end
	function DataService:waitForPersonSessionEndedAsync(player)
		return TS.Promise.new(function(resolve)
			if not self:isLoading(player) then
				resolve()
				return nil
			end
			local _threadsPendingSessionEndedLoad = self.threadsPendingSessionEndedLoad
			local _player = player
			local _condition = _threadsPendingSessionEndedLoad[_player]
			if not _condition then
				_condition = {}
			end
			local threads = _condition
			local _arg0 = coroutine.running()
			table.insert(threads, _arg0)
			local _threadsPendingSessionEndedLoad_1 = self.threadsPendingSessionEndedLoad
			local _player_1 = player
			_threadsPendingSessionEndedLoad_1[_player_1] = threads
			coroutine.yield()
			resolve()
		end)
	end
	function DataService:resumeThreadsPendingSessionEndedLoad(player)
		local _threadsPendingSessionEndedLoad = self.threadsPendingSessionEndedLoad
		local _player = player
		local threads = _threadsPendingSessionEndedLoad[_player]
		if threads then
			for _, thread in threads do
				task.spawn(thread)
			end
		end
		local _threadsPendingSessionEndedLoad_1 = self.threadsPendingSessionEndedLoad
		local _player_1 = player
		_threadsPendingSessionEndedLoad_1[_player_1] = nil
	end
	function DataService:cancelThreadsPendingSessionEndedLoad(player)
		local _threadsPendingSessionEndedLoad = self.threadsPendingSessionEndedLoad
		local _player = player
		local threads = _threadsPendingSessionEndedLoad[_player]
		if threads then
			for _, thread in threads do
				coroutine.resume(thread)
			end
		end
		local _threadsPendingSessionEndedLoad_1 = self.threadsPendingSessionEndedLoad
		local _player_1 = player
		_threadsPendingSessionEndedLoad_1[_player_1] = nil
	end
	function DataService:deepMergeWithTemplate(userData, template)
		local _template = template
		if typeof(_template) ~= "table" then
			return if userData ~= nil then userData else template
		end
		local _userData = userData
		if typeof(_userData) ~= "table" then
			return if userData ~= nil then userData else deepCopy(template)
		end
		local result = {}
		local templateTable = template
		local userDataTable = userData
		-- Add all fields from template
		for key, templateValue in pairs(templateTable) do
			local userValue = userDataTable[key]
			if typeof(templateValue) == "table" then
				result[key] = self:deepMergeWithTemplate(userValue, templateValue)
			else
				result[key] = if userValue ~= nil then userValue else templateValue
			end
		end
		-- Add extra fields from userData
		for key, userValue in pairs(userDataTable) do
			if templateTable[key] == nil then
				result[key] = if typeof(userValue) == "table" then deepCopy(userValue) else userValue
			end
		end
		return result
	end
	function DataService:dataCheck(value)
		performance:enable()
		return performance:measure("data_validation", function()
			local _value = value
			local _arg0 = typeof(_value) == "table"
			assert(_arg0, "Data must be a table")
			local dataTable = value
			-- Handle versioning for migrations
			if dataTable._version == nil then
				dataTable._version = 1
			end
			local version = dataTable._version
			-- Apply migrations if needed
			if version < self.CURRENT_DATA_VERSION then
				local _binding = migrations:migrateData(dataTable, version)
				local migrated = _binding[1]
				local newVersion = _binding[2]
				dataTable._version = newVersion
				for key, val in pairs(migrated) do
					dataTable[key] = val
				end
			end
			-- Deep merge with template defaults
			local completeData = self:deepMergeWithTemplate(dataTable, DATA_TEMPLATE)
			local result = completeData
			result._version = dataTable._version
			-- Validate the complete data
			local _binding = validateDataSection(result, function()
				return DATA_TEMPLATE
			end)
			local isValid = _binding[1]
			local errorMessage = _binding[2]
			if not isValid then
				warn(`Data validation failed: {errorMessage}`)
			end
			return result
		end)
	end
	function DataService:closeDocument(player)
		local _profiles = self.profiles
		local _player = player
		local profile = _profiles[_player]
		if profile then
			profile:EndSession()
		end
	end
	function DataService:getCache(player)
		return TS.Promise.new(function(resolve)
			local _profiles = self.profiles
			local _player = player
			local profile = _profiles[_player]
			if not profile then
				self:openDocument(player):andThen(function(success)
					if success then
						local _profiles_1 = self.profiles
						local _player_1 = player
						local playerProfile = _profiles_1[_player_1]
						if playerProfile then
							local data = self:dataCheck(deepCopy(playerProfile.Data))
							resolve(data)
						else
							resolve(nil)
						end
					else
						resolve(nil)
					end
				end)
			else
				local data = self:dataCheck(deepCopy(profile.Data))
				resolve(data)
			end
		end)
	end
	function DataService:openDocument(player)
		return TS.Promise.new(function(resolve)
			local profile = self.playerStore:StartSessionAsync(`Player_{player.UserId}`, {
				Cancel = function()
					return player.Parent ~= Players
				end,
			})
			if profile then
				profile:AddUserId(player.UserId)
				profile.OnSessionEnd:Connect(function()
					local _profiles = self.profiles
					local _player = player
					_profiles[_player] = nil
					self:resumeThreadsPendingSessionEndedLoad(player)
					task.defer(function()
						player:Kick("Profile session end - Please rejoin")
					end)
				end)
				if player.Parent == Players then
					local _profiles = self.profiles
					local _player = player
					_profiles[_player] = profile
					print(`Profile loaded for {player.DisplayName}!`)
					resolve(true)
				else
					-- Player left before profile session started
					profile:EndSession()
					resolve(false)
				end
			else
				-- Server shutting down or other failure
				self:cancelThreadsPendingSessionEndedLoad(player)
				task.defer(function()
					player:Kick("Profile load fail - Please rejoin")
				end)
				resolve(false)
			end
		end)
	end
	function DataService:setCache(player, newCache)
		local _profiles = self.profiles
		local _player = player
		local profile = _profiles[_player]
		assert(profile, "Profile not found for player")
		-- Use immutable update to ensure data integrity
		local safeCache = deepCopy(newCache)
		local data = self:dataCheck(safeCache)
		-- Optimize storage by removing default values
		local optimizedData = {}
		local template = DATA_TEMPLATE
		for key, value in pairs(data) do
			if template[key] == nil then
				warn(`Data migration: Unrecognized field '{key}' in old data. This may cause issues.`)
				optimizedData[key] = value
			else
				local _exp = typeof(value)
				local _arg0 = template[key]
				if _exp ~= typeof(_arg0) then
					local _arg0_1 = template[key]
					warn(`Data migration: Type mismatch for field '{key}'. Expected {typeof(_arg0_1)}, got {typeof(value)}. This may cause issues.`)
				end
				-- Keep non-default values and version info
				if value ~= template[key] or key == "_version" then
					optimizedData[key] = value
				end
			end
		end
		profile.Data = optimizedData
	end
	function DataService:getPerformanceMetrics()
		return performance:getMetrics()
	end
	function DataService:printPerformanceReport()
		performance:printReport()
	end
	function DataService:initializeMigrations()
		-- Migration from version 1 to version 2
		migrations:registerMigration(1, function(data)
			local _object = table.clone(data)
			setmetatable(_object, nil)
			local newData = _object
			local _value = newData.SlotsApplicable
			if not (_value ~= 0 and _value == _value and _value ~= "" and _value) then
				newData.SlotsApplicable = 3
			end
			return newData
		end, "Add missing SlotsApplicable field")
		-- Migration from version 2 to version 3
		migrations:registerMigration(2, function(data)
			local _object = table.clone(data)
			setmetatable(_object, nil)
			local newData = _object
			-- Handle old DailyRewardData structure
			local _value = newData.DailyRewardData
			if _value ~= 0 and _value == _value and _value ~= "" and _value then
				local oldDailyData = newData.DailyRewardData
				newData.DailyRewardsData = {
					LastClaimedDay = nil,
					CurrentStreak = 0,
					CanClaim = true,
					TotalClaimed = 0,
				}
				-- Preserve meaningful data
				local _condition = oldDailyData.LastClaimTime
				if _condition ~= 0 and _condition == _condition and _condition ~= "" and _condition then
					_condition = (oldDailyData.LastClaimTime) > 0
				end
				if _condition ~= 0 and _condition == _condition and _condition ~= "" and _condition then
					(newData.DailyRewardsData).LastClaimedDay = math.floor((oldDailyData.LastClaimTime) / 86400)
				end
				local _condition_1 = oldDailyData.StreakDays
				if _condition_1 ~= 0 and _condition_1 == _condition_1 and _condition_1 ~= "" and _condition_1 then
					_condition_1 = (oldDailyData.StreakDays) > 0
				end
				if _condition_1 ~= 0 and _condition_1 == _condition_1 and _condition_1 ~= "" and _condition_1 then
					(newData.DailyRewardsData).CurrentStreak = oldDailyData.StreakDays
				end
				newData.DailyRewardData = nil
			end
			-- Ensure DailyRewardsData exists
			local _value_1 = newData.DailyRewardsData
			if not (_value_1 ~= 0 and _value_1 == _value_1 and _value_1 ~= "" and _value_1) then
				newData.DailyRewardsData = {
					LastClaimedDay = nil,
					CurrentStreak = 0,
					CanClaim = true,
					TotalClaimed = 0,
				}
			end
			-- Handle ReceiptHistory migration
			local _condition = newData.ReceiptHistory
			if not (_condition ~= 0 and _condition == _condition and _condition ~= "" and _condition) then
				_condition = {}
			end
			newData.ReceiptHistory = _condition
			local _value_2 = newData.ProductsBought
			if _value_2 ~= 0 and _value_2 == _value_2 and _value_2 ~= "" and _value_2 then
				local productsBought = newData.ProductsBought
				local receiptHistory = newData.ReceiptHistory
				for _, purchaseId in productsBought do
					local _condition_1 = purchaseId
					if _condition_1 ~= 0 and _condition_1 == _condition_1 and _condition_1 ~= "" and _condition_1 then
						_condition_1 = not (table.find(receiptHistory, purchaseId) ~= nil)
					end
					if _condition_1 ~= 0 and _condition_1 == _condition_1 and _condition_1 ~= "" and _condition_1 then
						table.insert(receiptHistory, purchaseId)
					end
				end
				newData.ProductsBought = nil
			end
			local _value_3 = newData.FailedPurchases
			if _value_3 ~= 0 and _value_3 == _value_3 and _value_3 ~= "" and _value_3 then
				newData.FailedPurchases = nil
			end
			return newData
		end, "Transform daily rewards data structure and add ReceiptHistory")
		-- Add remaining migrations (3-5) following the same pattern...
		-- Migration from version 3 to version 4
		migrations:registerMigration(3, function(data)
			local _object = table.clone(data)
			setmetatable(_object, nil)
			local newData = _object
			local _value = newData.DailyRewardsData
			if _value ~= 0 and _value == _value and _value ~= "" and _value then
				local dailyData = newData.DailyRewardsData
				-- Check for old structure
				local _condition = dailyData.LastDay
				if not (_condition ~= 0 and _condition == _condition and _condition ~= "" and _condition) then
					_condition = dailyData.CurrentDay
					if not (_condition ~= 0 and _condition == _condition and _condition ~= "" and _condition) then
						_condition = dailyData.ClaimedDays
					end
				end
				if _condition ~= 0 and _condition == _condition and _condition ~= "" and _condition then
					local newDailyData = {
						LastClaimedDay = nil,
						CurrentStreak = 0,
						CanClaim = true,
						TotalClaimed = 0,
					}
					local _condition_1 = dailyData.LastDay
					if _condition_1 ~= 0 and _condition_1 == _condition_1 and _condition_1 ~= "" and _condition_1 then
						_condition_1 = (dailyData.LastDay) > 0
					end
					if _condition_1 ~= 0 and _condition_1 == _condition_1 and _condition_1 ~= "" and _condition_1 then
						newDailyData.LastClaimedDay = dailyData.LastDay
					end
					local _condition_2 = dailyData.CurrentDay
					if _condition_2 ~= 0 and _condition_2 == _condition_2 and _condition_2 ~= "" and _condition_2 then
						_condition_2 = (dailyData.CurrentDay) > 1
					end
					if _condition_2 ~= 0 and _condition_2 == _condition_2 and _condition_2 ~= "" and _condition_2 then
						newDailyData.CurrentStreak = (dailyData.CurrentDay) - 1
					end
					local _value_1 = dailyData.ClaimedDays
					if _value_1 ~= 0 and _value_1 == _value_1 and _value_1 ~= "" and _value_1 then
						local claimedDays = dailyData.ClaimedDays
						local count = 0
						for _, claimed in pairs(claimedDays) do
							if claimed then
								count += 1
							end
						end
						newDailyData.TotalClaimed = count
					end
					newData.DailyRewardsData = newDailyData
				end
			end
			return newData
		end, "Fix daily rewards data structure mismatches")
		-- Additional migrations (4-5) can be added here following the same pattern
	end
	do
		-- (Flamework) DataService metadata
		Reflect.defineMetadata(DataService, "identifier", "server/services/data.service@DataService")
		Reflect.defineMetadata(DataService, "flamework:implements", { "$:flamework@OnInit" })
	end
end
-- (Flamework) DataService decorators
Reflect.decorate(DataService, "@flamework/core:out/flamework@Service", Service, {})
return {
	DataService = DataService,
}
