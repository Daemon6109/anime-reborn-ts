import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const HeavensScar: PassiveData = {
    name: "Heaven's Scar",
    description: "First unit within this unit range get 'scar' effect on all attacks",
    // maxPassiveStacks: 1, // Only one unit can be buffed by this passive instance at a time.
    // tagName: "HeavenScar", // Tag applied to the buffed unit.
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with Heaven's Scar
            // TODO: Implement BuffLib, FastVector, workspace, attribute, and table.sort equivalents
            // This logic is complex: it finds the highest DPS unit in range that isn't already buffed by this specific Heaven's Scar,
            // and applies a buff ("PassiveScar", tagName) to it. It only buffs one unit.
            // It also seems to track "HeavenBleedStacks" on the source unit, which likely corresponds to how many units it's currently buffing (max 1).

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let currentBuffedUnitIdByThis = unit.getAttribute("HeavensScarBuffedUnitId");
            // let foundTargetThisTick: Unit | undefined = undefined;
            // const potentialTargets: { unit: Unit; dps: number; distance: number }[] = [];

            // // Check if current target is still valid and in range
            // if (currentBuffedUnitIdByThis) {
            //     const currentTarget = currentlyPlaced.find((u: any) => u.getAttribute("IUUID") === currentBuffedUnitIdByThis) as Unit | undefined;
            //     if (currentTarget && FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, currentTarget.getInstance().PrimaryPart.Position) <= unitRange) {
            //         foundTargetThisTick = currentTarget; // Current target is still fine
            //     } else {
            //         // Current target lost or out of range, remove its buff
            //         if (currentTarget) {
            //             currentTarget.removeTag(HeavensScar.tagName);
            //             currentTarget.setAttribute("HeavenBleedBuff", false); // Luau uses this attribute
            //             currentTarget.setAttribute("HeavenBleedId", undefined);
            //             currentTarget.setAttribute("PassiveScar", undefined);
            //         }
            //         unit.setAttribute("HeavensScarBuffedUnitId", undefined);
            //         currentBuffedUnitIdByThis = undefined;
            //     }
            // }

            // // If no current valid target, try to find a new one
            // if (!foundTargetThisTick) {
            //     for (const unitToCheckInstance of currentlyPlaced) {
            //         const unitToCheck = unitToCheckInstance as Unit;
            //         if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart") || unitToCheck.getAttribute("HeavenBleedId")) {
            //             // Skip self, invalid units, or units already buffed by *any* Heaven's Scar
            //             continue;
            //         }
            //         const distance = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position);
            //         if (distance <= unitRange) {
            //             const dps = (BuffLib.GetDamage(unitToCheck) / BuffLib.GetAttackSpeed(unitToCheck));
            //             if (dps > 5) { // Luau arbitrary DPS threshold
            //                 potentialTargets.push({ unit: unitToCheck, dps, distance });
            //             }
            //         }
            //     }

            //     if (potentialTargets.length > 0) {
            //         potentialTargets.sort((a, b) => { // Sort by DPS desc, then distance asc
            //             if (b.dps !== a.dps) return b.dps - a.dps;
            //             return a.distance - b.distance;
            //         });
            //         foundTargetThisTick = potentialTargets[0].unit;
            //         foundTargetThisTick.addTag(HeavensScar.tagName);
            //         foundTargetThisTick.setAttribute("HeavenBleedBuff", true);
            //         foundTargetThisTick.setAttribute("HeavenBleedId", unitIndividualID); // Mark who buffed it
            //         foundTargetThisTick.setAttribute("PassiveScar", 5); // What is PassiveScar 5? Duration? Stacks?
            //         unit.setAttribute("HeavensScarBuffedUnitId", foundTargetThisTick.getAttribute("IUUID"));
            //     }
            // }
            // // Update HeavenBleedStacks on the source unit (0 or 1)
            // unit.setAttribute("HeavenBleedStacks", foundTargetThisTick ? 1 : 0);
        },
        onRemove: (unit: Unit) => { // unit is the one with Heaven's Scar being removed
            // TODO: Implement workspace and attribute equivalents
            // const buffedUnitId = unit.getAttribute("HeavensScarBuffedUnitId");
            // if (buffedUnitId) {
            //     const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            //     const buffedUnit = currentlyPlaced.find((u: any) => u.getAttribute("IUUID") === buffedUnitId) as Unit | undefined;
            //     if (buffedUnit) {
            //         buffedUnit.removeTag(HeavensScar.tagName);
            //         buffedUnit.setAttribute("HeavenBleedBuff", false);
            //         buffedUnit.setAttribute("HeavenBleedId", undefined);
            //         buffedUnit.setAttribute("PassiveScar", undefined);
            //     }
            // }
        },
    },
};
