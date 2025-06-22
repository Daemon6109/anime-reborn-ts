--------------------------------------------------------------------------------
-- battlepass
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server").common
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

-- Battlepass constants
local XP_PER_TIER = 1000
local MAX_TIER = 100
local PREMIUM_COST = 1200 -- Robux

-- Create signals for battlepass events
local xpGainedEvent = Shingo.new() :: Shingo.Signal<{ player: Player, amount: number, totalXP: number }>
local tierUnlockedEvent = Shingo.new() :: Shingo.Signal<{ player: Player, tier: number }>
local rewardClaimedEvent =
	Shingo.new() :: Shingo.Signal<{ player: Player, tier: number, isPremium: boolean, reward: any }>

--[=[
   Battlepass system for managing seasonal progression.

   @class Battlepass
]=]
local Battlepass = {
	version = version,
	-- Events
	xpGained = xpGainedEvent,
	tierUnlocked = tierUnlockedEvent,
	rewardClaimed = rewardClaimedEvent,
}

--[=[
   Adds XP to a person's battlepass

   @within Battlepass

   @param person Person -- The person to add XP to
   @param amount number -- The amount of XP to add

   ```lua
   Battlepass.addBattlepassXP(person, 500)
   ```
]=]
function Battlepass.addBattlepassXP(person: Person.Person, amount: number): ()
	person.dataCache(function(dataCache)
		local bpData = dataCache.BattlepassData
		local oldXP = bpData.Exp
		local oldTier = bpData.Level
		bpData.Exp = oldXP + amount
		local newTier = math.min(math.floor(bpData.Exp / XP_PER_TIER) + 1, MAX_TIER)
		if newTier > oldTier then
			bpData.Level = newTier
			tierUnlockedEvent:fire({ player = person.player, tier = newTier })
		end
		xpGainedEvent:fire({ player = person.player, amount = amount, totalXP = bpData.Exp })
		return dataCache
	end)
end

--[=[
   Claims a battlepass reward for a specific tier

   @within Battlepass

   @param person Person -- The person claiming the reward
   @param tier number -- The tier to claim the reward for
   @param isPremium boolean -- Whether the reward is for premium tier

   @return boolean -- Whether the reward was successfully claimed

   ```lua
   local success = Battlepass.claimBattlepassReward(person, 5, true)
   if success then
	   print("Reward claimed successfully!")
   else
	   print("Failed to claim reward.")
   end
   ```
]=]
function Battlepass.claimBattlepassReward(person: Person.Person, tier: number, isPremium: boolean): boolean
	local cache = person.dataCache()
	local bpData = cache.BattlepassData
	-- Check if tier is unlocked
	if bpData.Level < tier then
		return false
	end
	-- Check if premium is required and player has it
	if isPremium and not bpData.HasPremium then
		return false
	end
	-- Check if reward was already claimed
	local claimedField = isPremium and "ClaimedPremium" or "ClaimedFree"
	local claimedMask = bpData[claimedField] or 0
	local tierBit = 2 ^ (tier - 1)
	if bit32.band(claimedMask, tierBit) ~= 0 then
		return false -- Already claimed
	end
	-- Get and give the reward
	local reward = Battlepass.getBattlepassReward(tier, isPremium)
	if reward then
		Battlepass.giveBattlepassReward(person, reward)
		-- Mark as claimed
		person.dataCache(function(dataCache)
			local bpDataUpdate = dataCache.BattlepassData
			bpDataUpdate[claimedField] = bit32.bor(bpDataUpdate[claimedField] or 0, tierBit)
			return dataCache
		end)
		rewardClaimedEvent:fire({ player = person.player, tier = tier, isPremium = isPremium, reward = reward })
		return true
	end
	return false
end

--[=[
   Purchases premium battlepass for a person

   @within Battlepass

   @param person Person -- The person to purchase premium for

   @return boolean -- Whether the purchase was successful

   ```lua
   local success = Battlepass.purchasePremiumBattlepass(person)
   if success then
	   print("Premium battlepass purchased successfully!")
   else
	   print("Failed to purchase premium battlepass.")
   end
   ```
]=]
function Battlepass.purchasePremiumBattlepass(person: Person.Person): boolean
	local cache = person.dataCache()
	local bpData = cache.BattlepassData
	if bpData.HasPremium then
		return false -- Already has premium
	end
	-- Check if player has enough currency (this would typically check Robux)
	local currencies = cache.Currencies
	if (currencies.Gems or 0) < PREMIUM_COST then
		return false
	end
	-- Purchase premium
	person.dataCache(function(dataCache)
		bpData = dataCache.BattlepassData
		-- Deduct cost
		currencies.Gems = (currencies.Gems or 0) - PREMIUM_COST
		-- Grant premium
		bpData.HasPremium = true
		return dataCache
	end)
	return true
end

