--------------------------------------------------------------------------------
-- daily_rewards
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server").common
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local Players = game:GetService("Players")

-- Daily reward constants
local _DAILY_RESET_HOUR = 0 -- Reset at midnight UTC
local MAX_STREAK_DAYS = 7 -- Reset streak after 7 days
local BASE_REWARD_COINS = 100
local STREAK_MULTIPLIER = 1.5

-- Create signals for daily reward events
local rewardClaimedEvent = Shingo.new() :: Shingo.Signal<any>
local newDayEvent = Shingo.new() :: Shingo.Signal<any>

--[=[
   Daily Rewards system for managing daily login rewards.

   @class DailyRewards
]=]
local DailyRewards = {
	version = version,

	-- Events
	rewardClaimed = rewardClaimedEvent,
	newDay = newDayEvent,
}

--[=[
   Checks if it's a new day and resets daily data if necessary

   @within DailyRewards

   @param person Person -- The person to check daily reset for

   ```lua
   DailyRewards.checkDailyReset(person)
   ```
]=]
function DailyRewards.checkDailyReset(person: Person.Person): ()
	local currentTime = os.time()
	local currentDay = math.floor(currentTime / 86400) -- Days since epoch

	person.dataCache(function(dataCache)
		local newCache = table.clone(dataCache)
		local dailyData = newCache.DailyRewardsData

		if not dailyData.LastClaimedDay or dailyData.LastClaimedDay < currentDay then
			-- New day detected
			if dailyData.LastClaimedDay and (currentDay - dailyData.LastClaimedDay) > 1 then
				-- Streak broken - reset to day 1
				dailyData.CurrentStreak = 1
			else
				-- Continue streak
				dailyData.CurrentStreak = math.min((dailyData.CurrentStreak or 0) + 1, MAX_STREAK_DAYS)
			end

			dailyData.CanClaim = true
			newDayEvent:fire({ player = person.player, day = dailyData.CurrentStreak })
		end

		return newCache
	end)
end

--[=[
   Claims the daily reward for a person

   @within DailyRewards

   @param person Person -- The person claiming the reward

   @return boolean -- Returns true if the reward was successfully claimed, false otherwise

   ```lua
   local success = DailyRewards.claimDailyReward(person)
   if success then
	   print("Reward claimed successfully!")
   else
	   print("You cannot claim the reward yet.")
   end
   ```
]=]
function DailyRewards.claimDailyReward(person: Person.Person): boolean
	local cache = person.dataCache()
	local dailyData = cache.DailyRewardsData

	if not dailyData.CanClaim then
		return false
	end

	local currentDay = dailyData.CurrentStreak or 1
	local reward = DailyRewards.calculateDailyReward(currentDay)
	DailyRewards.giveReward(person, reward)

	-- Update daily data
	person.dataCache(function(dataCache)
		local newCache = table.clone(dataCache)
		local dailyDataUpdate = newCache.DailyRewardsData

		dailyDataUpdate.CanClaim = false
		dailyDataUpdate.LastClaimedDay = math.floor(os.time() / 86400)
		dailyDataUpdate.TotalClaimed = (dailyDataUpdate.TotalClaimed or 0) + 1

		return newCache
	end)

	-- Fire event
	rewardClaimedEvent:fire({ player = person.player, day = currentDay, reward = reward })

	return true
end

--[=[
   Calculates the daily reward based on the current day

   @within DailyRewards

   @param day number -- The current day in the streak (1-7)

   @return { [string]: number } -- The reward for the given day

   ```lua
   local reward = DailyRewards.calculateDailyReward(3)
   print("Reward for day 3:", reward.Coins, "coins and", reward.Gems, "gems")
   end
   ```
]=]
function DailyRewards.calculateDailyReward(day: number): { [string]: number }
	local baseCoins = BASE_REWARD_COINS
	local streakBonus = math.floor(baseCoins * (day - 1) * STREAK_MULTIPLIER)

	local reward = {
		Coins = baseCoins + streakBonus,
	}

	-- Special rewards for certain days
	if day == 3 then
		reward.Gems = 10
	elseif day == 7 then
		reward.Gems = 25
		reward.BonusCoins = 500
	end

	return reward
end

--[=[
   Gives a reward to a person

   @within DailyRewards

   @param person Person -- The person to give the reward to
   @param reward { [string]: number } -- The reward to give (e.g., { Coins = 100, Gems = 10 })

   ```lua
   DailyRewards.giveReward(person, { Coins = 100, Gems = 10 })
   ```
]=]
function DailyRewards.giveReward(person: Person.Person, reward: { [string]: number }): ()
	person.dataCache(function(dataCache)
		local newCache = table.clone(dataCache)
		local currencies = newCache.Currencies

		-- Add coins
		if reward.Coins then
			currencies.Gold = (currencies.Gold or 0) + reward.Coins
		end

		-- Add gems
		if reward.Gems then
			currencies.Gems = (currencies.Gems or 0) + reward.Gems
		end

		-- Add bonus coins
		if reward.BonusCoins then
			currencies.Gold = (currencies.Gold or 0) + reward.BonusCoins
		end

		return newCache
	end)
end

--[=[
   Gets the current daily reward status for a person

   @param person Person -- The person to get the daily status for

   @return { currentDay: number, canClaim: boolean, totalClaimed: number } -- The daily status

   ```lua
   local status = DailyRewards.getDailyStatus(person)
   print("Current Day:", status.currentDay)
   print("Can Claim Reward:", status.canClaim)
   print("Total Claimed:", status.totalClaimed)
   end
   ```
]=]
function DailyRewards.getDailyStatus(
	person: Person.Person
): { currentDay: number, canClaim: boolean, totalClaimed: number }
	local cache = person.dataCache()
	local dailyData = cache.DailyRewardsData

	return {
		currentDay = dailyData.CurrentStreak or 1,
		canClaim = dailyData.CanClaim or false,
		totalClaimed = dailyData.TotalClaimed or 0,
	}
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   daily_rewards.start()
   ```
]=]
local function start(): ()
	-- Set up Blink network event for daily reward claiming
	Network.ClaimDailyReward.on(function(player: Player)
		local personFuture = Person.getForPlayer(player)
		local person = personFuture:Await()
		if not person then
			return
		end

		DailyRewards.claimDailyReward(person)
	end)
end

--[=[
   This function is used for initialization. It should be called before `start()` to set up the provider.

   ```lua
   daily_rewards.init()
   ```
]=]
local function init(): ()
	-- Check for daily resets when players join
	Person.personAdded:connect(function(person: Person.Person): ()
		task.wait(1) -- Wait for data to load
		DailyRewards.checkDailyReset(person)
	end)

	-- Set up periodic daily reset checks (every hour)
	task.spawn(function()
		while true do
			task.wait(3600) -- Check every hour
			for _, player in pairs(Players:GetPlayers()) do
				local personFuture = Person.getForPlayer(player)
				if personFuture then
					local person = personFuture:Await()
					if person then
						DailyRewards.checkDailyReset(person)
					end
				end
			end
		end
	end)
end

return {
	version = version,
	order = 15, -- Initialize after Person system

	-- Functions
	init = init,
	start = start,
	claimDailyReward = DailyRewards.claimDailyReward,
	getDailyStatus = DailyRewards.getDailyStatus,

	-- Events
	rewardClaimed = rewardClaimedEvent,
	newDay = newDayEvent,
}
