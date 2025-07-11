local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)

local DataAPI = DataAccess:GetAPI()

local uiCommunication = game.ReplicatedStorage.Events.UiCommunication

local TutorialUnits = { "Luffy [PTS]", "Ichigo", "Naruto" }

local unitManager

local MapSelection = {

	Claim = function(player: Player, UnitName)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		if typeof(UnitName) ~= "string" then
			return
		end
		if not table.find(TutorialUnits, UnitName) then
			return
		end
		if player:GetAttribute("TutorialClaimed") then
			return
		end
		player:SetAttribute("TutorialClaimed", true)
		if PlayerProfile:GetField("NPCData").ClaimedTutorial == true then
			return
		end

		PlayerProfile:WriteDirectory("NPCData/ClaimedTutorial", true, true)

		warn("Claiming", UnitName)

		unitManager = unitManager or _G.serverServices.UnitManager
		local unit = unitManager:giveUnit(player, UnitName, 1, nil, true)
		unit = unit[1]

		PlayerProfile:ReplicateField("SummoningData")

		local statistics = PlayerProfile:GetField("PlayerStatistics")
		PlayerProfile:WriteDirectory("PlayerStatistics/TotalSummons", statistics.TotalSummons + 1, true)

		uiCommunication:FireClient(player, "Summon/UnitSummoned", "Summon1", { unit }, { openWindow = "UnitInventory" })
		player:SetAttribute("EndTutorialClaimed", true)

		AnalyticsService:LogOnboardingFunnelStepEvent(player, 5, "Picked Stater Unit")
	end,
}

return MapSelection
