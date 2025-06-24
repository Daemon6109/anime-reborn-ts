import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Bestial: PassiveData = {
    name: "Bestial",
    description: "After 30 eliminations, he gains 35% damage buff + -35% SPA, Lasts for 10s. Cooldown : 60s",
    // killsNeeded: 30, // Configuration specific to this passive
    // duration: 10, // Configuration specific to this passive
    callbacks: {
        onKill: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting and task.delay, unit.waitForChild, ReplicatedStorage  equivalents
            // const stacks = unit.getAttribute("BestialStacks") || 0;
            // const mode = unit.getAttribute("BestialMode") || false;
            // const onCD = unit.getAttribute("BestialModeCD") || false;
            // const config = await unit.waitForChild("configuration", 10);
            // if (mode || onCD || !config) return;
            // if (stacks < Bestial.killsNeeded) {
            //     unit.setAttribute("BestialStacks", stacks + 1);
            // } else {
            //     unit.setAttribute("BestialStacks", 0);
            //     unit.setAttribute("BestialMode", true);
            //     unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") + 0.35);
            //     unit.setAttribute("PermanentAttackSpeedMulti", unit.getAttribute("PermanentAttackSpeedMulti") - 0.35);
            //     // TODO: Implement BuffLib, FastVector, workspace, and Stunned tag equivalents for ally stun
            //     task.delay(Bestial.duration / game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value, () => {
            //         unit.setAttribute("BestialMode", false);
            //         unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") - 0.35);
            //         unit.setAttribute("PermanentAttackSpeedMulti", unit.getAttribute("PermanentAttackSpeedMulti") + 0.35);
            //         unit.setAttribute("BestialModeCD", true);
            //         task.wait(60 / game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value);
            //         unit.setAttribute("BestialModeCD", undefined);
            //     });
            // }
        },
    },
};
