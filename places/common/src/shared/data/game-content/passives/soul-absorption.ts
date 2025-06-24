import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SoulAbsorption: PassiveData = {
    name: "Soul Absorption",
    description: "Gains +1% damage each 5 eliminations, up to +12% boost",
    // killsPerStack: 5, // Eliminations needed for one stack of the buff
    // damagePerStack: 0.01, // 1% damage
    // maxBuffStacks: 12,    // For a total of +12% damage
    // Luau: MaxPassiveStacks = 60, PercentPerStack = 0.01/5 = 0.002. Total = 60 * 0.002 = 0.12 (12%)
    // So, it's 0.2% per kill, up to 60 kills for 12%. This means 1% per 5 kills.
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting.
            // let currentKillsForStack = unit.getAttribute("SoulAbsorptionKillCounter") || 0;
            // let currentDamageBonusStacks = unit.getAttribute("SoulAbsorptionDmgStacks") || 0;
            // const maxDmgStacks = SoulAbsorption.maxBuffStacks || 12;

            // if (currentDamageBonusStacks < maxDmgStacks) {
            //     currentKillsForStack++;
            //     if (currentKillsForStack >= (SoulAbsorption.killsPerStack || 5)) {
            //         unit.setAttribute("SoulAbsorptionKillCounter", 0); // Reset kill counter for this stack
            //         currentDamageBonusStacks++;
            //         unit.setAttribute("SoulAbsorptionDmgStacks", currentDamageBonusStacks);
            //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (SoulAbsorption.damagePerStack || 0.01));
            //     } else {
            //         unit.setAttribute("SoulAbsorptionKillCounter", currentKillsForStack);
            //     }
            // }
            // Luau uses "RimuruSoulAbsorptionStacks" for total kill count and applies 0.002% per kill up to 60 kills.
        },
    },
};
