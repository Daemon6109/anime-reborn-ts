import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const GiantSlayer: PassiveData = {
    name: "Giant Slayer",
    description: "Everytime this unit attacks a non boss enemy this unit gains 0.5% dmg and 1% range ( upto 10% and 5% ). However, if this unit is attacking a boss gain 1% Damage every attack and 2% range ( upto 5% and 6% )",
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => { // Luau uses onConditionalDamage to apply stacking buffs.
                                                        // This is unusual, as onConditionalDamage usually just returns a multiplier.
                                                        // This should ideally be onAttack or onAttackHit.
            // TODO: Implement attribute getting/setting, enemy.IsBoss check
            // if (enemy && enemy.Health > 0) {
            //     if (enemy.IsBoss) {
            //         let stacksDamageBoss = unit.getAttribute("StacksDamageBossGS") || 0; // GS for GiantSlayer
            //         let stacksRangeBoss = unit.getAttribute("StacksRangeBossGS") || 0;
            //         // Max 5% damage (5 stacks of 1%) and 6% range (3 stacks of 2%) against bosses
            //         if (stacksDamageBoss < 5) { // 5 * 0.01 = 0.05
            //             unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + 0.01);
            //             unit.setAttribute("StacksDamageBossGS", stacksDamageBoss + 1);
            //         }
            //         if (stacksRangeBoss < 3) { // 3 * 0.02 = 0.06
            //             unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.02);
            //             unit.setAttribute("StacksRangeBossGS", stacksRangeBoss + 1);
            //         }
            //     } else { // Non-boss enemy
            //         let stacksDamageNonBoss = unit.getAttribute("StacksDamageNonBossGS") || 0;
            //         let stacksRangeNonBoss = unit.getAttribute("StacksRangeNonBossGS") || 0;
            //         // Max 10% damage (20 stacks of 0.5%) and 5% range (5 stacks of 1%) against non-bosses
            //         if (stacksDamageNonBoss < 20) { // 20 * 0.005 = 0.10
            //             unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + 0.005);
            //             unit.setAttribute("StacksDamageNonBossGS", stacksDamageNonBoss + 1);
            //         }
            //         if (stacksRangeNonBoss < 5) { // 5 * 0.01 = 0.05
            //             unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.01);
            //             unit.setAttribute("StacksRangeNonBossGS", stacksRangeNonBoss + 1);
            //         }
            //     }
            // }
            return 1; // This callback in Luau doesn't modify the current hit's damage, only applies future buffs.
        },
        // onAttack and onKill were commented out in the Luau source for this passive.
    },
};
