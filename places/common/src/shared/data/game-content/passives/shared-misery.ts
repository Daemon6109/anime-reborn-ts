import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SharedMisery: PassiveData = {
    name: "Shared Misery",
    description: "First 5 units within Pikkora's range get +15% boss damage increase",
    // percentIncrease: 0.15, // Boss damage increase
    // maxUnitsToBuff: 5,
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is Pikkora
            // TODO: Implement BuffLib, FastVector, workspace, attribute equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder

            // // Count how many units this Pikkora instance is currently buffing
            // let unitsCurrentlyBuffedByThis = 0;
            // for (const u of currentlyPlaced) {
            //     if ((u as Unit).getAttribute("SharedMiseryBuffSourceId") === unitIndividualID) {
            //         unitsCurrentlyBuffedByThis++;
            //     }
            // }
            // // unit.setAttribute("SharedMiseryActiveBuffs", unitsCurrentlyBuffedByThis); // Update self count

            // // Iterate to apply or remove buffs
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     const isBuffedByThis = unitToCheck.getAttribute("SharedMiseryBuffSourceId") === unitIndividualID;
            //     const isBuffedByAnySharedMisery = unitToCheck.getAttribute("SharedMiseryBuffActive"); // General flag

            //     if (isInRange) {
            //         if (!isBuffedByAnySharedMisery && unitsCurrentlyBuffedByThis < (SharedMisery.maxUnitsToBuff || 5)) {
            //             // unitToCheck.setAttribute("SharedMiseryBuffSourceId", unitIndividualID);
            //             // unitToCheck.setAttribute("SharedMiseryBuffActive", true);
            //             // unitToCheck.setAttribute("PermanentDmgToBossMulti", (unitToCheck.getAttribute("PermanentDmgToBossMulti") || 0) + (SharedMisery.percentIncrease || 0.15));
            //             unitsCurrentlyBuffedByThis++;
            //             // unit.setAttribute("SharedMiseryActiveBuffs", unitsCurrentlyBuffedByThis);
            //         }
            //     } else { // Out of range
            //         if (isBuffedByThis) {
            //             // unitToCheck.setAttribute("SharedMiseryBuffActive", false); // Allow another to buff
            //             // unitToCheck.removeAttribute("SharedMiseryBuffSourceId");
            //             // unitToCheck.setAttribute("PermanentDmgToBossMulti", (unitToCheck.getAttribute("PermanentDmgToBossMulti") || 0) - (SharedMisery.percentIncrease || 0.15));
            //             unitsCurrentlyBuffedByThis = Math.max(0, unitsCurrentlyBuffedByThis -1);
            //             // unit.setAttribute("SharedMiseryActiveBuffs", unitsCurrentlyBuffedByThis);
            //         }
            //     }
            // }
            // Luau uses "SharedMiseryStacks" on Pikkora to count, and "SharedMiseryBuff"/"SharedMiseryId" on targets.
        },
        onRemove: (unit: Unit) => { // Pikkora is removed
            // TODO: Implement workspace, attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute("SharedMiseryBuffSourceId") === unitIndividualID) {
            //         // unitToCheck.setAttribute("SharedMiseryBuffActive", false);
            //         // unitToCheck.removeAttribute("SharedMiseryBuffSourceId");
            //         // unitToCheck.setAttribute("PermanentDmgToBossMulti", (unitToCheck.getAttribute("PermanentDmgToBossMulti") || 0) - (SharedMisery.percentIncrease || 0.15));
            //     }
            // }
        },
    },
};
