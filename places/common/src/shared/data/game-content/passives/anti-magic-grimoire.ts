import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const AntiMagicGrimoire: PassiveData = {
    name: "Anti-Magic Grimoire",
    description: "Osta’s Anti-Magic Grimoire causes bosses to fear him, preventing them from attacking and stunning him. His anti-magic sword easily destroys shields.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("ShieldBreaker");
            unit.addTag("InnateNonTarget");
            unit.addTag("InnateNoStun");
        },
    },
};