--[=[
   Gets a battlepass reward for a specific tier

   @within Battlepass

   @param tier number -- The tier to get the reward for
   @param isPremium boolean -- Whether the reward is for premium tier

   @return { [string]: any }? -- The reward for the tier, or nil if no reward

   ```lua
   local reward = Battlepass.getBattlepassReward(5, true)
   if reward then
	   print("Reward for tier 5:", reward)
   else
	   print("No reward for this tier.")
   end
   ```
]=]
function Battlepass.getBattlepassReward(tier: number, isPremium: boolean): { [string]: any }?
	-- Basic reward structure - in a real implementation this would come from configuration
	local rewards = {
		[1] = { Gold = isPremium and 200 or 100 },
		[2] = { Gold = 0, Gems = isPremium and 50 or 10 },
		[3] = { Gold = isPremium and 400 or 200 },
		[5] = { Gold = 0, Gems = isPremium and 100 or 25 },
		[10] = { Gold = isPremium and 1000 or 500, Gems = isPremium and 200 or 50 },
	}
	return rewards[tier]
end

--[=[
   Gives a battlepass reward to a person

   @within Battlepass

   @param person Person -- The person to give the reward to
   @param reward { [string]: any } -- The reward to give (e.g. { Gold = 100, Gems = 50 })

   ```lua
   Battlepass.giveBattlepassReward(person, { Gold = 100, Gems = 50 })
   ```
]=]
function Battlepass.giveBattlepassReward(person: Person.Person, reward: { [string]: any }): ()
	person.dataCache(function(dataCache)
		local currencies = dataCache.Currencies
		-- Add currencies
		if reward.Gold then
			currencies.Gold = (currencies.Gold or 0) + reward.Gold
		end
		if reward.Gems then
			currencies.Gems = (currencies.Gems or 0) + reward.Gems
		end
		return dataCache
	end)
end

--[=[
   Gets the current battlepass tier for a person

   @within Battlepass

   @param person Person -- The person to get tier for

   @return number -- The current battlepass tier

   ```lua
   local currentTier = Battlepass.getCurrentTier(person)
   print("Current Battlepass Tier:", currentTier)
   ```
]=]
function Battlepass.getCurrentTier(person: Person.Person): number
	local dataCache = person.dataCache()
	return dataCache.BattlepassData.Level or 1
end

--[=[
   Gets the current battlepass XP for a person

   @within Battlepass

   @param person Person -- The person to get XP for

   @return number -- The current battlepass XP

   ```lua
   local currentXP = Battlepass.getCurrentXP(person)
   print("Current Battlepass XP:", currentXP)
   ```
]=]
function Battlepass.getCurrentXP(person: Person.Person): number
	local dataCache = person.dataCache()
	return dataCache.BattlepassData.Exp or 0
end

--[=[
   Checks if a person has premium battlepass

   @within Battlepass

   @param person Person -- The person to check

   @return boolean -- Whether the person has premium battlepass

   ```lua
   local hasPremium = Battlepass.hasPremium(person)
   if hasPremium then
	   print("Player has premium battlepass!")
   else
	   print("Player does not have premium battlepass.")
   end
   ```
]=]
function Battlepass.hasPremium(person: Person.Person): boolean
	local dataCache = person.dataCache()
	return dataCache.BattlepassData.HasPremium or false
end

--[=[
   Resets battlepass for new season

   @within Battlepass

   @param person Person -- The person whose battlepass to reset
   @param seasonName string -- The name of the new season

   ```lua
   Battlepass.resetBattlepass(person, "Season 2")
   ```
]=]
function Battlepass.resetBattlepass(person: Person.Person, seasonName: string): ()
	person.dataCache(function(dataCache)
		local bpData = dataCache.BattlepassData
		-- Reset progress but keep premium status for this example
		bpData.Exp = 0
		bpData.Level = 1
		bpData.HasPremium = false
		bpData.ClaimedFree = 0
		bpData.ClaimedPremium = 0
		bpData.BattlepassName = seasonName
		return dataCache
	end)
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   battlepass.start()
   ```
]=]
local function start(): ()
	-- Claim battlepass reward event
	Network.ClaimBattlepassReward.on(function(player, data)
		local personFuture = Person.getForPlayer(player)
		local person = personFuture:Unwrap()
		assert(person)
		Battlepass.claimBattlepassReward(person, data.tier, data.isPremium)
	end)
	-- Purchase premium battlepass event
	Network.PurchasePremiumBattlepass.on(function(player)
		local personFuture = Person.getForPlayer(player)
		local person = personFuture:Unwrap()
		assert(person)
		Battlepass.purchasePremiumBattlepass(person)
	end)
end

--[=[
   This function is used for initialization. It should be called before `start()` to set up the provider.

   ```lua
   battlepass.init()
   ```
]=]
local function init(): () end

return {
	version = version,
	order = 20, -- Initialize after Person system
	-- Functions
	init = init,
	start = start,
	addBattlepassXP = Battlepass.addBattlepassXP,
	claimBattlepassReward = Battlepass.claimBattlepassReward,
	purchasePremiumBattlepass = Battlepass.purchasePremiumBattlepass,
	getCurrentTier = Battlepass.getCurrentTier,
	getCurrentXP = Battlepass.getCurrentXP,
	hasPremium = Battlepass.hasPremium,
	resetBattlepass = Battlepass.resetBattlepass,
	-- Events
	xpGained = xpGainedEvent,
	tierUnlocked = tierUnlockedEvent,
	rewardClaimed = rewardClaimedEvent,
}
