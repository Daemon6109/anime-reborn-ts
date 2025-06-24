import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const TheQueen: PassiveData = {
    name: "The Queen",
    description: "Each other unit attack that is in range of the unit inscreases unit damage by 2% (80% max)",
    // damageIncreasePerAllyAttack: 0.02,
    // maxDamageIncreaseStacks: 40, // 80% / 2% = 40 stacks
    callbacks: {
        onAllyAttack: (unit: Unit, attackingAlly: Unit) => { // unit is The Queen
            // TODO: Implement BuffLib, FastVector, attribute getting/setting.
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);

            // if (attackingAlly && attackingAlly.getInstance()?.PrimaryPart && unit.getInstance()?.PrimaryPart) {
            //     const distance = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, attackingAlly.getInstance().PrimaryPart.Position);
            //     if (distance <= unitRange) { // Check if the attacking ally is in The Queen's range
            //         let currentStacks = unit.getAttribute("TheQueenDamageStacks") || 0; // Luau uses "HeirStacks"
            //         const maxStacks = TheQueen.maxDamageIncreaseStacks || 40;

            //         if (currentStacks < maxStacks) {
            //             currentStacks++; // Luau adds 2 to HeirStacks, but description implies 2% per ATTACK, not 2 stacks.
            //                             // Assuming 1 stack per qualifying ally attack.
            //             unit.setAttribute("TheQueenDamageStacks", currentStacks);
            //             unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (TheQueen.damageIncreasePerAllyAttack || 0.02));
            //         }
            //     }
            // }
        },
    },
};
