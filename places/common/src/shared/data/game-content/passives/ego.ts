import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Ego: PassiveData = {
    name: "Ego",
    description: "-5% SPA for each ability usage (Up to -15%). +25% Range if there is a boss on the map.",
    // percentIncrease: 0.05, // SPA reduction per ability use
    // maxPassiveStacks: 3,   // Max SPA reductions
    callbacks: {
        onSpecialAbility: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let stacks = unit.getAttribute("EgoAbilityStacks") || 0;
            // if (stacks < Ego.maxPassiveStacks) {
            //     stacks++;
            //     unit.setAttribute("EgoAbilityStacks", stacks);
            //     // Assuming PermanentAttackSpeedMulti is like a cooldown, so reducing it is a buff
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - Ego.percentIncrease);
            // }
        },
        onServerTick: (unit: Unit, deltaTime: number) => { // Assuming onServerTick provides deltaTime
            // TODO: Implement _G.Constructs to check for boss enemies, attribute getting/setting
            // let bossOnMap = false;
            // // for (const enemyConstruct of Object.values(_G.Constructs as any[])) { // Placeholder for enemy iteration
            // //     if (enemyConstruct.IsBoss) {
            // //         bossOnMap = true;
            // //         break;
            // //     }
            // // }
            // const egoBossBuffed = unit.getAttribute("EgoBossBuffed");
            // if (bossOnMap && !egoBossBuffed) {
            //     unit.setAttribute("EgoBossBuffed", true);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.25);
            // } else if (!bossOnMap && egoBossBuffed) {
            //     unit.setAttribute("EgoBossBuffed", false);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - 0.25);
            // }
        },
    },
};
