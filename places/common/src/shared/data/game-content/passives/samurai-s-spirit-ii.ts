import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SamuraiSSpiritII: PassiveData = {
    name: "Samurai's Spirit II",
    description: "Each friendly unit on his range gives him a +4% crit chance and crit damage, stacks up to 40%.",
    // maxUnitsToCount: 10, // 40% / 4% = 10 units
    // critChancePerUnit: 0.04,
    // critDamagePerUnit: 0.04,
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, attribute getting/setting.
            // if (unit.getAttribute("SamuraiSpiritIIActiveUnits") === undefined) { // Luau uses "SamuraiSpiritStacks"
            //     unit.setAttribute("SamuraiSpiritIIActiveUnits", 0);
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

            // const actualUnitsToCount = Math.min(friendlyUnitsInRangeCount, (SamuraiSSpiritII.maxUnitsToCount || 10));
            // const previousBuffedUnitsCount = unit.getAttribute("SamuraiSpiritIIActiveUnits") || 0;
            // const differenceInCount = actualUnitsToCount - previousBuffedUnitsCount;

            // if (differenceInCount !== 0) {
            //     const critChanceChange = differenceInCount * (SamuraiSSpiritII.critChancePerUnit || 0.04);
            //     const critDamageChange = differenceInCount * (SamuraiSSpiritII.critDamagePerUnit || 0.04);

            //     unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + critChanceChange);
            //     unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + critDamageChange);
            //     unit.setAttribute("SamuraiSpiritIIActiveUnits", actualUnitsToCount);
            // }
        },
    },
};
