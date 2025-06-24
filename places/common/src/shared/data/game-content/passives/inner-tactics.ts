import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const InnerTactics: PassiveData = {
    name: "Inner Tactics",
    description: "After eliminating 20 basic enemies he gains 3% dmg up to 15%, for every 10 air enemies he eliminates his range increases by 2% up to 8%. (2s cd)",
    // Note: The "2s cd" is mentioned in description but not implemented in the Luau onAnyKill.
    callbacks: {
        onAnyKill: (unit: Unit, killer: Unit, killedEnemy: any) => { // unit is the one with the passive
            // TODO: Implement attribute getting/setting, CollectionService, enemy.Class/NPC_Type checks.
            // if (killer !== unit) return; // Passive only procs if this unit is the killer

            // const enemyIsAir = killedEnemy.Class === "Flying" || killedEnemy.NPC_Type === "Flying" ||
            //                    killedEnemy.Class === "Air" || killedEnemy.NPC_Type === "Air";

            // if (enemyIsAir) {
            //     let airKillCount = unit.getAttribute("InnerTacticsAirKills") || 0;
            //     let airRangeBuffsApplied = unit.getAttribute("InnerTacticsAirRangeBuffs") || 0;
            //     const maxAirRangeBuffs = 4; // 8% / 2% = 4

            //     if (airRangeBuffsApplied < maxAirRangeBuffs) {
            //         airKillCount++;
            //         if (airKillCount >= 10) {
            //             unit.setAttribute("InnerTacticsAirKills", 0);
            //             unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.02);
            //             unit.setAttribute("InnerTacticsAirRangeBuffs", airRangeBuffsApplied + 1);
            //         } else {
            //             unit.setAttribute("InnerTacticsAirKills", airKillCount);
            //         }
            //     }
            // } else { // Basic (non-air) enemy
            //     let groundKillCount = unit.getAttribute("InnerTacticsGroundKills") || 0;
            //     let groundDmgBuffsApplied = unit.getAttribute("InnerTacticsGroundDmgBuffs") || 0;
            //     const maxGroundDmgBuffs = 5; // 15% / 3% = 5

            //     if (groundDmgBuffsApplied < maxGroundDmgBuffs) {
            //         groundKillCount++;
            //         if (groundKillCount >= 20) {
            //             unit.setAttribute("InnerTacticsGroundKills", 0);
            //             unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + 0.03);
            //             unit.setAttribute("InnerTacticsGroundDmgBuffs", groundDmgBuffsApplied + 1);
            //         } else {
            //             unit.setAttribute("InnerTacticsGroundKills", groundKillCount);
            //         }
            //     }
            // }
        },
    },
};
