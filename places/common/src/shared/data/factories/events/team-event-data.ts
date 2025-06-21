export interface TeamEventData {
	HasClaimed: boolean;
	Team: string;
}

export function createTeamEventData(): TeamEventData {
	return {
		HasClaimed: false,
		Team: "None",
	};
}
