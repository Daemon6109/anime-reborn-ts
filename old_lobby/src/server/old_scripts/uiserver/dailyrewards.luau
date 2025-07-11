local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DailyLibrary = require(ReplicatedStorage.Libs.DailyRewardsLibrary)

local DailyRewards = {
	ClaimCurrentDay = function(player)
		DailyLibrary:ClaimCurrentDay(player)
	end,

	UpdateDays = function(player)
		DailyLibrary:UpdatePlayerDays(player)
	end,
}

return DailyRewards
