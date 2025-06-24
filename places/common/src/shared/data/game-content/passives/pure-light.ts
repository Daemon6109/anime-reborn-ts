import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PureLight: PassiveData = {
    name: "Pure Light",
    description: "All `Light` type units in range gain +20% DMG (non-stackable)",
    // targetElement: "Light",
    // percentIncrease: 0.20,
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with Pure Light
            // TODO: Implement BuffLib, FastVector, workspace, attribute, unit.configuration.Element.Value
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "PureLightBuffIdPL"; // PL for PureLight
            // const buffFlagAttribute = "PureLightBuffActivePL";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     const isTargetElement = unitToCheck.configuration.Element.Value === (PureLight.targetElement || "Light");

            //     if (isInRange && isTargetElement) {
            //         if (!unitToCheck.getAttribute(buffFlagAttribute)) {
            //             unitToCheck.setAttribute(buffIdAttribute, unitIndividualID);
            //             unitToCheck.setAttribute(buffFlagAttribute, true);
            //             unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + (PureLight.percentIncrease || 0.20));
            //         }
            //     } else {
            //         if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //             unitToCheck.setAttribute(buffFlagAttribute, false);
            //             unitToCheck.removeAttribute(buffIdAttribute);
            //             unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - (PureLight.percentIncrease || 0.20));
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace, attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "PureLightBuffIdPL";
            // const buffFlagAttribute = "PureLightBuffActivePL";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //         unitToCheck.setAttribute(buffFlagAttribute, false);
            //         unitToCheck.removeAttribute(buffIdAttribute);
            //         unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - (PureLight.percentIncrease || 0.20));
            //     }
            // }
        },
    },
};
