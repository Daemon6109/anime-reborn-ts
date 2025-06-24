import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const RecklessCourage: PassiveData = {
    name: "Reckless Courage",
    description: "If no allies in range, Unit can not be stunned.",
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, tag manipulation
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let alliesFoundInRange = false;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     if (isInRange) {
            //         alliesFoundInRange = true;
            //         break;
            //     }
            // }

            // // Description: "If NO allies in range, Unit can not be stunned."
            // // Luau: if #BuffedUnits >= 1 then AddTag else RemoveTag. (If allies ARE in range, unit IS immune.) - This is opposite.
            // // Assuming description is the correct logic.
            // if (!alliesFoundInRange) {
            //     if (!unit.hasTag("InnateNoStun")) {
            //         unit.addTag("InnateNoStun");
            //     }
            // } else {
            //     if (unit.hasTag("InnateNoStun")) {
            //         unit.removeTag("InnateNoStun");
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Ensure tag is removed if unit is removed.
            // if (unit.hasTag("InnateNoStun")) {
            //     unit.removeTag("InnateNoStun");
            // }
        },
    },
};
