import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const RoyaleExecution: PassiveData = {
    name: "Royale Execution",
    description: "If an enemy is below 20% hp there is 15% chance for him to devour them and increase his dmg and range by 15% and decrease his spa by 5% for 10 seconds with 25 seconds cooldown.",
    // healthThreshold: 0.20,
    // procChance: 0.15, // Luau uses 20% (Chance <= 20). Using description's 15%.
    // buffDuration: 10, // seconds
    // cooldown: 25, // seconds
    // damageBuff: 0.15,
    // rangeBuff: 0.15,
    // spaReduction: -0.05,
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement BuffLib.GetDamage, attribute getting/setting, task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value, Random.new():NextNumber
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const cooldownAttribute = "RoyaleExecutionCooldownActiveRE"; // RE for RoyaleExecution
            // const isOnCooldown = unit.getAttribute(cooldownAttribute) || false;
            // if (isOnCooldown) return 1;

            // if (enemy && enemy.Health > 0) {
            //     const actualProcChance = RoyaleExecution.procChance || 0.15; // Using 15% from desc
            //     // Luau: if Random.new():NextNumber(0, 100) <= 20 (this is > 20% chance because 0 is included, so 21 outcomes out of 101)
            //     // Standard Math.random() is 0 to <1.
            //     if (Math.random() < actualProcChance) {
            //         if (enemy.Health <= enemy.MaxHealth * (RoyaleExecution.healthThreshold || 0.20)) {
            //             unit.setAttribute(cooldownAttribute, true); // Start cooldown before applying buffs
            //             // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (RoyaleExecution.damageBuff || 0.15));
            //             // unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + (RoyaleExecution.rangeBuff || 0.15));
            //             // unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) + (RoyaleExecution.spaReduction || -0.05));

            //             const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //             // task.delay((RoyaleExecution.buffDuration || 10) / gameSpeed, () => { // Placeholder for buff expiry
            //             //     if (unit && unit.getInstance()?.Parent) {
            //             //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - (RoyaleExecution.damageBuff || 0.15));
            //             //         unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - (RoyaleExecution.rangeBuff || 0.15));
            //             //         unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - (RoyaleExecution.spaReduction || -0.05));
            //             //     }
            //             // });
            //             // task.delay((RoyaleExecution.cooldown || 25) / gameSpeed, () => { // Placeholder for cooldown end
            //             //      if (unit && unit.getInstance()?.Parent) {
            //             //         unit.setAttribute(cooldownAttribute, false);
            //             //      }
            //             // });

            //             // Devour/Insta-kill logic from Luau
            //             // const currentAttackDamage = BuffLib.GetDamage(unit); // Placeholder
            //             // if (currentAttackDamage > 0) {
            //             //     return 1 + (enemy.Health / currentAttackDamage);
            //             // } else {
            //             //     return enemy.Health + 1;
            //             // }
            //         }
            //     }
            // }
            return 1;
        },
    },
};
