import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PurePower: PassiveData = {
    name: "Pure Power",
    description: "After 40 eliminations his power awakens giving him a 35% damage increase and a 25% range increase. lasts 45s. cooldown: 45s",
    // maxKillsForActivation: 40,
    // buffDuration: 45, // seconds
    // cooldownAfterBuff: 45, // seconds. Luau code has buff end and CD start immediately after buff duration.
    // damageBonus: 0.35,
    // rangeBonus: 0.25,
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // const isModeActive = unit.getAttribute("PurePowerModeActive") || false;
            // const isOnCooldown = unit.getAttribute("PurePowerCooldownUntil") && (unit.getAttribute("PurePowerCooldownUntil") || 0) > tick(); // Placeholder

            // if (isModeActive || isOnCooldown) return;

            // let kills = unit.getAttribute("PurePowerKills") || 0;
            // kills++;

            // if (kills >= (PurePower.maxKillsForActivation || 40)) {
            //     unit.setAttribute("PurePowerKills", 0);
            //     unit.setAttribute("PurePowerModeActive", true);

            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (PurePower.damageBonus || 0.35));
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + (PurePower.rangeBonus || 0.25));

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     const actualBuffDuration = (PurePower.buffDuration || 45);
            //     const actualCooldown = (PurePower.cooldownAfterBuff || 45);
            //     const currentTime = tick(); // Placeholder

            //     // task.delay(actualBuffDuration / gameSpeed, () => { // Placeholder for async delay
            //     //     if (unit && unit.getInstance()?.Parent && unit.getAttribute("PurePowerModeActive") === true) {
            //     //         unit.setAttribute("PurePowerModeActive", false);
            //     //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - (PurePower.damageBonus || 0.35));
            //     //         unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - (PurePower.rangeBonus || 0.25));
            //     //         unit.setAttribute("PurePowerCooldownUntil", tick() + actualCooldown); // Set cooldown end time
            //     //     }
            //     // });
            // } else {
            //     unit.setAttribute("PurePowerKills", kills);
            // }
        },
    },
};
