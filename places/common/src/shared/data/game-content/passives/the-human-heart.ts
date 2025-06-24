import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const TheHumanHeart: PassiveData = {
    name: "The Human Heart",
    description: "Light units in his range gain 15% dmg and 10% critical chance and for each light unit in his range he gains 4% dmg up to 16% and 12% critical chance.",
    // targetElement: "Light",
    // allyBuff: { damage: 0.15, critChance: 0.10 },
    // selfBuffPerLightAlly: { damage: 0.04, critChance: 0.03 }, // For self
    // maxSelfBuffStacks: 4, // 16% damage / 4% = 4 units; 12% crit / 3% = 4 units
    callbacks: {
        onUnitsInRange: (unit: Unit) => { // unit is the one with The Human Heart
            // TODO: Implement BuffLib, FastVector, workspace, attribute, unit.configuration.Element.Value
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder

            // const allyBuffIdAttr = "HumanHeartAllyBuffId"; // Specific to this passive
            // const allyBuffActiveAttr = "HumanHeartAllyBuffActive";
            // const selfBuffCurrentLightAlliesAttr = "HumanHeartSelfBuffLightAlliesCount";

            // // --- Manage buffs for other Light allies in range ---
            // // First, clear buffs from units no longer eligible or buffed by this instance
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck.getAttribute(allyBuffIdAttr) === unitIndividualID) {
            //         const isStillInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //         const isStillLight = unitToCheck.configuration.Element.Value === (TheHumanHeart.targetElement || "Light");
            //         if (!isStillInRange || !isStillLight) {
            //             // unitToCheck.removeAttribute(allyBuffIdAttr);
            //             // unitToCheck.removeAttribute(allyBuffActiveAttr);
            //             // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - (TheHumanHeart.allyBuff?.damage || 0.15));
            //             // unitToCheck.setAttribute("PermanentAttackCriticalChance", (unitToCheck.getAttribute("PermanentAttackCriticalChance") || 0) - (TheHumanHeart.allyBuff?.critChance || 0.10));
            //         }
            //     }
            // }

            // let lightAlliesInRangeCount = 0;
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) continue;

            //     const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange;
            //     if (isInRange && unitToCheck.configuration.Element.Value === (TheHumanHeart.targetElement || "Light")) {
            //         lightAlliesInRangeCount++;
            //         if (!unitToCheck.getAttribute(allyBuffActiveAttr)) { // Non-stackable part for allies
            //             // unitToCheck.setAttribute(allyBuffIdAttr, unitIndividualID);
            //             // unitToCheck.setAttribute(allyBuffActiveAttr, true);
            //             // unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + (TheHumanHeart.allyBuff?.damage || 0.15));
            //             // unitToCheck.setAttribute("PermanentAttackCriticalChance", (unitToCheck.getAttribute("PermanentAttackCriticalChance") || 0) + (TheHumanHeart.allyBuff?.critChance || 0.10));
            //         }
            //     }
            // }

            // // --- Manage self-buff based on Light allies in range ---
            // const prevSelfBuffCount = unit.getAttribute(selfBuffCurrentLightAlliesAttr) || 0;
            // const actualSelfBuffCount = Math.min(lightAlliesInRangeCount, (TheHumanHeart.maxSelfBuffStacks || 4));
            // const diffInSelfBuffCount = actualSelfBuffCount - prevSelfBuffCount;

            // if (diffInSelfBuffCount !== 0) {
            //     // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (diffInSelfBuffCount * (TheHumanHeart.selfBuffPerLightAlly?.damage || 0.04)));
            //     // unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + (diffInSelfBuffCount * (TheHumanHeart.selfBuffPerLightAlly?.critChance || 0.03)));
            //     // unit.setAttribute(selfBuffCurrentLightAlliesAttr, actualSelfBuffCount);
            // }
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement cleanup of buffs applied to other units and self.
        },
    },
};
