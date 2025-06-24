import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const IceShatter: PassiveData = {
    name: "Ice Shatter",
    description: "Does +25% more damage to enemies under `Frozen` status effect and deals 15% damage each second for 5 seconds.",
    // percentIncrease: 1.25, // Damage multiplier for direct hit on frozen target
    // statusNeeded: "Frozen",  // Status to check for bonus and to apply special DoT
    // dotName: "Ice Shatter", // Name of the DoT status effect
    // dotDuration: 5,         // Seconds
    // dotDamagePerSecondPercent: 0.15, // 15% of what? Unit's damage? Enemy max HP? (Assuming unit's damage)
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects[IceShatter.statusNeeded])
            // TODO: Implement _G.Registry.registry.StatusEffects["Ice Shatter"].OnServer for applying DoT
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[IceShatter.statusNeeded] === true) {
            //     // Apply the "Ice Shatter" DoT status effect
            //     // const StatusEffect = _G.Registry.registry.StatusEffects[IceShatter.dotName]; // Placeholder
            //     // if (StatusEffect) {
            //     //     // The DoT needs to know the base damage to calculate its 15% ticks.
            //     //     // This might need to be passed to the status effect system.
            //     //     StatusEffect.OnServer(unit, [enemy], IceShatter.dotDuration /*, { baseDamage: unit.getDamage() } */); // Placeholder
            //     // }
            //     return IceShatter.percentIncrease; // Return direct damage bonus
            // }
            return 1; // Default damage multiplier
        },
    },
};
