import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ElectroCharge: PassiveData = {
    name: "Electro Charge",
    description: "Every 6 attacks, this unit enters an enraged state for xx seconds, gaining 50% increased range. During this state, each kill boosts its damage by 1%, up to a maximum of 7%.",
    // enragedDuration: xx, // Needs a value for "xx seconds"
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting. Enraged state duration (xx seconds) needs to be defined.
            // let attackCount = unit.getAttribute("ElectroChargeAttackCount") || 0;
            // const isEnraged = unit.getAttribute("ElectroChargeEnraged") || false;
            // if (isEnraged) {
            //     // If already enraged, onAttack doesn't re-trigger enrage based on Luau logic.
            //     // Luau: if PassiveTrue (isEnraged), it sets PassiveTrue to false and reduces range. This seems like an error or misinterpretation.
            //     // The description implies enrage lasts for a duration, not toggled off by a normal attack.
            //     // Let's assume enrage has a timer. This onAttack would primarily count for the *next* enrage.
            // }
            // attackCount++;
            // if (attackCount >= 6 && !isEnraged) {
            //     unit.setAttribute("ElectroChargeEnraged", true);
            //     unit.setAttribute("ElectroChargeAttackCount", 0);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.5);
            //     unit.setAttribute("ElectroChargeEnrageEndTime", game.time() + ElectroCharge.enragedDuration); // Assuming game.time()
            //     unit.setAttribute("ElectroChargeKillStacksEnraged", 0); // Reset kill stacks for this enraged phase
            // } else if (!isEnraged) {
            //     unit.setAttribute("ElectroChargeAttackCount", attackCount);
            // }
        },
        onKill: (unit: Unit, enemy?: any) => {
            // TODO: Implement attribute getting/setting
            // const isEnraged = unit.getAttribute("ElectroChargeEnraged") || false;
            // if (isEnraged) {
            //     let killStacks = unit.getAttribute("ElectroChargeKillStacksEnraged") || 0;
            //     if (killStacks < 7) { // Max 7% damage boost
            //         killStacks++;
            //         unit.setAttribute("ElectroChargeKillStacksEnraged", killStacks);
            //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + 0.01);
            //     }
            // }
        },
        // onServerTick: (unit: Unit, deltaTime: number) => {
        //     // TODO: Check for enrage end time
        //     // const isEnraged = unit.getAttribute("ElectroChargeEnraged") || false;
        //     // if (isEnraged) {
        //     //     const endTime = unit.getAttribute("ElectroChargeEnrageEndTime");
        //     //     if (game.time() >= endTime) {
        //     //         unit.setAttribute("ElectroChargeEnraged", false);
        //     //         unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - 0.5); // Remove range buff
        //     //         // Remove damage buff accumulated during this rage
        //     //         const killStacks = unit.getAttribute("ElectroChargeKillStacksEnraged") || 0;
        //     //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - (killStacks * 0.01));
        //     //         unit.setAttribute("ElectroChargeKillStacksEnraged", 0);
        //     //     }
        //     // }
        // }
    },
};
