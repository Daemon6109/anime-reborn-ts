import { t } from "@rbxts/t";
import { EffectName, EffectsRegistry } from "@shared/data/effects-data";
import { getCalendarNames } from "@shared/data/advent-calendar-data";

const Traits = [
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
] as const;

const EffectNames: EffectName[] = [];
for (const [name] of pairs(EffectsRegistry)) {
	EffectNames.push(name as EffectName);
}

export default t.interface({
	units: t.array(
		t.interface({
			id: t.string,
			uuid: t.string,
			trait: t.optional(t.literal(...Traits)),
			traitData: t.optional(
				t.array(
					t.interface({
						trait: t.literal(...Traits),
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
	currencies: t.interface({
		gems: t.number,
		gold: t.number,
	}),
	items: t.array(
		t.interface({
			id: t.string,
			uuid: t.string,
			amount: t.number,
			locked: t.boolean,
		}),
	),
	mounts: t.interface({
		ownedMounts: t.array(
			t.interface({
				name: t.string,
				quantity: t.number,
				equipped: t.boolean,
			}),
		),
	}),
	daily_reward: t.interface({
		last_claimed: t.number,
		current_streak: t.number,
		CanClaim: t.boolean,
		total_claimed: t.number,
	}),
	team: t.array(t.optional(t.string)),
	effects: t.array(
		t.interface({
			id: t.literal(...EffectNames),
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
