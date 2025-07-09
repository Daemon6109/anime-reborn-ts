// Types
import type { PlayerData } from "@shared/atoms/player-data";
import type * as Types from "@shared/types";

const units: Types.InterfaceProps.PlayerData.Unit.Player[] = [];

for (let i = 1; i <= 500; i++) {
	units.push({
		id: "Aizen",
		uuid: `unit-00${i}`,

		obtainedAt: 123123123,

		trait: "Miracle",
		traitData: [{ trait: "Miracle", time: 123123123 }],

		evo: 0,

		shiny: false,

		locked: false,
		favorited: false,

		level: {
			value: 1,
			current: 0,
			target: 100,
		},
		potential: {
			damage: 1.1,
			range: 1.1,
			spa: 1.1,
		},
	});
}

const defaultData: PlayerData = {
	units,
	items: [],
	mounts: { ownedMounts: [] },
	team: [],
	effects: [],
	battlepass: [
		{
			level: 0,
			xp: 0,
			premium: false,
			claimed: new Map<number, { basic: boolean; premium: boolean }>(),
		},
	],
};

export default defaultData;
