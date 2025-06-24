import { PassiveData } from "../passive";

export const PreciseBlows: PassiveData = {
    name: "Precise Blows",
    description: "With each attack applies `Scar` status effect for 5 ticks.",
    callbacks: {}, // Logic for applying "Scar" (5 ticks) would be handled by the
                   // attack/status system, possibly via a tag like "AppliesPreciseScar"
                   // or by unit's base attack properties modified by this passive.
                   // The passive itself doesn't have active Luau callbacks.
};
