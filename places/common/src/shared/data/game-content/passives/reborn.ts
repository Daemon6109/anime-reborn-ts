import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Reborn: PassiveData = {
    name: "Reborn!",
    description: "Allies sharing the same element as this unit gain 20% bonus damage and 15% increased range. Additionally, their SPA is reduced by 1% each wave, up to a maximum of 5%.If only same-element allies are within range, this unit gains 20% critical chance and 25% critical damage.",
    // selfBuff: { critChance: 0.20, critDamage: 0.25 },
    // allyBuff: { damage: 0.20, range: 0.15, spaPerWave: -0.01, maxSpaReductionStacks: 5 },
    callbacks: {
        onUnitsInRange: async (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, attribute, unit.waitForChild, unit.configuration.Element.Value
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (!config) return;
            // const unitElement = config.Element.Value;

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder

            // let onlySameElementAlliesInRange = true;
            // let anyAlliesActuallyInRange = false; // To distinguish from just having units placed
            // const allyBuffIdAttribute = "RebornAllyBuffSourceIdRB"; // RB for Reborn
            // const allyBuffFlagAttribute = "RebornAllyBuffActiveRB";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) continue;

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     const isSameElement = unitToCheck.configuration.Element.Value === unitElement;

            //     if (isInRange) {
            //         anyAlliesActuallyInRange = true;
            //         if (!isSameElement) {
            //             onlySameElementAlliesInRange = false;
            //         }
            //         if (isSameElement) {
            //             if (!unitToCheck.getAttribute(allyBuffFlagAttribute)) {
            //                 // unitToCheck.setAttribute(allyBuffIdAttribute, unitIndividualID);
            //                 // unitToCheck.setAttribute(allyBuffFlagAttribute, true);
            //                 // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + (Reborn.allyBuff?.damage || 0.20));
            //                 // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) + (Reborn.allyBuff?.range || 0.15));
            //                 // unitToCheck.setAttribute("RebornAllySpaStacksRB", 0);
            //             }
            //         }
            //     } else { // Out of range
            //         if (unitToCheck.getAttribute(allyBuffIdAttribute) === unitIndividualID) {
            //             // unitToCheck.removeAttribute(allyBuffIdAttribute);
            //             // unitToCheck.removeAttribute(allyBuffFlagAttribute);
            //             // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - (Reborn.allyBuff?.damage || 0.20));
            //             // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - (Reborn.allyBuff?.range || 0.15));
            //             // const spaStacksToRemove = unitToCheck.getAttribute("RebornAllySpaStacksRB") || 0;
            //             // if (spaStacksToRemove > 0) {
            //             //    unitToCheck.setAttribute("PermanentAttackSpeedMulti", (unitToCheck.getAttribute("PermanentAttackSpeedMulti") || 1) - (spaStacksToRemove * (Reborn.allyBuff?.spaPerWave || -0.01)));
            //             // }
            //             // unitToCheck.removeAttribute("RebornAllySpaStacksRB");
            //         }
            //     }
            // }

            // const isSelfBuffed = unit.getAttribute("RebornSelfCritBuffActiveRB");
            // if (anyAlliesActuallyInRange && onlySameElementAlliesInRange) {
            //     if (!isSelfBuffed) {
            //         unit.setAttribute("RebornSelfCritBuffActiveRB", true);
            //         // unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + (Reborn.selfBuff?.critChance || 0.20));
            //         // unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + (Reborn.selfBuff?.critDamage || 0.25));
            //     }
            // } else {
            //     if (isSelfBuffed) {
            //         unit.setAttribute("RebornSelfCritBuffActiveRB", false);
            //         // unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) - (Reborn.selfBuff?.critChance || 0.20));
            //         // unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) - (Reborn.selfBuff?.critDamage || 0.25));
            //     }
            // }
        },
        onWave: (unit: Unit) => {
            // TODO: Implement workspace, attribute, unit.configuration.Element.Value
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const allyBuffIdAttribute = "RebornAllyBuffSourceIdRB";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) continue;

            //     if (unitToCheck.getAttribute(allyBuffIdAttribute) === unitIndividualID) { // Only affect allies buffed by *this* Reborn unit
            //         let spaStacks = unitToCheck.getAttribute("RebornAllySpaStacksRB") || 0;
            //         if (spaStacks < (Reborn.allyBuff?.maxSpaReductionStacks || 5)) {
            //             spaStacks++;
            //             // unitToCheck.setAttribute("RebornAllySpaStacksRB", spaStacks);
            //             // unitToCheck.setAttribute("PermanentAttackSpeedMulti", (unitToCheck.getAttribute("PermanentAttackSpeedMulti") || 1) + (Reborn.allyBuff?.spaPerWave || -0.01));
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace, attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const allyBuffIdAttribute = "RebornAllyBuffSourceIdRB";

            // if (unit.getAttribute("RebornSelfCritBuffActiveRB")) {
            //     // unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) - (Reborn.selfBuff?.critChance || 0.20));
            //     // unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) - (Reborn.selfBuff?.critDamage || 0.25));
            // }

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(allyBuffIdAttribute) === unitIndividualID) {
            //         // unitToCheck.removeAttribute(allyBuffIdAttribute);
            //         // unitToCheck.removeAttribute("RebornAllyBuffActiveRB");
            //         // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - (Reborn.allyBuff?.damage || 0.20));
            //         // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - (Reborn.allyBuff?.range || 0.15));
            //         // const spaStacksToRemove = unitToCheck.getAttribute("RebornAllySpaStacksRB") || 0;
            //         // if (spaStacksToRemove > 0) {
            //         //    unitToCheck.setAttribute("PermanentAttackSpeedMulti", (unitToCheck.getAttribute("PermanentAttackSpeedMulti") || 1) - (spaStacksToRemove * (Reborn.allyBuff?.spaPerWave || -0.01)));
            //         // }
            //         // unitToCheck.removeAttribute("RebornAllySpaStacksRB");
            //     }
            // }
        },
    },
};
