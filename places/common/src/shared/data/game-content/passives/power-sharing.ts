import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PowerSharing: PassiveData = {
    name: "Power Link", // Luau name: "Power Link"
    description: "This unit links with the 2 strongest units in range, getting +5% of their damages",
    // damageSharePercent: 0.05,
    // numberOfUnitsToLink: 2,
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with Power Link
            // TODO: Implement BuffLib, FastVector, workspace, attribute, unit.configuration.Damage.Value access and modification.
            // This passive directly modifies the unit's own Damage configuration value based on other units.
            // This is highly problematic for a static data system and needs careful redesign.
            // The damage should ideally be calculated dynamically or through temporary buffs.

            // // Revert previous buffs from this passive before recalculating
            // const extraDmg1 = unit.getAttribute("ExtraDamage1PS") || 0; // PS for PowerSharing
            // const extraDmg2 = unit.getAttribute("ExtraDamage2PS") || 0;
            // let baseDamage = unit.getAttribute("BaseDamageForPowerSharing"); // Store base damage if not already
            // if (baseDamage === undefined) {
            //     // baseDamage = unit.getConfiguration().Damage.Value; // Assuming how to get current damage
            //     // unit.setAttribute("BaseDamageForPowerSharing", baseDamage);
            // } else {
            //    // unit.getConfiguration().Damage.Value = baseDamage; // Reset to base before applying new buffs
            // }
            // unit.setAttribute("ExtraDamage1PS", 0);
            // unit.setAttribute("ExtraDamage2PS", 0);


            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const potentialLinkDamages: number[] = [];

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck !== unit && unitToCheck.getInstance()?.FindFirstChild("configuration") && unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) {
            //         const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //         if (isInRange) {
            //             // const targetDamage = unitToCheck.getConfiguration().Damage.Value; // Accessing other unit's config
            //             // potentialLinkDamages.push(targetDamage * (PowerSharing.damageSharePercent || 0.05) );
            //         }
            //     }
            // }

            // potentialLinkDamages.sort((a, b) => b - a); // Sort descending to get strongest

            // let totalDamageAddedThisTick = 0;
            // for (let i = 0; i < (PowerSharing.numberOfUnitsToLink || 2) && i < potentialLinkDamages.length; i++) {
            //     const damageToAdd = potentialLinkDamages[i];
            //     if (damageToAdd > 0) {
            //         totalDamageAddedThisTick += damageToAdd;
            //         unit.setAttribute(`ExtraDamage${i + 1}PS`, damageToAdd);
            //     }
            // }
            // // unit.getConfiguration().Damage.Value += totalDamageAddedThisTick; // Direct config modification
        },
    },
};
