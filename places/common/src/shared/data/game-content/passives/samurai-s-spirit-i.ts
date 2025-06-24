import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SamuraiSSpiritI: PassiveData = {
    name: "Samurai's Spirit I",
    description: "Each friendly unit on his range gives him a +2% crit chance and crit damage, stacks up to 20%.",
    // maxUnitsToCount: 10, // 20% / 2% = 10 units
    // critChancePerUnit: 0.02,
    // critDamagePerUnit: 0.02,
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, attribute getting/setting.
            // if (unit.getAttribute("SamuraiSpiritIActiveUnits") === undefined) { // Luau uses "SamuraiSpiritStacks"
            //     unit.setAttribute("SamuraiSpiritIActiveUnits", 0);
            // }

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // let friendlyUnitsInRangeCount = 0;

            // for (const unitToCheckInstance of currentlyPlaced) {
            //     const unitToCheck = unitToCheckInstance as Unit;
            //     if (unitToCheck === unit || !unitToCheck.getInstance()?.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     if (FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, unitToCheck.getInstance().PrimaryPart.Position) <= unitRange) {
            //         friendlyUnitsInRangeCount++;
            //     }
            // }

            // const actualUnitsToCount = Math.min(friendlyUnitsInRangeCount, (SamuraiSSpiritI.maxUnitsToCount || 10));
            // const previousBuffedUnitsCount = unit.getAttribute("SamuraiSpiritIActiveUnits") || 0;
            // const differenceInCount = actualUnitsToCount - previousBuffedUnitsCount;

            // if (differenceInCount !== 0) {
            //     const critChanceChange = differenceInCount * (SamuraiSSpiritI.critChancePerUnit || 0.02);
            //     const critDamageChange = differenceInCount * (SamuraiSSpiritI.critDamagePerUnit || 0.02);

            //     unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + critChanceChange);
            //     unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + critDamageChange);
            //     unit.setAttribute("SamuraiSpiritIActiveUnits", actualUnitsToCount);
            // }
        },
    },
};
