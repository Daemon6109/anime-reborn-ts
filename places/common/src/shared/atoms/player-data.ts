// Packages
import Charm from "@rbxts/charm";

// Types
import type * as Types from "@shared/types";
import type PlayerDataEffects from "@shared/types/interface/player-data/effects";

// Charm Components
const { atom } = Charm;

export type PlayerData = {
	units: Types.InterfaceProps.PlayerData.Unit.Player[];
	items: Types.InterfaceProps.PlayerData.Item.Player[];
	mounts: Types.InterfaceProps.PlayerData.Mount.Mount;
	team: Types.InterfaceProps.PlayerData.Team.default;
	effects: PlayerDataEffects[];
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
