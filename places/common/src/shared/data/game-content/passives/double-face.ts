import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const DoubleFace: PassiveData = {
    name: "Double Face",
    description: "On every attack, has 25% chance to do 50% more damage.",
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            if (math.random(1, 100) <= 25) { // 25% chance (includes 25)
                return 1.5; // 50% more damage
            }
            return 1; // Normal damage
        },
    },
};
