import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const GodsPresence: PassiveData = {
    name: "God's Presence",
    description: "Inflicts `Fear` on enemies when hit, making them take 12% more DMG.",
    callbacks: {
        // The Luau callbacks = {} suggests this passive's effects are likely triggered
        // by the core attack/damage system recognizing a tag or property associated with this passive.
        // For example:
        // 1. This passive could add a tag "AppliesGodsPresenceFear" to the unit onPlace.
        // 2. When the unit hits an enemy, the system sees this tag and applies the "Fear" status effect.
        // 3. The damage calculation system would then check if a target has "Fear" status
        //    and, if the source of damage has this passive, apply a 12% damage increase.

        // Example (conceptual):
        // onPlace: (unit: Unit) => {
        //     unit.addTag("TriggersGodsPresence");
        // }
        // The actual application of "Fear" and the damage bonus would be handled by other systems
        // reacting to this tag or by directly checking if the unit `hasPassive("God's Presence")`.
    },
};
