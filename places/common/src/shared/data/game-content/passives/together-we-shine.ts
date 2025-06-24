import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const TogetherWeShine: PassiveData = {
    name: "Together we shine",
    description: "First 10 units within Twenty One's range get +15% range increase",
    // percentIncrease: 0.15, // Range increase
    // maxUnitsToBuff: 10,
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is Twenty One
            // TODO: Implement BuffLib, FastVector, workspace, attribute getting/setting.
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "TogetherWeShineBuffIdTWS"; // TWS for TogetherWeShine
            // const buffFlagAttribute = "TogetherWeShineBuffActiveTWS";
            // const sourceUnitBuffCountAttr = "TogetherWeShineBuffsGivenCount";

            // let unitsCurrentlyBuffedByThisInstance = 0;
            // // First, check existing buffed units: remove if out of range, count if still in range & buffed by this.
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //         const isStillInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //         if (isStillInRange) {
            //             unitsCurrentlyBuffedByThisInstance++;
            //         } else {
            //             // unitToCheck.setAttribute(buffFlagAttribute, false);
            //             // unitToCheck.removeAttribute(buffIdAttribute);
            //             // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - (TogetherWeShine.percentIncrease || 0.15));
            //         }
            //     }
            // }
            // // unit.setAttribute(sourceUnitBuffCountAttr, unitsCurrentlyBuffedByThisInstance);

            // // Then, iterate to buff new units if cap not reached
            // if (unitsCurrentlyBuffedByThisInstance < (TogetherWeShine.maxUnitsToBuff || 10)) {
            //     for (const unitToCheckInstance of currentlyPlaced) {
            //         if (unitsCurrentlyBuffedByThisInstance >= (TogetherWeShine.maxUnitsToBuff || 10)) break; // Stop if cap reached

            //         const unitToCheck = unitToCheckInstance as Unit;
            //         if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart") || unitToCheck.getAttribute(buffFlagAttribute)) {
            //             // Skip self, invalid units, or units already buffed by *any* TogetherWeShine
            //             continue;
            //         }

            //         const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //         if (isInRange) {
            //             // unitToCheck.setAttribute(buffIdAttribute, unitIndividualID);
            //             // unitToCheck.setAttribute(buffFlagAttribute, true);
            //             // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) + (TogetherWeShine.percentIncrease || 0.15));
            //             unitsCurrentlyBuffedByThisInstance++;
            //             // unit.setAttribute(sourceUnitBuffCountAttr, unitsCurrentlyBuffedByThisInstance);
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace, attribute equivalents.
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "TogetherWeShineBuffIdTWS";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //         // unitToCheck.setAttribute("TogetherWeShineBuffActiveTWS", false);
            //         // unitToCheck.removeAttribute(buffIdAttribute);
            //         // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - (TogetherWeShine.percentIncrease || 0.15));
            //     }
            // }
        },
    },
};
