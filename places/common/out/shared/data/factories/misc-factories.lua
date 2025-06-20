-- Compiled with roblox-ts v2.3.0
-- Simple factories for various data types
local function createTeamEventData()
	return {
		score = 0,
		contributions = {},
	}
end
local function createAFKData()
	return {
		afkTime = 0,
		lastAfkClaim = 0,
	}
end
local function createBingoData()
	return {
		completedCells = {},
		currentCard = "",
	}
end
local function createIndexData()
	return {
		lastUpdate = 0,
		entries = {},
	}
end
local function createRedeemedCodes()
	return {}
end
return {
	createTeamEventData = createTeamEventData,
	createAFKData = createAFKData,
	createBingoData = createBingoData,
	createIndexData = createIndexData,
	createRedeemedCodes = createRedeemedCodes,
}
