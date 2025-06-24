import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const IceBreaker: PassiveData = {
    name: "Ice Breaker",
    description: "Does +35% more damage to enemies under `Frozen` status effect.",
    // percentIncrease: 1.35, // Damage multiplier (35% more damage)
    // statusNeeded: "Frozen", // Status to check for the bonus
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects[IceBreaker.statusNeeded])
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[IceBreaker.statusNeeded] === true) {
            //     return IceBreaker.percentIncrease;
            // }
            return 1; // Default damage multiplier
        },
    },
};
