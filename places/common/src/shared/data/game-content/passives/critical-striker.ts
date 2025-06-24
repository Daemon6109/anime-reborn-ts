import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CriticalStriker: PassiveData = {
    name: "Critical Striker",
    description: "Breaks enemy shields instantly.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("ShieldBreaker"); // This tag would be recognized by the damage/shield system
        },
    },
};
