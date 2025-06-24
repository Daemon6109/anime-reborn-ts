import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const OverflowingPowerI: PassiveData = {
    name: "Overflowing Power", // Luau uses "Overflowing Power"
    description: "On attack start each enemy in range increases damage by 0.5%, up to 15%",
    // maxPassiveStacks: 30,    // 15% / 0.5% = 30 enemies for max buff
    // percentPerStack: 0.005,  // 0.5% damage increase per enemy
    callbacks: {
        onAttack: (unit: Unit, dataPack?: any) => { // Luau includes DataPack
            // TODO: Implement attribute getting/setting, _G.serverServices.UnitHandler.GetEnemiesInRangeUnsorted
            // This should ideally be `onAttackStart` if the buff applies to the attack being initiated.
            // if (unit.getAttribute("OverflowingPowerIStacks") === undefined) { // Luau initializes if not present
            //     unit.setAttribute("OverflowingPowerIStacks", 0);
            // }

            // const npcCache = _G.serverServices.UnitHandler.GetEnemiesInRangeUnsorted(unit); // Placeholder
            // const enemiesInRangeCount = Math.min(npcCache.length, OverflowingPowerI.maxPassiveStacks);

            // const previousStacksCount = unit.getAttribute("OverflowingPowerIStacks") || 0;
            // const differenceInStacks = enemiesInRangeCount - previousStacksCount;

            // if (differenceInStacks !== 0) {
            //     unit.setAttribute("OverflowingPowerIStacks", enemiesInRangeCount); // Store the new count of enemies influencing the buff
            //     const currentDamageMulti = unit.getAttribute("PermanentDamageMulti") || 1;
            //     const damageChange = differenceInStacks * OverflowingPowerI.percentPerStack;
            //     unit.setAttribute("PermanentDamageMulti", currentDamageMulti + damageChange);
            // }
        },
        // If the buff is temporary for the attack, onAttackEnded would revert it.
        // Luau modifies PermanentDamageMulti, implying it's sticky until recalculated on the next attack.
    },
};
