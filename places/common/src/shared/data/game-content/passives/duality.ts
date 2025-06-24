import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

// Helper function to apply/remove stat modifications
// const applyDualityStats = (unit: Unit, amount: number) => {
//     // TODO: Implement attribute getting/setting logic. Ensure default values are handled.
//     // unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - amount);
//     // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + amount);
//     // unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + amount);
// };

export const Duality: PassiveData = {
    name: "Duality",
    description: "Having multiple Ihigos in range will buff all of them by 5%",
    // buffPercent: 0.05, // Configuration specific to this passive
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, attribute, and string.match equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffUnitsInRange: Unit[] = [];

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     if (isInRange && unitToCheck.Name.includes("Ichigo")) { // Assuming unit.Name is accessible and string.match
            //         buffUnitsInRange.push(unitToCheck);
            //     }
            // }

            // const unitAlreadyBuffed = unit.getAttribute("DualityBuff");

            // if (buffUnitsInRange.length >= 1 && !unitAlreadyBuffed) {
            //     unit.setAttribute("DualityBuff", true);
            //     // applyDualityStats(unit, Duality.buffPercent);

            //     for (const unitToBuff of buffUnitsInRange) {
            //         if (!unitToBuff.getAttribute("DualityBuff")) {
            //             unitToBuff.setAttribute("DualityBuff", true);
            //             unitToBuff.setAttribute("DualityBuffID", unitIndividualID); // Mark which unit applied the buff
            //             // applyDualityStats(unitToBuff, Duality.buffPercent);
            //         }
            //     }
            // } else if (buffUnitsInRange.length === 0 && unitAlreadyBuffed) { // Changed >= 1 to === 0 for clarity on when to remove
            //     unit.setAttribute("DualityBuff", false);
            //     // applyDualityStats(unit, -Duality.buffPercent); // Revert buff on self

            //     // The Luau code iterates `BuffUnits` here which would be empty.
            //     // It should iterate all units previously buffed by *this* unit.
            //     // This requires tracking which units this instance of Duality has buffed.
            //     // For now, this part of logic is complex to directly translate without better state management.
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck.getAttribute("DualityBuffID") === unitIndividualID) { // If this unit applied the buff
            //         unitToCheck.setAttribute("DualityBuff", undefined); // Or false
            //         unitToCheck.setAttribute("DualityBuffID", undefined);
            //         // applyDualityStats(unitToCheck, -Duality.buffPercent); // Revert buff
            //     }
            // }
            // // Also revert buff on self if it was active
            // if (unit.getAttribute("DualityBuff")) {
            //     // applyDualityStats(unit, -Duality.buffPercent);
            //     unit.setAttribute("DualityBuff", undefined);
            // }
        },
    },
};
