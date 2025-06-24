import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PsychicSurge: PassiveData = {
    name: "Psychic Surge",
    description: "Mimi deals 30% more damage to bosses.",
    // damageBonusToBosses: 1.3, // 30% more damage (multiplier)
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy.Class or enemy.IsBoss check.
            // Luau: if Enemy and Enemy.Health > 0 and Enemy.Class ~= "Regular" then return 1.3
            // This means it applies to any non-"Regular" enemy.
            // Description says "bosses". If description is primary:
            // if (enemy && enemy.Health > 0 && enemy.IsBoss) { // Assuming enemy.IsBoss property
            //     return PsychicSurge.damageBonusToBosses || 1.3;
            // }
            // If Luau logic (non-Regular) is primary:
            // if (enemy && enemy.Health > 0 && enemy.Class !== "Regular") {
            //     return PsychicSurge.damageBonusToBosses || 1.3;
            // }
            return 1;
        },
    },
};
