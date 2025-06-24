import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FierceEnforcement: PassiveData = {
    name: "Fierce Enforcement",
    description: "For every fierce unit in his range he gains 20% dmg against boss enemies up to 100% dmg, while fierce units in his range, they gain 15% dmg against boss enemies.",
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with this passive
            // TODO: Implement BuffLib, FastVector, workspace, attribute, unit.configuration.Element.Value, and PermanentDmgToBossMulti equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let fierceUnitsInRangeCount = 0;
            // const fierceUnitsFound: Unit[] = [];

            // // First pass: identify fierce units in range and apply buff to them
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     const isFierceElement = unitToCheck.configuration.Element.Value === "Fierce"; // Assuming element access

            //     if (isInRange && isFierceElement) {
            //         fierceUnitsInRangeCount++;
            //         fierceUnitsFound.push(unitToCheck);
            //         // Buff other fierce units
            //         if (!unitToCheck.getAttribute("FierceDarknessBuff")) { // Luau uses "FierceDarknessBuff"
            //             unitToCheck.setAttribute("FierceDarknessId", unitIndividualID);
            //             unitToCheck.setAttribute("FierceDarknessBuff", true);
            //             unitToCheck.setAttribute("PermanentDmgToBossMulti", (unitToCheck.getAttribute("PermanentDmgToBossMulti") || 1) + 0.15);
            //         }
            //     } else if (!isInRange && unitToCheck.getAttribute("FierceDarknessId") === unitIndividualID) {
            //         // Remove buff if it moved out of range and this unit applied it
            //         unitToCheck.setAttribute("FierceDarknessBuff", false);
            //         unitToCheck.setAttribute("FierceDarknessId", undefined);
            //         unitToCheck.setAttribute("PermanentDmgToBossMulti", (unitToCheck.getAttribute("PermanentDmgToBossMulti") || 1) - 0.15);
            //     }
            // }

            // // Buff self based on count of fierce units
            // const currentSelfBuffAmount = unit.getAttribute("FierceBuffIncrease") || 0; // This seems to be raw percentage 0-50 in Luau
            // const newSelfBuffAmount = Math.min(fierceUnitsInRangeCount * 10, 50); // Luau: *10, max 50 (for 20% per unit up to 100% total, this is 10% up to 50%)
            //                                                                      // Description: 20% per unit up to 100%. So, 20 per unit, max 100.
            // const actualNewSelfBuffPercent = Math.min(fierceUnitsInRangeCount * 0.20, 1.00); // Max 100% damage bonus
            // const lastAppliedSelfBuffPercent = unit.getAttribute("LastFierceSelfBuffPercent") || 0;

            // const diffToApply = actualNewSelfBuffPercent - lastAppliedSelfBuffPercent;

            // if (diffToApply !== 0) {
            //      unit.setAttribute("PermanentDmgToBossMulti", (unit.getAttribute("PermanentDmgToBossMulti") || 1) + diffToApply);
            //      unit.setAttribute("LastFierceSelfBuffPercent", actualNewSelfBuffPercent);
            // }
            // // Luau's FierceBuffIncrease & FierceBuffIncrease2 seems overly complex for just tracking the self-buff.
            // // Simplified to directly calculate and apply the change to PermanentDmgToBossMulti for self.
        },
        onRemove: (unit: Unit) => { // Unit with the passive is removed
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     // Remove buff from other units if this unit was the source
            //     if (unitToCheck.getAttribute("FierceDarknessId") === unitIndividualID) {
            //         unitToCheck.setAttribute("FierceDarknessBuff", false);
            //         unitToCheck.setAttribute("FierceDarknessId", undefined);
            //         unitToCheck.setAttribute("PermanentDmgToBossMulti", (unitToCheck.getAttribute("PermanentDmgToBossMulti") || 1) - 0.15);
            //     }
            // }
            // // Revert self-buff if any was applied (though PermanentDmgToBossMulti is usually persistent)
            // const selfBuffApplied = unit.getAttribute("LastFierceSelfBuffPercent") || 0;
            // if (selfBuffApplied > 0) {
            //    unit.setAttribute("PermanentDmgToBossMulti", (unit.getAttribute("PermanentDmgToBossMulti") || 1) - selfBuffApplied);
            //    unit.setAttribute("LastFierceSelfBuffPercent", 0);
            // }
        },
    },
};
