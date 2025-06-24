import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const HemorrhagicSeverance: PassiveData = {
    name: "Hemorrhagic Severance",
    description: "Proccs 'Scar' while permanently getting rid of their regen, For bosses their regen will stop for 15s",
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement _G.Constructs, ReplicatedStorage.GameVariables.GameSpeed.Value, and task.delay equivalents.
            // This passive applies "Scar" (not explicitly here, but implied by description)
            // AND manipulates a custom "Regen" property on the enemy construct.
            // if (enemy && enemy.EnemyID) { // Assuming enemy has an EnemyID to look up in a global constructs map
            //     const enemyConstruct = _G.Constructs[enemy.EnemyID]; // Placeholder for global enemy map
            //     if (enemyConstruct && enemyConstruct.Regen === true) { // Check if it was regenerating
            //         enemyConstruct.Regen = false; // Disable regen
            //         if (enemyConstruct.IsBoss) {
            //             // task.delay(15 / game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value, () => { // Placeholder
            //             //     if (_G.Constructs && _G.Constructs[enemy.EnemyID]) { // Check if boss still exists
            //             //         _G.Constructs[enemy.EnemyID].Regen = true; // Re-enable for boss
            //             //     }
            //             // });
            //         }
            //     }
            // }
            return 1; // No direct damage modification from this callback
        },
        // onAttackHit: (unit: Unit, enemy: any) => {
        //     // Apply "Scar" status effect here.
        // }
    },
};
