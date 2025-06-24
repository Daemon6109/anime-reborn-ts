import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Blindness: PassiveData = {
    name: "Blindness",
    description: "Immune to debuffs but has 5% to miss an attack",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("InnateNonTarget");
            unit.addTag("InnateNoStun");
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            if (math.random(1, 20) === 1) { // 5% chance (1 out of 20)
                return 0; // Missed attack
            }
            return 1; // Normal damage
        },
    },
};
