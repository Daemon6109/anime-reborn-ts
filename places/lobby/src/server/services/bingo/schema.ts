import { t } from "@rbxts/t";

export const bingoQuestSchema = t.interface({
	id: t.string,
	completed: t.boolean,
	progress: t.number,
	target: t.number,
});

export const bingoDataSchema = t.interface({
	board: t.array(t.array(bingoQuestSchema)),
	lastRefreshed: t.number,
	rowRewards: t.array(t.boolean),
	columnRewards: t.array(t.boolean),
	diagonalRewards: t.array(t.boolean),
});
