import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Gear2nd: PassiveData = {
    name: "GEAR", // Name in Luau is "GEAR", description mentions "Laugfy" (Luffy)
    description: "Laugfy feels safer with more allies around, increasing his attack speed by 5% for every unit within his range, up to a maximum of 20%.",
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is Laugfy
            // TODO: Implement BuffLib, FastVector, workspace, and attribute equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let unitsCountInRange = 0;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     if (FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange) {
            //         unitsCountInRange++;
            //     }
            // }

            // if (unit.getAttribute("OriginalSpeedGear2nd") === undefined) { // Store original SPA to revert correctly
            //     unit.setAttribute("OriginalSpeedGear2nd", unit.getAttribute("PermanentAttackSpeedMulti") || 1);
            // }
            // const originalSpeed = unit.getAttribute("OriginalSpeedGear2nd");
            // let buffPercent = 0;
            // if (unitsCountInRange > 0) {
            //     const calculatedBuff = Math.min(unitsCountInRange * 0.05, 0.20); // 5% per unit, max 20%
            //     buffPercent = calculatedBuff;
            // }
            // // Assuming PermanentAttackSpeedMulti lower is faster (cooldown based)
            // unit.setAttribute("PermanentAttackSpeedMulti", originalSpeed * (1 - buffPercent)); // Apply as a multiplier
        },
        onRemove: (unit: Unit) => {
            // TODO: Revert PermanentAttackSpeedMulti to original if needed.
            // const originalSpeed = unit.getAttribute("OriginalSpeedGear2nd");
            // if (originalSpeed !== undefined) {
            //     unit.setAttribute("PermanentAttackSpeedMulti", originalSpeed);
            // }
        },
        // The Luau onRemove re-runs the onUnitsInRange logic which is redundant if the unit is being removed.
        // A simpler onRemove would just clean up its own state or ensure its original stats are restored if they were temporarily altered.
    },
};
