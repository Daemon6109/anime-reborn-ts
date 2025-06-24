import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FastReflexesI: PassiveData = {
    name: "Fast Reflexes I",
    description: "She deals 20% more dmg against `Slow` enemies, for every 50 `Slow` enemies that are eliminated this unit range gets increased by 2.5% upto 10 % ",
    // statusNeeded: "Slow", // For damage bonus and kill count condition
    callbacks: {
        onKill: (unit: Unit, killedEnemy: any) => {
            // TODO: Implement attribute getting/setting, status effect checking (killedEnemy.StatusEffects[FastReflexesI.statusNeeded])
            // The Luau code increments "FastReflexesStacks" up to 5.
            // If the killed enemy had "Slow", it increases PermanentRangeMulti by 0.025.
            // This means up to 5 * 0.025 = 0.125 or 12.5% range, not 10% as in desc.
            // Also, "every 50 slow enemies" is not in Luau logic; it's every slow enemy kill, up to 5 times.
            // Assuming Luau logic is the source of truth for now.

            // let killCountForRangeBonus = unit.getAttribute("FastReflexesRangeBonusKills") || 0;
            // const maxRangeBonusApplications = 4; // For 10% at 2.5% each. Or 5 for 12.5%. Luau uses 5.
            // const rangePerApplication = 0.025;

            // if (killCountForRangeBonus < maxRangeBonusApplications) {
            //     if (killedEnemy && killedEnemy.StatusEffects && killedEnemy.StatusEffects[FastReflexesI.statusNeeded] === true) {
            //         unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + rangePerApplication);
            //         unit.setAttribute("FastReflexesRangeBonusKills", killCountForRangeBonus + 1);
            //     }
            // }
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects[FastReflexesI.statusNeeded])
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[FastReflexesI.statusNeeded] === true) {
            //     return 1.20; // 20% more damage
            // }
            return 1;
        },
    },
};
