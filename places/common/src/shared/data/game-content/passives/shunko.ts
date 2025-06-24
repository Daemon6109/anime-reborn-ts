import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Shunko: PassiveData = {
    name: "Shunko",
    description: "Enemies attacked for the first time will take 10% more damage while being stunned for 2s",
    // damageBonusFirstHit: 1.10,
    // stunDurationFirstHit: 2, // seconds
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy-specific stack tracking (Enemy.ShunkoStacks), _G.Registry.registry.StatusEffects.Stun.OnServer
            // if (enemy && enemy.Health > 0) {
            //     let shunkoHitCountOnEnemy = enemy.ShunkoStacks || 0; // Assuming this property can be set on the enemy instance

            //     if (shunkoHitCountOnEnemy === 0) {
            //         // enemy.ShunkoStacks = 1; // Mark as hit by Shunko once
            //         // _G.Registry.registry.StatusEffects.Stun.OnServer(unit, [enemy], Shunko.stunDurationFirstHit || 2); // Placeholder
            //         return Shunko.damageBonusFirstHit || 1.10; // Apply damage bonus for this first hit
            //     }
            // }
            return 1; // Default damage multiplier for subsequent hits or if conditions not met
        },
    },
};
