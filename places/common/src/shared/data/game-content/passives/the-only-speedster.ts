import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const TheOnlySpeedster: PassiveData = {
    name: "The Only Speedster",
    description: "100% increased damage to speedsters",
    // damageBonusMultiplier: 2, // 100% increased means 2x damage
    // targetEnemyClass: "Speedster",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("SpeedsterStrong"); // Luau adds this tag.
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy.Class check.
            // if (enemy && enemy.Health > 0 && enemy.Class === (TheOnlySpeedster.targetEnemyClass || "Speedster")) {
            //     return TheOnlySpeedster.damageBonusMultiplier || 2;
            // }
            return 1;
        },
    },
};
