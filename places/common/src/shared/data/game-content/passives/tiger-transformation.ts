import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const TigerTransformation: PassiveData = {
    name: "Tiger Transformation",
    description: "After 25 eliminations, he gains 18% damage buff and -18% spa, Lasts for 20s. Cooldown : 40s",
    // killsNeeded: 25,
    // buffDuration: 20, // seconds
    // cooldownAfterBuff: 40, // seconds
    // damageBuff: 0.18,
    // spaBuff: -0.18, // Description -18%. Luau applies -0.10 and reverts with +0.10. Assuming description is correct for value.
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // const modeActiveAttr = "TigerModeActiveTT"; // TT for TigerTransformation
            // const cooldownActiveAttr = "TigerModeCooldownTT";
            // const killsCountAttr = "TigerKillsTT";

            // if (unit.getAttribute(modeActiveAttr) || unit.getAttribute(cooldownActiveAttr)) return;

            // let kills = unit.getAttribute(killsCountAttr) || 0;
            // kills++;

            // if (kills >= (TigerTransformation.killsNeeded || 25)) {
            //     unit.setAttribute(killsCountAttr, 0);
            //     unit.setAttribute(modeActiveAttr, true);

            //     const actualDamageBuff = TigerTransformation.damageBuff || 0.18;
            //     const actualSpaBuff = TigerTransformation.spaBuff || -0.18; // Use -0.18 as per desc for SPA decrease

            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + actualDamageBuff);
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) + actualSpaBuff);

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     // task.delay((TigerTransformation.buffDuration || 20) / gameSpeed, () => { // Placeholder
            //     //     if (unit && unit.getInstance()?.Parent && unit.getAttribute(modeActiveAttr) === true) {
            //     //         unit.setAttribute(modeActiveAttr, false);
            //     //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - actualDamageBuff);
            //     //         unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - actualSpaBuff); // Revert SPA buff (add back)

            //     //         unit.setAttribute(cooldownActiveAttr, true);
            //     //         task.delay((TigerTransformation.cooldownAfterBuff || 40) / gameSpeed, () => { // Placeholder
            //     //             if (unit && unit.getInstance()?.Parent) {
            //     //                 unit.setAttribute(cooldownActiveAttr, false);
            //     //             }
            //     //         });
            //     //     }
            //     // });
            // } else {
            //     unit.setAttribute(killsCountAttr, kills);
            // }
        },
    },
};
