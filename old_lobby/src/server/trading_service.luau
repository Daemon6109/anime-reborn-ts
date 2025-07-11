--------------------------------------------------------------------------------
-- trading_service (placeholder)
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require("@network/server")

-- Network events
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer_2

--[=[
Service for managing player-to-player trading functionality.
Note: This is a placeholder implementation during modernization.

@class TradingService
]=]
local TradingService = {
	version = version,
}

function TradingService.startTrade(player: Player, player2UserId: number)
	NotifyPlayer:FireClient(player, {
		color = "Red",
		text = "Trading system is under maintenance",
	})
end

function TradingService.requestTrade(player: Player, targetUserId: number)
	NotifyPlayer:FireClient(player, {
		color = "Red",
		text = "Trading system is under maintenance",
	})
end

-- Register placeholder handlers
Network.registerHandler("StartTrade", TradingService.startTrade)
Network.registerHandler("RequestTrade", TradingService.requestTrade)

return TradingService
