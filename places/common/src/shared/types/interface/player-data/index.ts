export type * as Unit from "./units";
export type * as Team from "./team";
export type * as Item from "./items";

import type { Atom } from "@rbxts/charm";
import type * as Item from "./items";
import type Unit from "./units";

import type PlayerDataTeam from "./team";

export default interface PlayerDataTypes {
	units: Atom<Unit[]>;
	items: Atom<Item.Player[]>;
	team: Atom<PlayerDataTeam>;
}
