import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const DragonsWill: PassiveData = {
    name: "Dragon's Will",
    description: "Reduces other unit's special ability cooldown by 15%",
    // percentIncrease: 0.15, // Cooldown reduction percentage
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, and attribute equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     const hasBuffFromThisSource = unitToCheck.getAttribute("KaidoDragonsWillId") === unitIndividualID;
            //     const hasAnyBuff = unitToCheck.getAttribute("KaidoDragonsWillBuff");

            //     if (isInRange && !hasAnyBuff) { // Apply if in range and not buffed by any Dragon's Will
            //         // unit.setAttribute("KaidoDragonsWillStacks", (unit.getAttribute("KaidoDragonsWillStacks") || 0) + 1); // Original Luau increments a stack on the applier, purpose unclear.
            //         unitToCheck.setAttribute("KaidoDragonsWillBuff", true);
            //         unitToCheck.setAttribute("KaidoDragonsWillId", unitIndividualID); // Mark who applied it
            //         unitToCheck.setAttribute("PermanentSpecialAbilityCdMulti", (unitToCheck.getAttribute("PermanentSpecialAbilityCdMulti") || 1) - DragonsWill.percentIncrease);
            //     } else if (!isInRange && hasBuffFromThisSource) { // Remove if out of range AND this unit applied it
            //         // unit.setAttribute("KaidoDragonsWillStacks", Math.max(0, (unit.getAttribute("KaidoDragonsWillStacks") || 0) - 1));
            //         unitToCheck.setAttribute("KaidoDragonsWillBuff", false);
            //         unitToCheck.setAttribute("KaidoDragonsWillId", undefined);
            //         unitToCheck.setAttribute("PermanentSpecialAbilityCdMulti", (unitToCheck.getAttribute("PermanentSpecialAbilityCdMulti") || 1) + DragonsWill.percentIncrease); // Revert reduction
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck.getAttribute("KaidoDragonsWillId") === unitIndividualID) { // If this unit was the source
            //         unitToCheck.setAttribute("KaidoDragonsWillBuff", false);
            //         unitToCheck.setAttribute("KaidoDragonsWillId", undefined);
            //         unitToCheck.setAttribute("PermanentSpecialAbilityCdMulti", (unitToCheck.getAttribute("PermanentSpecialAbilityCdMulti") || 1) + DragonsWill.percentIncrease); // Revert reduction
            //         // const applierUnit = ... get unit with unitIndividualID ...
            //         // if (applierUnit) {
            //         //    applierUnit.setAttribute("KaidoDragonsWillStacks", Math.max(0, (applierUnit.getAttribute("KaidoDragonsWillStacks") || 0) - 1));
            //         // }
            //     }
            // }
        },
    },
};
