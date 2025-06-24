import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PerfectAssistant: PassiveData = {
    name: "Perfect Assistant",
    description: "All non farm units in Whis’ range gain a +10% Damage, +5% Range, and -5% SPA buff.",
    // buffDetails: { damage: 0.10, range: 0.05, spa: -0.05 }, // SPA: negative is a buff (faster)
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is Whis
            // TODO: Implement BuffLib, FastVector, workspace, attribute, and unit type check (non-farm)
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "PerfectAssistantBuffId";
            // const buffFlagAttribute = "PerfectAssistantBuffActive";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }

            //     // const isFarmUnit = unitToCheck.configuration.UnitType === "Farm"; // Example: needs actual farm unit check
            //     // if (isFarmUnit) continue;

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;

            //     if (isInRange) {
            //         if (!unitToCheck.getAttribute(buffFlagAttribute)) {
            //             // unitToCheck.setAttribute(buffIdAttribute, unitIndividualID);
            //             // unitToCheck.setAttribute(buffFlagAttribute, true);
            //             // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + PerfectAssistant.buffDetails.damage);
            //             // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) + PerfectAssistant.buffDetails.range);
            //             // unitToCheck.setAttribute("PermanentAttackSpeedMulti", (unitToCheck.getAttribute("PermanentAttackSpeedMulti") || 1) + PerfectAssistant.buffDetails.spa); // SPA buff is added (e.g., if base is 1, becomes 0.95)
            //         }
            //     } else { // Out of range
            //         if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //             // unitToCheck.setAttribute(buffFlagAttribute, false);
            //             // unitToCheck.removeAttribute(buffIdAttribute);
            //             // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - PerfectAssistant.buffDetails.damage);
            //             // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - PerfectAssistant.buffDetails.range);
            //             // unitToCheck.setAttribute("PermanentAttackSpeedMulti", (unitToCheck.getAttribute("PermanentAttackSpeedMulti") || 1) - PerfectAssistant.buffDetails.spa);
            //         }
            //     }
            // }
            // Luau uses "PDarknessBuff" / "PDarknessId", using more descriptive names here.
        },
        onRemove: (unit: Unit) => { // Whis is removed
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "PerfectAssistantBuffId";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //         // unitToCheck.setAttribute("PerfectAssistantBuffActive", false);
            //         // unitToCheck.removeAttribute(buffIdAttribute);
            //         // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - PerfectAssistant.buffDetails.damage);
            //         // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - PerfectAssistant.buffDetails.range);
            //         // unitToCheck.setAttribute("PermanentAttackSpeedMulti", (unitToCheck.getAttribute("PermanentAttackSpeedMulti") || 1) - PerfectAssistant.buffDetails.spa);
            //     }
            // }
        },
    },
};
