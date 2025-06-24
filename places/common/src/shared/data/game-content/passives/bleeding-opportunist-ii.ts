import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const BleedingOpportunistII: PassiveData = {
    name: "Scarring Opportunist II",
    description: "+25% crit damage against `Scar` enemies",
    // statusNeeded: "Scar", // Configuration specific to this passive
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking. The return type of this callback might need adjustment
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects) {
            //     const hasStatus = enemy.StatusEffects[BleedingOpportunistII.statusNeeded] === true;
            //     if (hasStatus) {
            //         return [1, undefined, 0.25]; // Luau returns multiple values (damage, crit, critDamage).
            //     }
            // }
            return 1;
        },
    },
};
