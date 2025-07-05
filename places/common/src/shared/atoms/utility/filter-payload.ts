// Packages
import ServerNetwork from "@network/server";

// Types
import type { PlayerData } from "@shared/atoms/player-data";
import type { SyncPayload } from "@rbxts/charm-sync";

// Atoms
import { GlobalAtoms } from "..";

function objectToMap<T>(obj: { [key: string]: T | undefined }): Map<string, T> {
	const map = new Map<string, T>();

	if (!obj) {
		return map;
	}

	let key = next(obj)[0];
	while (key !== undefined) {
		const value = obj[key];
		if (value !== undefined) {
			map.set(tostring(key), value);
		}
		const nextResult = next(obj, key);
		key = nextResult[0];
	}
	return map;
}

export function filterPayload(player: Player, payload: SyncPayload<GlobalAtoms>) {
	let playersMap = new Map<string, PlayerData>();

	if (payload.data.players !== undefined) {
		try {
			playersMap = objectToMap(payload.data.players as unknown as { [key: string]: PlayerData | undefined });
		} catch (error) {
			playersMap = new Map<string, PlayerData>();
		}
	}

	return {
		...payload,
		data: {
			...payload.data,
			players: playersMap,
		},
	} as unknown as Parameters<typeof ServerNetwork.playerData.Atoms.sync.fire>[1];
}
