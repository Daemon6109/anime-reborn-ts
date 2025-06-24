import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ShadowClone: PassiveData = {
    name: "Shadow Clone",
    description: "For each Noroto in range, unit gains +3% more attack damage.",
    // percentIncreasePerNoroto: 0.03,
    // targetUnitName: "Noroto", // Implied by description, Luau uses `Unit.Name == UnitToCheck.Name`
    callbacks: {
        onUnitsInRange: async (unit: Unit) => { // unit is the one with this passive
            // TODO: Implement BuffLib, FastVector, workspace, attribute, unit.waitForChild, unit.Name access
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (!config) return;

            // const previousBuffAmount = unit.getAttribute("ShadowCloneBuffIncrease") || 0;
            // if (previousBuffAmount > 0) {
            //     // Revert previous buff before recalculating
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - previousBuffAmount);
            //     unit.setAttribute("ShadowCloneBuffIncrease", 0);
            // }

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let norotoCountInRange = 0;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     // Luau: if Unit:GetAttribute("IUUID") == UnitToCheck:GetAttribute("IUUID") then continue end
            //     // Luau: if IsInRange and Unit.Name == UnitToCheck.Name then
            //     // This means it counts other units with the *same name* as this unit (e.g. other Norotos if this is on Noroto)
            //     if (unit.getInstance().Name === unitToCheck.getInstance().Name && unit !== unitToCheck) {
            //         const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //         if (isInRange) {
            //             norotoCountInRange++;
            //         }
            //     }
            // }

            // if (norotoCountInRange > 0) {
            //     const totalBuffToAdd = norotoCountInRange * (ShadowClone.percentIncreasePerNoroto || 0.03);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + totalBuffToAdd);
            //     unit.setAttribute("ShadowCloneBuffIncrease", totalBuffToAdd);
            // }
        },
        // onRemove could revert the buff if "ShadowCloneBuffIncrease" is > 0.
    },
};
