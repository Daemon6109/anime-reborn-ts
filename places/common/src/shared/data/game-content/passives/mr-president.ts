import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const MrPresident: PassiveData = {
    name: "Mr. President",
    description: "After defeating 23 enemies, Smiling Valentine’s next attack envelops him and allied units within range in a barrier for 15 seconds. This barrier makes them immune to negative effects.",
    // tagName: "MrPresident", // Tag for units affected by the barrier
    // killsNeeded: 23,
    // barrierDuration: 15, // seconds
    callbacks: {
        onKill: (unit: Unit) => { // unit is Smiling Valentine
            // TODO: Implement attribute getting/setting
            // let currentKills = unit.getAttribute(`${MrPresident.tagName}Kills`) || 0;
            // if (currentKills < MrPresident.killsNeeded) {
            //     currentKills++;
            //     unit.setAttribute(`${MrPresident.tagName}Kills`, currentKills);
            // }
        },
        onAttack: (unit: Unit) => { // unit is Smiling Valentine, this is the attack that procs the barrier
            // TODO: Implement attribute getting/setting, _G.UnitHandler.GetAllyUnitsInRange, task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // let currentKills = unit.getAttribute(`${MrPresident.tagName}Kills`) || 0;

            // if (currentKills >= MrPresident.killsNeeded) {
            //     unit.setAttribute(`${MrPresident.tagName}Kills`, 0); // Reset kills

            //     const unitsToBarrier: Unit[] = [unit];
            //     // const alliesInRange = _G.UnitHandler.GetAllyUnitsInRange(unit); // Placeholder
            //     // unitsToBarrier.push(...alliesInRange);

            //     for (const targetUnit of unitsToBarrier) {
            //         // targetUnit.removeTag("Stunned"); // Clear existing stun
            //         // targetUnit.addTag("NonTarget");   // General immunity tag
            //         // targetUnit.addTag("NoStun");      // Specific stun immunity
            //         // targetUnit.addTag(MrPresident.tagName); // Mark as having the barrier
            //     }

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     // task.delay(MrPresident.barrierDuration / gameSpeed, () => { // Placeholder for async delay
            //     //     for (const targetUnit of unitsToBarrier) {
            //     //         // Check if unit still exists and has the barrier tag before removing
            //     //         if (targetUnit && targetUnit.getInstance() && targetUnit.getInstance().Parent && targetUnit.hasTag(MrPresident.tagName)) {
            //     //             targetUnit.removeTag("NonTarget");
            //     //             targetUnit.removeTag("NoStun");
            //     //             targetUnit.removeTag(MrPresident.tagName);
            //     //         }
            //     //     }
            //     // });
            // }
        },
    },
};
