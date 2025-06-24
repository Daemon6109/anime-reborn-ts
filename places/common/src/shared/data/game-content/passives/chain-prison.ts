import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ChainPrison: PassiveData = {
    name: "Chain Prison",
    description: "For each stunned enemy he kills, his range gets increased by 1% up to 15%, At max stacks his every 5th attack stun for 2 seconds. (5s cooldown)",
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, task.delay equivalent
            // const onCooldown = unit.getAttribute("PrisonCooldown") || false;
            // if (!unit.getAttribute("StunEffectiveActive")) return; // Guard clause if stun ability isn't active
            // if (onCooldown) return;
            // unit.setAttribute("PassiveStun", false); // Reset passive stun flag
            // let passiveStacks = unit.getAttribute("PassiveStacks") || 0;
            // passiveStacks++; // Increment attack counter
            // if (passiveStacks >= 5) {
            //     unit.setAttribute("PassiveStacks", 0); // Reset attack counter
            //     unit.setAttribute("PrisonCooldown", true);
            //     unit.setAttribute("PassiveStun", true); // Flag that this attack should stun
            //     // task.delay(5, () => { // Luau task.delay
            //     //     unit.setAttribute("PrisonCooldown", false);
            //     // });
            // } else {
            //     unit.setAttribute("PassiveStacks", passiveStacks);
            // }
        },
        onKill: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting/setting, status effect checking (enemy.StatusEffects["Stun"])
            // let rangeStacks = unit.getAttribute("RangeStacks") || 0;
            // // Assuming enemy.StatusEffects is an object/map
            // if (rangeStacks < 0.15 && enemy && enemy.StatusEffects && enemy.StatusEffects["Stun"]) {
            //     rangeStacks += 0.01;
            //     unit.setAttribute("RangeStacks", rangeStacks);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.01);
            // }
            // if (rangeStacks >= 0.15) { // Check if it should be exactly 0.15 or >=
            //     unit.setAttribute("StunEffectiveActive", true);
            // }
        },
        // The onConditionalDamage was commented out in Luau, so omitting here unless needed.
    },
};
