import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const MistCoverII: PassiveData = {
    name: "Mist Cover", // Luau passive name is "Mist Cover" for both I and II
    description: "Every time this unit is stunned, damage +2.5% (Up to 35%). Additionally +15% DMG to bosses. ",
    // percentPerStack: 0.025, // Damage increase per stun
    // maxPassiveStacks: 14,   // 35% / 2.5% = 14 stun events for general damage
    // bossDamageBonus: 0.15,  // Flat +15% damage to bosses
    callbacks: {
        onStunned: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let stacks = unit.getAttribute("MistCoverIIStacks") || 0; // Use unique attribute for version II
            // if (stacks < MistCoverII.maxPassiveStacks) {
            //     stacks++;
            //     unit.setAttribute("MistCoverIIStacks", stacks);
            //     // The Luau has `Passive.configuration.PercentIncrease` but it's not defined in this passive's config.
            //     // Assuming it means `MistCoverII.percentPerStack`.
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + MistCoverII.percentPerStack);
            // }
        },
        onPlace: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     // Add the flat boss damage bonus
            //     // Assuming PermanentDmgToBossMulti is an additive multiplier (e.g., 0 means no bonus, 0.15 means +15%)
            //     unit.setAttribute("PermanentDmgToBossMulti", (unit.getAttribute("PermanentDmgToBossMulti") || 0) + MistCoverII.bossDamageBonus);
            // }
        },
    },
};
