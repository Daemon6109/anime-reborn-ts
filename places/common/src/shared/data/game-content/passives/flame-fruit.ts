import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FlameFruit: PassiveData = {
    name: "Flame Fruit",
    description: "Mage Inflicts burn equal to 100% of his damage.", // Description is a bit ambiguous.
                                                                 // Luau code suggests it deals 2x damage to already burning targets.
    // percentIncrease: 2,    // Luau: if enemy has "Burning", return 2 (meaning 2x damage)
    // statusNeeded: "Burning", // Status to check for the damage bonus
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects[FlameFruit.statusNeeded])
            // The description "Inflicts burn equal to 100% of his damage" is not what the Luau code does for onConditionalDamage.
            // The Luau onConditionalDamage checks if the target is ALREADY burning, and if so, deals 2x damage.
            // It does not itself apply a burn based on damage value in this callback.
            // That burn application might be a separate part of "Mage" unit's attack or another passive.
            // Translating the Luau onConditionalDamage:
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[FlameFruit.statusNeeded] === true) {
            //     return FlameFruit.percentIncrease; // Deal 2x damage if enemy is already burning
            // }
            return 1; // Default damage multiplier
        },
        // If "Inflicts burn equal to 100% of his damage" is a separate effect:
        // onAttack: (unit: Unit, enemy: any, damageDealt: number) => {
        // Apply a Burn DoT status effect with total damage equal to `damageDealt` over its duration.
        // This would require a flexible status effect system.
        // }
    },
};
