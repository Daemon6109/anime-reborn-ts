// Types
import type { Source } from "@rbxts/vide";
import type * as Item from "../types/interface/player-data/items";
import type * as Unit from "../types/interface/player-data/units";

export interface RawBingoQuest {
	name: string;
	progress: {
		current: number;
		target: number;
	};
}

export interface BingoQuest {
	name: Source<string>;
	progress: {
		current: Source<number>;
		target: Source<number>;
	};
}

export interface PlayerDataBingo {
	quests: Source<
		[
			Source<BingoQuest>,
			Source<BingoQuest>,
			Source<BingoQuest>,
			Source<BingoQuest>,
			Source<BingoQuest>,
			Source<BingoQuest>,
			Source<BingoQuest>,
			Source<BingoQuest>,
			Source<BingoQuest>,
		]
	>;
	rewards: {
		sheet: Source<Array<Unit.Constant | Item.Constant>>;
		row: Source<Array<Unit.Constant | Item.Constant>>;
	};
}
