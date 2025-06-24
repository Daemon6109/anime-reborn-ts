import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ElectricSurge: PassiveData = {
    name: "Electric Surge",
    description: "After killing an enemy her next attack deals 15% more dmg and stuns enemies in range for 2 seconds.",
    callbacks: {
        onKill: (unit: Unit, killedEnemy: any) => { // killedEnemy is the one that was just killed by this unit
            // TODO: Implement attribute getting/setting, FastVector, BuffLib, _G.Constructs, _G.Registry (for status effects)
            // The Luau code for `onKill` is a bit confusing. It increments "ElectricStacks".
            // If stacks >= 1, it resets stacks, then iterates enemies *around the killedEnemy's position*
            // (using `Enemy.Position` which is `killedEnemy.Position` here)
            // and stuns them. It then sets "ESPP" (Electric Surge Passive Proc?) to true.
            // The `onConditionalDamage` then checks for "ESPP" to give a damage bonus and consumes the flag.
            // This implies the stun happens on kill, and the *next single attack* gets bonus damage.

            // let stacks = unit.getAttribute("ElectricStacks") || 0;
            // stacks++; // Increment per kill that triggers this
            // unit.setAttribute("ElectricStacks", stacks);

            // // The description says "After killing an enemy her next attack ... stuns enemies in range"
            // // The Luau code stuns on kill if stacks >= 1. Let's assume the stun should happen on the *next attack*
            // // as well, or the description means the *state* to stun is primed by a kill.
            // // For now, let's set a flag that the next attack should be special.
            // unit.setAttribute("ElectricSurgePrimed", true); // New attribute to indicate next attack is special

            // // The Luau `ElectricStacks` logic seems to be a simple 1-kill trigger.
            // // If a kill happens, it sets ESPP to true for the next damage calc.
            // // The stun part in Luau's onKill:
            // // if ((unit.getAttribute("ElectricStacks") || 0) >= 1) {
            // //    unit.setAttribute("ElectricStacks", 0); // Reset
            // //    // ... stun logic around killedEnemy ...
            // //    unit.setAttribute("ESPP", true); // For damage bonus on next hit
            // // }
            // // This means any kill will prime the ESPP for the next damage.
            // // The stun, however, happens immediately around the *killed* enemy if ElectricStacks was >=1.
            // // This is a bit convoluted.

            // // Let's simplify based on description:
            // // 1. On Kill, set a flag "ElectricSurgeNextAttackBonus" = true
            // unit.setAttribute("ElectricSurgeNextAttackBonus", true);
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting/setting
            // if (unit.getAttribute("ElectricSurgeNextAttackBonus")) {
            //     unit.setAttribute("ElectricSurgeNextAttackBonus", false); // Consume the bonus
            //     return 1.15; // 15% more damage
            // }
            return 1;
        },
        // onAttack: (unit: Unit, targetEnemy: any) => {
        //     // TODO: If ElectricSurgeNextAttackBonus was true (set by onKill, consumed by onConditionalDamage for damage part)
        //     // then this attack should also trigger the stun AOE.
        //     // This requires knowing if the bonus was active *for this specific attack instance*.
        //     // if (unit.getAttribute("ElectricSurgeStunReady")) { // A different flag set by onKill
        //     //     unit.setAttribute("ElectricSurgeStunReady", false);
        //     //     // ... Perform AOE stun around `targetEnemy` or `unit` based on interpretation ...
        //     //     // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
        //     //     // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
        //     //     // const stunRange = BuffLib.GetRangeScaled(unit); // Or a fixed range for the stun AOE
        //     //     // for (const enemyConstruct of Object.values(_G.Constructs as any[])) {
        //     //     //     const distance = FastVector.FastMagnitudeVec3(targetEnemy.Position, enemyConstruct.Position);
        //     //     //     if (distance <= stunRange) {
        //     //     //         // _G.Registry.registry.StatusEffects["Stun"].OnServer(unit, [enemyConstruct], 2);
        //     //     //     }
        //     //     // }
        //     // }
        // }
    },
};
