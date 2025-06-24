import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const IceDestroyer: PassiveData = {
    name: "Ice Destroyer",
    description: "Does +100% more damage to enemies under `Frozen` status effect.",
    // percentIncrease: 2, // Damage multiplier (100% more damage means 2x total)
    // statusNeeded: "Frozen", // Status to check for the bonus
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects[IceDestroyer.statusNeeded])
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[IceDestroyer.statusNeeded] === true) {
            //     return IceDestroyer.percentIncrease;
            // }
            return 1; // Default damage multiplier
        },
    },
};
