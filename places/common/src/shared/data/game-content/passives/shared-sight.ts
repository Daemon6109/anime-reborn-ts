import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SharedSight: PassiveData = {
    name: "Shared Sight",
    description: "This unit gives first 2 units in radius the ability to see 'Shade' type enemies",
    // maxUnitsToBuff: 2,
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with Shared Sight
            // TODO: Implement BuffLib, FastVector, workspace, attribute, tag manipulation.
            // This needs to carefully manage which 2 units get the buff if there are more than 2 in range.
            // Luau's logic is a bit simple: it iterates and buffs the first 2 it finds that aren't already buffed,
            // storing the count on the source unit. It doesn't prioritize or re-evaluate if closer/better targets appear.

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const sightBuffSourceIdAttr = "SharedSightSourceId";
            // const sightBuffActiveAttr = "SharedSightActive"; // Luau uses "SharedSight"
            // const sourceUnitId = unit.getAttribute("IUUID");

            // let unitsBuffedByThisInstance = 0;
            // // Count units currently buffed by this specific Shared Sight unit
            // for (const u of currentlyPlaced) {
            //     if ((u as Unit).getAttribute(sightBuffSourceIdAttr) === sourceUnitId) {
            //         unitsBuffedByThisInstance++;
            //     }
            // }
            // // unit.setAttribute("SharedSightBuffCount", unitsBuffedByThisInstance); // Store on self

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     const isBuffedByThis = unitToCheck.getAttribute(sightBuffSourceIdAttr) === sourceUnitId;

            //     if (isInRange) {
            //         if (!unitToCheck.getAttribute(sightBuffActiveAttr) && unitsBuffedByThisInstance < (SharedSight.maxUnitsToBuff || 2)) {
            //             // unitToCheck.addTag("TrueSight");
            //             // unitToCheck.setAttribute(sightBuffActiveAttr, true);
            //             // unitToCheck.setAttribute(sightBuffSourceIdAttr, sourceUnitId);
            //             unitsBuffedByThisInstance++;
            //             // unit.setAttribute("SharedSightBuffCount", unitsBuffedByThisInstance);
            //         }
            //     } else { // Out of range
            //         if (isBuffedByThis) {
            //             // unitToCheck.removeTag("TrueSight");
            //             // unitToCheck.setAttribute(sightBuffActiveAttr, false);
            //             // unitToCheck.removeAttribute(sightBuffSourceIdAttr);
            //             unitsBuffedByThisInstance = Math.max(0, unitsBuffedByThisInstance - 1);
            //             // unit.setAttribute("SharedSightBuffCount", unitsBuffedByThisInstance);
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => { // Unit with Shared Sight is removed
            // TODO: Implement workspace, attribute, tag manipulation.
            // const sourceUnitId = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const sightBuffSourceIdAttr = "SharedSightSourceId";
            // const sightBuffActiveAttr = "SharedSightActive";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(sightBuffSourceIdAttr) === sourceUnitId) {
            //         // unitToCheck.removeTag("TrueSight");
            //         // unitToCheck.setAttribute(sightBuffActiveAttr, false);
            //         // unitToCheck.removeAttribute(sightBuffSourceIdAttr);
            //     }
            // }
        },
    },
};
