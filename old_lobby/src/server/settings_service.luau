--------------------------------------------------------------------------------
-- settings_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")
local createSettingsData = require("@data/factories/settingsdata")
local deepCopy = require("@data/utils/deepCopy")

type SettingsData = createSettingsData.SettingsData

-- Settings validation constants
local NUMERIC_MIN = 0
local NUMERIC_MAX = 1

-- Create signals for settings events
local settingsUpdatedEvent = Shingo.new() :: Shingo.Signal<Player, { [string]: any }>

--[=[
   Settings management system for handling player settings.

   @class SettingsService
]=]
local SettingsService = {
	version = version,

	-- Events
	settingsUpdated = settingsUpdatedEvent,
}

--[=[
   Validates a setting value based on its type

   @within SettingsService

   @param oldValue any -- The current value
   @param newValue any -- The new value to validate

   @return any? -- The validated value or nil if invalid

   ```lua
   local validValue = SettingsService.validateSetting(currentValue, newValue)
   ```
]=]
function SettingsService.validateSetting(oldValue: any, newValue: any): any?
	if type(newValue) == "number" then
		-- Handle NaN values
		if newValue ~= newValue then
			newValue = 0
		end
		return math.clamp(newValue, NUMERIC_MIN, NUMERIC_MAX)
	elseif type(newValue) == "boolean" then
		return newValue
	end

	return nil
end

--[=[
   Updates player settings with validation

   @within SettingsService

   @param person Person -- The person updating settings
   @param settingsTable { [string]: any } -- The new settings

   @return string -- The name of the updated settings

   ```lua
   SettingsService.updateSettings(person, { volume = 0.5, graphics = true })
   ```
]=]
function SettingsService.updateSettings(person: Person.Person, settingsTable: { [string]: any }): string
	local updatedSettings = {}
	local hasChanges = false

	-- First, get current settings to check what's valid
	local currentDataCache = person.dataCache()
	local currentSettings: SettingsData = currentDataCache.Settings or createSettingsData()
	local validUpdates = {}

	-- Check if there are any valid settings to update
	for settingName, newValue in pairs(settingsTable) do
		if currentSettings[settingName] ~= nil then
			local validatedValue = SettingsService.validateSetting(currentSettings[settingName], newValue)
			if validatedValue ~= nil then
				validUpdates[settingName] = validatedValue
				updatedSettings[settingName] = validatedValue
				hasChanges = true
			else
				warn(`Invalid setting value for {settingName}: {newValue}`)
			end
		end
	end

	-- Only call dataCache with update function if there are valid changes
	if hasChanges then
		person.dataCache(function(dataCache)
			local newSettings: SettingsData = deepCopy(currentSettings)

			-- Apply the valid updates
			for settingName, validatedValue in pairs(validUpdates) do
				(newSettings :: any)[settingName] = validatedValue
			end

			dataCache.Settings = newSettings
			return dataCache
		end)
	end

	-- Fire events only if there were changes
	if hasChanges then
		-- Fire local event
		settingsUpdatedEvent:fire(person.player, updatedSettings)
		-- Fire network event to client
		Network.ReturnSettingsUpdated.fire(person.player, { settings = updatedSettings })
	end

	return "Settings"
end

--[=[
   Initializes the settings service

   @within SettingsService

   ```lua
   SettingsService.init()
   ```
]=]
function SettingsService.init(): ()
	-- Listen for network events when they're added
	-- Network events would be handled here
end

return SettingsService
