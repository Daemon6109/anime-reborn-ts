import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ColdHeartedEmpress: PassiveData = {
    name: "Cold Hearted Empress",
    description: "If the Attacked Enemy has `Charmed` status on, Bao [Empress] does +150% DMG to them. When an enemy `Charmed` by a unit named `Bao [Empress]` is defeated, a `Heart Explosion` happens, stunning nearby enemies for 3 seconds (6s application CD).",
    // tagName: "ColdHeartedEmpress", // Unit specific tag
    // percentIncrease: 1.5, // Damage increase multiplier (150% more damage means 2.5x, or 1.5 if it's additive to a base of 1)
                          // Luau code returns 1.5, which implies it's an additive multiplier to the base of 1 (total 2.5x) or it's just 1.5x.
                          // Given it's `return Passive.configuration.PercentIncrease`, it's likely intended as a direct multiplier (e.g. 1.5x).
                          // However, "+150% DMG" usually means base * (1 + 1.50) = base * 2.5.
                          // Clarification needed. Assuming it means damage is multiplied by 1.5 + 1 = 2.5.
                          // For now, using the Luau code's direct return of 1.5, implying it's a final multiplier.
    callbacks: {
        onPlace: (unit: Unit) => {
            // unit.addTag(ColdHeartedEmpress.tagName);
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects["Charm"] or "CharmBoaEvo")
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && (enemy.StatusEffects["Charm"] === true || enemy.StatusEffects["CharmBoaEvo"] === true)) {
            //     return 1 + 1.5; // Actual damage would be baseDamage * (1 + 1.5) if it's +150%
            //     // Or if Luau's `return Passive.configuration.PercentIncrease` means the final multiplier, then just `return 1.5;`
            //     // For now, sticking to Luau logic: return 1.5; (needs clarification on what this return value means in TS context)
            // }
            return 1;
        },
        onAnyKill: (unit: Unit, killer: Unit, killedEnemy: any) => { // killer is the unit that performed the kill, unit is the one with this passive
            // TODO: Implement FastVector, _G.Constructs, _G.Registry (for status effects), status effect checking (killedEnemy.StatusEffects["CharmBoaEvo"])
            // Cooldown for Heart Explosion application (6s) needs to be handled, likely with a timestamp attribute on `unit`.
            // if (killedEnemy && killedEnemy.StatusEffects && killedEnemy.StatusEffects["CharmBoaEvo"] === true) {
            //     // Check cooldown for Heart Explosion here
            //     const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            //     // const allEnemies = _G.Constructs; // How to get all enemy constructs?
            //     // for (const enemyInRange of allEnemies) { // Iterate over actual enemy objects
            //     //     if (enemyInRange === killedEnemy) continue; // Don't apply to the already dead one
            //     //     const distance = FastVector.FastMagnitudeVec3(enemyInRange.Position, killedEnemy.Position); // Explosion around killed enemy
            //     //     if (distance <= 20) { // Explosion radius 20
            //     //         const statusEffectDefinition = _G.Registry.registry.StatusEffects["CharmStun"]; // Assuming "CharmStun" is the correct stun
            //     //         if (statusEffectDefinition) {
            //     //             // statusEffectDefinition.OnServer(unit, [enemyInRange], 3); // Apply stun for 3s
            //     //         }
            //     //     }
            //     // }
            //     // Update cooldown timestamp for Heart Explosion on `unit`
            // }
        },
    },
};
