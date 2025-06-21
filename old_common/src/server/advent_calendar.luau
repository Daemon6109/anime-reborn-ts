--------------------------------------------------------------------------------
-- advent_calendar
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server").common
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local Players = game:GetService("Players")

type Signal<T> = Shingo.Signal<T>

-- Create signals for advent calendar events
local dayUnlockedEvent = Shingo.new() :: Signal<any>
local rewardClaimedEvent = Shingo.new() :: Signal<any>
local calendarEndedEvent = Shingo.new() :: Signal<any>

export type AdventCalendarConfig = {
	startYear: number,
	startMonth: number,
	startDay: number,
	targetHour: number,
	targetMin: number,
	totalDays: number,
	rewards: { [number]: { [string]: any } }, -- day -> rewards
}

--[=[
   Advent calendar system for managing time-limited daily rewards during special events.

   @class AdventCalendar
]=]
local AdventCalendar = {
	version = version,

	-- Events
	dayUnlocked = dayUnlockedEvent,
	rewardClaimed = rewardClaimedEvent,
	calendarEnded = calendarEndedEvent,

	-- Configuration
	config = nil :: AdventCalendarConfig?,
}

--[=[
   Loads the default advent calendar configuration.

   @within AdventCalendar

   @private

   ```lua
   advent_calendar.loadDefaultConfig()
   ```
]=]
local function loadDefaultConfig(): ()
	-- Example configuration - this would typically be loaded from a registry
	AdventCalendar.config = {
		startYear = 2024,
		startMonth = 12,
		startDay = 1,
		targetHour = 18, -- 6 PM
		targetMin = 0,
		totalDays = 25, -- 25 days for December
		rewards = {
			[1] = { Gold = 100, Gems = 10 },
			[2] = { Gold = 150, Gems = 15 },
			[3] = { Gold = 200, Gems = 20 },
			[4] = { Gold = 250, Gems = 25 },
			[5] = { Gold = 300, Gems = 30 },
			-- Continue for all 25 days...
			[25] = { Gold = 2500, Gems = 250, SpecialItem = "ChristmasUnit" },
		},
	}
end

--[=[
   Gets the first day of the advent calendar as a date table.

   @within AdventCalendar

   @private

   @return { year: number, month: number, day: number, hour: number, min: number, sec: number } -- The first day date table

   ```lua
   local firstDay = advent_calendar.getFirstDay()
   print(`First Advent Calendar Day: {firstDay.year}-{firstDay.month}-{firstDay.day} {firstDay.hour}:{firstDay.min}:{firstDay.sec}`)
   ```
]=]
function AdventCalendar:getFirstDay(): { year: number, month: number, day: number, hour: number, min: number, sec: number }
	if not AdventCalendar.config then
		error("Advent calendar config not loaded")
	end

	local config = AdventCalendar.config
	return {
		year = config.startYear,
		month = config.startMonth,
		day = config.startDay,
		hour = config.targetHour,
		min = config.targetMin,
		sec = 0,
	}
end

--[=[
   Gets the current day number in the advent calendar.

   @within AdventCalendar

   @return number -- The current day number (0 if before start)

   ```lua
   local currentDay = advent_calendar.getCurrentDay()
   print(`Current Advent Calendar Day: {currentDay}`)
   ```
]=]
function AdventCalendar:getCurrentDay(): number
	if not AdventCalendar.config then
		return 0
	end

	local config = AdventCalendar.config
	local now = os.time()
	local currentDate = os.date("!*t", now)

	local actualCurrentDay = currentDate.day
	local actualCurrentHour = currentDate.hour
	local actualCurrentMin = currentDate.min

	-- Adjust for target time
	currentDate.day = actualCurrentDay + 1
	currentDate.hour = config.targetHour
	currentDate.min = config.targetMin
	currentDate.sec = 0

	if (actualCurrentHour * 60) + actualCurrentMin < (config.targetHour * 60) + config.targetMin then
		currentDate.day = currentDate.day - 1
	end

	-- Calculate difference from first day
	local firstDay = AdventCalendar:getFirstDay()
	local unixDifference = os.difftime(os.time(currentDate), os.time(firstDay))

	local dayDifference = math.floor(unixDifference / 86400)

	return math.max(0, dayDifference)
end

--[=[
   Gives advent calendar rewards to a player.

   @within AdventCalendar

   @private

   @param person Person -- The person to give rewards to
   @param reward { [string]: any } -- The reward data

   ```lua
   advent_calendar.giveAdventReward(player, { Gold = 100, Gems = 10 })
   ```
]=]
function AdventCalendar:giveAdventReward(person: Person.Person, reward: { [string]: any }): ()
	person.dataCache(function(dataCache)
		local newDataCache = table.clone(dataCache)
		local currencies = newDataCache.Currencies
		local inventory = newDataCache.Inventory.Items

		-- Give currency rewards
		for rewardType, amount in pairs(reward) do
			if typeof(amount) == "number" then
				currencies[rewardType] = (currencies[rewardType] or 0) + amount
			elseif typeof(amount) == "string" then
				-- Special item reward
				inventory[amount] = inventory[amount] or { Count = 0 }
				inventory[amount].Count = inventory[amount].Count + 1
			end
		end

		return newDataCache
	end)
