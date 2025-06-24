import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Materialism: PassiveData = {
    name: "Materialism",
    description: "3% Chance To Insta Kill Enemies That are Below 30% every 3 minutes, normal mobs only.",
    // instaKillChance: 0.03,
    // healthThreshold: 0.30, // Luau uses 0.35 in code
    // cooldownSeconds: 3 * 60,
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement workspace attribute for global CD, tick(), enemy.IsBoss, enemy.Health, enemy.MaxHealth
            // const globalCooldownAttribute = "UlquioraGlobalCD"; // Name of the global cooldown attribute on workspace
            // const lastActivationTime = workspace.GetAttribute(globalCooldownAttribute) || 0; // Placeholder
            // const currentTime = tick(); // Placeholder for current game time in seconds

            // if ((currentTime - lastActivationTime) > Materialism.cooldownSeconds) {
            //     workspace.SetAttribute(globalCooldownAttribute, currentTime); // Update last activation time

            //     if (enemy && !enemy.IsBoss && enemy.Health > 0 && enemy.Health <= enemy.MaxHealth * 0.35) { // Luau uses 0.35
            //         if (Math.random() < Materialism.instaKillChance) {
            //             // Return damage equal to enemy's current health to insta-kill
            //             // Or use a special return type if the damage system supports it e.g., { instaKill: true }
            //             return enemy.Health + 1; // Ensures kill
            //         }
            //     }
            // }
            return 1; // Default damage multiplier
        },
    },
};
