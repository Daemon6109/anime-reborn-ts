--------------------------------------------------------------------------------
-- team_events
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server").common
local MockDataStoreService = require("@pkgs/mockdatastoreservice")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local Players = game:GetService("Players")

type Signal<T> = Shingo.Signal<T>

-- Create signals for team event events
local teamJoinedEvent = Shingo.new() :: Signal<any>
local pointsEarnedEvent = Shingo.new() :: Signal<any>
local eventEndedEvent = Shingo.new() :: Signal<any>

export type TeamEventConfig = {
	name: string,
	description: string,
	teams: { string },
	startTime: number, -- Unix timestamp
	endTime: number, -- Unix timestamp
	rewards: {
		[string]: { -- team name
			[number]: { [string]: any }, -- placement -> rewards
		},
	},
}

--[=[
   Team event system for managing competitive team-based events.

   @class TeamEvents
]=]
local TeamEvents = {
	version = version,

	-- Events
	teamJoined = teamJoinedEvent,
	pointsEarned = pointsEarnedEvent,
	eventEnded = eventEndedEvent,

	-- Active events
	activeEvents = {} :: { [string]: TeamEventConfig },
}

-- Global team balancing data store
local TeamBalancingDataStore = MockDataStoreService:GetDataStore("TeamBalancing")
local teamBalanceValue = 50000 -- Default value

--[=[
   Loads the team balance value from the data store.

   @within TeamEvents

   @private

   ```lua
   TeamEvents.loadTeamBalanceValue()
   ```
]=]
local function loadTeamBalanceValue(): ()
	local success, result = pcall(function()
		return TeamBalancingDataStore:UpdateAsync("Value", function(newValue)
			teamBalanceValue = newValue or 50000
			return teamBalanceValue
		end)
	end)

	if not success then
		warn("Failed to load team balance value:", result)
	end
end

--[=[
   Updates the team balance value in the data store.

   @within TeamEvents

   @private

   @param addValue number -- Value to add to the balance

   ```lua
   TeamEvents.updateTeamBalanceValue(1000)
   ```
]=]
local function updateTeamBalanceValue(addValue: number): ()
	local success, result = pcall(function()
		return TeamBalancingDataStore:UpdateAsync("Value", function(newValue)
			newValue = newValue or 50000
			teamBalanceValue = newValue + addValue
			return teamBalanceValue
		end)
	end)

	if not success then
		warn("Failed to update team balance value:", result)
	end
end

--[=[
   Checks if an event is currently active.

   @within TeamEvents

   @private

   @param config TeamEventConfig -- The event configuration

   @return boolean -- Whether the event is active

   ```lua
   local isActive = TeamEvents.isEventActive(eventConfig)
   ```
]=]
local function isEventActive(config: TeamEventConfig): boolean
	local currentTime = os.time()
	return currentTime >= config.startTime and currentTime <= config.endTime
end

