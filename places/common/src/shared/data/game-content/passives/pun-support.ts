import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PunSupport: PassiveData = {
    name: "Pun support",
    description: "Each Pun in this unit radius buffs it's damage and range by 3% ",
    // percentIncreasePerPun: 0.03,
    callbacks: {
        onUnitsInRange: async (unit: Unit) => { // unit is the one with PunSupport
            // TODO: Implement BuffLib, FastVector, workspace, attribute, unit.waitForChild, unit.Name access
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (!config) return;

            // const previousTotalBuff = unit.getAttribute("PunSupportTotalBuffAmount") || 0;
            // let currentTotalBuff = 0; // This will be the new total buff to apply

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let punCountInRange = 0;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     // Luau: if Unit.Name == UnitToCheck.Name then ... (and not self)
            //     if (unit.getInstance().Name === unitToCheck.getInstance().Name && unit !== unitToCheck) {
            //         const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //         if (isInRange) {
            //             punCountInRange++;
            //         }
            //     }
            // }

            // if (punCountInRange > 0) {
            //     currentTotalBuff = punCountInRange * (PunSupport.percentIncreasePerPun || 0.03);
            // }

            // const diffBuff = currentTotalBuff - previousTotalBuff;

            // if (diffBuff !== 0) {
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + diffBuff);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + diffBuff);
            //     unit.setAttribute("PunSupportTotalBuffAmount", currentTotalBuff);
            // }
            // Luau logic for PunBuffIncrease seems to correctly handle the delta.
        },
    },
};
