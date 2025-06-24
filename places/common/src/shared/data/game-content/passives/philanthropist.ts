import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Philanthropist: PassiveData = {
    name: "Philanthropist",
    description: "First 5 units within Speedcart's range get 15% discount on upgrades (Non-stackable)",
    // percentIncrease: 0.15, // Actually a decrease for price, so -0.15
    // maxPassiveStacks: 5,   // Max units to buff
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is Speedcart
            // TODO: Implement BuffLib, FastVector, workspace, attribute equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "PhilanthropistBuffId";
            // const buffFlagAttribute = "PhilanthropistBuffActive";
            // const priceReduction = -0.15; // 15% discount

            // let unitsCurrentlyBuffedByThisInstance = 0;
            // for (const u of currentlyPlaced) {
            //     if ((u as Unit).getAttribute(buffIdAttribute) === unitIndividualID) {
            //         unitsCurrentlyBuffedByThisInstance++;
            //     }
            // }
            // // unit.setAttribute("PhilanthropistActiveBuffsCount", unitsCurrentlyBuffedByThisInstance); // Track own buff count

            // // Iterate to apply or remove buffs
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     const isBuffedByThis = unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID;
            //     const isBuffedByAnyone = unitToCheck.getAttribute(buffFlagAttribute); // General flag to prevent stacking from multiple philanthropists

            //     if (isInRange) {
            //         if (!isBuffedByAnyone && unitsCurrentlyBuffedByThisInstance < Philanthropist.maxPassiveStacks) {
            //             // unitToCheck.setAttribute(buffIdAttribute, unitIndividualID);
            //             // unitToCheck.setAttribute(buffFlagAttribute, true);
            //             // unitToCheck.setAttribute("PermanentPriceMulti", (unitToCheck.getAttribute("PermanentPriceMulti") || 1) + priceReduction);
            //             unitsCurrentlyBuffedByThisInstance++;
            //             // unit.setAttribute("PhilanthropistActiveBuffsCount", unitsCurrentlyBuffedByThisInstance);
            //         }
            //     } else { // Out of range
            //         if (isBuffedByThis) {
            //             // unitToCheck.setAttribute(buffFlagAttribute, false); // Allow another philanthropist to buff
            //             // unitToCheck.removeAttribute(buffIdAttribute);
            //             // unitToCheck.setAttribute("PermanentPriceMulti", (unitToCheck.getAttribute("PermanentPriceMulti") || 1) - priceReduction); // Revert
            //             unitsCurrentlyBuffedByThisInstance = Math.max(0, unitsCurrentlyBuffedByThisInstance - 1);
            //             // unit.setAttribute("PhilanthropistActiveBuffsCount", unitsCurrentlyBuffedByThisInstance);
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => { // Speedcart is removed
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "PhilanthropistBuffId";
            // const priceReduction = -0.15;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //         // unitToCheck.setAttribute("PhilanthropistBuffActive", false);
            //         // unitToCheck.removeAttribute(buffIdAttribute);
            //         // unitToCheck.setAttribute("PermanentPriceMulti", (unitToCheck.getAttribute("PermanentPriceMulti") || 1) - priceReduction); // Revert
            //     }
            // }
        },
    },
};
