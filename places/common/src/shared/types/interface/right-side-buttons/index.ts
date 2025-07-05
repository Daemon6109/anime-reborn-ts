// Types
export type * as Battlepass from "./battlepass";
export type * as Crates from "./crates";
export type * as Bingo from "./bingo";

import type { Source } from "@rbxts/vide";

import type Pass from "./battlepass";
import type Crates from "./crates";
import type Bingo from "./bingo";

export default interface RightSideTypes {
	visible: Source<boolean>;

	battlepass: Pass;
	crates: Crates;
	bingo: Bingo;
}
