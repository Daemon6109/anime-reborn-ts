import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const MistCoverI: PassiveData = {
    name: "Mist Cover", // Luau passive name is "Mist Cover" for both I and II
    description: "Every time this unit is stunned, damage +2.5% (Up to 35%). ",
    // percentPerStack: 0.025, // Damage increase per stun
    // maxPassiveStacks: 14,   // 35% / 2.5% = 14 stun events
    callbacks: {
        onStunned: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let stacks = unit.getAttribute("MistCoverIStacks") || 0; // Use unique attribute for version I
            // if (stacks < MistCoverI.maxPassiveStacks) {
            //     stacks++;
            //     unit.setAttribute("MistCoverIStacks", stacks);
            //     // The Luau has `Passive.configuration.PercentIncrease` but it's not defined in this passive's config.
            //     // Assuming it means `MistCoverI.percentPerStack`.
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + MistCoverI.percentPerStack);
            // }
        },
    },
};
