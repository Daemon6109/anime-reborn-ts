import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PerfectTiming: PassiveData = {
    name: "Perfect Timing",
    description: " After getting stunned, for the next 15 seconds his critical chance is increased by 35% and crit dmg by 15%. (30s CD)",
    // buffDuration: 15, // seconds
    // cooldown: 30, // seconds
    // critChanceBonus: 0.35,
    // critDamageBonus: 0.15,
    callbacks: {
        onStunEnded: (unit: Unit) => { // Luau: onStunEnded
            // TODO: Implement attribute getting/setting, task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // constหน่วยBuffedAttribute = "IsBuffedHittoPerfectTiming"; // More specific attribute
            // const cooldownAttribute = "PerfectTimingCooldownUntil";
            // const now = tick(); // Placeholder for current time

            // const isOnCooldown = (unit.getAttribute(cooldownAttribute) || 0) > now;
            // const isAlreadyBuffed = unit.getAttribute(หน่วยBuffedAttribute) || false;

            // if (isOnCooldown || isAlreadyBuffed) return;

            // unit.setAttribute(หน่วยBuffedAttribute, true);
            // unit.setAttribute(cooldownAttribute, now + PerfectTiming.cooldown);

            // unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + PerfectTiming.critChanceBonus);
            // unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + PerfectTiming.critDamageBonus);

            // const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            // // task.delay(PerfectTiming.buffDuration / gameSpeed, () => { // Placeholder for async delay
            // //     // Check if unit still exists and still has the buff from this specific activation
            // //     if (unit && unit.getInstance() && unit.getInstance().Parent && unit.getAttribute(หน่วยBuffedAttribute) === true) {
            // //         unit.setAttribute(หน่วยBuffedAttribute, false);
            // //         unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) - PerfectTiming.critChanceBonus);
            // //         unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) - PerfectTiming.critDamageBonus);
            // //     }
            // // });
            // // The Luau code has a separate 30s cooldown for "IsBuffedHittoCD" which seems to just prevent re-applying the main buff immediately.
            // // The logic here sets a single cooldown for the entire effect.
        },
    },
};
