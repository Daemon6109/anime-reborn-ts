import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const DivineEnlightenment: PassiveData = {
    name: "Divine Enlightenment",
    description: "Gain Damage by 1% with each enemy defeated, up to 15%. The boost resets each wave, but once maxed, his spa is decreased by 5% permanently.",
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting. Note: Luau uses backticks for attribute names here `DPerfectionStacks`, `SpaActived`.
            // let dStacks = unit.getAttribute("DPerfectionStacks") || 0; // Current damage bonus percentage (e.g., 0.0 to 0.15)
            // const spaActivated = unit.getAttribute("SpaActived") || false;
            // const maxDamageBonus = 0.15;
            // const damagePerKill = 0.01;
            // const spaPermanentDecrease = 0.05;
            // if (dStacks < maxDamageBonus) {
            //     const oldDmgMulti = unit.getAttribute("PermanentDamageMulti") || 1;
            //     // Remove old stack value before adding new one if it's directly modifying PermanentDamageMulti
            //     // unit.setAttribute("PermanentDamageMulti", oldDmgMulti - dStacks); // This line is complex, depends on how PermanentDamageMulti is structured
            //     // It's safer to store the bonus separately and have the damage formula use it, or ensure exact reversal.
            //     // For now, assuming PermanentDamageMulti has this bonus *added* to it.
            //     // So, if we are adding 0.01, we must ensure the previous dStacks value isn't doubly counted.
            //     // Let's assume PermanentDamageMulti is base and we add dStacks to it.
            //     // Simpler: store the raw damage bonus from this passive.
            //     let currentBonusFromThisPassive = unit.getAttribute("DivineEnlightenmentBonus") || 0;
            //     if (currentBonusFromThisPassive < maxDamageBonus) {
            //         currentBonusFromThisPassive = Math.min(currentBonusFromThisPassive + damagePerKill, maxDamageBonus);
            //         unit.setAttribute("DivineEnlightenmentBonus", currentBonusFromThisPassive);
            //         // The Luau code directly modifies PermanentDamageMulti by +0.01
            //         // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + damagePerKill);
            //     }
            // }
            // // Check current total bonus from this passive
            // const currentTotalBonus = unit.getAttribute("DivineEnlightenmentBonus") || 0;
            // if (currentTotalBonus >= maxDamageBonus && !spaActivated) {
            //     unit.setAttribute("SpaActived", true); // Typo from Luau: SpaActived
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - spaPermanentDecrease);
            // }
        },
        onWave: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // const currentTotalBonus = unit.getAttribute("DivineEnlightenmentBonus") || 0;
            // if (currentTotalBonus > 0) {
            //     // Reset temporary damage boost from kills for the new wave
            //     // The Luau code subtracts DStacks from PermanentDamageMulti.
            //     // This implies DStacks was the *total accumulated bonus* that was added.
            //     // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - currentTotalBonus);
            //     unit.setAttribute("DivineEnlightenmentBonus", 0);
            //     // DPerfectionStacks in Luau was reset to 0.
            //     unit.setAttribute("DPerfectionStacks", 0);
            // }
            // // The permanent SPA decrease from SpaActived remains.
        },
    },
};
