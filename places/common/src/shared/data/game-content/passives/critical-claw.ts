import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CriticalClaw: PassiveData = {
    name: "Critical Claw",
    description: "Critical hits infflicts enemies with permanent `Scar` and `Slow` for 2s, Criticals hits increases damage by 1% up to 10%",
    callbacks: {
        onCriticalHit: (unit: Unit, enemy: any) => {
            // TODO: Implement _G.Registry (for status effects PermaBleed, Slow), attribute getting/setting
            // if (enemy && enemy.Health > 0) {
            //     // Apply PermaBleed (Scar) and Slow status effects
            //     // _G.Registry.registry.StatusEffects.PermaBleed.OnServer(unit, [enemy], 999); // 999 for permanent
            //     // _G.Registry.registry.StatusEffects.Slow.OnServer(unit, [enemy], 2); // Slow for 2 seconds
            //     let stacks = unit.getAttribute("CritClawStacks") || 0;
            //     if (stacks < 10) { // Max 10 stacks for +10% crit damage
            //         stacks++;
            //         unit.setAttribute("CritClawStacks", stacks);
            //         // Assuming PermanentAttackCriticalDamage is a multiplier like 0.1 for 10%
            //         // and it's additive.
            //         unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + 0.01);
            //     }
            // }
        },
    },
};
