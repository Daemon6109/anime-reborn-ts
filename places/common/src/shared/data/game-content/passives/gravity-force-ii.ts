import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const GravityForceII: PassiveData = {
    name: "Gravity Force II",
    description: "Stuns enemies on every 4th attack.",
    // maxPassiveStacks: 4, // Attacks needed to trigger stun
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let attackCount = unit.getAttribute("GravityForceIIAttackCount") || 0;
            // attackCount++;
            // unit.setAttribute("PassiveStun", false); // Default to no stun

            // if (attackCount >= GravityForceII.maxPassiveStacks) {
            //     unit.setAttribute("GravityForceIIAttackCount", 0); // Reset count
            //     unit.setAttribute("PassiveStun", true); // Flag for stun
            // } else {
            //     unit.setAttribute("GravityForceIIAttackCount", attackCount);
            // }
        },
    },
};
