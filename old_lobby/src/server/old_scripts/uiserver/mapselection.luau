local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
--require(ServerScripts.Services.QueueHandler)
local UiCommunication = ReplicatedStorage.Events.UiCommunication
local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)

local DataAPI = DataAccess:GetAPI()

local MapSelection = {

	SelectMap = function(player: Player, data: QueueHandler.ChosenDataType)
		local GameType = data.GameType
		GameType = GameType == "Legend" and "Story" or GameType
		local QueueGameType = GameType
		if data.MapName == "Winter Mayhem" then
			QueueGameType = "Adventure"
		end

		local QueueHandler = GameType and _G.serverServices[`Queue{QueueGameType}Handler`]
			or _G.serverServices.QueueHandler

		local Zone = QueueHandler:GetPlayerZone(player)

		if Zone.MapSelector == player and not Zone.ChosenData then
			if not QueueHandler:ValidateData(Zone, data) then
				return
			end

			Zone.ChosenData = data
			--warn(Zone.ChosenData)
			Zone.Active = true
			Zone.CanPlayersEnter = true

			local FoundMap = _G.Registry.registry.Maps[Zone.ChosenData.MapName]
			local FoundAct = require(
				_G.Registry.registry.Maps[Zone.ChosenData.MapName].raw[GameType]:FindFirstChild(
					Zone.ChosenData.GameScenarioID
				)
			)
			--QueueHandler:UpdateBillboard(Zone)
			Zone.DisplayName = FoundMap.DisplayName
			Zone.Icon = FoundMap.Icon

			QueueHandler:UpdateZoneGui(Zone, player == Zone.MapSelector)
			player:SetAttribute("WindowsDisabled", false)

			UiCommunication:FireClient(player, "WindowManager/CloseWindow", "MapSelection")

			local PlayersHolder, RewardsHolder, MapData =
				Zone.Instance.GuiContainer.SurfaceGui.Container.Frame,
				Zone.Instance.GuiContainer.SurfaceGui.Container.Rewards,
				Zone.Instance.GuiContainer.SurfaceGui.Container.MapData

			--warn(',Zone.Difficulty',Zone.Difficulty)
			--warn('opening the side menu rn')
			UiCommunication:FireClient(
				player,
				"WindowManager/OpenWindow",
				{
					WindowName = "MatchStats",
					CloseCurrentWindow = true,
					HideSlotBar = true,
					Blur = false,
					BarsHidden = true,
					Darken = false,
				},
				Zone.PassedTime,
				Zone.DisplayName,
				Zone.Icon,
				Zone.ChallengeDisplayName,
				Zone.TimerDisplay,
				Zone.TimerBar,
				PlayersHolder,
				RewardsHolder,
				MapData,
				Zone.ChosenData.Difficulty,
				{
					["GameType"] = Zone.ChosenData.GameType,
					["GameScenarioID"] = Zone.ChosenData.GameScenarioID,
					["MapName"] = Zone.ChosenData.MapName,
					["BossName"] = FoundAct.Boss,
				}
			)

			for _, plr in Zone.Players do
				UiCommunication:FireClient(plr, "MapSelection/OpenQueueExitButton", plr == Zone.MapSelector, Zone)
			end
		end
	end,

	ExitQueue = function(player: Player, GameType)
		print(GameType)
		if GameType and typeof(GameType) ~= "string" then
			return
		end
		local QueueHandler = GameType and _G.serverServices[`Queue{GameType}Handler`] or _G.serverServices.QueueHandler

		local Zone = QueueHandler:GetPlayerZone(player)

		if not Zone or Zone.IsTeleporting then
			return
		end
		player:SetAttribute("WindowsDisabled", false)
		QueueHandler:KickPlayer(player)
	end,

	StartGame = function(player: Player, GameType)
		print(GameType)
		if GameType and typeof(GameType) ~= "string" then
			return
		end
		local QueueHandler = GameType and _G.serverServices[`Queue{GameType}Handler`] or _G.serverServices.QueueHandler

		local Zone = QueueHandler:GetPlayerZone(player)

		if not Zone or Zone.MapSelector ~= player or Zone.IsTeleporting then
			return
		end

		QueueHandler:StartGame(Zone)

		AnalyticsService:LogOnboardingFunnelStepEvent(player, 7, "Starting Match")
	end,
}

return MapSelection
