// Mission completion data factory
export interface MissionCompletionData {
	completedMissions: string[];
	currentProgress: Record<string, number>;
}

export function createMissionCompletionData(): MissionCompletionData {
	return {
		completedMissions: [],
		currentProgress: {},
	};
}
