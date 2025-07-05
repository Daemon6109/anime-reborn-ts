// Types
import type { Source } from "@rbxts/vide";

export default interface PlayerDataBattlepass {
	level: {
		value: Source<number>;
		required: Source<number>;
		current: Source<number>;
	};
	premium: Source<boolean>;
	claimed: Array<{ basic: Source<boolean>; premium: Source<boolean> }>;
}
