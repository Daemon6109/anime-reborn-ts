import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const GeneticPerfection: PassiveData = {
    name: "Genetic Perfection",
    description: "for every 10 eliminations his critical chance gets increased by 1% up to 20%. At max stacks his critical dmg gets increased by 20%",
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting. Luau uses backticks in attribute names.
            // let perfectionStacks = unit.getAttribute("PerfectionStacks") || 0; // Kills counter (0-9 for each 1% crit)
            // let dPerfectionStacks = unit.getAttribute("DPerfectionStacks") || 0; // Actual crit chance bonus accumulated (0.0 to 0.20)
            // const critActivated = unit.getAttribute("SpaActived"); // Luau uses "SpaActived" for when crit DMG buff is active.

            // const maxCritChanceBonus = 0.20;
            // const critChancePerMilestone = 0.01;
            // const killsPerMilestone = 10;
            // const critDmgBonusAtMaxCrit = 0.20;

            // perfectionStacks++;

            // if (perfectionStacks >= killsPerMilestone) {
            //     unit.setAttribute("PerfectionStacks", 0); // Reset kill counter for this milestone

            //     if (dPerfectionStacks < maxCritChanceBonus) {
            //         const newCritChanceBonus = Math.min(dPerfectionStacks + critChancePerMilestone, maxCritChanceBonus);
            //         unit.setAttribute("DPerfectionStacks", newCritChanceBonus);
            //         // Apply the incremental crit chance bonus
            //         unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + critChancePerMilestone);
            //     }
            // } else {
            //     unit.setAttribute("PerfectionStacks", perfectionStacks);
            // }

            // // Check if max crit chance bonus has been reached to apply crit damage
            // const currentTotalCritChanceBonus = unit.getAttribute("DPerfectionStacks") || 0;
            // if (currentTotalCritChanceBonus >= maxCritChanceBonus && !critActivated) {
            //     unit.setAttribute("SpaActived", true); // Mark that crit damage bonus is now active
            //     unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + critDmgBonusAtMaxCrit);
            // }
        },
        // onConditionalDamage was commented out in Luau.
    },
};
