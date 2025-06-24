import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PowerRoll: PassiveData = {
    name: "Power Roll",
    description: "Aira randomly selects one of the following buff pool every 60s (+10% dmg to speed enemies, +10% dmg to flying enemies, +10% dmg to shade enemies)",
    // buffInterval: 60, // seconds
    // damageBonus: 0.10,
    callbacks: {
        onPlace: (unit: Unit) => {
            // TODO: Implement task.spawn, task.wait, unit.configuration.CurrentUpgrade.Value, tag manipulation, ReplicatedStorage.GameVariables.GameSpeed.Value
            // unit.setAttribute("CurrentTypeBuffThingPR1", ""); // PR1 for PowerRoll I to distinguish from II

            // const buffLogic = () => {
            //     const typeTableBase = ["Speedster", "Air", "Shade"];
            //     let availableTypes = [...typeTableBase];

            //     // Luau: if Unit.configuration.CurrentUpgrade.Value < 7 then table.remove(TypeTable, 2) (removes "Air")
            //     // This implies unit.configuration needs to be accessible and up-to-date.
            //     // if ((unit.getConfiguration().CurrentUpgrade || 0) < 7) { // Assuming getConfiguration() method
            //     //     availableTypes = availableTypes.filter(type => type !== "Air");
            //     // }

            //     if (availableTypes.length === 0) return; // Should not happen if logic is correct

            //     const chosenType = availableTypes[Math.floor(Math.random() * availableTypes.length)];
            //     const newTagName = `${chosenType === "Air" ? "Flying" : chosenType}Strong`; // Tag indicating bonus against this type
            //     const previousChosenType = unit.getAttribute("CurrentTypeBuffThingPR1");

            //     if (previousChosenType) {
            //         const previousTagName = `${previousChosenType === "Air" ? "Flying" : previousChosenType}Strong`;
            //         unit.removeTag(previousTagName);
            //     }

            //     unit.addTag(newTagName);
            //     unit.setAttribute("CurrentTypeBuffThingPR1", chosenType);
            // };

            // buffLogic(); // Initial buff

            // task.spawn(async () => { // Placeholder for async background task
            //     while (unit && unit.getInstance() && unit.getInstance().Parent) {
            //         const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //         // await task.wait(PowerRoll.buffInterval / gameSpeed); // Placeholder
            //         if (!(unit && unit.getInstance() && unit.getInstance().Parent)) break;
            //         buffLogic();
            //     }
            // });
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting, enemy.Class, enemy.NPC_Type checks
            // if (enemy && enemy.Health > 0 && enemy.Class && enemy.NPC_Type) {
            //     const currentBuffedType = unit.getAttribute("CurrentTypeBuffThingPR1");
            //     if (!currentBuffedType) return 1;

            //     if (enemy.Class === currentBuffedType || enemy.NPC_Type === currentBuffedType) {
            //         return 1 + (PowerRoll.damageBonus || 0.10); // Default to 0.10 if not set
            //     }
            // }
            return 1;
        },
    },
};
