export type * as Unit from "./units";
export type * as Team from "./team";
export type * as Item from "./items";
export type * as Effects from "./effects";
export type * as Mount from "./mount";
export type * as Battlepass from "./battlepass";
export type * as DailyReward from "./daily_reward";
export type * as Currencies from "./currencies";

import type { Atom } from "@rbxts/charm";
import type * as Item from "./items";
import type Unit from "./units";

import type PlayerDataTeam from "./team";
import type PlayerDataEffects from "./effects";
import type { Mount } from "./mount";
import type daily_reward from "./daily_reward";
import type PlayerDataBattlepass from "./battlepass";
import { Currencies } from "../../../data/data-template";

export default interface PlayerDataTypes {
	units: Atom<Unit[]>;
	items: Atom<Item.Player[]>;
	mounts: Atom<Mount>;
	daily_reward: Atom<daily_reward>;
	currencies: Atom<Currencies>;
	team: Atom<PlayerDataTeam>;
	effects: Atom<PlayerDataEffects>;
	battlepass: Atom<PlayerDataBattlepass>;
}
