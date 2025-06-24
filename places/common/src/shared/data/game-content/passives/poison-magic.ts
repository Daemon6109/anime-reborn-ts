import { PassiveData } from "../passive";

export const PoisonMagic: PassiveData = {
    name: "Poison Magic",
    description: "With each attack this unit applies `Poison` status effect, lasts for 25 seconds.",
    callbacks: {}, // Logic for applying "Poison" status effect (duration 25s)
                   // would likely be handled by the attack/status system via a tag
                   // (e.g., "AppliesPoisonMagic") or by the unit's base attack properties.
};
