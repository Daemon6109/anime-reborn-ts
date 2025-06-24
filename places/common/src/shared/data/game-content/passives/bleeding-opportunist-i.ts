import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const BleedingOpportunistI: PassiveData = {
    name: "Scarring Opportunist I",
    description: "+100% crit chance against `Scar` enemies",
    // statusNeeded: "Scar", // Configuration specific to this passive
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking. The return type of this callback might need adjustment
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects) {
            //     const hasStatus = enemy.StatusEffects[BleedingOpportunistI.statusNeeded] === true;
            //     if (hasStatus) {
            //         return [1, true]; // Luau returns multiple values, TS needs to handle this (e.g. object or tuple)
            //     }
            // }
            return 1;
        },
    },
};
