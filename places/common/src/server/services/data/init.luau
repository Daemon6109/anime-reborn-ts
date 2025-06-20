--------------------------------------------------------------------------------
-- data
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Future = require("@pkgs/future")
local ProfileStore = require("@serverpkgs/profilestore")

local data_constants = require("@self/data_constants")
local data_template = require("@data/data_template")

local migrations = require("@data/utils/migrations")
local performance = require("@data/utils/performance")
local validate = require("@data/utils/validate")

local deepCopy = require("@data/utils/deepCopy")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Define the current data version for migrations
local CURRENT_DATA_VERSION = migrations.CurrentVersion

local PlayerStore = (
	if not RunService:IsStudio()
		then ProfileStore.New(data_constants.DATASTORE_NAME, data_template)
		else ProfileStore.New(data_constants.DATASTORE_NAME, data_template).Mock :: any
) :: ProfileStore.ProfileStore<DataTemplate>
local Profiles: { [Player]: ProfileStore.Profile<DataTemplate> } = {}

--[=[
	Namespace for data-related functions and operations.

	@class Data
]=]
local Data = {
	CONSTANTS = data_constants,
	playerStore = PlayerStore,
	template = data_template,
	version = version,
}

local threadsPendingPersonSessionEndedLoad = {} :: { [Player]: { thread } }

local function isLoading(player: Player): boolean
	if Profiles[player] then
		return false
	else
		return true
	end
end

local function waitForPersonSessionEndedAsync(player: Player): ()
	if not isLoading(player) then -- If the data is already loaded,
		return
	end
	threadsPendingPersonSessionEndedLoad[player] = threadsPendingPersonSessionEndedLoad[player] or {}

	-- We'll store the thread and resume it in _resumeThreadsPendingSessionEndedLoad when the data loads
	table.insert(threadsPendingPersonSessionEndedLoad[player], coroutine.running())

	coroutine.yield()
end

local function resumeThreadsPendingSessionEndedLoad(player: Player): ()
	if threadsPendingPersonSessionEndedLoad[player] then
		for _, thread in ipairs(threadsPendingPersonSessionEndedLoad[player]) do
			task.spawn(thread)
		end
	end

	threadsPendingPersonSessionEndedLoad[player] = nil
end

local function cancelThreadsPendingSessionEndedLoad(player: Player): ()
	if threadsPendingPersonSessionEndedLoad[player] then
		for _, thread in ipairs(threadsPendingPersonSessionEndedLoad[player]) do
			coroutine.resume(thread, nil) -- Resume the thread with nil to indicate cancellation
		end
	end

	threadsPendingPersonSessionEndedLoad[player] = nil
end

--[=[
	Deeply merges user data with template defaults, preserving existing values 
	and filling in missing nested fields recursively.

	@private

	@within Data

	@param userData any -- The user's data (may be incomplete).
	@param template any -- The template to merge with (provides defaults).

	@return any -- A complete data structure with all fields from template.
]=]
local function deepMergeWithTemplate(userData: any, template: any): any
	-- If template is not a table, return userData or the template default
	if type(template) ~= "table" then
		return userData ~= nil and userData or template
	end

	-- If userData is not a table but template is, start with template and override with userData if it exists
	if type(userData) ~= "table" then
		return userData ~= nil and userData or deepCopy(template)
	end

	-- Both are tables, merge recursively
	local result = {}

	-- First, add all fields from template (ensures completeness)
	for key, templateValue in pairs(template) do
		local userValue = userData[key]
		if type(templateValue) == "table" then
			-- Recursively merge nested tables
			result[key] = deepMergeWithTemplate(userValue, templateValue)
		else
			-- Use user value if it exists, otherwise use template default
			result[key] = userValue ~= nil and userValue or templateValue
		end
	end

	-- Then, add any extra fields from userData that aren't in template (preserve user data)
	for key, userValue in pairs(userData) do
		if template[key] == nil then
			if type(userValue) == "table" then
				result[key] = deepCopy(userValue)
			else
				result[key] = userValue
			end
		end
	end

	return result
end

