import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CienFleurBind: PassiveData = {
    name: "Cien Fleur Bind",
    description: "Every 15th attack, Robin summons a tornado that stuns all enemies hit for 2.5 seconds. During the stun, enemies take 15% more damage.",
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute setting. The Luau math.random(1,4) means 25% chance, not every 15th.
            // This needs clarification: Is it every 15th attack OR 25% chance?
            // Assuming the description "Every 15th attack" is correct:
            // let attackCount = unit.getAttribute("CienFleurAttackCount") || 0;
            // attackCount++;
            // if (attackCount >= 15) {
            //     unit.setAttribute("PassiveStun", true); // Flag for attack system to handle stun + tornado
            //     unit.setAttribute("CienFleurAttackCount", 0);
            // } else {
            //     unit.setAttribute("PassiveStun", false);
            //     unit.setAttribute("CienFleurAttackCount", attackCount);
            // }
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects["Stun"])
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects["Stun"]) {
            //     return 1.15; // 15% more damage
            // }
            return 1;
        },
    },
};
