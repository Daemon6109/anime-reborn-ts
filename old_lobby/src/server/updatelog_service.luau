--------------------------------------------------------------------------------
-- updatelog_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local AnalyticsService = game:GetService("AnalyticsService")

local Network = require("@network/server")

--[=[
Service for handling update log interactions and analytics.

@class UpdateLogService
]=]
local UpdateLogService = {
	version = version,
}

--[=[
Handles when a player closes the update log.

@param player Player -- The player closing the update log
]=]
function UpdateLogService.close(player: Player)
	if not player:GetAttribute("ClosedUpdLogs") then
		player:SetAttribute("ClosedUpdLogs", true)
		AnalyticsService:LogOnboardingFunnelStepEvent(player, 3, "Closed Update Log")
	end
end

-- Register network handlers
Network.registerHandler("CloseUpdateLog", UpdateLogService.close)

return UpdateLogService
