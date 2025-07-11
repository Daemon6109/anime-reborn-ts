// Types
import type { Source } from "@rbxts/vide";

export default interface PlayerDataLevel {
	value: Source<number>;
	required: Source<number>;
	current: Source<number>;
}
