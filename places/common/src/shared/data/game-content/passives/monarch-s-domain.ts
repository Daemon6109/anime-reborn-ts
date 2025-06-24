import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const MonarchsDomain: PassiveData = {
    name: "Monarch's Domain",
    description: "Whenever ally shadows are within Solo's range - Solo gains +10% DMG (non-stackable), While ally shadow units Gain -10% SPA",
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is Solo
            // TODO: Implement BuffLib, FastVector, workspace, attribute, string.match, table.find equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const shadowUnitsInRange: Unit[] = [];
            // const buffableShadowNames = [ // From Luau
            //     "Beru [Evo]", "Beru [Evo2]",
            //     "Iron [Evo]", "Iron [Evo2]",
            //     "Kargalgan [Evo]", "Kargalgan [Evo2]"
            // ];

            // // First, revert buffs from units that are no longer valid shadows or out of range
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute("MonarchsDomainAllyBuffSourceId") === unitIndividualID) {
            //         const isStillInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //         const isStillShadow = unitToCheck.Name.includes("Igris") || buffableShadowNames.includes(unitToCheck.Name);
            //         if (!isStillInRange || !isStillShadow) {
            //             // unitToCheck.setAttribute("PermanentAttackSpeedMulti", unitToCheck.getAttribute("OriginalAttackSpeedMultiMonarch") || 1);
            //             // unitToCheck.removeAttribute("MonarchsDomainAllyBuffSourceId");
            //             // unitToCheck.removeAttribute("OriginalAttackSpeedMultiMonarch");
            //         }
            //     }
            // }

            // // Find current shadows in range
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) continue;

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     if (isInRange && (unitToCheck.Name.includes("Igris") || buffableShadowNames.includes(unitToCheck.Name))) {
            //         shadowUnitsInRange.push(unitToCheck);
            //     }
            // }

            // const soloAlreadyBuffed = unit.getAttribute("MonarchsDomainSoloBuffActive");

            // if (shadowUnitsInRange.length > 0) {
            //     if (!soloAlreadyBuffed) {
            //         unit.setAttribute("MonarchsDomainSoloBuffActive", true);
            //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + 0.10);
            //     }
            //     for (const shadowUnit of shadowUnitsInRange) {
            //         if (shadowUnit.getAttribute("MonarchsDomainAllyBuffSourceId") !== unitIndividualID) { // Only buff if not already buffed by this Solo
            //             // shadowUnit.setAttribute("OriginalAttackSpeedMultiMonarch", shadowUnit.getAttribute("PermanentAttackSpeedMulti") || 1);
            //             // shadowUnit.setAttribute("PermanentAttackSpeedMulti", (shadowUnit.getAttribute("PermanentAttackSpeedMulti") || 1) - 0.10); // -10% SPA
            //             // shadowUnit.setAttribute("MonarchsDomainAllyBuffSourceId", unitIndividualID);
            //         }
            //     }
            // } else { // No shadows in range
            //     if (soloAlreadyBuffed) {
            //         unit.setAttribute("MonarchsDomainSoloBuffActive", false);
            //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - 0.10);
            //     }
            // }
            // // Note: Luau uses "WarriorsResolveBuff" attributes. Using more specific names here.
        },
        onRemove: (unit: Unit) => { // Solo is removed
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute("MonarchsDomainAllyBuffSourceId") === unitIndividualID) {
            //         // unitToCheck.setAttribute("PermanentAttackSpeedMulti", unitToCheck.getAttribute("OriginalAttackSpeedMultiMonarch") || 1);
            //         // unitToCheck.removeAttribute("MonarchsDomainAllyBuffSourceId");
            //         // unitToCheck.removeAttribute("OriginalAttackSpeedMultiMonarch");
            //     }
            // }
        },
    },
};
