export type * as Unit from "./units";
export type * as Team from "./team";
export type * as Item from "./items";
export type * as Effects from "./effects";

import type { Atom } from "@rbxts/charm";
import type * as Item from "./items";
import type Unit from "./units";

import type PlayerDataTeam from "./team";
import type PlayerDataEffects from "./effects";

export default interface PlayerDataTypes {
	units: Atom<Unit[]>;
	items: Atom<Item.Player[]>;
	team: Atom<PlayerDataTeam>;
	effects: Atom<PlayerDataEffects>;
}
