import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SoulEchoes: PassiveData = {
    name: "Soul Echoes",
    description: "Enemies that has lower than 30% health, attacked for the first time, will get `Frozen` for 2s.",
    // healthThreshold: 0.30,
    // stunDuration: 2, // seconds (Frozen status)
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy.Health, enemy.MaxHealth access, enemy-specific stack tracking (Enemy.SoulStacks), _G.Registry.registry.StatusEffects.Frozen.OnServer
            // This callback in Luau applies Frozen but returns 1 (no direct damage mod here).
            // if (enemy && enemy.Health > 0 && enemy.Health <= enemy.MaxHealth * (SoulEchoes.healthThreshold || 0.30)) {
            //     let enemyHitBySoulEchoesCount = enemy.SoulStacks || 0; // Assuming SoulStacks is on enemy instance
            //     if (enemyHitBySoulEchoesCount === 0) {
            //         // enemy.SoulStacks = 1; // Mark as hit once by this passive type
            //         // const StatusEffect = _G.Registry.registry.StatusEffects["Frozen"]; // Placeholder
            //         // if (StatusEffect) {
            //         //     StatusEffect.OnServer(unit, [enemy], SoulEchoes.stunDuration || 2);
            //         // }
            //     }
            // }
            return 1; // No direct damage modification from this passive callback itself.
        },
        // An onAttackHit might be more appropriate for applying the status effect.
    },
};
