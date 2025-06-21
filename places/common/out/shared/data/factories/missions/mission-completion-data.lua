-- Compiled with roblox-ts v2.3.0
-- Mission completion data factory
local function createMissionCompletionData()
	return {
		completedMissions = {},
		currentProgress = {},
	}
end
return {
	createMissionCompletionData = createMissionCompletionData,
}
