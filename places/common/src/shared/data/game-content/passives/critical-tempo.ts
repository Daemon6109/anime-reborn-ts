import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CriticalTempo: PassiveData = {
    name: "Critical Tempo",
    description: "On Each Kill, Increases Critical Chance by 0.5%, Upto 25%.",
    callbacks: {
        onKill: (unit: Unit, enemy?: any) => {
            // TODO: Implement attribute getting/setting
            // let addedCrit = unit.getAttribute("AddedCriticalChance") || 0;
            // if (addedCrit < 0.25) { // Max 25% increase
            //     addedCrit += 0.005; // 0.5%
            //     // Ensure addedCrit doesn't exceed 0.25 due to floating point issues
            //     addedCrit = Math.min(addedCrit, 0.25);
            //     unit.setAttribute("AddedCriticalChance", addedCrit);
            //     // Assuming PermanentAttackCriticalChance is the base crit chance that gets modified
            //     // Or this is an additive bonus to a base crit chance defined elsewhere.
            //     // The Luau code suggests it's an addition to an existing attribute.
            //     unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + 0.005);
            // }
        },
    },
};
