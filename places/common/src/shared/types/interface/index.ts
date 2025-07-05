// Types
export type * as RightSideButtons from "./right-side-buttons";
export type * as LeftSideButtons from "./left-side-buttons";
export type * as PlayerData from "./player-data";
export type * as Shared from "./shared";
export type * as Hotbar from "./hotbar";

export type * as Network from "@network/client";

import type RightSideButtons from "./right-side-buttons";
import type LeftSideButtons from "./left-side-buttons";
import type PlayerData from "./player-data";
import type Shared from "./shared";
import type Hotbar from "./hotbar";

export default interface InterfaceProps {
	rightSideButtons: RightSideButtons;
	leftSideButtons: LeftSideButtons;
	playerData: PlayerData;
	hotbar: Hotbar;
	shared: Shared;
}
