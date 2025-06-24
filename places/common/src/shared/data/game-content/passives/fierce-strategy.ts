import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FierceStrategy: PassiveData = {
    name: "Fierce Strategy",
    description: "If there is more than 3 units of the same element in his range this unit gains 15% dmg and 10% range if there is less than 3 units of the same element in his range this unit gains 25% crit chance and 30% crit dmg ( does not stack )",
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with this passive
            // TODO: Implement BuffLib, FastVector, workspace, attribute, and unit.configuration.Element.Value equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let sameElementUnitsInAreaCount = 0; // Specifically "Fierce" element based on Luau
            // const unitElement = unit.configuration.Element.Value; // Element of the unit with the passive

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     if (FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange) {
            //         if (unitToCheck.configuration.Element.Value === "Fierce") { // Luau code specifically checks for "Fierce"
            //             sameElementUnitsInAreaCount++;
            //         }
            //     }
            // }

            // const hasBuffMode1 = unit.getAttribute("FierceStrategyBuff1Active"); // For >= 3 same element units
            // const hasBuffMode2 = unit.getAttribute("FierceStrategyBuff2Active"); // For < 3 same element units

            // if (sameElementUnitsInAreaCount >= 3) {
            //     // Activate/Maintain Mode 1 Buff (DMG + Range)
            //     if (!hasBuffMode1) {
            //         unit.setAttribute("FierceStrategyBuff1Active", true);
            //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + 0.15);
            //         unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.10);
            //     }
            //     // Deactivate/Remove Mode 2 Buff (Crit) if it was active
            //     if (hasBuffMode2) {
            //         unit.setAttribute("FierceStrategyBuff2Active", false);
            //         unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) - 0.30);
            //         unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) - 0.25);
            //     }
            // } else { // sameElementUnitsInAreaCount < 3
            //     // Deactivate/Remove Mode 1 Buff (DMG + Range) if it was active
            //     if (hasBuffMode1) {
            //         unit.setAttribute("FierceStrategyBuff1Active", false);
            //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - 0.15);
            //         unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - 0.10);
            //     }
            //     // Activate/Maintain Mode 2 Buff (Crit)
            //     if (!hasBuffMode2) {
            //         unit.setAttribute("FierceStrategyBuff2Active", true);
            //         unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + 0.30);
            //         unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + 0.25);
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Revert any active buffs if necessary, though permanent stat changes usually persist.
            // The Luau onRemove is just `return`.
            // if (unit.getAttribute("FierceStrategyBuff1Active")) {
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - 0.15);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - 0.10);
            // }
            // if (unit.getAttribute("FierceStrategyBuff2Active")) {
            //     unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) - 0.30);
            //     unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) - 0.25);
            // }
        },
    },
};
