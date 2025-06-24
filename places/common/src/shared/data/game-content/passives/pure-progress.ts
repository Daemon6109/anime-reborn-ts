import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PureProgress: PassiveData = {
    name: "Pure Progress",
    description: "Every attack increases his critical chance by 5% until he critical strikes an enemy then it resets back to normal, every time he critical strikes an enemy his critical dmg increases by 2% up to 14%.",
    // critChancePerAttack: 0.05,
    // critDmgPerCritStack: 0.02,
    // maxCritDmgStacks: 7, // 14% / 2% = 7 stacks
    callbacks: {
        onAttack: async (unit: Unit) => {
            // TODO: Implement unit.waitForChild, attribute getting/setting
            // const config = await unit.waitForChild("configuration", 10); // Placeholder, may not be needed

            // // Get current temporary crit chance bonus from this passive
            // let currentTempCritChanceBonus = unit.getAttribute("PureProgressTempCritChance") || 0;
            // // Get base crit chance (assuming it's stored or can be fetched)
            // const baseCritChance = unit.getAttribute("PermanentAttackCriticalChanceBase") || unit.getAttribute("PermanentAttackCriticalChance") || 0;
            // // Calculate new temporary bonus
            // currentTempCritChanceBonus += (PureProgress.critChancePerAttack || 0.05);
            // unit.setAttribute("PureProgressTempCritChance", currentTempCritChanceBonus);
            // // Apply to unit's actual crit chance for this attack
            // unit.setAttribute("PermanentAttackCriticalChance", baseCritChance + currentTempCritChanceBonus);
        },
        onCriticalHit: (unit: Unit, enemy: any) => { // Called after a critical hit lands
            // TODO: Implement attribute getting/setting
            // const currentTempCritChanceBonus = unit.getAttribute("PureProgressTempCritChance") || 0;
            // const baseCritChance = unit.getAttribute("PermanentAttackCriticalChanceBase") || unit.getAttribute("PermanentAttackCriticalChance") || 0;

            // if (currentTempCritChanceBonus > 0) {
            //     // Reset temporary crit chance bonus by subtracting it from the current total
            //     unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) - currentTempCritChanceBonus);
            //     unit.setAttribute("PureProgressTempCritChance", 0);
            // }

            // // Handle critical damage stacking
            // let critDmgStacks = unit.getAttribute("PureProgressCritDmgStacks") || 0;
            // if (critDmgStacks < (PureProgress.maxCritDmgStacks || 7)) {
            //     critDmgStacks++;
            //     unit.setAttribute("PureProgressCritDmgStacks", critDmgStacks);
            //     // Assuming PermanentAttackCriticalDamage is a multiplier (e.g., 0.5 for +50% crit damage)
            //     unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + (PureProgress.critDmgPerCritStack || 0.02));
            // }
        },
    },
};
