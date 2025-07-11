import bingoQuests from "@shared/configuration/bingo-quests-data.json";

export type BingoQuestsRegistry = typeof bingoQuests;
export type BingoQuestName = keyof BingoQuestsRegistry;
export type BingoQuestData = BingoQuestsRegistry[BingoQuestName];

/**
 * All bingo quests organized by their internal names
 */
export const BingoQuestsRegistry: BingoQuestsRegistry = bingoQuests;

/**
 * Helper functions for working with bingo quests
 */
export namespace BingoQuestsData {
	/**
	 * Get bingo quest data by name
	 */
	export function getBingoQuest(name: BingoQuestName): BingoQuestData | undefined {
		return BingoQuestsRegistry[name];
	}

	/**
	 * Get the max progress for a bingo quest
	 */
	export function getMaxProgress(name: BingoQuestName): number | undefined {
		return BingoQuestsRegistry[name]?.MaxProgress;
	}

	/**
	 * Get the min progress for a bingo quest
	 */
	export function getMinProgress(name: BingoQuestName): number | undefined {
		return BingoQuestsRegistry[name]?.MinProgress;
	}

	/**
	 * Get the display name for a bingo quest
	 */
	export function getDisplayName(name: BingoQuestName): string | undefined {
		return BingoQuestsRegistry[name]?.Name;
	}
}
