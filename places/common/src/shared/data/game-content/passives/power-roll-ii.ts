import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PowerRollII: PassiveData = {
    name: "Power Roll II",
    description: "Aira randomly selects one of the following buff pool every 60s (+20% dmg to speed enemies, +20% dmg to flying enemies, +20% dmg to shade enemies)",
    // buffInterval: 60, // seconds
    // damageBonus: 0.20, // Increased damage bonus for version II
    callbacks: {
        onPlace: (unit: Unit) => {
            // TODO: Implement task.spawn, task.wait, unit.configuration.CurrentUpgrade.Value, tag manipulation, ReplicatedStorage.GameVariables.GameSpeed.Value
            // unit.setAttribute("CurrentTypeBuffThingPR2", ""); // PR2 for PowerRoll II

            // const buffLogic = () => {
            //     const typeTableBase = ["Speedster", "Air", "Shade"];
            //     let availableTypes = [...typeTableBase];

            //     // if ((unit.getConfiguration().CurrentUpgrade || 0) < 7) {
            //     //     availableTypes = availableTypes.filter(type => type !== "Air");
            //     // }
            //     if (availableTypes.length === 0) return;

            //     const chosenType = availableTypes[Math.floor(Math.random() * availableTypes.length)];
            //     const newTagName = `${chosenType === "Air" ? "Flying" : chosenType}Strong`;
            //     const previousChosenType = unit.getAttribute("CurrentTypeBuffThingPR2");

            //     if (previousChosenType) {
            //         const previousTagName = `${previousChosenType === "Air" ? "Flying" : previousChosenType}Strong`;
            //         unit.removeTag(previousTagName);
            //     }
            //     unit.addTag(newTagName);
            //     unit.setAttribute("CurrentTypeBuffThingPR2", chosenType);
            // };

            // buffLogic(); // Initial buff

            // task.spawn(async () => { // Placeholder
            //     while (unit && unit.getInstance() && unit.getInstance().Parent) {
            //         const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //         // await task.wait(PowerRollII.buffInterval / gameSpeed); // Placeholder
            //         if (!(unit && unit.getInstance() && unit.getInstance().Parent)) break;
            //         buffLogic();
            //     }
            // });
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting, enemy.Class, enemy.NPC_Type checks
            // if (enemy && enemy.Health > 0 && enemy.Class && enemy.NPC_Type) {
            //     const currentBuffedType = unit.getAttribute("CurrentTypeBuffThingPR2");
            //     if (!currentBuffedType) return 1;

            //     if (enemy.Class === currentBuffedType || enemy.NPC_Type === currentBuffedType) {
            //         return 1 + (PowerRollII.damageBonus || 0.20); // Default to 0.20 if not set
            //     }
            // }
            return 1;
        },
    },
};
