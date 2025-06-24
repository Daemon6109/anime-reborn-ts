import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const NaturalEvolution: PassiveData = {
    name: "Natural Evolution",
    description: "After eliminating 50 enemies, all future upgrades cost 50% less.",
    // killsNeededForBuff: 50,
    // upgradeCostMultiplierAfterBuff: 0.5, // 50% less means multiplier of 0.5
    callbacks: {
        onAnyKill: (unit: Unit, killer: Unit, killedEnemy: any) => { // unit is the one with the passive
            // TODO: Implement attribute getting/setting.
            // if (killer !== unit) return; // Only count kills by this unit

            // const buffApplied = unit.getAttribute("NaturalEvolutionBuffApplied") || false;
            // if (buffApplied) return; // Buff is permanent once applied

            // let killCount = unit.getAttribute("NaturalEvolutionKillCount") || 0;
            // killCount++;

            // if (killCount >= NaturalEvolution.killsNeededForBuff) {
            //     unit.setAttribute("NaturalEvolutionBuffApplied", true);
            //     // The attribute "PermanentPriceMulti" is what Luau modifies.
            //     // This implies the unit's upgrade cost calculation system reads this attribute.
            //     // It subtracts 0.5 from it. If base is 1, it becomes 0.5.
            //     unit.setAttribute("PermanentPriceMulti", (unit.getAttribute("PermanentPriceMulti") || 1) - 0.5);
            //     // No need to store kill count anymore once buff is active.
            //     // unit.removeAttribute("NaturalEvolutionKillCount");
            // } else {
            //     unit.setAttribute("NaturalEvolutionKillCount", killCount);
            // }
        },
        // The onWave logic in Luau for "Vegeta [Evo]" seems unrelated to this passive's description
        // and might be a leftover or part of a different unit's specific logic.
        // It's omitted here as it doesn't match "Natural Evolution".
    },
};
