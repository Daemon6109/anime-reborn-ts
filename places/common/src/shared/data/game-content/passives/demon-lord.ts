import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const DemonLord: PassiveData = {
    name: "Demon Lord",
    description: "Gains -1% SPA each wave up to -7% decrease, +2.5% damage for each special ability use up to +25% boost",
    // maxDamageStacks: 10, // Max applications of damage boost (25% / 2.5% = 10)
    // damagePerStack: 0.025, // Damage increase per special ability use
    // maxSpaReductions: 7,   // Max applications of SPA decrease (7 waves for -7%)
    // spaReductionPerWave: 0.01, // SPA decrease per wave
    callbacks: {
        onSpecialAbility: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let damageStacks = unit.getAttribute("RimuruDemonLordDamageStacks") || 0;
            // if (damageStacks < DemonLord.maxDamageStacks) {
            //     damageStacks++;
            //     unit.setAttribute("RimuruDemonLordDamageStacks", damageStacks);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + DemonLord.damagePerStack);
            // }
        },
        onWave: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let spaStacks = unit.getAttribute("RimuruDemonLordSpaStacks") || 0;
            // if (spaStacks < DemonLord.maxSpaReductions) {
            //     spaStacks++;
            //     unit.setAttribute("RimuruDemonLordSpaStacks", spaStacks);
            //     // Assuming PermanentAttackSpeedMulti is a multiplier where lower is faster (like a cooldown)
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - DemonLord.spaReductionPerWave);
            // }
        },
    },
};
