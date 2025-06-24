import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const TimeSlowdown: PassiveData = {
    name: "Time Slowdown",
    description: "This unit slows down every enemy in range up to 55% depending on how close they are!",
    // rangeTable: [ // Luau order is descending by distance for iteration, but ascending by slow amount
    //     { maxDistance: 10, slowPercent: 0.55 },
    //     { maxDistance: 15, slowPercent: 0.45 },
    //     { maxDistance: 25, slowPercent: 0.33 },
    //     { maxDistance: 30, slowPercent: 0.25 },
    //     { maxDistance: 50, slowPercent: 0.15 },
    //     { maxDistance: 60, slowPercent: 0.05 },
    // ],
    callbacks: {
        onServerTick: (unit: Unit, deltaTime: number) => {
            // TODO: Implement BuffLib.GetRangeScaled, FastVector.FastMagnitudeVec3, _G.Constructs, _G.EnemySpeedManager equivalents.
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitMaxRange = BuffLib.GetRangeScaled(unit);
            // const sourceUnitId = unit.getAttribute("IUUID");
            // const slowDebuffAttrKey = "TimeSlowdownAppliedBy"; // To store sourceUnitId and appliedSlowPercent

            // for (const enemyId in _G.Constructs) { // Placeholder
            //     const enemyConstruct = _G.Constructs[enemyId];
            //     if (enemyConstruct && enemyConstruct.Position && enemyConstruct.HumanoidRootPart && enemyConstruct.EnemyID) {
            //         const distance = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, enemyConstruct.Position);
            //         let targetSlowPercent = 0;

            //         if (distance <= unitMaxRange) { // Must be within overall unit range first
            //             for (const tier of (TimeSlowdown.rangeTable || [])) {
            //                 if (distance < tier.maxDistance) { // Luau iterates and takes the first one it's less than
            //                     targetSlowPercent = tier.slowPercent;
            //                     break;
            //                 }
            //             }
            //         }

            //         const currentSlowData = enemyConstruct[slowDebuffAttrKey];

            //         if (targetSlowPercent > 0) { // Should be slowed
            //             if (!currentSlowData || currentSlowData.sourceUnitId !== sourceUnitId || currentSlowData.appliedSlow !== targetSlowPercent) {
            //                 // If not slowed by this unit, or if slow tier changed:
            //                 // First, remove any old slow from this source if it exists
            //                 // if (currentSlowData && currentSlowData.sourceUnitId === sourceUnitId) {
            //                 //    _G.EnemySpeedManager.RemoveBooster(enemyConstruct, currentSlowData.guid); // Assuming AddDirectBooster returns a GUID to remove
            //                 // }
            //                 // const guid = _G.EnemySpeedManager.AddDirectBooster("JuliusSlowdown", enemyConstruct, -enemyConstruct.OriginalSpeed * targetSlowPercent, 999999);
            //                 // enemyConstruct.SlowdownImmunity = true; // Luau sets this
            //                 // enemyConstruct[slowDebuffAttrKey] = { sourceUnitId: sourceUnitId, appliedSlow: targetSlowPercent, guid: guid };
            //             }
            //         } else { // Should not be slowed by this unit
            //             if (currentSlowData && currentSlowData.sourceUnitId === sourceUnitId) {
            //                 // _G.EnemySpeedManager.RemoveBooster(enemyConstruct, currentSlowData.guid);
            //                 // enemyConstruct.SlowdownImmunity = undefined;
            //                 // delete enemyConstruct[slowDebuffAttrKey];
            //             }
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement _G.Constructs, _G.EnemySpeedManager to remove any slows applied by this unit.
            // const sourceUnitId = unit.getAttribute("IUUID");
            // const slowDebuffAttrKey = "TimeSlowdownAppliedBy";
            // for (const enemyId in _G.Constructs) {
            //     const enemyConstruct = _G.Constructs[enemyId];
            //     if (enemyConstruct && enemyConstruct[slowDebuffAttrKey] && enemyConstruct[slowDebuffAttrKey].sourceUnitId === sourceUnitId) {
            //         // _G.EnemySpeedManager.RemoveBooster(enemyConstruct, enemyConstruct[slowDebuffAttrKey].guid);
            //         // enemyConstruct.SlowdownImmunity = undefined;
            //         // delete enemyConstruct[slowDebuffAttrKey];
            //     }
            // }
        },
    },
};