--[=[
	Performs a data check on the provided value and ensures it matches the expected data template.

	@private

	@within Data

	@param value -- The data to be checked.

	@return DataTemplate -- A table matching the data_template structure.

	```lua
	dataCheck(value) -- returns a table matching the data_template structure
	```
]=]
local function dataCheck(value): DataTemplate
	-- Enable performance monitoring to track validation speed
	performance.enable()

	-- Use the performance.measure function to track the validation time
	return performance.measure("data_validation", function()
		-- First check if it's a table
		assert(type(value) == "table", "Data must be a table")

		-- Check if the data has a version field for migrations
		if value._version == nil then
			-- If no version, assume version 1 for backward compatibility
			value._version = 1
		end

		-- Apply migrations if needed
		if value._version < CURRENT_DATA_VERSION then
			local migrated, newVersion: number = migrations.migrateData(value, value._version)
			value = migrated
			value._version = newVersion
		end

		-- Deep merge with template defaults BEFORE validation
		-- This ensures all required fields exist before validation
		local completeData = deepMergeWithTemplate(value, data_template)

		-- Preserve version information for migrations
		completeData._version = value._version

		-- Use our validation utility to validate the complete data
		local isValid, errorMessage = validate.validateDataSection(completeData, function()
			return data_template
		end)

		if not isValid then
			warn("Data validation failed:", errorMessage)
		end

		return completeData
	end)
end

--[=[
	Closes the document associated with the given player if it is open.

	@within Data

	@param player Player - The player whose document needs to be closed.

	```lua
	Data.closeDocument(player) -- Closes the document for the specified player
	```
]=]
function Data.closeDocument(player: Player): ()
	local profile = Profiles[player]
	if profile ~= nil then
		profile:EndSession()
	end
end

--[=[
	Retrieves the cache for a given player from the data store.

	@within Data

	@param player Player -- The player whose cache is to be retrieved.

	@return DataTemplate? -- The cache data for the player, or nil if the document could not be opened.

	```lua
	Data.getCache(player) -- Returns the cache for the specified player, or nil if not found
	```
]=]
function Data.getCache(player: Player): DataTemplate?
	local future_document = Future.new(function(): DataTemplate?
		local profile = Profiles[player]
		if not profile then
			if not Data.openDocument(player) then
				return nil
			end
		end
		return dataCheck(deepCopy(Profiles[player].Data))
	end)

	return future_document:Await()
end

