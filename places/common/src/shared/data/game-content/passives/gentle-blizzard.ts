import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const GentleBlizzard: PassiveData = {
    name: "Gentle Blizzard",
    description: "Slows all enemies in range on every 15th elimination. Slowed enemies takes 15% more damage.",
    // percentIncrease: 1.15, // Damage multiplier against slowed enemies
    // statusNeeded: "Slow",  // For onConditionalDamage check
    callbacks: {
        onKill: (unit: Unit, killedEnemy: any) => { // killedEnemy is the one just killed by this unit
            // TODO: Implement attribute getting/setting, FastVector, BuffLib, _G.Constructs, _G.Registry (for status effects)
            // let killCount = unit.getAttribute("GentleStacks") || 0;
            // killCount++;

            // if (killCount >= 15) {
            //     unit.setAttribute("GentleStacks", 0); // Reset kill count

            //     // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            //     // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            //     // const unitRange = BuffLib.GetRangeScaled(unit); // Range of THIS unit (Gentle Blizzard holder)
            //     // Not range around the killedEnemy as in ElectricSurge Luau.

            //     // for (const enemyConstruct of Object.values(_G.Constructs as any[])) { // Iterate all enemies
            //     //     if (enemyConstruct && enemyConstruct.Position) { // Check if enemy is valid
            //     //         const distance = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, enemyConstruct.Position);
            //     //         if (distance <= unitRange) {
            //     //             // const StatusEffect = _G.Registry.registry.StatusEffects["Slow"]; // Placeholder
            //     //             // if (StatusEffect) {
            //     //             //     StatusEffect.OnServer(unit, [enemyConstruct], 5); // Apply Slow for 5 seconds
            //     //             // }
            //     //         }
            //     //     }
            //     // }
            // } else {
            //     unit.setAttribute("GentleStacks", killCount);
            // }
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects[GentleBlizzard.statusNeeded])
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[GentleBlizzard.statusNeeded] === true) {
            //     return GentleBlizzard.percentIncrease; // 15% more damage
            // }
            return 1;
        },
    },
};
