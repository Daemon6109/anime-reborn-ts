// Packages
import Charm from "@rbxts/charm";

// Types
import type { Player as UnitPlayer } from "@shared/data/units-data";
import type { Player as ItemPlayer } from "@shared/data/items-data";
import type Mount from "@shared/data/mount-data";
import type daily_reward from "@shared/data/daily-reward-data";
import type { PlayerDataCurrencies } from "@shared/data/currencies-data";
import type PlayerDataTeam from "@shared/data/team-data";
import type { PlayerEffectData } from "@shared/data/effects-data";
import type { BattlepassDataForPlayer } from "@shared/data/battlepass-data";
import type { AdventCalendarData } from "@shared/data/advent-calendar-data";
import type { BingoData } from "../../../../lobby/src/server/services/bingo/types";

// Charm Components
const { atom } = Charm;

export interface BattlepassData {
	premium: boolean;
	claimed: Map<number, { basic: boolean; premium: boolean }>;
}

export type PlayerData = {
	units: UnitPlayer[];
	items: ItemPlayer[];
	mounts: Mount;
	daily_reward: daily_reward;
	currencies: PlayerDataCurrencies;
	team: PlayerDataTeam;
	effects: PlayerEffectData[];
	battlepass: BattlepassData[];
	adventCalendar: AdventCalendarData;
	bingo?: BingoData;
};

type PlayerDataMap = {
	readonly [K in string]?: PlayerData;
};

export const datastore = {
	players: atom<PlayerDataMap>({}),
};

export function getPlayerData(id: string) {
	return datastore.players()[id];
}

export function setPlayerData(id: string, playerData: PlayerData) {
	datastore.players((state) => ({
		...state,
		[id]: playerData,
	}));
}

export function deletePlayerData(id: string) {
	datastore.players((state) => ({
		...state,
		[id]: undefined,
	}));
}

export function updatePlayerData(id: string, updater: (data: PlayerData) => PlayerData) {
	datastore.players((state) => ({
		...state,
		[id]: state[id] && updater(state[id]),
	}));
}
