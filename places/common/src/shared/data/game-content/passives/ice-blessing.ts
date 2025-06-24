import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const IceBlessing: PassiveData = {
    name: "Ice Blessing",
    description: "Unit can't be targetted by Bosses and is Immune to Stuns.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("InnateNonTarget");  // For general non-targetability, which might cover bosses.
            unit.addTag("InnateNoStun");     // Explicit stun immunity.
            // For "can't be targetted by Bosses", a more specific tag like "BossImmuneTarget"
            // might be needed if "InnateNonTarget" is too broad or if bosses have special targeting.
            // The game's targeting logic for bosses would check for this.
        },
    },
};
