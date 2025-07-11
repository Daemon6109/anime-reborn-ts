local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
--require(ServerScripts.Services.QueueHandler)
local UiCommunication = ReplicatedStorage.Events.UiCommunication

local MatchStats = {

	--SelectMap = function(player: Player, data: QueueHandler.ChosenDataType)
	--	local QueueChallengeHandler = _G.serverServices.QueueChallengeHandler

	--	local Zone = QueueChallengeHandler:GetPlayerZone(player)

	--	if Zone.MapSelector == player and not Zone.ChosenData then
	--		if not QueueChallengeHandler:ValidateData(Zone, data) then return end

	--		Zone.ChosenData = data
	--		Zone.Active = true
	--		Zone.CanPlayersEnter = true

	--		--QueueHandler:UpdateBillboard(Zone)

	--		QueueChallengeHandler:UpdateZoneGui(Zone)

	--		UiCommunication:FireClient(player, "WindowManager/CloseWindow", "MatchStats")

	--		for _, plr in Zone.Players do
	--			UiCommunication:FireClient(plr, "MatchStats/OpenQueueExitButton", plr == Zone.MapSelector)
	--		end
	--	end
	--end,

	ExitQueue = function(player: Player, GameType, MapName)
		local QueueHandler = GameType == "Challenge" and _G.serverServices.QueueChallengeHandler
			or _G.serverServices.QueueAdventureHandler
		if MapName == "World Collision" then
			QueueHandler = _G.serverServices.QueueYearHandler
		end

		local Zone = QueueHandler:GetPlayerZone(player)

		if not Zone or Zone.IsTeleporting then
			return
		end
		player:SetAttribute("WindowsDisabled", false)
		QueueHandler:KickPlayer(player)
	end,

	StartGame = function(player: Player, GameType, MapName)
		local QueueHandler = GameType == "Challenge" and _G.serverServices.QueueChallengeHandler
			or _G.serverServices.QueueAdventureHandler
		if MapName == "World Collision" then
			QueueHandler = _G.serverServices.QueueYearHandler
		end

		local Zone = QueueHandler:GetPlayerZone(player)

		if not Zone or Zone.IsTeleporting then
			return
		end

		QueueHandler:StartGame(Zone)
	end,
}

return MatchStats
