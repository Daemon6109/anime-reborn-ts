// effects
--------------------------------------------------------------------------------

import { EffectsData, Multiplier, EffectData } from "@registry/EffectsData";
import { Person } from "@commonserver/person";
import { DateTime } from "@rbxts/luxon";

const version = { major: 1, minor: 0, patch: 0 };

interface ActiveEffectData {
	Duration: number;
	StartTime: number;
}

interface EffectsCacheData {
	Effects: { [key: string]: ActiveEffectData };
}

//[=[
//	Effects module for managing player effects in the game.
//
//	@class Effects
//]=]
const Effects = {
	//[=[
	//	Applies an effect to a player.
	//
	//	@within Effects
	//
	//	@param person Person -- The person to apply the effect to
	//	@param effect Multiplier -- The effect name
	//	@param span number -- Duration in seconds
	//
	//	```ts
	//	Effects.ApplyEffect(person, "ExpBoost", 3600);
	//	```
	//]=]
	ApplyEffect(person: Person, effect: Multiplier, span: number): void {
		if (!EffectsData[effect]) {
			warn(`Invalid effect: ${effect}`);
			return;
		}
		person.dataCache((dataCache) => {
			const effects = (dataCache as EffectsCacheData).Effects;
			let newTable: ActiveEffectData;
			if (Effects.IsEffectActive(person, effect)) {
				newTable = {
					Duration: effects[effect].Duration + span,
					StartTime: effects[effect].StartTime,
				};
			} else {
				newTable = {
					Duration: span,
					StartTime: DateTime.now().toUnixInteger(),
				};
			}
			effects[effect] = newTable;
			return dataCache;
		});
	},

	//[=[
	//	Revokes an effect from a player.
	//
	//	@within Effects
	//
	//	@param person Person -- The person to revoke the effect from
	//	@param effect Multiplier -- The effect name
	//
	//	```ts
	//	Effects.RevokeEffect(person, "ExpBoost");
	//	```
	//]=]
	RevokeEffect(person: Person, effect: Multiplier): void {
		person.dataCache((dataCache) => {
			const effects = (dataCache as EffectsCacheData).Effects;
			if (effects[effect]) {
				delete effects[effect];
			}
			return dataCache;
		});
	},

	//[=[
	//	Checks if an effect is currently active for a player.
	//
	//	@within Effects
	//
	//	@param person Person -- The person to check
	//	@param effect Multiplier -- The effect name
	//
	//	@return boolean -- Whether the effect is active
	//
	//	```ts
	//	const isActive = Effects.IsEffectActive(person, "ExpBoost");
	//	```
	//]=]
	IsEffectActive(person: Person, effect: Multiplier): boolean {
		const dataCache = person.dataCache() as EffectsCacheData;
		const effects = dataCache.Effects;
		if (effects[effect]) {
			return effects[effect].StartTime + effects[effect].Duration > DateTime.now().toUnixInteger();
		} else {
			return false;
		}
	},

	//[=[
	//	Gets all active effects for a player.
	//
	//	@within Effects
	//
	//	@param person Person -- The person to get effects for
	//	@return { [key in Multiplier]?: ActiveEffectData } -- Dictionary of active effects
	//
	//	```ts
	//	const activeEffects = Effects.GetAllActiveEffects(person);
	//	```
	//]=]
	GetAllActiveEffects(person: Person): { [key in Multiplier]?: ActiveEffectData } {
		const dataCache = person.dataCache() as EffectsCacheData;
		const allEffects = dataCache.Effects;
		const toReturn: { [key in Multiplier]?: ActiveEffectData } = {};

		for (const [effect, data] of pairs(allEffects)) {
			if (Effects.IsEffectActive(person, effect as Multiplier)) {
				toReturn[effect as Multiplier] = data;
			}
		}

		return toReturn;
	},

	//[=[
	//	Calculates the total multiplier for a specific type from all active effects.
	//
	//	@within Effects
	//
	//	@param person Person -- The person to calculate for
	//	@param multiplierType Multiplier -- The type of multiplier to calculate
	//
	//	@return number -- The total multiplier value
	//
	//	```ts
	//	const multiplier = Effects.CalculateMultiplier(person, "ExpBoost");
	//	```
	//]=]
	CalculateMultiplier(person: Person, multiplierType: Multiplier): number {
		const activeEffects = this.GetAllActiveEffects(person);
		let multiplier = 1;

		for (const [effect, data] of pairs(activeEffects)) {
			const effectEnum = effect as Multiplier;
			if (EffectsData[effectEnum] && EffectsData[effectEnum].Multiplier) {
				for (const [mltName, mlt] of pairs(EffectsData[effectEnum].Multiplier!)) {
					if ((mltName as Multiplier) === multiplierType) {
						multiplier += (mlt as number) - 1;
					}
				}
			}
		}
		return multiplier;
	},
};

//[=[
//	Initializes the effects system.
//
//	```ts
//	init();
//	```
//]=]
function init(): void {
	// Connect to person events using Shingo signals
	Person.personAdded.Connect((person: Person) => {
		person.dataCache((dataCache) => {
			const effects = (dataCache as EffectsCacheData).Effects;
			for (const [effect, data] of pairs(effects)) {
				data.StartTime = DateTime.now().toUnixInteger();
			}
			return dataCache;
		});
	});
	Person.personRemoved.Connect((person: Person) => {
		person.dataCache((dataCache) => {
			const currentTime = DateTime.now().toUnixInteger();
			const effects = (dataCache as EffectsCacheData).Effects;
			for (const [effect, data] of pairs(effects)) {
				if (Effects.IsEffectActive(person, effect as Multiplier)) {
					data.Duration = data.StartTime + data.Duration - currentTime;
				} else {
					delete effects[effect as Multiplier];
				}
			}
			return dataCache;
		});
	});
}

export default {
	version: version,

	// Functions
	init: init,
	ApplyEffect: Effects.ApplyEffect,
	RevokeEffect: Effects.RevokeEffect,
	IsEffectActive: Effects.IsEffectActive,
	GetAllActiveEffects: Effects.GetAllActiveEffects,
	CalculateMultiplier: Effects.CalculateMultiplier,
};
