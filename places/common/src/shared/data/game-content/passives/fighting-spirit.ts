import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FightingSpirit: PassiveData = {
    name: "Fighting Spirit",
    description: "On attack start each enemy in his range increases his crit chance by 1%, up to 15%",
    // maxPassiveStacks: 15, // Max crit chance bonus stacks (15 for 15%)
    // percentPerStack: 0.01,  // Crit chance increase per enemy in range
    callbacks: {
        onAttack: (unit: Unit, dataPack?: any) => { // Luau onAttack also has DataPack
            // TODO: Implement _G.serverServices.UnitHandler.GetEnemiesInRangeUnsorted, attribute getting/setting
            // This should ideally be `onAttackStart` or similar if the buff applies to the attack being initiated.
            // const npcCache = _G.serverServices.UnitHandler.GetEnemiesInRangeUnsorted(unit); // Placeholder
            // const enemiesInRangeCount = Math.min(npcCache.length, FightingSpirit.maxPassiveStacks);

            // const previousCritStacks = unit.getAttribute("FightingSpiritActiveStacks") || 0;
            // const differenceInStacks = enemiesInRangeCount - previousCritStacks;

            // if (differenceInStacks !== 0) {
            //     unit.setAttribute("FightingSpiritActiveStacks", enemiesInRangeCount);
            //     const currentCritChance = unit.getAttribute("PermanentAttackCriticalChance") || 0;
            //     const newCritChance = currentCritChance + (differenceInStacks * FightingSpirit.percentPerStack);
            //     unit.setAttribute("PermanentAttackCriticalChance", newCritChance);
            // }
        },
        // onAttackEnded might be needed to revert the temporary crit chance buff if it's only for that one attack.
        // However, the Luau code modifies PermanentAttackCriticalChance, implying it's sticky until the next onAttack recalculation.
    },
};
