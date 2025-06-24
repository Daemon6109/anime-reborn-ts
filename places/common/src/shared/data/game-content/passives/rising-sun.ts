import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const RisingSun: PassiveData = {
    name: "Rising Sun",
    description: "Attack applies `Burning` status, if unit attacks an enemy that already has burn dot he increases his own dmg by 0.2% up to 10%",
    // statusNeeded: "Burning",
    // damageIncreasePerHit: 0.002, // 0.2%
    // maxDamageIncrease: 0.10,     // 10%
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting/setting, status effect checking
            // The "Attack applies `Burning` status" part would likely be a tag or inherent property of the attack.
            // This callback handles the damage increase *if* the target is already burning.
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[RisingSun.statusNeeded || "Burning"] === true) {
            //     let currentDamageBonus = unit.getAttribute("RisingSunDmgBonus") || 0;
            //     const maxBonus = RisingSun.maxDamageIncrease || 0.10;
            //     const increaseAmount = RisingSun.damageIncreasePerHit || 0.002;

            //     if (currentDamageBonus < maxBonus) {
            //         const actualIncrease = Math.min(increaseAmount, maxBonus - currentDamageBonus);
            //         // unit.setAttribute("RisingSunDmgBonus", currentDamageBonus + actualIncrease);
            //         // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + actualIncrease);
            //     }
            // }
            return 1; // This callback in Luau does not directly change the current hit's damage, only future ones.
        },
        // onAttackHit: (unit: Unit, enemy: any) => {
        //     // TODO: Apply "Burning" status to enemy if it's meant to be applied by this passive directly.
        // }
    },
};
