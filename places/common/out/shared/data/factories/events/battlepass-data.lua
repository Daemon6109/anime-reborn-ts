-- Compiled with roblox-ts v2.3.0
-- Battlepass data factory
local function createBattlepassData()
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
return {
	createBattlepassData = createBattlepassData,
}
