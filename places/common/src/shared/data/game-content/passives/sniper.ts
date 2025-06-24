import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Sniper: PassiveData = {
    name: "Sniper",
    description: "Each attack increases range by 1% (Max 15%)",
    // percentIncreasePerAttack: 0.01,
    // maxTotalIncrease: 0.15, // Corresponds to 15 stacks if applied directly to a multiplier
    callbacks: {
        onAttack: async (unit: Unit) => {
            // TODO: Implement unit.waitForChild, attribute getting/setting
            // const config = await unit.waitForChild("configuration", 10); // Placeholder, likely not needed
            // if (!config) return;

            // let currentTotalRangeBonus = unit.getAttribute("SniperPassiveAppliedBuff") || 0;
            // const increaseAmount = Sniper.percentIncreasePerAttack || 0.01;
            // const maxBonus = Sniper.maxTotalIncrease || 0.15;

            // if (currentTotalRangeBonus < maxBonus) {
            //     const actualIncrease = Math.min(increaseAmount, maxBonus - currentTotalRangeBonus);
            //     unit.setAttribute("SniperPassiveAppliedBuff", currentTotalRangeBonus + actualIncrease);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + actualIncrease);
            // }
        },
        // onRemove or onGameEnd might be needed if the buff should not persist indefinitely (e.g. across matches)
        // but PermanentRangeMulti implies it's a lasting change for the unit's lifetime.
    },
};
