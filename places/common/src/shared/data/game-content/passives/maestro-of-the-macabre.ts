import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const MaestroOfTheMacabre: PassiveData = {
    name: "Maestro of the Macabre",
    description: "At the start off each wave , grants all `ICE` element allies a 2% attack dmg and 3% range stacking up to 10% dmg and 15% range. every 10th buff wave, buff resets.",
    callbacks: {
        onWave: async (unit: Unit) => { // unit is the Maestro
            // TODO: Implement unit.waitForChild, workspace.UnitsPlaced, attribute getting/setting, unit.configuration.Element.Value
            // const config = await unit.waitForChild("configuration", 10); // May not be needed if not accessing Maestro's config directly
            // let waveCounterForReset = unit.getAttribute("MaestroWaveCounter") || 0;
            // waveCounterForReset++;
            // unit.setAttribute("MaestroWaveCounter", waveCounterForReset);

            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder

            // const shouldResetThisWave = waveCounterForReset >= 10;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }

            //     if (unitToCheck.configuration.Element.Value === "Ice") { // Assuming element access
            //         let maestroStacksOnTarget = unitToCheck.getAttribute("MaestroBuffStacks") || 0;
            //         const currentDmgBuffFromThis = unitToCheck.getAttribute("MaestroDmgBuffApplied") || 0;
            //         const currentRngBuffFromThis = unitToCheck.getAttribute("MaestroRngBuffApplied") || 0;

            //         if (shouldResetThisWave) {
            //             if (unitToCheck.getAttribute("MaestroBuffSourceId") === unitIndividualID) {
            //                 // Reset buffs applied by this Maestro
            //                 // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - currentDmgBuffFromThis);
            //                 // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - currentRngBuffFromThis);
            //                 // unitToCheck.setAttribute("MaestroBuffStacks", 0);
            //                 // unitToCheck.setAttribute("MaestroDmgBuffApplied", 0);
            //                 // unitToCheck.setAttribute("MaestroRngBuffApplied", 0);
            //                 // unitToCheck.removeAttribute("MaestroBuffSourceId"); // No longer buffed by this Maestro
            //             }
            //         } else {
            //             // Apply or stack buff if not resetting
            //             if (!unitToCheck.getAttribute("MaestroBuffSourceId") || unitToCheck.getAttribute("MaestroBuffSourceId") === unitIndividualID) {
            //                 if (maestroStacksOnTarget < 5) { // Max 5 stacks (10% dmg, 15% range)
            //                     // unitToCheck.setAttribute("MaestroBuffStacks", maestroStacksOnTarget + 1);
            //                     // unitToCheck.setAttribute("MaestroBuffSourceId", unitIndividualID);

            //                     // const dmgToAdd = 0.02;
            //                     // const rngToAdd = 0.03;
            //                     // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + dmgToAdd);
            //                     // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) + rngToAdd);
            //                     // unitToCheck.setAttribute("MaestroDmgBuffApplied", currentDmgBuffFromThis + dmgToAdd);
            //                     // unitToCheck.setAttribute("MaestroRngBuffApplied", currentRngBuffFromThis + rngToAdd);
            //                 }
            //             }
            //         }
            //     }
            // }
            // if (shouldResetThisWave) {
            //     unit.setAttribute("MaestroWaveCounter", 0); // Reset Maestro's own wave counter
            // }
        },
        onRemove: (unit: Unit) => { // Maestro unit is removed
            // TODO: Implement workspace, attribute getting/setting
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute("MaestroBuffSourceId") === unitIndividualID) {
            //         // const currentDmgBuffFromThis = unitToCheck.getAttribute("MaestroDmgBuffApplied") || 0;
            //         // const currentRngBuffFromThis = unitToCheck.getAttribute("MaestroRngBuffApplied") || 0;
            //         // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - currentDmgBuffFromThis);
            //         // unitToCheck.setAttribute("PermanentRangeMulti", (unitToCheck.getAttribute("PermanentRangeMulti") || 1) - currentRngBuffFromThis);
            //         // unitToCheck.setAttribute("MaestroBuffStacks", 0);
            //         // unitToCheck.setAttribute("MaestroDmgBuffApplied", 0);
            //         // unitToCheck.setAttribute("MaestroRngBuffApplied", 0);
            //         // unitToCheck.removeAttribute("MaestroBuffSourceId");
            //         // unitToCheck.removeAttribute("MaestroBuff"); // Luau uses "MaestroBuff" as a general flag too
            //     }
            // }
        },
    },
};
