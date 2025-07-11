--------------------------------------------------------------------------------
-- tutorial_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require("@network/server")
local Person = require("@commonserver/person")
local UnitManager = require("@server/unit_manager")

-- Network events
local UICommunication = ReplicatedStorage.Events.UiCommunication

--[=[
Service for handling tutorial functionality and starter unit claiming.

@class TutorialService
]=]
local TutorialService = {
	version = version,
}

-- Constants
local TUTORIAL_UNITS = { "Luffy [PTS]", "Ichigo", "Naruto" }

--[=[
Claims a tutorial starter unit for a player.

@param player Player -- The player claiming the unit
@param unitName string -- The name of the unit to claim
]=]
function TutorialService.claimTutorialUnit(player: Player, unitName: string)
	-- Validate unit name
	if typeof(unitName) ~= "string" or not table.find(TUTORIAL_UNITS, unitName) then
		return
	end

	-- Check if already claimed
	if player:GetAttribute("TutorialClaimed") then
		return
	end

	local person = Person.new(player)
	local npcData = person.dataCache().NPCData

	-- Check if tutorial already claimed in data
	if npcData.ClaimedTutorial then
		return
	end

	-- Mark as claimed
	player:SetAttribute("TutorialClaimed", true)
	npcData.ClaimedTutorial = true

	-- Give the unit
	local unitResult = UnitManager:giveUnit(player, unitName, 1, nil, true)
	if not unitResult or #unitResult == 0 then
		return
	end

	local unit = unitResult[1]

	-- Update statistics
	local statistics = person.dataCache().PlayerStatistics
	statistics.TotalSummons = (statistics.TotalSummons or 0) + 1

	-- Trigger UI events
	UICommunication:FireClient(player, "Summon/UnitSummoned", "Summon1", { unit }, {
		openWindow = "UnitInventory",
	})

	player:SetAttribute("EndTutorialClaimed", true)

	-- Analytics tracking
	AnalyticsService:LogOnboardingFunnelStepEvent(player, 5, "Picked Starter Unit")
	AnalyticsService:LogCustomEvent(player, "TutorialUnitClaimed", {
		unitName = unitName,
	})
end

--[=[
Gets the available tutorial units.

@return table -- Array of tutorial unit names
]=]
function TutorialService.getTutorialUnits(): { string }
	return TUTORIAL_UNITS
end

--[=[
Checks if a player has completed the tutorial.

@param player Player -- The player to check
@return boolean -- Whether the tutorial is completed
]=]
function TutorialService.hasTutorialCompleted(player: Player): boolean
	local person = Person.new(player)
	return person.dataCache().NPCData.ClaimedTutorial == true
end

-- Register network handlers
Network.registerHandler("ClaimTutorialUnit", TutorialService.claimTutorialUnit)
Network.registerHandler("GetTutorialUnits", TutorialService.getTutorialUnits)
Network.registerHandler("HasTutorialCompleted", TutorialService.hasTutorialCompleted)

return TutorialService
