import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SolarInferno: PassiveData = {
    name: "Solar Inferno",
    description: "All allies in range get increased DoT dmg by 30% and for each fire element unit in range gain 15% increased DoT dmg up to 75%.",
    // targetElement: "Fire",
    // baseDotDamageIncreaseAllies: 0.30,
    // selfDotDamageIncreasePerFireAlly: 0.15,
    // maxSelfDotDamageIncrease: 0.75, // 75% / 15% = 5 fire allies for max self-buff
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with Solar Inferno
            // TODO: Implement BuffLib, FastVector, workspace, attribute, unit.configuration.Element.Value access,
            // TODO: and unit.configuration.AttackEffectDamageMultiplier.Value modification (this is problematic).
            // Modifying AttackEffectDamageMultiplier directly is tricky. A better system would be for DoTs to query
            // for applicable multipliers from passives on the source unit or affected target.

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder

            // const allyBuffId = "SolarInfernoAllyBuffId";
            // const selfBuffCurrentFireAlliesCountAttr = "SolarInfernoSelfBuffFireAllies";
            // const selfBuffCurrentDotMultiplierAttr = "SolarInfernoSelfDotMultiplier"; // Stores the current DoT multiplier for self

            // // --- Manage buffs for other allies in range ---
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) continue;

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     const isBuffedByThis = unitToCheck.getAttribute(allyBuffId) === unitIndividualID;

            //     if (isInRange) {
            //         if (!isBuffedByThis) { // Apply buff if not already buffed by this Solar Inferno
            //             // unitToCheck.setAttribute(allyBuffId, unitIndividualID);
            //             // // How to apply "+30% DoT damage"? This needs a system.
            //             // // unitToCheck.setAttribute("DotDamageMultiplierBonus", (unitToCheck.getAttribute("DotDamageMultiplierBonus") || 0) + SolarInferno.baseDotDamageIncreaseAllies);
            //             // Luau: unitToCheck.configuration.AttackEffectDamageMultiplier.Value += 0.3
            //             // This needs to be refactored to not directly modify config.
            //         }
            //     } else { // Out of range
            //         if (isBuffedByThis) {
            //             // unitToCheck.removeAttribute(allyBuffId);
            //             // // Revert buff
            //             // // unitToCheck.setAttribute("DotDamageMultiplierBonus", (unitToCheck.getAttribute("DotDamageMultiplierBonus") || 0) - SolarInferno.baseDotDamageIncreaseAllies);
            //             // Luau: unitToCheck.configuration.AttackEffectDamageMultiplier.Value -= 0.3
            //         }
            //     }
            // }

            // // --- Manage self-buff based on Fire allies in range ---
            // let fireAlliesInRangeCount = 0;
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) continue;
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     if (isInRange && unitToCheck.configuration.Element.Value === SolarInferno.targetElement) {
            //         fireAlliesInRangeCount++;
            //     }
            // }

            // const lastTrackedFireAllies = unit.getAttribute(selfBuffCurrentFireAlliesCountAttr) || 0;
            // const newSelfDotBonusPercent = Math.min(fireAlliesInRangeCount * (SolarInferno.selfDotDamageIncreasePerFireAlly || 0.15), (SolarInferno.maxSelfDotDamageIncrease || 0.75));
            // const oldSelfDotBonusPercentFromLuauLogic = (unit.getAttribute("YBuffIncrease") || 0) / 100; // Luau stores this as 0-75

            // // Luau logic for YBuffIncrease / VYBuffIncrease and modifying AttackEffectDamageMultiplier is complex.
            // // It seems to adjust the multiplier based on the *change* in the number of fire allies.
            // // A simpler approach: calculate the target self-buff based on current fire allies, then apply the difference.
            // const currentSelfDotMultiplierBonus = unit.getAttribute(selfBuffCurrentDotMultiplierAttr) || 0;
            // const diffToApply = newSelfDotBonusPercent - currentSelfDotMultiplierBonus;

            // if (diffToApply !== 0) {
            //     // unit.setAttribute("DotDamageMultiplierBonus", (unit.getAttribute("DotDamageMultiplierBonus") || 0) + diffToApply); // For self
            //     // unit.setAttribute(selfBuffCurrentDotMultiplierAttr, newSelfDotBonusPercent);
            //     // Luau: Unit.configuration.AttackEffectDamageMultiplier.Value += Amount/100
            // }
            // // unit.setAttribute(selfBuffCurrentFireAlliesCountAttr, fireAlliesInRangeCount); // Store for next tick comparison
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement removal of buffs from allies and self.
            // const unitIndividualID = unit.getAttribute("IUUID");
            // // ... iterate and remove buffs from allies ...
            // // ... revert self-buff ...
        },
    },
};
