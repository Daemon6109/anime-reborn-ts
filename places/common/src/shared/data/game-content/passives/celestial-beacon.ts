import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CelestialBeacon: PassiveData = {
    name: "Celestial Beacon",
    description: "Boosts the range of all ground units in his range by 20% while boosting the damage of all hills units by 10%.",
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, and attribute equivalents
            // const BuffLib = require(replicated.Libs.BuffLib);
            // const FastVector = require(replicated.Libs.FastVector).new();
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren();
            // for (const unitToCheck of currentlyPlaced) {
            //     if (unitToCheck === unit || !unitToCheck.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.HumanoidRootPart.Position, unitToCheck.HumanoidRootPart.Position) <= unitRange;
            //     const hasBuff = unitToCheck.getAttribute("VYBuff2"); // VYBuff2 seems to be the flag for this passive's buff
            //     const buffSourceId = unitToCheck.getAttribute("VYBuffID2");
            //     if (isInRange && !hasBuff) { // Apply buff if in range and not already buffed by this passive from another source
            //         const placementType = unitToCheck.configuration.PlacementType.Value; // Assuming PlacementType is available
            //         if (placementType === "Ground") {
            //             unitToCheck.setAttribute("VYBuffID2", unitIndividualID);
            //             unitToCheck.setAttribute("VYBuff2", true);
            //             unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) + 0.2);
            //         } else if (placementType === "Air") { // Original code says "Air", assuming "Hills" from desc means Air/Flying
            //             unitToCheck.setAttribute("VYBuffID2", unitIndividualID);
            //             unitToCheck.setAttribute("VYBuff2", true);
            //             unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + 0.1);
            //         }
            //     } else if (!isInRange && hasBuff && buffSourceId === unitIndividualID) { // Remove buff if out of range and this unit applied it
            //         const placementType = unitToCheck.configuration.PlacementType.Value;
            //          unitToCheck.setAttribute("VYBuffID2", undefined);
            //          unitToCheck.setAttribute("VYBuff2", false);
            //         if (placementType === "Ground") {
            //             unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - 0.2);
            //         } else if (placementType === "Air") {
            //             unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - 0.1);
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren();
            // for (const unitToCheck of currentlyPlaced) {
            //     if (!unitToCheck.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     if (unitToCheck.getAttribute("VYBuffID2") === unitIndividualID) { // If this unit was the source
            //         unitToCheck.setAttribute("VYBuffID2", undefined);
            //         unitToCheck.setAttribute("VYBuff2", false);
            //         const placementType = unitToCheck.configuration.PlacementType.Value;
            //         if (placementType === "Ground") {
            //             unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - 0.2);
            //         } else if (placementType === "Air") {
            //             unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - 0.1);
            //         }
            //     }
            // }
        },
    },
};
