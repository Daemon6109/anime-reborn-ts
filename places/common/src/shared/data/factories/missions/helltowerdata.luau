export type HellTowerRoomCompletion = {
	ClearAmount: number,
	FastestTime: number,
}
export type HellTowerData = {
	HighestRoom: number,
	Season: number,
	RoomCompletionData: { [string]: HellTowerRoomCompletion },
	ClaimData: { [number]: boolean },
}

local function createHellTowerData(): HellTowerData
	return {
		HighestRoom = 0,
		Season = 1,
		RoomCompletionData = {
			["1"] = {
				ClearAmount = 0,
				FastestTime = 0,
			},
		},
		ClaimData = {},
	}
end

return createHellTowerData
