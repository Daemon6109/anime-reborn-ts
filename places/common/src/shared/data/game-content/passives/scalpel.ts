import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Scalpel: PassiveData = {
    name: "Scalpel",
    description: "For every unit that is in range Sentinel gains +1% dmg (caps at 5%) and -1% spa (caps at -5%)",
    // buffPerUnit: 0.01,
    // maxUnitsToCount: 5,
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, attribute getting/setting.
            // const originalSpeedAttr = "OriginalSpeedScalpel";
            // const originalDamageAttr = "OriginalDamageScalpel";
            // const currentBuffAmountAttr = "ScalpelCurrentBuffValue"; // Stores the total % buff (e.g., 0.03 for 3%)

            // if (unit.getAttribute(originalSpeedAttr) === undefined) {
            //     unit.setAttribute(originalSpeedAttr, unit.getAttribute("PermanentAttackSpeedMulti") || 1);
            // }
            // if (unit.getAttribute(originalDamageAttr) === undefined) {
            //     unit.setAttribute(originalDamageAttr, unit.getAttribute("PermanentDamageMulti") || 1);
            // }
            // unit.setAttribute(currentBuffAmountAttr, 0); // Reset for recalculation

            // // Revert to original stats before applying new calculation
            // unit.setAttribute("PermanentAttackSpeedMulti", unit.getAttribute(originalSpeedAttr));
            // unit.setAttribute("PermanentDamageMulti", unit.getAttribute(originalDamageAttr));

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let unitsInRangeCount = 0;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     if (FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange) {
            //         unitsInRangeCount++;
            //     }
            // }

            // const actualUnitsToCount = Math.min(unitsInRangeCount, (Scalpel.maxUnitsToCount || 5));
            // const totalBuffPercent = actualUnitsToCount * (Scalpel.buffPerUnit || 0.01);

            // if (totalBuffPercent > 0) {
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute(originalSpeedAttr) || 1) - totalBuffPercent); // SPA decrease
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute(originalDamageAttr) || 1) + totalBuffPercent);   // Damage increase
            //     unit.setAttribute(currentBuffAmountAttr, totalBuffPercent);
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Revert to original stats if they were stored.
            // const originalSpeed = unit.getAttribute("OriginalSpeedScalpel");
            // const originalDamage = unit.getAttribute("OriginalDamageScalpel");
            // if (originalSpeed !== undefined) unit.setAttribute("PermanentAttackSpeedMulti", originalSpeed);
            // if (originalDamage !== undefined) unit.setAttribute("PermanentDamageMulti", originalDamage);
        },
    },
};
