import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const BaraBaraBarrage: PassiveData = {
    name: "Bara Bara Barrage",
    description: "Unit applies `Scar` on each attack. `Scar` enemies takes 7.5% more damage.",
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects) {
            //     const hasStatus = enemy.StatusEffects["Scar"] === true;
            //     if (hasStatus) {
            //         return 1.075;
            //     }
            // }
            return 1;
        },
    },
};
