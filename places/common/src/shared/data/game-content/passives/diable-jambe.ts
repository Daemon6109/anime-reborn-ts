import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const DiableJambe: PassiveData = {
    name: "Diable Jambe",
    description: "On Attack Sijin inflicts enemy with `Burn`, if they already have `Burn`, instead deals 35% more dmg to them.",
    // percentIncrease: 1.35, // Damage multiplier if enemy is already burning (1 = no change, 1.35 = 35% more)
    // statusNeeded: "Burning", // Status to check for the damage bonus
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects[DiableJambe.statusNeeded])
            // TODO: The passive also implies it *applies* Burn on attack if not already burning. This needs to be handled,
            // perhaps in onAttack, or the damage system needs to know to apply it based on this passive.
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects) {
            //     const hasBurn = enemy.StatusEffects[DiableJambe.statusNeeded] === true;
            //     if (hasBurn) {
            //         return DiableJambe.percentIncrease; // Apply 35% damage bonus
            //     } else {
            //         // Apply 'Burn' status effect to enemy here if not already burning
            //         // This might need an `onAttack` callback or integration with the attack sequence.
            //     }
            // }
            return 1; // Default damage multiplier
        },
        // onAttack: (unit: Unit, enemy: any) => {
        //     // If not handled by conditional damage or attack system directly:
        //     // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[DiableJambe.statusNeeded] !== true) {
        //     // Apply 'Burn' status
        //     // }
        // }
    },
};
