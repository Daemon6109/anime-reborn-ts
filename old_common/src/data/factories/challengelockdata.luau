export type ChallengeLockData = {
	Seeds: { [string]: boolean },
	Time: number,
}

local function createChallengeLockData(): ChallengeLockData
	return {
		Seeds = {},
		Time = 0,
	}
end

return createChallengeLockData
