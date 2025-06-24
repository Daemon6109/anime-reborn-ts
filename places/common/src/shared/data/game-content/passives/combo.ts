import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Combo: PassiveData = {
    name: "Combo",
    description: "Deals +5% damage with each consecutive attack on an enemy (up to +20%).",
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy-specific stack tracking (e.g., enemy.SaberStacks). This state needs to be managed.
            // if (enemy && enemy.Health > 0) {
            //     let stack = enemy.SaberStacks || 0; // Assuming SaberStacks is stored on the enemy instance
            //     if (stack < 4) { // Max 4 stacks for +20% (0->0, 1->5, 2->10, 3->15, 4->20)
            //         stack++; // Increment for the current hit
            //         // enemy.SaberStacks = stack; // Persist the stack count on the enemy
            //     }
            //     // The damage calculation should be: baseDamage * (1 + (stack -1) * 0.05)
            //     // Or if the stack is applied *after* this hit for the *next* hit, then it's current stack.
            //     // Luau code: `return 1+(Stack * .05)`. If Stack is 0 initially, it becomes 1, returns 1.05.
            //     // If Stack is 3, becomes 4, returns 1.20. This seems correct.
            //     // However, the `enemy.SaberStacks = Stack + 1` happens before the return.
            //     // Let's re-evaluate:
            //     // Hit 1: enemy.SaberStacks (undefined/0). Stack becomes 1. Returns 1 + (1*0.05) = 1.05. Enemy stack is 1.
            //     // Hit 2: enemy.SaberStacks (1). Stack becomes 2. Returns 1 + (2*0.05) = 1.10. Enemy stack is 2.
            //     // Hit 3: enemy.SaberStacks (2). Stack becomes 3. Returns 1 + (3*0.05) = 1.15. Enemy stack is 3.
            //     // Hit 4: enemy.SaberStacks (3). Stack becomes 4. Returns 1 + (4*0.05) = 1.20. Enemy stack is 4.
            //     // Hit 5: enemy.SaberStacks (4). Stack remains 4 (due to `if Stack < 4`). Returns 1 + (4*0.05) = 1.20. Enemy stack is 4.
            //     // This logic seems to apply the buff for the current hit based on the new stack count.
            //     // The returned value is the damage multiplier.
            //     let currentEnemyStacks = enemy.SaberStacks || 0;
            //     if (currentEnemyStacks < 4) {
            //        currentEnemyStacks++;
            //        // enemy.SaberStacks = currentEnemyStacks; // Update enemy's persisted stack
            //     }
            //     return 1 + (currentEnemyStacks * 0.05);
            // }
            return 1;
        },
        // Need a way to reset enemy.SaberStacks if the unit attacks a *different* enemy.
        // This might require an onAttackStart or onTargetChanged callback.
    },
};
