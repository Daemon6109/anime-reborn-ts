export type * as Unit from "../types/interface/player-data/units";
export type * as Team from "../types/interface/player-data/team";
export type * as Item from "../types/interface/player-data/items";
export type * as Effects from "../types/interface/player-data/effects";
export type * as Mount from "../types/interface/player-data/mount";
export type * as Battlepass from "../types/interface/player-data/battlepass";
export type * as DailyReward from "../types/interface/player-data/daily_reward";
export type * as Currencies from "../types/interface/player-data/currencies";
export type * as AdventCalendar from "../types/interface/player-data/advent-calendar";
export type * as ShopData from "../types/interface/player-data/shop";
import type { Atom } from "@rbxts/charm";
import type { Player as ItemPlayer } from "./items-data";
import type { UnitData } from "./units-data";
import type PlayerDataTeam from "./team-data";
import type { PlayerEffectData } from "./effects-data";
import type { Mount as MountData } from "./mount-data";
import type daily_reward from "./daily-reward-data";
import type { ShopItems } from "./shop-data";
import type { PlayerDataBattlepass } from "./battlepass-data";
import type { PlayerDataCurrencies } from "./currencies-data";
import type { AdventCalendarData } from "./advent-calendar-data";

export default interface PlayerDataTypes {
	units: Atom<UnitData[]>;
	items: Atom<ItemPlayer[]>;
	mounts: Atom<MountData>;
	daily_reward: Atom<daily_reward>;
	shop: Atom<ShopItems>;
	currencies: Atom<PlayerDataCurrencies>;
	team: Atom<PlayerDataTeam>;
	effects: Atom<PlayerEffectData[]>;
	battlepass: Atom<PlayerDataBattlepass>;
	adventCalendar: Atom<AdventCalendarData>;
}
