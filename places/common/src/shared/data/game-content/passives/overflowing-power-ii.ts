import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const OverflowingPowerII: PassiveData = {
    name: "Overflowing Power II",
    description: "On attack start each enemy in range increases damage by 1%, up to 25%",
    // maxPassiveStacks: 25,    // 25% / 1% = 25 enemies for max buff
    // percentPerStack: 0.01,   // 1% damage increase per enemy
    callbacks: {
        onAttack: (unit: Unit, dataPack?: any) => { // Luau includes DataPack
            // TODO: Implement attribute getting/setting, _G.serverServices.UnitHandler.GetEnemiesInRangeUnsorted
            // if (unit.getAttribute("OverflowingPowerIIStacks") === undefined) {
            //     unit.setAttribute("OverflowingPowerIIStacks", 0);
            // }

            // const npcCache = _G.serverServices.UnitHandler.GetEnemiesInRangeUnsorted(unit); // Placeholder
            // const enemiesInRangeCount = Math.min(npcCache.length, OverflowingPowerII.maxPassiveStacks);

            // const previousStacksCount = unit.getAttribute("OverflowingPowerIIStacks") || 0;
            // const differenceInStacks = enemiesInRangeCount - previousStacksCount;

            // if (differenceInStacks !== 0) {
            //     unit.setAttribute("OverflowingPowerIIStacks", enemiesInRangeCount);
            //     const currentDamageMulti = unit.getAttribute("PermanentDamageMulti") || 1;
            //     const damageChange = differenceInStacks * OverflowingPowerII.percentPerStack;
            //     unit.setAttribute("PermanentDamageMulti", currentDamageMulti + damageChange);
            // }
        },
    },
};