--[=[
	Opens a document for the given player and handles potential errors.

	This function attempts to open a document associated with the player. If the document is locked due to an active session,
	it will attempt to steal the session and reopen the document. If the document cannot be opened due to compatibility issues
	or Roblox API errors, the player will be kicked with an appropriate message.

	@within Data

	@param player Player - The player for whom the document is being opened.

	@return boolean - Returns true if the document was successfully opened, false otherwise.

	```lua
	Data.openDocument(player) -- Attempts to open the document for the specified player
	```
]=]
function Data.openDocument(player: Player): boolean
	-- Start a profile session for this player's data:

	local profile = PlayerStore:StartSessionAsync("Player_" .. player.UserId, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	-- Handling new profile session or failure to start it:

	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		-- profile:Reconcile() -- Fill in missing variables from data_template (optional)

		profile.OnSessionEnd:Connect(function()
			Profiles[player] = nil
			resumeThreadsPendingSessionEndedLoad(player)
			task.defer(function()
				player:Kick(`Profile session end - Please rejoin`)
			end)
		end)

		if player.Parent == Players then
			Profiles[player] = profile :: any
			print(`Profile loaded for {player.DisplayName}!`)
			return true
		else
			-- The player has left before the profile session started
			profile:EndSession()
			return false
		end
	else
		-- This condition should only happen when the Roblox server is shutting down
		cancelThreadsPendingSessionEndedLoad(player)
		task.defer(function()
			player:Kick(`Profile load fail - Please rejoin`)
		end)
		return false
	end
end

--[=[
	Sets the cache for a given player.

	@within Data

	@param player Player - The player whose cache is to be set.
	@param newCache DataTemplate - The new cache data to be set for the player.

	@error "Profile not found for player" - Throws an error if the profile is not found for the player.

	```lua
	Data.setCache(player, newCache) -- Sets the cache for the specified player
	```
]=]
function Data.setCache(player: Player, newCache: DataTemplate): ()
	local profile = Profiles[player]
	assert(profile, "Profile not found for player")

	-- Use immutable update to ensure data integrity
	local safeCache = deepCopy(newCache)
	local data = dataCheck(safeCache)
	for key, value in pairs(data) do
		if data_template[key] == nil then
			warn(`Data migration: Unrecognized field '{key}' in old data. This may cause issues.`)
		else
			if type(value) ~= type(data_template[key]) then
				warn(
					`Data migration: Type mismatch for field '{key}'. Expected {type(data_template[key])}, got {type(
						value
					)}. This may cause issues.`
				)
			else
				if value == data_template[key] and key ~= "_version" then
					-- Remove fields that match the default value to optimize storage
					data[key] = nil
				end
			end
		end
	end

	profile.Data = data
end

--[=[
	Gets the performance metrics for data operations.
	
	@within Data

	@return table - A table containing performance metrics for data operations.
	
	```lua
	Data.getPerformanceMetrics() -- Returns a table with performance metrics
	```
]=]
function Data.getPerformanceMetrics()
	return performance.getMetrics()
end

--[=[
	Prints a performance report for data operations.
	
	@within Data
	
	```lua
	Data.printPerformanceReport() -- Prints a performance report
	```
]=]
function Data.printPerformanceReport(): ()
	performance.printReport()
end

--[=[
	Performs a data check on the provided value and ensures it matches the expected data template.
	This function is exposed for testing purposes to validate the complete data flow including migrations.

	@within Data

	@param value -- The data to be checked.

	@return DataTemplate -- A table matching the data_template structure.

	```lua
	Data.dataCheck(value) -- returns a table matching the data_template structure
	```
]=]
function Data.dataCheck(value): DataTemplate
	return dataCheck(value)
end

Data.waitForPersonSessionEndedAsync = waitForPersonSessionEndedAsync

--[=[
	Initialize the Data module and register all data migrations.
	
	This function sets up all the data migrations needed to transform 
	older data structures to match current system expectations.
]=]
function Data.init()
	-- Import factory functions to get expected structure
	local createDailyRewardsData = require("@data/factories/dailyrewardsdata")

	--[=[
	   Migration from version 1 to version 2
	   Adds missing data fields that were added to the data template
	]=]
	migrations.registerMigration(1, function(data: { [string]: any }): { [string]: any }
		local newData = table.clone(data)

		-- Ensure all required top-level fields exist
		if not newData.SlotsApplicable then
			newData.SlotsApplicable = 3 -- Default value from PlayerBasicData
		end

		return newData
	end, "Add missing SlotsApplicable field")

	--[=[
	   Migration from version 2 to version 3
	   Transforms old daily rewards structure and adds ReceiptHistory
	]=]
	migrations.registerMigration(2, function(data: { [string]: any }): { [string]: any }
		local newData = table.clone(data)

		-- Handle old DailyRewardData structure if it exists
		if newData.DailyRewardData then
			local oldDailyData = newData.DailyRewardData

			-- Transform to new structure expected by daily rewards system
			newData.DailyRewardsData = {
				LastClaimedDay = nil, -- Will be set when player first claims
				CurrentStreak = 0,
				CanClaim = true, -- Allow first claim
				TotalClaimed = 0,
			}

			-- Try to preserve any meaningful data from old structure
			if oldDailyData.LastClaimTime and oldDailyData.LastClaimTime > 0 then
				-- Convert timestamp to day number
				newData.DailyRewardsData.LastClaimedDay = math.floor(oldDailyData.LastClaimTime / 86400)
			end

			if oldDailyData.StreakDays and oldDailyData.StreakDays > 0 then
				newData.DailyRewardsData.CurrentStreak = oldDailyData.StreakDays
			end

			-- Remove old data
			newData.DailyRewardData = nil
		end

		-- Ensure DailyRewardsData exists with correct structure
		if not newData.DailyRewardsData then
			newData.DailyRewardsData = createDailyRewardsData()
		end

		-- Handle ReceiptHistory migration (from old migrations)
		newData.ReceiptHistory = newData.ReceiptHistory or data_template.ReceiptHistory
		if newData.ProductsBought then
			for _, purchaseId in pairs(newData.ProductsBought) do
				if purchaseId and not table.find(newData.ReceiptHistory, purchaseId) then
					table.insert(newData.ReceiptHistory, purchaseId)
				end
			end
			newData.ProductsBought = nil -- Clear ProductsBought as they are now consolidated into ReceiptHistory
		end
		if newData.FailedPurchases then
			newData.FailedPurchases = nil -- Clear FailedPurchases as they are now consolidated into ReceiptHistory
		end

		return newData
	end, "Transform daily rewards data structure and add ReceiptHistory")

	--[=[
	   Migration from version 3 to version 4
	   Handle old daily rewards structures that don't match current system
	]=]
	migrations.registerMigration(3, function(data: { [string]: any }): { [string]: any }
		local newData = table.clone(data)

		-- Fix DailyRewardsData structure if it has wrong fields
		if newData.DailyRewardsData then
			local dailyData = newData.DailyRewardsData

			-- Check if it has old structure (LastDay, CurrentDay, ClaimedDays)
			if dailyData.LastDay or dailyData.CurrentDay or dailyData.ClaimedDays then
				-- Transform old factory structure to system-expected structure
				local newDailyData = createDailyRewardsData()

				-- Try to preserve meaningful data
				if dailyData.LastDay and dailyData.LastDay > 0 then
					newDailyData.LastClaimedDay = dailyData.LastDay
				end

				if dailyData.CurrentDay and dailyData.CurrentDay > 1 then
					newDailyData.CurrentStreak = dailyData.CurrentDay - 1 -- Convert to streak
				end

				-- Count claimed days if ClaimedDays exists
				if dailyData.ClaimedDays then
					local count = 0
					for _, claimed in pairs(dailyData.ClaimedDays) do
						if claimed then
							count = count + 1
						end
					end
					newDailyData.TotalClaimed = count
				end

				newData.DailyRewardsData = newDailyData
			end
		end

		return newData
	end, "Fix daily rewards data structure mismatches")

	--[=[
	   Migration from version 4 to version 5
	   Ensure all systems have proper data structures
	]=]
	migrations.registerMigration(4, function(data: { [string]: any }): { [string]: any }
		local newData = table.clone(data)

		-- Ensure BattlepassData has correct structure
		if newData.BattlepassData then
			local bpData = newData.BattlepassData

			-- Ensure Level starts at 0 (not 1) to match system expectations
			if not bpData.Level or bpData.Level < 0 then
				bpData.Level = 0
			end

			-- Ensure Exp exists
			if not bpData.Exp then
				bpData.Exp = 0
			end

			-- Ensure all required boolean fields exist
			if bpData.HasPremium == nil then
				bpData.HasPremium = false
			end

			if bpData.ResetExp == nil then
				bpData.ResetExp = false
			end

			-- Ensure claimed counters exist
			if not bpData.ClaimedFree then
				bpData.ClaimedFree = 0
			end

			if not bpData.ClaimedPremium then
				bpData.ClaimedPremium = 0
			end

			-- Ensure BattlepassName exists
			if not bpData.BattlepassName then
				bpData.BattlepassName = ""
			end
		end

		return newData
	end, "Ensure all system data structures match their implementations")

	--[=[
	   Migration from version 5 to version 6
	   Add DayNumber field to AdventCalendarData
	]=]
	migrations.registerMigration(5, function(data: { [string]: any }): { [string]: any }
		local newData = table.clone(data)

		-- Ensure AdventCalendarData has DayNumber field
		if newData.AdventCalendarData then
			local acData = newData.AdventCalendarData

			-- Add DayNumber field if it doesn't exist
			if acData.DayNumber == nil then
				acData.DayNumber = 0
			end
		end

		return newData
	end, "Add DayNumber field to AdventCalendarData for proper tracking")
end

return Data
