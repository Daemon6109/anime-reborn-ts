// Types
import type { PlayerData } from "@shared/atoms/player-data";
import type { Player as UnitPlayer } from "@shared/data/units-data";
import type { CalendarName } from "@shared/data/advent-calendar-data";

const units: UnitPlayer[] = [];

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
	shop: [], // Empty shop items array
	daily_reward: {
		last_claimed: 0,
		current_streak: 0,
		CanClaim: true,
		total_claimed: 0,
	},
	currencies: {
		gems: 0,
		gold: 0,
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
