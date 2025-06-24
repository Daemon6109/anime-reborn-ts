import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PredatorsHunch: PassiveData = {
    name: "Predator's Hunch",
    description: "After 30 eliminations, he gains 7.5% damage buff and -7.5% spa, Lasts for 25s. Cooldown : 35s",
    // killsNeeded: 30,
    // buffDuration: 25, // seconds. Luau uses 20s for delay.
    // cooldown: 35,     // seconds. Luau uses 40s for cd after buff ends.
    // damageBonus: 0.075,
    // spaBonus: -0.075, // Negative for SPA decrease (faster)
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // const isModeActive = unit.getAttribute("PredatorHunchMode") || false;
            // const isOnCooldown = unit.getAttribute("PredatorHunchCDActive") || false;

            // if (isModeActive || isOnCooldown) return;

            // let kills = unit.getAttribute("PredatorHunchKills") || 0;
            // kills++;

            // if (kills >= (PredatorsHunch.killsNeeded || 30)) {
            //     unit.setAttribute("PredatorHunchKills", 0);
            //     unit.setAttribute("PredatorHunchMode", true);

            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (PredatorsHunch.damageBonus || 0.075));
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) + (PredatorsHunch.spaBonus || -0.075));

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     const actualBuffDuration = (PredatorsHunch.buffDuration || 25); // Luau uses 20s, desc says 25s
            //     // task.delay(actualBuffDuration / gameSpeed, () => { // Placeholder for async delay
            //     //     if (unit && unit.getInstance()?.Parent && unit.getAttribute("PredatorHunchMode") === true) {
            //     //         unit.setAttribute("PredatorHunchMode", false);
            //     //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - (PredatorsHunch.damageBonus || 0.075));
            //     //         unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - (PredatorsHunch.spaBonus || -0.075));

            //     //         unit.setAttribute("PredatorHunchCDActive", true);
            //     //         const actualCooldown = (PredatorsHunch.cooldown || 35); // Luau uses 40s, desc says 35s
            //     //         task.wait(actualCooldown / gameSpeed, () => { // Placeholder
            //     //             if (unit && unit.getInstance()?.Parent) {
            //     //                 unit.setAttribute("PredatorHunchCDActive", false);
            //     //             }
            //     //         });
            //     //     }
            //     // });
            // } else {
            //     unit.setAttribute("PredatorHunchKills", kills);
            // }
        },
    },
};
