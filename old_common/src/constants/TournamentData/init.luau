local module = {}

local WEEK_SECONDS = 7 * 24 * 3600
local BASE_TIME = DateTime.fromUniversalTime(2025, 3, 8, 16, 0, 0, 0).UnixTimestamp

local mapRotation = {"Leaf Village", "West City", "Land of the Sky", "Red Army HQ", "Fujishima Island", "Ghost Tunnel", "Clover Kingdom", "Ant Cave", "Soul Desert"}

local function getCurrentUTCTournamentStart()
	local UTC = DateTime.now():ToUniversalTime()
	local currentTimestamp = DateTime.fromUniversalTime(UTC.Year, UTC.Month, UTC.Day, UTC.Hour, UTC.Minute, UTC.Second, UTC.Millisecond).UnixTimestamp
	local weeksPassed = math.floor((currentTimestamp - BASE_TIME) / WEEK_SECONDS)
	local tournamentStartTimestamp = BASE_TIME + weeksPassed * WEEK_SECONDS
	local tournamentStart = DateTime.fromUnixTimestamp(tournamentStartTimestamp)
	return tournamentStart, tournamentStartTimestamp
end

function module:ReturnTournament(Number)
	local currentPeriod = getCurrentUTCTournamentStart()
	local tournamentNumber = Number or math.floor((currentPeriod.UnixTimestamp - BASE_TIME) / WEEK_SECONDS)

	math.randomseed(BASE_TIME + tournamentNumber)

	local tournament = {}
	tournament.MapName = mapRotation[math.random(#mapRotation)]

	local modifiers = {"Fast Enemies", "Powerful Enemies", "Traits Disabled", "Shield Enemies", "Mini Range", "High Cost", "Regen Enemies"}
	local modIndex = math.random(#modifiers)
	tournament.Modifier = modifiers[modIndex]
	table.remove(modifiers, modIndex)

	if math.random() <= 0.1 then
		local sideModIndex = math.random(#modifiers)
		tournament.SideModifier = modifiers[sideModIndex]
	end

	local allElements = {"Fierce", "Fire", "Ice", "Dark", "Light", "Wind", "Water"}
	local debuffIndex = math.random(1, #allElements)
	local Debuff = allElements[debuffIndex]
	table.remove(allElements, debuffIndex)
	local Buff = allElements[math.random(1, #allElements)]

	tournament.ForcedElements = {
		[Buff] = { Min = 150, Max = 150 },
		[Debuff] = { Min = -200, Max = -200 }
	}

	local goals = {"Kills", "Damage"}
	tournament.Goal = goals[math.random(#goals)]

	tournament.Number = tournamentNumber

	local UTC = DateTime.now():ToUniversalTime()
	local currentTime = DateTime.fromUniversalTime(UTC.Year, UTC.Month, UTC.Day, UTC.Hour, UTC.Minute, UTC.Second, UTC.Millisecond).UnixTimestamp
	
	tournament.TimeLeft = (currentPeriod.UnixTimestamp + WEEK_SECONDS) - currentTime

	math.randomseed(tick())

	return tournament
end

return module