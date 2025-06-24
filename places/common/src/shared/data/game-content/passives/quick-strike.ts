import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const QuickStrike: PassiveData = {
    name: "Quick Strike",
    description: "This unit deals double damage to the closest enemy",
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, _G.Constructs, attribute setting.
            // This logic should run *before* onConditionalDamage for the same attack.
            // It identifies the closest enemy to be targeted for the damage bonus.
            // unit.setAttribute("ClosestEnemyIDQS", undefined);

            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit); // This passive doesn't mention range limit, but Luau uses it.

            // let closestDistance = Number.POSITIVE_INFINITY;
            // let closestEnemyId: string | undefined = undefined;

            // // for (const enemyId in _G.Constructs) { // Placeholder for iterating global enemies
            // //     const enemyConstruct = _G.Constructs[enemyId];
            // //     if (enemyConstruct && enemyConstruct.Position && unit.getInstance()?.PrimaryPart) {
            // //         const distance = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, enemyConstruct.Position);
            // //         // Luau checks if IsInRange first, then if distance < current closest.
            // //         // Description doesn't state it has to be in attack range, just "closest enemy".
            // //         // For now, assuming any enemy on map can be "closest".
            // //         if (distance < closestDistance) {
            // //             closestDistance = distance;
            // //             closestEnemyId = enemyId;
            // //         }
            // //     }
            // // }

            // if (closestEnemyId) {
            //     unit.setAttribute("ClosestEnemyIDQS", closestEnemyId);
            // }
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting, enemy.EnemyID access
            // if (enemy && enemy.EnemyID && enemy.EnemyID === unit.getAttribute("ClosestEnemyIDQS")) {
            //     return 2; // Double damage
            // }
            return 1;
        },
    },
};
