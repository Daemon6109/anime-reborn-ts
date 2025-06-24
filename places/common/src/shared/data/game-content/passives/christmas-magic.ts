import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ChristmasMagic: PassiveData = {
    name: "Christmas Magic",
    description: "Attacks freeze enemies that are below 35% health; SPA -10% for 25 seconds after killing a frozen enemy",
    // maxPassiveStacks: 3, // Configuration specific to this passive
    // percentPerStack: 0.1, // Configuration specific to this passive (SPA reduction)
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement _G.Registry (for status effects), enemy health/maxHealth access
            // if (enemy && enemy.Health > 0) {
            //     if (enemy.Health < enemy.MaxHealth * 0.35) {
            //         const statusEffectDefinition = _G.Registry.registry.StatusEffects["Frozen"];
            //         if (statusEffectDefinition) {
            //             // statusEffectDefinition.OnServer(unit, [enemy], 3); // Apply Frozen status for 3s
            //         }
            //     }
            // }
            return 1; // Does not modify damage directly
        },
        onKill: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting/setting, status effect checking (enemy.StatusEffects["Frozen"]), task.delay, ReplicatedStorage (GameVariables.GameSpeed)
            // let stacks = unit.getAttribute("IceFrenzyStacks") || 0;
            // // Assuming enemy.StatusEffects is an object/map
            // if (stacks < ChristmasMagic.maxPassiveStacks && enemy && enemy.StatusEffects && enemy.StatusEffects["Frozen"]) {
            //     stacks++;
            //     unit.setAttribute("IceFrenzyStacks", stacks);
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - ChristmasMagic.percentPerStack);
            //     // const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value;
            //     // task.delay(15 / gameSpeed, () => { // Original was 15s, then 25s in desc. Using 15 from code.
            //     //     const currentStacks = unit.getAttribute("IceFrenzyStacks");
            //     //     if (currentStacks > 0) { // Ensure stacks haven't been reset or gone below zero elsewhere
            //     //        unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) + ChristmasMagic.percentPerStack);
            //     //        unit.setAttribute("IceFrenzyStacks", currentStacks - 1);
            //     //     }
            //     // });
            // }
        },
    },
};
