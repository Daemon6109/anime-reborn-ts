import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FreezingAura: PassiveData = {
    name: "Freezing Aura",
    description: "Attacks freeze enemies that are below 40% health",
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy.Health, enemy.MaxHealth access, and _G.Registry.registry.StatusEffects["Frozen"].OnServer
            // This callback in Luau applies a status effect but returns 1 (no direct damage modification here).
            // The application of "Frozen" should ideally be handled by the attack sequence if conditions are met.
            // if (enemy && enemy.Health > 0) {
            //     if (enemy.Health < enemy.MaxHealth * 0.40) {
            //         // const StatusEffect = _G.Registry.registry.StatusEffects["Frozen"]; // Placeholder
            //         // if (StatusEffect) {
            //         //     StatusEffect.OnServer(unit, [enemy], 3); // Apply Frozen for 3 seconds
            //         // }
            //     }
            // }
            return 1; // No direct damage modification from this passive callback itself
        },
        // It might be cleaner to have an onAfterDamageDealt or onAttackHit callback
        // onAttackHit: (unit: Unit, enemy: any) => {
        //     if (enemy && enemy.Health > 0 && enemy.Health < enemy.MaxHealth * 0.40) {
        //         // Apply Frozen status
        //     }
        // }
    },
};
