import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FanBase: PassiveData = {
    name: "Fanbase",
    description: "Mr. set gains 1% damage per unit in his range (max. 10%)",
    // maxPassiveStacks: 10, // Max units to count for bonus
    // percentPerStack: 0.01,  // Damage increase per unit
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is Mr. Set
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
            // unitsCountInRange = Math.min(unitsCountInRange, FanBase.maxPassiveStacks); // Cap at max stacks

            // const previousFanbaseStacks = unit.getAttribute("FanbaseActiveStacks") || 0;
            // const differenceInStacks = unitsCountInRange - previousFanbaseStacks;

            // if (differenceInStacks !== 0) {
            //     unit.setAttribute("FanbaseActiveStacks", unitsCountInRange);
            //     const currentDamageMulti = unit.getAttribute("PermanentDamageMulti") || 1;
            //     const newDamageMulti = currentDamageMulti + (differenceInStacks * FanBase.percentPerStack);
            //     unit.setAttribute("PermanentDamageMulti", newDamageMulti);
            // }
        },
        // onRemove could reset the FanbaseActiveStacks and revert damage if needed, though Luau doesn't explicitly.
    },
};
