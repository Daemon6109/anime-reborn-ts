-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
-- Example usage of the DataService in a Flamework controller or service
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local Players = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
--[[
	*
	 * Example service showing how to use the DataService
	 
]]
local PlayerManagerService
do
	PlayerManagerService = setmetatable({}, {
		__tostring = function()
			return "PlayerManagerService"
		end,
	})
	PlayerManagerService.__index = PlayerManagerService
	function PlayerManagerService.new(...)
		local self = setmetatable({}, PlayerManagerService)
		return self:constructor(...) or self
	end
	function PlayerManagerService:constructor(dataService)
		self.dataService = dataService
	end
	function PlayerManagerService:onStart()
		-- Handle player joining
		Players.PlayerAdded:Connect(function(player)
			self:handlePlayerJoined(player)
		end)
		-- Handle player leaving
		Players.PlayerRemoving:Connect(function(player)
			self:handlePlayerLeaving(player)
		end)
	end
	PlayerManagerService.handlePlayerJoined = TS.async(function(self, player)
		print(`{player.DisplayName} is joining...`)
		TS.try(function()
			-- Open the player's data document
			local success = TS.await(self.dataService:openDocument(player))
			if success then
				print(`Successfully loaded data for {player.DisplayName}`)
				-- Get the player's data
				local playerData = TS.await(self.dataService:getCache(player))
				if playerData then
					print(`Player level: {playerData.Level}`)
					print(`Player XP: {playerData.XP}`)
					print(`Daily rewards streak: {playerData.DailyRewardsData.CurrentStreak}`)
				end
			else
				warn(`Failed to load data for {player.DisplayName}`)
			end
		end, function(error)
			warn(`Error loading player data: {error}`)
		end)
	end)
	function PlayerManagerService:handlePlayerLeaving(player)
		print(`{player.DisplayName} is leaving...`)
		-- Close the player's data document
		self.dataService:closeDocument(player)
	end
	PlayerManagerService.givePlayerXP = TS.async(function(self, player, amount)
		TS.try(function()
			local playerData = TS.await(self.dataService:getCache(player))
			if playerData then
				-- Update XP
				playerData.XP += amount
				-- Level up logic (example)
				local xpNeededForNextLevel = playerData.Level * 100
				if playerData.XP >= xpNeededForNextLevel then
					playerData.Level += 1
					playerData.XP -= xpNeededForNextLevel
					print(`{player.DisplayName} leveled up to level {playerData.Level}!`)
				end
				-- Save the updated data
				self.dataService:setCache(player, playerData)
			end
		end, function(error)
			warn(`Error updating player XP: {error}`)
		end)
	end)
	PlayerManagerService.claimDailyReward = TS.async(function(self, player)
		local _exitType, _returns = TS.try(function()
			local playerData = TS.await(self.dataService:getCache(player))
			if playerData and playerData.DailyRewardsData.CanClaim then
				local currentDay = math.floor(tick() / 86400)
				local lastClaimedDay = playerData.DailyRewardsData.LastClaimedDay
				-- Check if it's a new day
				if not (lastClaimedDay ~= 0 and lastClaimedDay == lastClaimedDay and lastClaimedDay) or currentDay > lastClaimedDay then
					-- Update daily rewards data
					playerData.DailyRewardsData.LastClaimedDay = currentDay
					playerData.DailyRewardsData.TotalClaimed += 1
					-- Update streak
					local _condition = lastClaimedDay
					if _condition ~= 0 and _condition == _condition and _condition then
						_condition = currentDay == lastClaimedDay + 1
					end
					if _condition ~= 0 and _condition == _condition and _condition then
						playerData.DailyRewardsData.CurrentStreak += 1
					else
						playerData.DailyRewardsData.CurrentStreak = 1
					end
					-- Set can't claim again today
					playerData.DailyRewardsData.CanClaim = false
					-- Save the data
					self.dataService:setCache(player, playerData)
					print(`{player.DisplayName} claimed daily reward! Streak: {playerData.DailyRewardsData.CurrentStreak}`)
					return TS.TRY_RETURN, { true }
				end
			end
			return TS.TRY_RETURN, { false }
		end, function(error)
			warn(`Error claiming daily reward: {error}`)
			return TS.TRY_RETURN, { false }
		end)
		if _exitType then
			return unpack(_returns)
		end
	end)
	do
		-- (Flamework) PlayerManagerService metadata
		Reflect.defineMetadata(PlayerManagerService, "identifier", "server/services/player-manager.service@PlayerManagerService")
		Reflect.defineMetadata(PlayerManagerService, "flamework:parameters", { "server/services/data.service@DataService" })
		Reflect.defineMetadata(PlayerManagerService, "flamework:implements", { "$:flamework@OnStart" })
	end
end
-- (Flamework) PlayerManagerService decorators
Reflect.decorate(PlayerManagerService, "@flamework/core:out/flamework@Service", Service, {})
return {
	PlayerManagerService = PlayerManagerService,
}
