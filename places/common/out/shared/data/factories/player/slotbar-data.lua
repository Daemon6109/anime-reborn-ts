-- Compiled with roblox-ts v2.3.0
-- Slotbar data factory
local function createSlotbar()
	return {
		UUID = "",
		UnitName = "",
		Traits = {
			[1] = "",
			[2] = "",
			[3] = "",
		},
		Relic = "",
		Skin = "",
		Level = 1,
		XP = 0,
		AbilityTree = {},
		StatsPotential = {},
		StatsTraining = {},
		Locked = false,
		Shiny = false,
	}
end
local function createSlotbarData()
	return {
		Slot1 = createSlotbar(),
		Slot2 = createSlotbar(),
		Slot3 = createSlotbar(),
		Slot4 = createSlotbar(),
		Slot5 = createSlotbar(),
		Slot6 = createSlotbar(),
	}
end
return {
	createSlotbarData = createSlotbarData,
}
