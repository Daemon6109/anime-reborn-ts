export type BingoQuest = {
	questName: string,
	progress: number,
	claimed: boolean,
}

export type BingoData = {
	NextBingoIn: number,
	Quests: { [number]: BingoQuest },
	Claimed: { [number]: boolean },
	TotalClaimedRows: number,
}

local function createBingoData(): BingoData
	return {
		NextBingoIn = 0,
		Quests = {},
		Claimed = {},
		TotalClaimedRows = 0,
	}
end

return createBingoData
