// Packages
import Charm from "@rbxts/charm";

// Types
import type * as Types from "@shared/types";

// Charm Components
const { atom } = Charm;

export type PlayerData = {
	units: Types.InterfaceProps.PlayerData.Unit.Player[];
	items: Types.InterfaceProps.PlayerData.Item.Player[];
	mounts: Types.InterfaceProps.PlayerData.Mount.Mount;
	daily_reward: Types.InterfaceProps.PlayerData.DailyReward.daily_reward;
	currencies: Types.InterfaceProps.PlayerData.Currencies.default;
	team: Types.InterfaceProps.PlayerData.Team.default;
	effects: Types.InterfaceProps.PlayerData.Effects.EffectData[];
	battlepass: Types.InterfaceProps.PlayerData.Battlepass.BattlepassData[];
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
