export type TournamentsData = {
	PreviousResults: {},
	Bracket: any?,
	Damage: number,
	Kills: number,
	CurrentTournament: any?,
}

local function createTournamentsData(): TournamentsData
	return {
		PreviousResults = {},

		Bracket = nil,

		Damage = 0,
		Kills = 0,

		CurrentTournament = nil,
	}
end

return createTournamentsData
