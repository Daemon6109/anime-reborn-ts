import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CaptainsPresence: PassiveData = {
    name: "Captain's Presence",
    description: "Allies in range get +15% CRIT RATE and +15% CRIT DMG (non-stackable)",
    // percentIncrease: 0.15, // Configuration specific to this passive
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, and attribute equivalents
            // const BuffLib = require(replicated.Libs.BuffLib);
            // const FastVector = require(replicated.Libs.FastVector).new();
            // const unitIndividualID = unit.getAttribute("IUUID");
            // for (const unitToCheck of workspace.UnitsPlaced.GetChildren()) {
            //     if (unitToCheck === unit || !unitToCheck.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const unitRange = BuffLib.GetRangeScaled(unit); // Should this be unitToCheck range?
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.HumanoidRootPart.Position, unitToCheck.HumanoidRootPart.Position) <= unitRange;
            //     const hasBuff = unitToCheck.getAttribute("CaptainPresenceBuff");
            //     // Check if the unit already has this specific buff from another source via CaptainPresenceId
            //     if (!hasBuff && isInRange && unitToCheck.getAttribute("CaptainPresenceId") === undefined) {
            //         unitToCheck.setAttribute("CaptainPresenceId", unitIndividualID);
            //         unitToCheck.setAttribute("CaptainPresenceBuff", true); // Using true/false for buff status
            //         unitToCheck.setAttribute("PermanentAttackCriticalDamage", (unitToCheck.getAttribute("PermanentAttackCriticalDamage") || 0) + CaptainsPresence.percentIncrease);
            //         unitToCheck.setAttribute("PermanentAttackCriticalChance", (unitToCheck.getAttribute("PermanentAttackCriticalChance") || 0) + CaptainsPresence.percentIncrease);
            //     } else if (hasBuff && !isInRange && unitToCheck.getAttribute("CaptainPresenceId") === unitIndividualID) {
            //         // Unit moved out of range, remove buff if this unit applied it
            //         unitToCheck.setAttribute("CaptainPresenceBuff", false);
            //         unitToCheck.setAttribute("CaptainPresenceId", undefined);
            //         unitToCheck.setAttribute("PermanentAttackCriticalDamage", (unitToCheck.getAttribute("PermanentAttackCriticalDamage") || 0) - CaptainsPresence.percentIncrease);
            //         unitToCheck.setAttribute("PermanentAttackCriticalChance", (unitToCheck.getAttribute("PermanentAttackCriticalChance") || 0) - CaptainsPresence.percentIncrease);
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // for (const unitToCheck of workspace.UnitsPlaced.GetChildren()) {
            //     if (unitToCheck === unit || !unitToCheck.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     // If this unit was the source of the buff, remove it
            //     if (unitToCheck.getAttribute("CaptainPresenceBuff") === true && unitToCheck.getAttribute("CaptainPresenceId") === unitIndividualID) {
            //         unitToCheck.setAttribute("CaptainPresenceBuff", false);
            //         unitToCheck.setAttribute("CaptainPresenceId", undefined);
            //         unitToCheck.setAttribute("PermanentAttackCriticalDamage", (unitToCheck.getAttribute("PermanentAttackCriticalDamage") || 0) - CaptainsPresence.percentIncrease);
            //         unitToCheck.setAttribute("PermanentAttackCriticalChance", (unitToCheck.getAttribute("PermanentAttackCriticalChance") || 0) - CaptainsPresence.percentIncrease);
            //     }
            // }
        },
    },
};
