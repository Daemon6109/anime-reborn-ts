export type QuestTableData = {
	Day: number,
	Week: number,
	ActiveQuests: { [string]: number },
	FinishedQuests: { [string]: boolean },
}

local function createQuestTableData(): QuestTableData
	return {
		Day = 0,
		Week = 0,
		ActiveQuests = {},
		FinishedQuests = {},
	}
end

return createQuestTableData
