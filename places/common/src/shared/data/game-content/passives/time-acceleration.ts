import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const TimeAcceleration: PassiveData = {
    name: "Time Acceleration",
    description: "All units in range get -10% SPA buff.",
    // spaBuffToAllies: -0.10, // SPA decrease (buff)
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the source of the aura
            // TODO: Implement BuffLib, FastVector, workspace, attribute getting/setting.
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "TimeAccelerationBuffSourceIdTA"; // TA for TimeAcceleration
            // const buffFlagAttribute = "TimeAccelerationBuffActiveTA";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;

            //     if (isInRange) {
            //         if (!unitToCheck.getAttribute(buffFlagAttribute)) {
            //             // unitToCheck.setAttribute(buffIdAttribute, unitIndividualID);
            //             // unitToCheck.setAttribute(buffFlagAttribute, true);
            //             // unitToCheck.setAttribute("PermanentAttackSpeedMulti", (unitToCheck.getAttribute("PermanentAttackSpeedMulti") || 1) + (TimeAcceleration.spaBuffToAllies || -0.10));
            //         }
            //     } else {
            //         if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //             // unitToCheck.setAttribute(buffFlagAttribute, false);
            //             // unitToCheck.removeAttribute(buffIdAttribute);
            //             // unitToCheck.setAttribute("PermanentAttackSpeedMulti", (unitToCheck.getAttribute("PermanentAttackSpeedMulti") || 1) - (TimeAcceleration.spaBuffToAllies || -0.10)); // Revert
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace, attribute equivalents.
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "TimeAccelerationBuffSourceIdTA";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //         // unitToCheck.setAttribute("TimeAccelerationBuffActiveTA", false);
            //         // unitToCheck.removeAttribute(buffIdAttribute);
            //         // unitToCheck.setAttribute("PermanentAttackSpeedMulti", (unitToCheck.getAttribute("PermanentAttackSpeedMulti") || 1) - (TimeAcceleration.spaBuffToAllies || -0.10)); // Revert
            //     }
            // }
        },
    },
};
