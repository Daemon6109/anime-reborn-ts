import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PerfectHaki: PassiveData = {
    name: "Perfect Haki",
    description: "Hits ignore/break shields from enemies, dealing damage towards them instantly.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("ShieldBreaker"); // This tag implies that the damage system should bypass/break shields.
                                         // The "dealing damage towards them instantly" part is inherent to breaking shields effectively.
        },
    },
};
