import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const DeltaOne: PassiveData = {
    name: "Delta One",
    description: "After every 5 hits, the Delta Brothers SPA decreases by 5%, down to -20%",
    // maxPassiveStacks: 4, // Max applications of the SPA decrease
    // percentIncrease: 0.05, // SPA decrease per application (actually a decrease)
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let hitCount = unit.getAttribute("DeltaOneHitCount") || 0;
            // let spaReductionsApplied = unit.getAttribute("DeltaOneSpaReductions") || 0;
            // if (spaReductionsApplied < DeltaOne.maxPassiveStacks) {
            //     hitCount++;
            //     unit.setAttribute("DeltaOneHitCount", hitCount);
            //     if (hitCount >= 5) {
            //         spaReductionsApplied++;
            //         unit.setAttribute("DeltaOneSpaReductions", spaReductionsApplied);
            //         unit.setAttribute("DeltaOneHitCount", 0); // Reset hit count
            //         // SPA is attack speed; decreasing SPA means increasing attack speed multiplier?
            //         // Or is PermanentAttackSpeedMulti a cooldown, so decreasing it is good?
            //         // Luau: PermanentAttackSpeedMulti - PercentIncrease. If SPA is like cooldown, this is a buff.
            //         unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - DeltaOne.percentIncrease);
            //     }
            // }
        },
    },
};
