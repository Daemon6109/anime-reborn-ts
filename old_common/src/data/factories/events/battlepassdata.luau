export type BattlepassData = {
	Level: number,
	Exp: number,
	BattlepassName: string,
	ClaimedFree: number,
	ClaimedPremium: number,
	HasPremium: boolean,
	ResetExp: boolean,
}

local function createBattlepassData(): BattlepassData
	return {
		Level = 0,
		Exp = 0,
		BattlepassName = "",
		ClaimedFree = 0,
		ClaimedPremium = 0,
		HasPremium = false,
		ResetExp = false,
	}
end

return createBattlepassData
