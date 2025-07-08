export type * as Unit from "./units";
export type * as Team from "./team";
export type * as Item from "./items";
export type * as Effects from "./effects";
export type * as Mount from "./mount";

import type { Atom } from "@rbxts/charm";
import type * as Item from "./items";
import type Unit from "./units";

import type PlayerDataTeam from "./team";
import type PlayerDataEffects from "./effects";
import { Mount } from "./mount";

export default interface PlayerDataTypes {
	units: Atom<Unit[]>;
	items: Atom<Item.Player[]>;
	mounts: Atom<Mount>;
	team: Atom<PlayerDataTeam>;
	effects: Atom<PlayerDataEffects>;
}
