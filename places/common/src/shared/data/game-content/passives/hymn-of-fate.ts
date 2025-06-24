import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const HymnOfFate: PassiveData = {
    name: "Hymn of Fate",
    description: "Tusk randomly burns, slows or stuns the units hit by his attacks.",
    // statusEffects: [ // Configuration for the random effects
    //     { name: "Burning", duration: 3 },
    //     { name: "Slow", duration: 2 },
    //     { name: "Stun", duration: 1 },
    // ],
    callbacks: {
        onAttack: async (unit: Unit) => { // Luau onAttack, implies this happens before the attack hits or as it's decided
            // TODO: Implement unit.waitForChild and modification of unit.configuration values.
            // This approach of modifying configuration directly on the unit instance at runtime is tricky.
            // A better approach might be for this callback to set a temporary attribute on the unit,
            // e.g., "NextAttackAppliesStatusEffect" with the chosen effect name and duration,
            // which the attack system then reads and applies.

            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     const effects = HymnOfFate.statusEffects;
            //     const randomIndex = Math.floor(Math.random() * effects.length);
            //     const chosenEffect = effects[randomIndex];

            //     // These lines in Luau modify the unit's current configuration for the attack:
            //     // config.AttackEffect.Value = chosenEffect.name;
            //     // config.AttackEffectDuration.Value = chosenEffect.duration;
            //     // This needs a corresponding system in TS where the attack execution can read these dynamic values.
            //     // unit.setAttribute("CurrentAttackEffectName", chosenEffect.name);
            //     // unit.setAttribute("CurrentAttackEffectDuration", chosenEffect.duration);
            // }
        },
    },
};
