import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const NeedleMaster: PassiveData = {
    name: "Needle Master",
    description: "If an enemy has lower than 20% hp, deals 15% increased dmg against them and his chance to leave a needle is increased by 10%",
    // healthThreshold: 0.20,
    // damageIncrease: 1.15, // 15% increased damage
    // needleChanceIncrease: 0.10, // Additional 10% chance
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy.Health, enemy.MaxHealth access.
            // TODO: Implement how "leaving a needle" works. This implies setting a property on the enemy.
            // if (enemy && enemy.Health > 0 && enemy.Health < enemy.MaxHealth * NeedleMaster.healthThreshold) {
            //     // Check for applying needle
            //     // const baseNeedleChance = unit.getBaseNeedleChance(); // Assuming unit has a base chance
            //     // if (Math.random() < (baseNeedleChance + NeedleMaster.needleChanceIncrease)) {
            //     //     enemy["NeedleHas"] = true; // Luau sets this property directly on enemy object.
            //     // }
            //     return NeedleMaster.damageIncrease;
            // }
            return 1;
        },
    },
};
