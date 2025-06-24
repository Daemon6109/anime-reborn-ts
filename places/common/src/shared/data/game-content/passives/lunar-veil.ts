import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const LunarVeil: PassiveData = {
    name: "Lunar Veil",
    description: "Water units in range gains 10% Damage and 15% range. For every water unit in range, gain 2% dmg upto 10%.",
    // targetElement: "Water",
    // buffToWaterUnits: { damage: 0.10, range: 0.15 },
    // selfBuffPerWaterUnit: { damage: 0.02, maxTotal: 0.10 },
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with Lunar Veil
            // TODO: Implement BuffLib, FastVector, workspace, attribute, and unit.configuration.Element.Value equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const waterUnitsInRange: Unit[] = [];

            // // Debuff all units previously buffed by *this* Lunar Veil instance first
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute("LunarVeilBuffSourceId") === unitIndividualID) {
            //         // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - LunarVeil.buffToWaterUnits.damage);
            //         // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - LunarVeil.buffToWaterUnits.range);
            //         // unitToCheck.removeAttribute("LunarVeilBuffSourceId");
            //         // unitToCheck.removeAttribute("LunarVeilBuffActive");
            //     }
            // }

            // // Identify and buff Water units currently in range
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;

            //     if (isInRange && unitToCheck.configuration.Element.Value === LunarVeil.targetElement) {
            //         if (!unitToCheck.getAttribute("LunarVeilBuffActive")) { // Only buff if not already buffed by another Lunar Veil
            //             // unitToCheck.setAttribute("LunarVeilBuffSourceId", unitIndividualID);
            //             // unitToCheck.setAttribute("LunarVeilBuffActive", true);
            //             // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + LunarVeil.buffToWaterUnits.damage);
            //             // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) + LunarVeil.buffToWaterUnits.range);
            //         }
            //         waterUnitsInRange.push(unitToCheck); // Count for self-buff
            //     }
            // }

            // // Apply self-buff based on number of water units in range
            // const previousSelfBuff = unit.getAttribute("LunarVeilSelfBuffAmount") || 0;
            // const newSelfBuffStacks = Math.min(waterUnitsInRange.length, LunarVeil.selfBuffPerWaterUnit.maxTotal / LunarVeil.selfBuffPerWaterUnit.damage);
            // const newSelfBuffAmount = newSelfBuffStacks * LunarVeil.selfBuffPerWaterUnit.damage;

            // if (newSelfBuffAmount !== previousSelfBuff) {
            //     // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - previousSelfBuff + newSelfBuffAmount);
            //     // unit.setAttribute("LunarVeilSelfBuffAmount", newSelfBuffAmount);
            // }
            // // Luau's VYBuffIncrease/LVYBuffIncrease is similar to the self-buff logic here.
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute("LunarVeilBuffSourceId") === unitIndividualID) {
            //         // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - LunarVeil.buffToWaterUnits.damage);
            //         // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - LunarVeil.buffToWaterUnits.range);
            //         // unitToCheck.removeAttribute("LunarVeilBuffSourceId");
            //         // unitToCheck.removeAttribute("LunarVeilBuffActive");
            //     }
            // }
            // // Revert self-buff
            // const selfBuffAmount = unit.getAttribute("LunarVeilSelfBuffAmount") || 0;
            // if (selfBuffAmount > 0) {
            //     // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - selfBuffAmount);
            //     // unit.removeAttribute("LunarVeilSelfBuffAmount");
            // }
        },
    },
};
