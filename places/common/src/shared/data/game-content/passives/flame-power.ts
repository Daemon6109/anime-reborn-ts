import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FlamePower: PassiveData = {
    name: "Flame Power",
    description: "This unit builds up flame power for each elimination. At full energy his next 3-5 attacks deal 230% of his current damage",
    // maxPassiveStacks: 100, // Kills needed to reach full energy
    callbacks: {
        onKill: (unit: Unit, killedEnemy?: any) => {
            // TODO: Implement attribute getting/setting
            // let chargeStacks = unit.getAttribute("FlameCharge") || 0;
            // chargeStacks++;
            // unit.setAttribute("FlameCharge", chargeStacks);

            // if (chargeStacks >= FlamePower.maxPassiveStacks) {
            //     unit.setAttribute("FlameCharge", 0); // Reset kill counter
            //     const attacksToBuff = Math.floor(Math.random() * (5 - 3 + 1)) + 3; // Random integer between 3 and 5
            //     unit.setAttribute("FlameChargeAttacksLeft", attacksToBuff);
            // }
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting/setting
            // let chargeAttacksLeft = unit.getAttribute("FlameChargeAttacksLeft") || 0;
            // if (enemy && enemy.Health > 0 && chargeAttacksLeft > 0) {
            //     unit.setAttribute("FlameChargeAttacksLeft", chargeAttacksLeft - 1);
            //     return 3.3; // Luau code returns 3.3 (230% *more* damage, so base + 2.3*base = 3.3*base)
            // }
            return 1; // Default damage multiplier
        },
    },
};
