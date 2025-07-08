import { t } from "@rbxts/t";

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
			id: t.string,
			duration: t.number,
			startTime: t.number,
		}),
	),
});
