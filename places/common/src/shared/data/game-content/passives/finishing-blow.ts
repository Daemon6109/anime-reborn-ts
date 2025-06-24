import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FinishingBlow: PassiveData = {
    name: "Finishing Blow",
    description: "Deals 30% more DMG to enemies below 25% HP.",
    // percentIncrease: 1.3, // This means total damage is 1.3x, or 30% more.
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy.Health and enemy.MaxHealth access
            // if (enemy && enemy.Health > 0 && enemy.Health <= enemy.MaxHealth * 0.25) {
            //     return FinishingBlow.percentIncrease;
            // }
            return 1; // Default damage multiplier
        },
    },
};