end

--[=[
   Claims an advent calendar reward for a player.

   @within AdventCalendar

   @param person Person -- The person claiming the reward
   @param day number -- The day to claim

   @return boolean -- Whether the claim was successful

   ```lua
   local success = advent_calendar.claimAdventReward(player, 1)
   if success then
	   print("Reward claimed successfully!")
   else
	   print("Failed to claim reward.")
   end
   ```
]=]
function AdventCalendar:claimAdventReward(person: Person.Person, day: number): boolean
	local canClaim, errorMessage = AdventCalendar:canClaimAdventReward(person, day)
	if not canClaim then
		warn(`Cannot claim advent reward: {errorMessage}`)
		return false
	end

	local config = AdventCalendar.config
	assert(config, "Advent calendar config not set")
	local reward = config.rewards[day]

	-- Give rewards
	AdventCalendar:giveAdventReward(person, reward)

	-- Mark as claimed
	person.dataCache(function(dataCache)
		local newDataCache = table.clone(dataCache)
		local acData = newDataCache.AdventCalendarData

		local claimed = acData.Claimed or {}
		table.insert(claimed, day)
		acData.Claimed = claimed

		return newDataCache
	end)

	rewardClaimedEvent:fire(person.player, day)
	return true
end

--[=[
   Updates advent calendar data for a player.
  
   @within AdventCalendar

   @private
   
   @param person Person -- The person to update data for

   ```lua
   advent_calendar.updateAdventCalendarData(player)
   ```
]=]
function AdventCalendar:updateAdventCalendarData(person: Person.Person): ()
	if not AdventCalendar.config then
		return
	end

	local currentDay = AdventCalendar:getCurrentDay()

	person.dataCache(function(dataCache)
		local newDataCache = table.clone(dataCache)
		local acData = newDataCache.AdventCalendarData

		-- Initialize if needed
		if not acData.OnlineDays then
			acData.OnlineDays = 0
		end

		if not acData.DayNumber then
			acData.DayNumber = 0
		end

		if not acData.Claimed then
			acData.Claimed = {}
		end

		-- Check if it's a new day
		if acData.DayNumber ~= currentDay then
			acData.DayNumber = currentDay
			acData.OnlineDays = acData.OnlineDays + 1

			-- Unlock new day
			if currentDay > 0 and currentDay <= AdventCalendar.config.totalDays then
				dayUnlockedEvent:fire(person.player, currentDay)
			end
		end

		return newDataCache
	end)
end

--[=[
   Checks if a player can claim a reward for a specific day.

   @within AdventCalendar

   @param person Person -- The person to check
   @param day number -- The day to check

   @return boolean -- Whether the reward can be claimed
   @return string? -- Error message if cannot claim

   ```lua
   local canClaim, errorMessage = advent_calendar.canClaimAdventReward(player, 1)
   if canClaim then
	   print("You can claim the reward!")
   else
	   print(`Cannot claim reward: {errorMessage}`)
   end
   ```
]=]
function AdventCalendar:canClaimAdventReward(person: Person.Person, day: number): (boolean, string?)
	if not AdventCalendar.config then
		return false, "Advent calendar not active"
	end

	local config = AdventCalendar.config

	-- Check if day is valid
	if day < 1 or day > config.totalDays then
		return false, "Invalid day"
	end

	-- Check if reward exists for this day
	if not config.rewards[day] then
		return false, "No reward for this day"
	end

	local dataCache = person.dataCache()
	local acData = dataCache.AdventCalendarData

	-- Check if already claimed
	if table.find(acData.Claimed or {}, day) then
		return false, "Already claimed"
	end

	-- Check if day is unlocked (player must have been online for this day)
	local currentDay = AdventCalendar:getCurrentDay()
	if day > currentDay then
		return false, "Day not yet unlocked"
	end

	-- Check if player was online for enough days
	if (acData.OnlineDays or 0) < day then
		return false, "Must be online for more days"
	end

	return true
end

--[=[
   Gets the claimed days for a player.

   @within AdventCalendar

   @param person Person -- The person to check

   @return { number } -- Array of claimed day numbers

   ```lua
   local claimedDays = advent_calendar.getClaimedDays(player)
   print(`Claimed Days: {table.concat(claimedDays, ", ")}`)
   ```
]=]
function AdventCalendar:getClaimedDays(person: Person.Person): { number }
	local dataCache = person.dataCache()
	return dataCache.AdventCalendarData.Claimed or {}
