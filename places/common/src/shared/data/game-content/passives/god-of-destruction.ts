import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const GodOfDestruction: PassiveData = {
    name: "God Of Destruction",
    description: "Has a 30% chance to insta-kill enemies below 15% HP",
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy.Health, enemy.MaxHealth, BuffLib.GetDamage equivalents
            // The BuffLib:GetDamage(Unit) part is to ensure the returned damage is enough to kill.
            // if (enemy && enemy.Health > 0) {
            //     const chance = Math.random(); // 0.0 to <1.0
            //     if (chance < 0.30) { // 30% chance
            //         if (enemy.Health <= enemy.MaxHealth * 0.15) {
            //             // const currentAttackDamage = BuffLib.GetDamage(unit); // Placeholder
            //             // To insta-kill, return a damage value >= enemy's current health.
            //             // Luau: return 1 + (Enemy.Health / BuffLib:GetDamage(Unit))
            //             // If GetDamage is base damage, this formula is trying to make the multiplier large enough.
            //             // A simpler way: return enemy.Health + 1; (or a very large number if the system handles it)
            //             // Or, if the damage system supports an "instaKill" flag:
            //             // return { instaKill: true };
            //             // For now, mimicking the large multiplier idea:
            //             // if (currentAttackDamage > 0) {
            //             //     return 1 + (enemy.Health / currentAttackDamage);
            //             // } else { // Avoid division by zero if base damage is 0 for some reason
            //             //     return enemy.Health +1; // Ensure it's enough to kill
            //             // }
            //         }
            //     }
            // }
            return 1; // Default damage multiplier
        },
    },
};
