// Simple factories for various data types

export interface TeamEventData {
	score: number;
	contributions: Record<string, number>;
}

export function createTeamEventData(): TeamEventData {
	return {
		score: 0,
		contributions: {},
	};
}

export interface AFKData {
	afkTime: number;
	lastAfkClaim: number;
}

export function createAFKData(): AFKData {
	return {
		afkTime: 0,
		lastAfkClaim: 0,
	};
}

export interface BingoData {
	completedCells: number[];
	currentCard: string;
}

export function createBingoData(): BingoData {
	return {
		completedCells: [],
		currentCard: "",
	};
}

export interface IndexData {
	lastUpdate: number;
	entries: Record<string, unknown>;
}

export function createIndexData(): IndexData {
	return {
		lastUpdate: 0,
		entries: {},
	};
}

export interface RedeemedCodes {
	codes: string[];
}

export function createRedeemedCodes(): string[] {
	return [];
}
