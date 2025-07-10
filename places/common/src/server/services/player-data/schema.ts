import { t } from "@rbxts/t";
import { EFFECT_NAMES } from "@shared/types/interface/player-data/effects";
import { getCalendarNames } from "@shared/types/interface/player-data/advent-calendar";

export default t.interface({
	units: t.array(
		t.interface({
			id: t.string,
			uuid: t.string,
			trait: t.optional(
				t.literal(
					"Warrior",
					"Agile",
					"Sniper",
					"Exploder",
					"Anubis",
					"Archer",
					"Potential",
					"Wealth",
					"Slayer",
					"Heavenly",
					"Demon",
					"Ethereal",
					"Paladin",
					"Miracle",
				),
			),
			traitData: t.optional(
				t.array(
					t.interface({
						trait: t.literal(
							"Warrior",
							"Agile",
							"Sniper",
							"Exploder",
							"Anubis",
							"Archer",
							"Potential",
							"Wealth",
							"Slayer",
							"Heavenly",
							"Demon",
							"Ethereal",
							"Paladin",
							"Miracle",
						),
						time: t.number,
					}),
				),
			),
			obtainedAt: t.number,
			evo: t.number,
			shiny: t.boolean,
			locked: t.boolean,
			favorited: t.boolean,
			level: t.interface({
				value: t.number,
				current: t.number,
				target: t.number,
			}),
			potential: t.interface({
				damage: t.number,
				range: t.number,
				spa: t.number,
			}),
		}),
	),
	items: t.array(
		t.interface({
			id: t.string,
			uuid: t.string,
			amount: t.number,
			locked: t.boolean,
		}),
	),
	team: t.array(t.optional(t.string)),
	effects: t.array(
		t.interface({
			id: t.literal(...EFFECT_NAMES),
			duration: t.number,
			startTime: t.number,
		}),
	),
	battlepass: t.array(
		t.interface({
			level: t.number,
			xp: t.number,
			premium: t.boolean,
			claimed: t.map(t.number, t.interface({ basic: t.boolean, premium: t.boolean })),
		}),
	),
	adventCalendar: t.map(
		t.literal(...getCalendarNames()),
		t.interface({
			claimed: t.array(t.number),
			onlineDays: t.number,
		}),
	),
});
