import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

// Note: This passive has complex global-like interactions with _G.EnemySpeedManager and _G.Constructs.
// These will require significant refactoring or a new system in TS.

export const GodsAura: PassiveData = {
    name: "God’s Aura",
    description: "Any enemy that enters this unit's range is slowed by 25% and takes 10% more damage.",
    callbacks: {
        onServerTick: (unit: Unit, deltaTime: number) => {
            // TODO: Implement BuffLib, FastVector, _G.Constructs, _G.EnemySpeedManager equivalents.
            // This logic is highly dependent on the global _G.EnemySpeedManager and direct manipulation of enemy properties.
            // This needs a major rethink in a structured component-based or event-based system.

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);

            // for (const enemyId in _G.Constructs) { // Iterating over global enemy constructs
            //     const enemyConstruct = _G.Constructs[enemyId];
            //     if (enemyConstruct && enemyConstruct.Position && enemyConstruct.HumanoidRootPart) { // Basic checks
            //         const distance = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, enemyConstruct.Position);
            //         const isInRange = distance <= unitRange;
            //         const slowDebuffKey = "GodsAuraSlow"; // Custom key for this passive's slow

            //         if (isInRange) {
            //             if (!enemyConstruct.customDebuffs || !enemyConstruct.customDebuffs[slowDebuffKey]) {
            //                 // Apply 25% slow if not already slowed by this passive
            //                 // This would involve calling an enemy speed modification function.
            //                 // _G.EnemySpeedManager.AddDirectBooster("WhisSlowdown", enemyConstruct, -enemyConstruct.OriginalSpeed * 0.25, 999999);
            //                 // Mark that this passive applied a slow
            //                 // if (!enemyConstruct.customDebuffs) enemyConstruct.customDebuffs = {};
            //                 // enemyConstruct.customDebuffs[slowDebuffKey] = { sourceUnitId: unit.getAttribute("IUUID") };
            //             }
            //         } else { // Not in range
            //             if (enemyConstruct.customDebuffs && enemyConstruct.customDebuffs[slowDebuffKey] &&
            //                 enemyConstruct.customDebuffs[slowDebuffKey].sourceUnitId === unit.getAttribute("IUUID")) {
            //                 // Remove slow if this unit applied it and enemy is now out of range
            //                 // This would involve calling an enemy speed modification function to revert.
            //                 // _G.EnemySpeedManager.RemoveDirectBooster("WhisSlowdown", enemyConstruct); // Or by ID
            //                 // delete enemyConstruct.customDebuffs[slowDebuffKey];
            //             }
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement _G.Constructs, _G.EnemySpeedManager equivalents to remove applied slows.
            // const unitId = unit.getAttribute("IUUID");
            // for (const enemyId in _G.Constructs) {
            //     const enemyConstruct = _G.Constructs[enemyId];
            //     if (enemyConstruct && enemyConstruct.customDebuffs && enemyConstruct.customDebuffs["GodsAuraSlow"] &&
            //         enemyConstruct.customDebuffs["GodsAuraSlow"].sourceUnitId === unitId) {
            //         // Remove slow applied by this unit
            //         // _G.EnemySpeedManager.RemoveDirectBooster("WhisSlowdown", enemyConstruct); // Or by ID
            //         // delete enemyConstruct.customDebuffs["GodsAuraSlow"];
            //     }
            // }
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute and enemy range check (or assume if onConditionalDamage is called, enemy is targeted)
            // Luau code: if SpecialAbilityUsed return 1.3 else return 1.1. This applies to *any* enemy.
            // The description "takes 10% more damage" implies always 1.1 for enemies in range.
            // The "SpecialAbilityUsed" part is an additional conditional buff.
            // Assuming the 10% is for any enemy affected by the aura (in range).
            // This check should ideally be part of the damage calculation if the enemy is inside the aura.

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // let damageMultiplier = 1;
            // if (enemy && enemy.Position && FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, enemy.Position) <= unitRange) {
            //    damageMultiplier = 1.1; // Base 10% increase for enemies in aura
            // }
            // if (unit.getAttribute("SpecialAbilityUsed")) { // This seems like a temporary buff on the unit itself
            //    damageMultiplier = Math.max(damageMultiplier, 1.3); // If special ability used, ensure at least 1.3x
            //                                                      // Or it could be multiplicative: damageMultiplier * 1.3 (if special used)
            //                                                      // Luau logic is: if special, 1.3, ELSE (if in aura) 1.1. This interpretation is simpler.
            //                                                      // Let's assume if special is used, it's 1.3, otherwise check aura.
            //    return 1.3;
            // }
            // if (enemy && enemy.Position && FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, enemy.Position) <= unitRange) {
            //    return 1.1;
            //}
            return 1; // Default
        },
    },
};
