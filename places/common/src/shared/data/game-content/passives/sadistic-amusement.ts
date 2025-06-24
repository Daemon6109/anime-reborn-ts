import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SadisticAmusement: PassiveData = {
    name: "Sadistic Amusement",
    description: "Unit deals 10% more damage against enemies below 75% hp and 15% more dmg against enemies below 50% hp.",
    // threshold1: 0.75, damageBonus1: 1.10,
    // threshold2: 0.50, damageBonus2: 1.15,
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy.Health, enemy.MaxHealth access
            // if (enemy && enemy.Health > 0 && enemy.MaxHealth > 0) {
            //     const healthPercent = enemy.Health / enemy.MaxHealth;
            //     // Order of checks is important: lower health threshold takes precedence if both are met.
            //     if (healthPercent < (SadisticAmusement.threshold2 || 0.50)) {
            //         return SadisticAmusement.damageBonus2 || 1.15;
            //     } else if (healthPercent < (SadisticAmusement.threshold1 || 0.75)) {
            //         return SadisticAmusement.damageBonus1 || 1.10;
            //     }
            // }
            return 1;
        },
        // Luau config has "StatusNeeded = Burning" but it's not used in its onConditionalDamage.
    },
};
