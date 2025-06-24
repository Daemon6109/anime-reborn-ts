import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const JajankenMastery: PassiveData = {
    name: "Jajanken Mastery",
    description: "Every wave unit switches his power, Rock (15% dmg and 10% crit increase), Paper (20% range but -5% dmg), Scissors (-7.5% spa but -5% range)",
    callbacks: {
        onWave: async (unit: Unit) => { // Luau has async call to unit:WaitForChild
            // TODO: Implement attribute getting/setting, unit.waitForChild("configuration", 10)
            // const config = await unit.waitForChild("configuration", 10); // Placeholder for async
            // if (!config) return;

            // const powers = {
            //     Rock: {
            //         apply: () => {
            //             unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + 0.15);
            //             unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + 0.10);
            //         },
            //         remove: () => {
            //             unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - 0.15);
            //             unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) - 0.10);
            //         },
            //     },
            //     Paper: {
            //         apply: () => {
            //             unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - 0.05);
            //             unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.20);
            //         },
            //         remove: () => {
            //             unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + 0.05);
            //             unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - 0.20);
            //         },
            //     },
            //     Scissor: { // Original Luau uses "Scissor"
            //         apply: () => {
            //             unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - 0.075);
            //             unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - 0.05);
            //         },
            //         remove: () => {
            //             unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) + 0.075);
            //             unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.05);
            //         },
            //     },
            // };

            // const switchablePowerNames = ["Rock", "Paper", "Scissor"] as const; // Literal types
            // type PowerName = typeof switchablePowerNames[number];

            // const lastPower = unit.getAttribute("JajankenLastPower") as PowerName | undefined;
            // if (lastPower && powers[lastPower]) {
            //     powers[lastPower].remove();
            // }

            // const newPowerIndex = Math.floor(Math.random() * switchablePowerNames.length);
            // const newPower = switchablePowerNames[newPowerIndex];
            // unit.setAttribute("JajankenLastPower", newPower);
            // if (powers[newPower]) {
            //     powers[newPower].apply();
            // }
        },
    },
};
