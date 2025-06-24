import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Metralleta: PassiveData = {
    name: "Metralleta",
    description: "Every 10 hits, his next attack will deal x2 damage while applying permanent bleed, Also gains 1% crit damage each time this passive is used (Max 50%)",
    // hitsNeeded: 10,
    // maxCritDmgBonusStacks: 50,
    // critDmgPerStack: 0.01,
    callbacks: {
        onAttack: async (unit: Unit) => {
            // TODO: Implement unit.waitForChild, attribute getting/setting
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (!config) return;

            // const isModeActive = unit.getAttribute("MetralletaMode") || false;
            // if (isModeActive) return; // Don't stack hits if mode is already primed for current/next attack

            // let hitCount = unit.getAttribute("MetralletaHitCount") || 0;
            // hitCount++;

            // if (hitCount >= Metralleta.hitsNeeded) {
            //     unit.setAttribute("MetralletaHitCount", 0);
            //     unit.setAttribute("MetralletaMode", true); // Prime the special attack

            //     let critStacks = unit.getAttribute("MetralletaCritStacks") || 0;
            //     if (critStacks < Metralleta.maxCritDmgBonusStacks) {
            //         critStacks++;
            //         unit.setAttribute("MetralletaCritStacks", critStacks);
            //         unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + Metralleta.critDmgPerStack);
            //     }
            // } else {
            //     unit.setAttribute("MetralletaHitCount", hitCount);
            // }
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting, _G.Registry.registry.StatusEffects.PermaBleed.OnServer
            // if (enemy && enemy.Health > 0 && unit.getAttribute("MetralletaMode") === true) {
            //     // _G.Registry.registry.StatusEffects.PermaBleed.OnServer(unit, [enemy], 999); // Apply permanent bleed
            //     return 2; // x2 damage
            // }
            return 1;
        },
        onAttackEnded: async (unit: Unit) => {
            // TODO: Implement unit.waitForChild, attribute setting
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (!config) return;

            // if (unit.getAttribute("MetralletaMode") === true) {
            //     unit.setAttribute("MetralletaMode", false); // Consume the mode after the attack
            // }
        },
    },
};
