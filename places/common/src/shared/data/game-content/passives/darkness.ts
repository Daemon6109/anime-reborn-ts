import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Darkness: PassiveData = {
    name: "Darkness",
    description: "All `Dark` type units in range gain +35% DMG (non-stackable)",
    // targetElement: "Dark", // Configuration specific to this passive
    // percentIncrease: 0.35, // Configuration specific to this passive
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, attribute, and unit.configuration.Element.Value equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Assuming conversion or type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     // Assuming unitToCheck.configuration.Element.Value holds the element string
            //     if (isInRange && !unitToCheck.getAttribute("DarknessBuff") && unitToCheck.configuration.Element.Value === Darkness.targetElement) {
            //         unitToCheck.setAttribute("DarknessId", unitIndividualID);
            //         unitToCheck.setAttribute("DarknessBuff", true);
            //         unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + Darkness.percentIncrease);
            //     } else if (!isInRange && unitToCheck.getAttribute("DarknessBuff") && unitToCheck.getAttribute("DarknessId") === unitIndividualID) {
            //         // Unit moved out of range, remove buff if this unit applied it
            //         unitToCheck.setAttribute("DarknessBuff", false);
            //         unitToCheck.setAttribute("DarknessId", undefined);
            //         unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - Darkness.percentIncrease);
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Assuming conversion or type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     if (unitToCheck.getAttribute("DarknessBuff") === true && unitToCheck.getAttribute("DarknessId") === unitIndividualID) {
            //         unitToCheck.setAttribute("DarknessBuff", false);
            //         unitToCheck.setAttribute("DarknessId", undefined);
            //         unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - Darkness.percentIncrease);
            //     }
            // }
        },
    },
};
