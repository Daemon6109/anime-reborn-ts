import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const HardToHit: PassiveData = {
    name: "Hard to hit",
    description: "This unit immune to boss attacks",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("InnateNonTarget"); // Makes the unit non-targetable by default
                                         // The game's targeting logic for bosses would need to respect this tag.
                                         // Or, more specifically, a tag like "ImmuneToBossAttacks" could be used
                                         // and checked by the damage application system when the attacker is a boss.
        },
    },
};
