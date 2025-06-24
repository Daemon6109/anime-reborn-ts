import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FamilyInfluence: PassiveData = {
    name: "Family Influence",
    description: "Whenever Laughfy is placed in Mage’s range, he gains +25% Damage and +10% Range.",
    // Note: The Luau code logic seems to be: "If any 'Luffy' unit is in this (Mage's) range, this (Mage) unit gets buffed."
    // The description says: "Whenever Laughfy is placed in Mage’s range, he (Laughfy) gains..." - this is the opposite.
    // I will translate the Luau code's apparent logic. If the description is correct, the logic needs to be inverted.
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit here is the Mage with this passive
            // TODO: Implement BuffLib, FastVector, workspace, attribute, and string.match equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit); // Mage's range
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let luffyFoundInRange = false;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     if (isInRange) {
            //         // Check if unitToCheck is a "Luffy" variant
            //         if (unitToCheck.Name.includes("Luffy") || unitToCheck.Name === "Luffy [DR] [Evo]" || unitToCheck.Name === "Luffy [DR]") {
            //             luffyFoundInRange = true;
            //             break;
            //         }
            //     }
            // }

            // // Store original stats if not already stored, to handle buff reversion correctly
            // if (unit.getAttribute("OriginalDamageMultiFI") === undefined) { // FI for FamilyInfluence to avoid clashes
            //     unit.setAttribute("OriginalDamageMultiFI", unit.getAttribute("PermanentDamageMulti") || 1);
            // }
            // if (unit.getAttribute("OriginalAttackSpeedMultiFI") === undefined) { // Luau uses Speed, description uses Range. Assuming Range based on desc.
            //     unit.setAttribute("OriginalRangeMultiFI", unit.getAttribute("PermanentRangeMulti") || 1);
            // }

            // const isCurrentlyBuffed = unit.getAttribute("FamilyInfluenceBuffActive");

            // if (luffyFoundInRange && !isCurrentlyBuffed) {
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("OriginalDamageMultiFI") || 1) + 0.25);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("OriginalRangeMultiFI") || 1) + 0.10); // Using Range from desc
            //     unit.setAttribute("FamilyInfluenceBuffActive", true);
            // } else if (!luffyFoundInRange && isCurrentlyBuffed) {
            //     unit.setAttribute("PermanentDamageMulti", unit.getAttribute("OriginalDamageMultiFI") || 1);
            //     unit.setAttribute("PermanentRangeMulti", unit.getAttribute("OriginalRangeMultiFI") || 1);
            //     unit.setAttribute("FamilyInfluenceBuffActive", false);
            // }
        },
        onRemove: (unit: Unit) => { // unit is the Mage being removed
            // TODO: Implement attribute getting/setting
            // If the Mage is removed, its buff should be considered gone.
            // The Luau onRemove re-runs the onUnitsInRange logic, which is a bit odd.
            // A simpler onRemove would be to ensure its own stats are reset if it was buffed.
            // if (unit.getAttribute("FamilyInfluenceBuffActive")) {
            //     unit.setAttribute("PermanentDamageMulti", unit.getAttribute("OriginalDamageMultiFI") || 1);
            //     unit.setAttribute("PermanentRangeMulti", unit.getAttribute("OriginalRangeMultiFI") || 1);
            //     unit.setAttribute("FamilyInfluenceBuffActive", false);
            // }
        },
    },
};
