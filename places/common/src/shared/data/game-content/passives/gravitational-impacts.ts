import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const GravitationalImpacts: PassiveData = {
    name: "Gravitational impacts",
    description: "Unit `Slows` enemies, Slowed enemies takes 15% more damage. Also, Buffs Dark Units by 10%.",
    // percentIncrease: 1.15, // For damage against slowed enemies
    // statusNeeded: "Slow",  // For conditional damage
    // darkUnitBuff: 0.10,    // For buffing dark units
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects[GravitationalImpacts.statusNeeded])
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[GravitationalImpacts.statusNeeded] === true) {
            //     return GravitationalImpacts.percentIncrease;
            // }
            return 1;
        },
        // The onUnitsInRange and onRemove logic in Luau seems to be copied from "Captain's Presence"
        // and buffs crit chance/damage, which doesn't match "Buffs Dark Units by 10%".
        // Assuming the description "Buffs Dark Units by 10%" is the correct intent for this part.
        onUnitsInRange: (unit: Unit) => { // unit is the one with Gravitational Impacts
            // TODO: Implement BuffLib, FastVector, workspace, attribute, and unit.configuration.Element.Value equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck === unit || !unitToCheck.getInstance().FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     const isDarkElement = unitToCheck.configuration.Element.Value === "Dark"; // Assuming element access
            //     const buffIdAttribute = "GravImpactsDarkBuffId";
            //     const buffFlagAttribute = "GravImpactsDarkBuffActive";

            //     if (isInRange && isDarkElement) {
            //         if (!unitToCheck.getAttribute(buffFlagAttribute)) {
            //             unitToCheck.setAttribute(buffIdAttribute, unitIndividualID);
            //             unitToCheck.setAttribute(buffFlagAttribute, true);
            //             unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + GravitationalImpacts.darkUnitBuff);
            //         }
            //     } else if (!isInRange && unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //         // Unit moved out of range, remove buff if this unit applied it
            //         unitToCheck.setAttribute(buffFlagAttribute, false);
            //         unitToCheck.setAttribute(buffIdAttribute, undefined);
            //         unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - GravitationalImpacts.darkUnitBuff);
            //     }
            // }
            // Note: The passive also "Slows enemies". This might be an aura effect (onServerTick) or on-hit.
            // If on-hit, it needs an onAttack/onAttackHit callback. If aura, onServerTick. Not specified in Luau callbacks for this part.
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace and attribute equivalents to remove buffs applied to Dark units
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // const buffIdAttribute = "GravImpactsDarkBuffId";
            // const buffFlagAttribute = "GravImpactsDarkBuffActive";

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck.getAttribute(buffIdAttribute) === unitIndividualID) {
            //         unitToCheck.setAttribute(buffFlagAttribute, false);
            //         unitToCheck.setAttribute(buffIdAttribute, undefined);
            //         unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - GravitationalImpacts.darkUnitBuff);
            //     }
            // }
        },
    },
};
