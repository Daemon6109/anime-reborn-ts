import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const IceFrenzy: PassiveData = {
    name: "Ice Frenzy",
    description: "SPA -10% for 15 seconds after killing a frozen enemy (down to -30%)",
    // maxPassiveStacks: 3,    // Max concurrent SPA buffs
    // percentPerStack: 0.1,   // SPA reduction (becomes -0.1 for speed attribute)
    // buffDuration: 15,       // Seconds
    callbacks: {
        onKill: (unit: Unit, killedEnemy: any) => {
            // TODO: Implement attribute getting/setting, status effect checking (killedEnemy.StatusEffects["Frozen"]), task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // let currentStacks = unit.getAttribute("IceFrenzyStacks") || 0;

            // if (currentStacks < IceFrenzy.maxPassiveStacks && killedEnemy && killedEnemy.StatusEffects && killedEnemy.StatusEffects["Frozen"] === true) {
            //     unit.setAttribute("IceFrenzyStacks", currentStacks + 1);
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - IceFrenzy.percentPerStack);

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     // task.delay(IceFrenzy.buffDuration / gameSpeed, () => { // Placeholder for async delay
            //     //     // Check if unit still exists before trying to revert
            //     //     if (unit && unit.getInstance() && unit.getInstance().Parent) {
            //     //         const stacksNow = unit.getAttribute("IceFrenzyStacks") || 0;
            //     //         if (stacksNow > 0) { // Only revert if a stack is supposed to be active
            //     //             unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) + IceFrenzy.percentPerStack);
            //     //             unit.setAttribute("IceFrenzyStacks", stacksNow - 1);
            //     //         }
            //     //     }
            //     // });
            // }
        },
    },
};
