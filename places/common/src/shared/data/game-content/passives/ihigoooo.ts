import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Ihigoooo: PassiveData = {
    name: "Ihigoooo!", // Luau name "Ihigoooo!" (Ichigo)
    description: "If placed near an Ihigo, Will have stun immunity for the next 20s",
    callbacks: {
        onPlace: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, string.match, task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit); // Range of THIS unit to check for an Ichigo
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let ichigoFoundInRange = false;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     if (isInRange && unitToCheck.Name.includes("Ichigo")) { // Assuming unit.Name is accessible
            //         ichigoFoundInRange = true;
            //         break;
            //     }
            // }

            // if (ichigoFoundInRange) {
            //     unit.addTag("InnateNonTarget"); // Provides general immunity
            //     unit.addTag("InnateNoStun");   // Explicit stun immunity
            //     // warn("Great stuff, has immunity"); // Luau log

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     // task.delay(20 / gameSpeed, () => { // Placeholder for async delay
            //     //     // warn("no mooo"); // Luau log
            //     //     // Check if unit still exists before removing tags
            //     //     if (unit && unit.getInstance() && unit.getInstance().Parent) {
            //     //         unit.removeTag("InnateNonTarget");
            //     //         unit.removeTag("InnateNoStun");
            //     //     }
            //     // });
            // }
        },
    },
};
