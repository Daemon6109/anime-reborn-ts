import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Revenge: PassiveData = {
    name: "Revenge",
    description: "When a boss is on map, String Mage gains 10% Damage, 25% Range, 25% Critical Chance.",
    // damageBonus: 0.10,
    // rangeBonus: 0.05, // Luau uses 0.05, description 0.25. Using Luau's for translation.
    // critChanceBonus: 0.25,
    callbacks: {
        onServerTick: (unit: Unit, deltaTime: number) => {
            // TODO: Implement _G.Constructs to check for boss enemies, attribute getting/setting.
            // let bossCurrentlyOnMap = false;
            // // for (const enemyId in _G.Constructs) { // Placeholder for global enemy map
            // //     if (_G.Constructs[enemyId].IsBoss) {
            // //         bossCurrentlyOnMap = true;
            // //         break;
            // //     }
            // // }

            // const wasBuffActive = unit.getAttribute("RevengeBossBuffActiveRV") || false;

            // if (bossCurrentlyOnMap && !wasBuffActive) {
            //     unit.setAttribute("RevengeBossBuffActiveRV", true);
            //     // unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + (Revenge.rangeBonus || 0.05));
            //     // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (Revenge.damageBonus || 0.10));
            //     // unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + (Revenge.critChanceBonus || 0.25));
            // } else if (!bossCurrentlyOnMap && wasBuffActive) {
            //     unit.setAttribute("RevengeBossBuffActiveRV", false);
            //     // unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - (Revenge.rangeBonus || 0.05));
            //     // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - (Revenge.damageBonus || 0.10));
            //     // unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) - (Revenge.critChanceBonus || 0.25));
            // }
        },
    },
};
