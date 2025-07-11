// Types
import { source } from "@rbxts/vide";
import type { PlayerData } from "@shared/atoms/player-data";
import type * as Types from "@shared/types";
import type { CalendarName } from "@shared/types/interface/player-data/advent-calendar";

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
	daily_reward: {
		last_claimed: 0,
		current_streak: 0,
		CanClaim: true,
		total_claimed: 0,
	},
	currencies: {
		gold: source(0), // watever default is for gold and gems
		gems: source(0),
	},
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
	adventCalendar: new Map<CalendarName, { claimed: number[]; onlineDays: number }>(),
};

export default defaultData;
