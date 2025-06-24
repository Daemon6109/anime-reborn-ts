import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const OnPoint: PassiveData = {
    name: "On Point",
    description: "This unit has 35% chance to do double damage",
    // percentIncrease: 2, // Damage multiplier for double damage
    // procChance: 0.35,   // 35% chance
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy health check (though not strictly needed for this passive's core logic)
            // if (enemy && enemy.Health > 0 && Math.random() < OnPoint.procChance) {
            //     return OnPoint.percentIncrease;
            // }
            return 1; // Default damage multiplier
        },
    },
};
