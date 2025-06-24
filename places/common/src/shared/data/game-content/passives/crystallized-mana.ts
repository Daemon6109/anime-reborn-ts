import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CrystallizedMana: PassiveData = {
    name: "Crystallized Mana",
    description: "Unit attacks ignores enemy elements damage debuffs.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("IgnoreElementsDebuff"); // Tag to be checked by damage calculation system
        },
    },
};
