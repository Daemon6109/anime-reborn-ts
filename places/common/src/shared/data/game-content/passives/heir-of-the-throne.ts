import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const HeirOfTheThrone: PassiveData = {
    name: "Heir of the Throne",
    description: "When placed, units in her range are considered her `Rook Pieces`, whenever a rook attacks, Rise's Damage is increased by 1% (Upto 50%)",
    // tagName: "RiasRook", // Tag for units considered Rook Pieces
    // maxPassiveStacks: 50,  // Max damage stacks for Rise (50 * 1% = 50%)
    // percentPerStack: 0.01, // Damage increase per rook attack
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is Rise (passive holder)
            // TODO: Implement _G.UnitHandler.GetAllyUnitsInRange, attribute, and tag equivalents
            // const alliesInRange = _G.UnitHandler.GetAllyUnitsInRange(unit); // Placeholder
            // const unitId = unit.getAttribute("IUUID");

            // for (const ally of alliesInRange) {
            //     if (!ally.hasTag(HeirOfTheThrone.tagName)) {
            //         // Mark ally as a rook piece for this specific Rise unit
            //         ally.setAttribute(`${HeirOfTheThrone.tagName}Id`, unitId);
            //         ally.addTag(HeirOfTheThrone.tagName);
            //     }
            // }
            // // Also need to handle units moving out of range or Rooks being removed
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const placedUnit of currentlyPlaced) {
            //     if (placedUnit.hasTag(HeirOfTheThrone.tagName) && placedUnit.getAttribute(`${HeirOfTheThrone.tagName}Id`) === unitId) {
            //         const distance = /* calculate distance between unit and placedUnit */;
            //         const unitRange = /* get unit's range */;
            //         if (distance > unitRange || !placedUnit.Parent) { // Out of range or removed
            //             placedUnit.removeAttribute(`${HeirOfTheThrone.tagName}Id`);
            //             placedUnit.removeTag(HeirOfTheThrone.tagName);
            //         }
            //     }
            // }
        },
        onRemove: (unit: Unit) => { // Rise is removed
            // TODO: Implement workspace, attribute, and tag equivalents
            // const unitId = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const ally of currentlyPlaced) {
            //     if (ally.hasTag(HeirOfTheThrone.tagName) && ally.getAttribute(`${HeirOfTheThrone.tagName}Id`) === unitId) {
            //         ally.removeAttribute(`${HeirOfTheThrone.tagName}Id`);
            //         ally.removeTag(HeirOfTheThrone.tagName);
            //     }
            // }
        },
        onAllyAttack: (unit: Unit, attackingAlly: Unit) => { // unit is Rise, attackingAlly is the one that attacked
            // TODO: Implement attribute and tag equivalents
            // if (attackingAlly.hasTag(HeirOfTheThrone.tagName) && attackingAlly.getAttribute(`${HeirOfTheThrone.tagName}Id`) === unit.getAttribute("IUUID")) {
            //     let currentStacks = unit.getAttribute(`${HeirOfTheThrone.tagName}Stacks`) || 0;
            //     if (currentStacks < HeirOfTheThrone.maxPassiveStacks) {
            //         currentStacks++;
            //         unit.setAttribute(`${HeirOfTheThrone.tagName}Stacks`, currentStacks);
            //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + HeirOfTheThrone.percentPerStack);
            //     }
            // }
        },
    },
};