--[=[
   Selects a team based on balance considerations.

   @within TeamEvents

   @private

   @param teams { string } -- Available teams

   @return string -- Selected team name

   ```lua
   local selectedTeam = TeamEvents.selectBalancedTeam({"TeamA", "TeamB"})
   ```
]=]
local function selectBalancedTeam(teams: { string }): string
	-- Simple balancing: alternate between teams based on team balance value
	local teamIndex = (teamBalanceValue % #teams) + 1
	updateTeamBalanceValue(1)

	return teams[teamIndex]
end

--[=[
   Joins a player to a team.

   @within TeamEvents

   @param person Person -- The person joining the team
   @param teamName string -- The team to join

   @return boolean -- Whether the join was successful

   ```lua
   local success = TeamEvents.joinTeam(person, "TeamA")
   ```
]=]
local function joinTeam(person: Person.Person, teamName: string): boolean
	-- Find an active event that has this team
	local activeEvent = nil
	for eventId, config in pairs(TeamEvents.activeEvents) do
		if isEventActive(config) and table.find(config.teams, teamName) then
			activeEvent = config
			break
		end
	end

	if not activeEvent then
		return false
	end

	-- Update player data
	person.dataCache(function(dataCache)
		local newDataCache = table.clone(dataCache)
		local teamEventData = newDataCache.TeamEventData

		teamEventData.Team = teamName

		return newDataCache
	end)

	teamJoinedEvent:fire(person.player, teamName)
	return true
end

--[=[
   Assigns a team to a player if they don't have one.

   @within TeamEvents

   @private

   @param person Person -- The person to assign a team to

   ```lua
   TeamEvents.assignTeamIfNeeded(person)
   ```
]=]
local function assignTeamIfNeeded(person: Person.Person): ()
	local dataCache = person.dataCache()
	local teamEventData = dataCache.TeamEventData

	-- Check if player already has a team
	if teamEventData.Team and teamEventData.Team ~= "" then
		return
	end

	-- Find active event to assign team for
	for eventId, config in pairs(TeamEvents.activeEvents) do
		if isEventActive(config) then
			local assignedTeam = selectBalancedTeam(config.teams)
			joinTeam(person, assignedTeam)
			break
		end
	end
end

--[=[
   Gives team event rewards to a player.

   @within TeamEvents

   @private

   @param person Person -- The person to give rewards to
   @param rewards { [string]: any } -- The rewards to give

   ```lua
   TeamEvents.giveTeamRewards(person, { Gold = 1000, Gems = 500 })
   ```
]=]
local function giveTeamRewards(person: Person.Person, rewards: { [string]: any }): ()
	person.dataCache(function(dataCache)
		local newDataCache = table.clone(dataCache)
		local currencies = newDataCache.Currencies

		-- Give currency rewards
		for rewardType, amount in pairs(rewards) do
			if typeof(amount) == "number" then
				currencies[rewardType] = (currencies[rewardType] or 0) + amount
			end
		end

		return newDataCache
	end)
end

--[=[
   Distributes rewards to all members of a team.

   @within TeamEvents

   @private

   @param teamName string -- The team name
   @param rewards { [string]: any } -- The rewards to distribute

   ```lua
   TeamEvents.distributeTeamRewards("TeamA", { Gold = 1000, Gems = 500 })
   ```
]=]
local function distributeTeamRewards(teamName: string, rewards: { [string]: any }): ()
	for _, player in pairs(Players:GetPlayers()) do
		local person = Person.getForPlayer(player):Await()
		if person then
			local dataCache = person.dataCache()
			local teamEventData = dataCache.TeamEventData

			if teamEventData.Team == teamName then
				giveTeamRewards(person, rewards)
			end
		end
	end
end

--[=[
   Gets the total contribution for a team across all players.

   @within TeamEvents

   @param teamName string -- The team name

   @return number -- Total team contribution (souls + reaper parts)

   ```lua
   local totalContribution = TeamEvents.getTeamTotalContribution("TeamA")
   ```
]=]
local function getTeamTotalContribution(teamName: string): number
	local totalContribution = 0

	for _, player in pairs(Players:GetPlayers()) do
		local person = Person.getForPlayer(player):Await()
		if person then
			local dataCache = person.dataCache()
			local teamEventData = dataCache.TeamEventData

			if teamEventData.Team == teamName then
				totalContribution = totalContribution
					+ teamEventData.ContributedSouls
					+ teamEventData.ContributedReaperParts
			end
		end
	end

	return totalContribution
end

--[=[
   Gets team rankings for active events.

   @within TeamEvents

   @return { { team: string, contribution: number } } -- Sorted team rankings

   ```lua
   local rankings = TeamEvents.getTeamRankings()
   ```
]=]
local function getTeamRankings(): { { team: string, contribution: number } }
	local teamContributions = {}
	local rankings = {}

	-- Collect contributions for each team
	for _, player in pairs(Players:GetPlayers()) do
		local person = Person.getForPlayer(player):Await()
		if person then
			local dataCache = person.dataCache()
			local teamEventData = dataCache.TeamEventData

			if teamEventData.Team and teamEventData.Team ~= "" then
				teamContributions[teamEventData.Team] = (teamContributions[teamEventData.Team] or 0)
					+ teamEventData.ContributedSouls
					+ teamEventData.ContributedReaperParts
			end
		end
	end

	-- Convert to ranking array
	for team, contribution in pairs(teamContributions) do
		table.insert(rankings, { team = team, contribution = contribution })
	end

	-- Sort by contribution (highest first)
	table.sort(rankings, function(a, b)
		return a.contribution > b.contribution
	end)

	return rankings
end

--[=[
   Ends a team event and distributes rewards.

   @within TeamEvents

   @private

   @param eventId string -- The event identifier
   @param config TeamEventConfig -- The event configuration

   ```lua
   TeamEvents.endEvent("event_id", eventConfig)
   ```
]=]
local function endEvent(eventId: string, config: TeamEventConfig): ()
	local rankings = getTeamRankings()

	-- Distribute rewards based on rankings
	for placement, rankData in ipairs(rankings) do
		local teamName = rankData.team
		local rewards = config.rewards[teamName] and config.rewards[teamName][placement]

		if rewards then
			distributeTeamRewards(teamName, rewards)
		end
	end

	-- Remove from active events
	TeamEvents.activeEvents[eventId] = nil

	eventEndedEvent:fire(eventId)
end

--[=[
   Checks the status of all events and handles endings.

   @within TeamEvents

   @private

   ```lua
   TeamEvents.checkEventStatus()
   ```
]=]
local function checkEventStatus(): ()
	local currentTime = os.time()

	for eventId, config in pairs(TeamEvents.activeEvents) do
		if currentTime > config.endTime then
			endEvent(eventId, config)
		end
	end
end

--[=[
   Registers a team event.

   @within TeamEvents

   @param eventId string -- The event identifier
   @param config TeamEventConfig -- The event configuration

   ```lua
   TeamEvents.registerEvent("event_id", eventConfig)
   ```
]=]
local function registerEvent(eventId: string, config: TeamEventConfig): ()
	TeamEvents.activeEvents[eventId] = config
end

--[=[
   Loads default team events.

   @within TeamEvents

   @private

   ```lua
   TeamEvents.loadDefaultEvents()
   ```
]=]
local function loadDefaultEvents(): ()
	-- Example: Aliens vs Spirits event
	local aliensVsSpirits: TeamEventConfig = {
		name = "Aliens vs Spirits",
		description = "Epic battle between two powerful factions!",
		teams = { "Aliens", "Spirits" },
		startTime = os.time(), -- Current time for demo
		endTime = os.time() + (86400 * 7), -- One week from now
		rewards = {
			["Aliens"] = {
				[1] = { Gold = 5000, Gems = 500 }, -- 1st place
				[2] = { Gold = 3000, Gems = 300 }, -- 2nd place
			},
			["Spirits"] = {
				[1] = { Gold = 5000, Gems = 500 }, -- 1st place
				[2] = { Gold = 3000, Gems = 300 }, -- 2nd place
			},
		},
	}

	registerEvent("aliens_vs_spirits", aliensVsSpirits)
end

--[=[
   Awards souls contribution to a player for their team.

   @within TeamEvents

   @param person Person -- The person earning souls
   @param souls number -- The souls to contribute
   @param reason string? -- Optional reason for the contribution

   ```lua
   TeamEvents.awardTeamSouls(person, 100, "Completed a quest")
   ```
]=]
local function awardTeamSouls(person: Person.Person, souls: number, reason: string?): ()
	local dataCache = person.dataCache()
	local teamEventData = dataCache.TeamEventData

	if not teamEventData.Team or teamEventData.Team == "" then
		return
	end

	person.dataCache(function(currentDataCache)
		local newDataCache = table.clone(currentDataCache)
		local newTeamEventData = newDataCache.TeamEventData

		newTeamEventData.ContributedSouls = newTeamEventData.ContributedSouls + souls

		return newDataCache
	end)

	pointsEarnedEvent:fire(person.player, teamEventData.Team, souls)
end

--[=[
   Awards reaper parts contribution to a player for their team.

   @within TeamEvents

   @param person Person -- The person earning reaper parts
   @param reaperParts number -- The reaper parts to contribute
   @param reason string? -- Optional reason for the contribution

   ```lua
   TeamEvents.awardTeamReaperParts(person, 50, "Defeated a boss")
   ```
]=]
local function awardTeamReaperParts(person: Person.Person, reaperParts: number, reason: string?): ()
	local dataCache = person.dataCache()
	local teamEventData = dataCache.TeamEventData

	if not teamEventData.Team or teamEventData.Team == "" then
		return
	end

	person.dataCache(function(currentDataCache)
		local newDataCache = table.clone(currentDataCache)
		local newTeamEventData = newDataCache.TeamEventData

		newTeamEventData.ContributedReaperParts = newTeamEventData.ContributedReaperParts + reaperParts

		return newDataCache
	end)

	pointsEarnedEvent:fire(person.player, teamEventData.Team, reaperParts)
end

--[=[
   Gets the current team for a player.

   @within TeamEvents

   @param person Person -- The person to check

   @return string? -- The current team name

   ```lua
   local currentTeam = TeamEvents.getCurrentTeam(person)
   ```
]=]
local function getCurrentTeam(person: Person.Person): string?
	local dataCache = person.dataCache()
	return dataCache.TeamEventData.Team
end

--[=[
   Gets the team contribution for a player.

   @within TeamEvents

   @param person Person -- The person to check

   @return number -- The player's total team contribution

   ```lua
   local teamContribution = TeamEvents.getPlayerTeamContribution(person)
   ```
]=]
local function getPlayerTeamContribution(person: Person.Person): number
	local dataCache = person.dataCache()
	local teamEventData = dataCache.TeamEventData
	return teamEventData.ContributedSouls + teamEventData.ContributedReaperParts
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   team_events.start()
   ```
]=]
local function start(): ()
	-- Set up network events
	Network.JoinTeam.on(function(player, teamId)
		local person = Person.getForPlayer(player):Await()
		if not person then
			return
		end
		joinTeam(person, teamId)
	end)
	-- Set up periodic event checks
	task.spawn(function()
		while true do
			task.wait(60) -- Check every minute
			checkEventStatus()
		end
	end)

	-- Load default events
	loadDefaultEvents()
end

--[=[
   This function is used for initialization. It should be called before `start()` to set up the provider.

   ```lua
   team_events.init()
   ```
]=]
local function init(): ()
	-- Load team balance value
	loadTeamBalanceValue()

	-- Set up person events
	Person.personAdded:connect(function(person): ()
		assignTeamIfNeeded(person)
	end)
end

return {
	version = version,

	-- Functions
	start = start,
	init = init,
	joinTeam = joinTeam,
	awardTeamSouls = awardTeamSouls,
	awardTeamReaperParts = awardTeamReaperParts,
	getCurrentTeam = getCurrentTeam,
	getPlayerTeamContribution = getPlayerTeamContribution,
	getTeamTotalContribution = getTeamTotalContribution,
	getTeamRankings = getTeamRankings,
	registerEvent = registerEvent,

	-- Events
	teamJoined = teamJoinedEvent,
	pointsEarned = pointsEarnedEvent,
	eventEnded = eventEndedEvent,
}
