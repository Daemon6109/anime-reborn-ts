export interface BingoQuest {
	id: string;
	completed: boolean;
	progress: number;
	target: number;
}

export interface BingoData {
	board: BingoQuest[][];
	lastRefreshed: number;
	rowRewards: boolean[];
	columnRewards: boolean[];
	diagonalRewards: boolean[];
}
