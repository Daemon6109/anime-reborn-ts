export type * as Unit from "./units";
export type * as Team from "./team";
export type * as Item from "./items";
export type * as Effects from "./effects";
export type * as Battlepass from "./battlepass";

import type { Atom } from "@rbxts/charm";
import type * as Item from "./items";
import type Unit from "./units";

import type PlayerDataTeam from "./team";
import type PlayerDataEffects from "./effects";
import type PlayerDataBattlepass from "./battlepass";

export default interface PlayerDataTypes {
	units: Atom<Unit[]>;
	items: Atom<Item.Player[]>;
	team: Atom<PlayerDataTeam>;
	effects: Atom<PlayerDataEffects>;
	battlepass: Atom<PlayerDataBattlepass>;
}
