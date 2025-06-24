import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SirensCall: PassiveData = {
    name: "Siren's Call",
    description: "+10% range buff for every unit in range (Non-stackable)",
    // percentIncrease: 0.1, // Range buff percentage
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with Siren's Call
            // TODO: Implement BuffLib, FastVector, workspace, attribute getting/setting
            // This passive buffs OTHER units in range, not self. "Non-stackable" means a unit can only get this buff once, even if in range of multiple Sirens.
            // The Luau code gives the buff to *each* unit in range if it doesn't have it.
            // "for every unit in range" in desc might be a typo and should be "for all units in range".

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const sourceUnitRange = BuffLib.GetRangeScaled(unit); // Range of the Siren's Call unit
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffFlagAttribute = "SirensCallBuffActive"; // To ensure non-stacking
            // const buffSourceAttribute = "SirensCallBuffSourceId"; // To track which Siren applied it
            // const sourceUnitId = unit.getAttribute("IUUID");

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= sourceUnitRange;

            //     if (isInRange) {
            //         if (!unitToCheck.getAttribute(buffFlagAttribute)) { // Only apply if not already buffed by any Siren's Call
            //             // unitToCheck.setAttribute(buffFlagAttribute, true);
            //             // unitToCheck.setAttribute(buffSourceAttribute, sourceUnitId);
            //             // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) + (SirensCall.percentIncrease || 0.1));
            //         }
            //     } else { // Out of range
            //         if (unitToCheck.getAttribute(buffSourceAttribute) === sourceUnitId) { // If this Siren was the source
            //             // unitToCheck.setAttribute(buffFlagAttribute, false); // Allow another Siren to buff if it comes in range
            //             // unitToCheck.removeAttribute(buffSourceAttribute);
            //             // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - (SirensCall.percentIncrease || 0.1));
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => { // Siren's Call unit is removed
            // TODO: Implement workspace, attribute getting/setting
            // const sourceUnitId = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffFlagAttribute = "SirensCallBuffActive";
            // const buffSourceAttribute = "SirensCallBuffSourceId";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(buffSourceAttribute) === sourceUnitId) {
            //         // unitToCheck.setAttribute(buffFlagAttribute, false);
            //         // unitToCheck.removeAttribute(buffSourceAttribute);
            //         // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - (SirensCall.percentIncrease || 0.1));
            //     }
            // }
        },
    },
};
