export type TeamEventBattlepass = {
	Level: number,
	Exp: number,
	BattlepassName: string,
	Claimed: { ["Regular"]: { [number]: boolean }, ["Premium"]: { [number]: boolean } },
	HasPremium: boolean,
	ResetExp: boolean,
}
export type TeamEventData = {
	Shop: { Bought: { [string]: boolean } },
	ContributedSouls: number,
	ContributedReaperParts: number,
	Battlepass: TeamEventBattlepass,
	GlobalBattlepass: TeamEventBattlepass,
	Team: any?,
}

local function createTeamEventData(): TeamEventData
	return {
		Shop = {
			Bought = {},
		},

		ContributedSouls = 0,
		ContributedReaperParts = 0,

		Battlepass = {
			Level = 0,
			Exp = 0,
			BattlepassName = "",
			Claimed = {
				["Regular"] = {},
				["Premium"] = {},
			},
			HasPremium = false,
			ResetExp = false,
		},

		GlobalBattlepass = {
			Level = 0,
			Exp = 0,
			BattlepassName = "",
			Claimed = {
				["Regular"] = {},
				["Premium"] = {},
			},
			HasPremium = false,
			ResetExp = false,
		},
		Team = nil,

		HasClaimed = nil,
	}
end

return createTeamEventData