end

--[=[
   Gets the number of days a player has been online during the event.

   @within AdventCalendar

   @param person Person -- The person to check

   @return number -- Number of online days

   ```lua
   local onlineDays = advent_calendar.getOnlineDays(player)
   print(`Online Days: {onlineDays}`)
   ```
]=]
function AdventCalendar:getOnlineDays(person: Person.Person): number
	local dataCache = person.dataCache()
	return dataCache.AdventCalendarData.OnlineDays or 0
end

--[=[
   Checks if the advent calendar is currently active.

   @within AdventCalendar

   @return boolean -- Whether the calendar is active

   ```lua
   local isActive = advent_calendar.isAdventCalendarActive()
   if isActive then
	   print("Advent calendar is active!")
   else
	   print("Advent calendar is not active.")
   end
   ```
]=]
function AdventCalendar:isAdventCalendarActive(): boolean
	if not AdventCalendar.config then
		return false
	end

	local currentDay = AdventCalendar:getCurrentDay()
	return currentDay >= 1 and currentDay <= AdventCalendar.config.totalDays
end

--[=[
   Gets the time remaining until the next day unlocks.

   @within AdventCalendar

   @return number -- Seconds until next day unlock

   ```lua
   local timeUntilNextDay = advent_calendar.getTimeUntilNextDay()
   print(`Time until next day unlocks: {timeUntilNextDay} seconds`)
   ```
]=]
function AdventCalendar:getTimeUntilNextDay(): number
	if not AdventCalendar.config then
		return 0
	end

	local config = AdventCalendar.config
	local now = os.time()
	local currentDate = os.date("!*t", now)

	-- Calculate next unlock time
	local nextUnlockTime = os.time({
		year = currentDate.year,
		month = currentDate.month,
		day = currentDate.day + 1,
		hour = config.targetHour,
		min = config.targetMin,
		sec = 0,
	})

	return math.max(0, nextUnlockTime - now)
end

--[=[
   Sets a custom advent calendar configuration.

   @within AdventCalendar

   @param config AdventCalendarConfig -- The new configuration

   ```lua
   advent_calendar.setAdventCalendarConfig({
	   startYear = 2024,
	   startMonth = 12,
	   startDay = 1,
	   targetHour = 18,
	   targetMin = 0,
	   totalDays = 25,
	   rewards = {
		   [1] = { Gold = 100, Gems = 10 },
		   [2] = { Gold = 150, Gems = 15 },
		   -- Add more rewards...
	   },
   })
   ```
]=]
function AdventCalendar:setAdventCalendarConfig(config: AdventCalendarConfig): ()
	AdventCalendar.config = config
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   advent_calendar.start()
   ```
]=]
local function start(): ()
	assert(AdventCalendar.config, "Advent calendar config not set. Call `setAdventCalendarConfig` before starting.")

	-- Set up Blink network event handling
	Network.ClaimAdventReward.on(function(player, day)
		local person = Person.getForPlayer(player):Await()
		if not person then
			return
		end
		AdventCalendar:claimAdventReward(person, day)
	end)

	-- Set up periodic checks for new days
	task.spawn(function()
		while true do
			task.wait(300) -- Check every 5 minutes
			for _, player in pairs(Players:GetPlayers()) do
				task.spawn(function()
					local person = Person.getForPlayer(player):Await()
					if person then
						AdventCalendar:updateAdventCalendarData(person)
					end
				end)
			end
		end
	end)
end

--[=[
   This function is used for initialization. It should be called before `start()` to set up the provider.

   ```lua
   advent_calendar.init()
   ```
]=]
local function init(): ()
	-- Load default configuration
	loadDefaultConfig()

	-- Set up person events
	Person.personAdded:connect(function(person: Person.Person): ()
		AdventCalendar:updateAdventCalendarData(person)
	end)
end

return {
	version = version,

	-- Functions
	start = start,
	init = init,
	setAdventCalendarConfig = AdventCalendar.setAdventCalendarConfig,
	getCurrentDay = AdventCalendar.getCurrentDay,
	claimAdventReward = AdventCalendar.claimAdventReward,
	canClaimAdventReward = AdventCalendar.canClaimAdventReward,
	getClaimedDays = AdventCalendar.getClaimedDays,
	getOnlineDays = AdventCalendar.getOnlineDays,
	getTimeUntilNextDay = AdventCalendar.getTimeUntilNextDay,
	isAdventCalendarActive = AdventCalendar.isAdventCalendarActive,

	-- Events
	dayUnlocked = AdventCalendar.dayUnlocked,
	rewardClaimed = AdventCalendar.rewardClaimed,
	calendarEnded = AdventCalendar.calendarEnded,
}
