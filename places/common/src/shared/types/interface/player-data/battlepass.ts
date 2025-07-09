// Types
import type { Source } from "@rbxts/vide";
import type {
	BattlepassReward,
	BattlepassName,
	BattlepassConfig,
	BattlepassLevelData,
	ExactBattlepassConfig,
	ExactLevelData,
	ExactLevelReward,
} from "@shared/types/battlepass-data";

export interface BattlepassData {
	level: number;
	xp: number;
	premium: boolean;
	claimed: Map<number, { basic: boolean; premium: boolean }>;
}

export default interface PlayerDataBattlepass {
	level: {
		value: Source<number>;
		required: Source<number>;
		current: Source<number>;
	};
	premium: Source<boolean>;
	claimed: Array<{ basic: Source<boolean>; premium: Source<boolean> }>;
}

// Re-export all battlepass types for convenience
export type {
	BattlepassReward,
	BattlepassName,
	BattlepassConfig,
	BattlepassLevelData,
	ExactBattlepassConfig,
	ExactLevelData,
	ExactLevelReward,
};
