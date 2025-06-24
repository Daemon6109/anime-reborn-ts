import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PureEndurance: PassiveData = {
    name: "Pure Endurance",
    description: "Immune to stuns.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("InnateNoStun"); // Standard tag for stun immunity
        },
    },
};
