// Battlepass data factory
export interface BattlepassData {
	Level: number;
	Exp: number;
	BattlepassName: string;
	ClaimedFree: number;
	ClaimedPremium: number;
	HasPremium: boolean;
	ResetExp: boolean;
}

export function createBattlepassData(): BattlepassData {
	return {
		Level: 0,
		Exp: 0,
		BattlepassName: "",
		ClaimedFree: 0,
		ClaimedPremium: 0,
		HasPremium: false,
		ResetExp: false,
	};
}
