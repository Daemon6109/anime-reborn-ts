// Types
export type * as Profile from "./profile";
export type * as Quests from "./quest";
export type * as Areas from "./areas";
export type * as Units from "./units";
export type * as Items from "./items";
export type * as Trade from "./trade";
export type * as Codes from "./codes";
export type * as Shop from "./shop";

import type { Source } from "@rbxts/vide";

import type Profile from "./profile";
import type Quests from "./quest";
import type Areas from "./areas";
import type Units from "./units";
import type Items from "./items";
import type Trade from "./trade";
import type Codes from "./codes";
import type Shop from "./shop";

export default interface LeftSideTypes {
	visible: Source<boolean>;

	units: Units;
	items: Items;

	profile: Profile;
	quests: Quests;
	areas: Areas;
	trade: Trade;
	codes: Codes;
	shop: Shop;
}
