import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const GravityForceI: PassiveData = {
    name: "Gravity Force",
    description: "Stuns enemies on every 8th attack.",
    // maxPassiveStacks: 8, // Attacks needed to trigger stun
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let attackCount = unit.getAttribute("GravityForceIAttackCount") || 0;
            // attackCount++;
            // unit.setAttribute("PassiveStun", false); // Default to no stun for this attack

            // if (attackCount >= GravityForceI.maxPassiveStacks) {
            //     unit.setAttribute("GravityForceIAttackCount", 0); // Reset count
            //     unit.setAttribute("PassiveStun", true); // Flag for the attack system to apply stun
            // } else {
            //     unit.setAttribute("GravityForceIAttackCount", attackCount);
            // }
        },
    },
};
