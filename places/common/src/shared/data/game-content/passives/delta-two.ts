import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const DeltaTwo: PassiveData = {
    name: "Delta Two",
    description: "After every 10 hits, the Delta Brothers DMG increases by 5%, up to +30%",
    // maxPassiveStacks: 6, // Max applications of the DMG increase (30% / 5% = 6)
    // percentIncrease: 0.05, // DMG increase per application
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let hitCount = unit.getAttribute("DeltaTwoHitCount") || 0;
            // let dmgIncreasesApplied = unit.getAttribute("DeltaTwoDmgIncreases") || 0;
            // if (dmgIncreasesApplied < DeltaTwo.maxPassiveStacks) {
            //     hitCount++;
            //     unit.setAttribute("DeltaTwoHitCount", hitCount);
            //     if (hitCount >= 10) {
            //         dmgIncreasesApplied++;
            //         unit.setAttribute("DeltaTwoDmgIncreases", dmgIncreasesApplied);
            //         unit.setAttribute("DeltaTwoHitCount", 0); // Reset hit count
            //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + DeltaTwo.percentIncrease);
            //     }
            // }
        },
    },
};
