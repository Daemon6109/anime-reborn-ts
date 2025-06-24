import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const DeathBeam: PassiveData = {
    name: "Death Beam",
    description: "Attacks inflict `Dark Flames` and for each enemy inflicted with `Dark Flames` in his range he gains 0.2% dot dmg increase up to 15%, at max stacks ground units in his range gain 5% dmg.",
    callbacks: {
        onAttack: (unit: Unit, dataPack: any) => {
            // TODO: Implement _G.serverServices.UnitHandler, status effect checking (enemy.StatusEffects["Dark Flames"]), attribute getting/setting.
            // TODO: unit.configuration.AttackEffectDamageMultiplier.Value modification needs a new approach.
            // const npcCache = _G.serverServices.UnitHandler.GetEnemiesInRangeUnsorted(unit); // Placeholder
            // const effectedUnits = [];
            // for (const v of Object.values(npcCache as any[])) { // Assuming npcCache is an array or map
            //     const enemyUnit = v.npc as any; // Define type for enemyUnit
            //     if (enemyUnit.StatusEffects && enemyUnit.StatusEffects["Dark Flames"]) {
            //         effectedUnits.push(enemyUnit);
            //     }
            // }
            // let stacks = unit.getAttribute("DotStacks") || 0;
            // const maxDotDmgIncrease = 0.15; // 15%
            // const increasePerStackGroup = 0.002; // 0.2%
            // const currentDotDmgIncrease = (unit.getAttribute("CurrentDotDmgIncrease") || 0);
            // if (currentDotDmgIncrease < maxDotDmgIncrease) {
            //     const potentialIncrease = effectedUnits.length * increasePerStackGroup;
            //     const actualIncrease = Math.min(potentialIncrease, maxDotDmgIncrease - currentDotDmgIncrease);
            //     unit.setAttribute("CurrentDotDmgIncrease", currentDotDmgIncrease + actualIncrease);
            //     // The line `Unit.configuration.AttackEffectDamageMultiplier.Value += .002` is tricky.
            //     // This implies direct modification of a config value at runtime for *this specific unit instance*.
            //     // This needs a robust way to handle instance-specific modifications or a different system for DOT damage scaling.
            //     // For now, let's assume there's an attribute like "InstanceAttackEffectDamageMultiplier"
            //     // unit.setAttribute("InstanceAttackEffectDamageMultiplier", (unit.getAttribute("InstanceAttackEffectDamageMultiplier") || initialMultiplier) + actualIncrease);
            // }
            // // The original code uses `Stacks < 76` and `Stacks >= 75` with `DotStacks` attribute,
            // // which seems related to the 0.2% up to 15% (15 / 0.2 = 75 stacks).
            // // Let's use the total increase for MaxDoTStacks flag.
            // if ((unit.getAttribute("CurrentDotDmgIncrease") || 0) >= maxDotDmgIncrease) {
            //     unit.setAttribute("MaxDoTStacks", true);
            // }
        },
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, BuffLib, FastVector, workspace equivalents
            // const isMaxStacks = unit.getAttribute("MaxDoTStacks") || false;
            // if (!isMaxStacks) return;
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
            //     if (isInRange && !unitToCheck.getAttribute("FreDarknessBuff") && unitToCheck.configuration.PlacementType.Value === "Ground") {
            //         unitToCheck.setAttribute("FreDarknessId", unitIndividualID);
            //         unitToCheck.setAttribute("FreDarknessBuff", true);
            //         unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) + 0.05);
            //     } else if (!isInRange && unitToCheck.getAttribute("FreDarknessBuff") && unitToCheck.getAttribute("FreDarknessId") === unitIndividualID) {
            //         unitToCheck.setAttribute("FreDarknessBuff", false);
            //         unitToCheck.setAttribute("FreDarknessId", undefined);
            //         unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - 0.05);
            //     }
            // }
            // The "HighestCost" logic from Luau is unclear and seems incomplete, so it's omitted for now.
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement workspace and attribute equivalents
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit; // Type assertion
            //     if (unitToCheck.getAttribute("FreDarknessBuff") === true && unitToCheck.getAttribute("FreDarknessId") === unitIndividualID) {
            //         unitToCheck.setAttribute("FreDarknessBuff", false);
            //         unitToCheck.setAttribute("FreDarknessId", undefined);
            //         unitToCheck.setAttribute("PermanentDamageMulti", (unitToCheck.getAttribute("PermanentDamageMulti") || 1) - 0.05);
            //     }
            // }
        },
    },
};
